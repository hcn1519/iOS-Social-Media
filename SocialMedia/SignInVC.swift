//
//  ViewController.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 9..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("ID found in keyChain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("창남 - Unable to authenticate Firebase, Error: \(error)")
            } else {
                print("창남 - Firebase authentication Success")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            }
        })
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("창남 - Unable to login Facebook, Error: \(error)")
            } else if result?.isCancelled == true {
                print("창남 - User canceled Facebook authentication")
            } else {
                print("창남 - Facebook login success")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("창남 - Firebase 이메일 로그인")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user, error) in
                        if error != nil {
                            print("창남 - 이메일 인증을 할 수 없습니다.")
                        } else {
                            print("창남 - Success authentication with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("창남 - Data Saved to keyChain result: \(keyChainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}


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

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("창남 - Unable to authenticate Firebase, Error: \(error)")
            } else {
                print("창남 - Firebase authentication Success")
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
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user, error) in
                        if error != nil {
                            print("창남 - 이메일 인증을 할 수 없습니다.")
                        } else {
                            print("창남 - Success authentication with Firebase")
                        }
                    })
                }
            })
        }
    }
    
}


//
//  FeedVC.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 10..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    @IBOutlet weak var captionField: CustomField!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<AnyObject, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        // 각각의 데이터를 배열에 집어넣기
                        self.posts.append(post)
                    }
                    
                }
            }
        self.tableView.reloadData()
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("창남 - vaild image not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as AnyObject) {
                cell.configureCell(post: post, img: img)
                
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func postToFirebase(imgURL: String) {
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageURL": imgURL,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("Sign out \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    
    @IBAction func addImageBtnPressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        // if let과 반대로 사용하는 것
        guard let caption = captionField.text, caption != "" else {
            print("창남 - caption이 들어가야 합니다.")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("창남 - 이미지가 선택되어야 합니다.")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("창남 - Firebase storage에 이미지를 업로드 할 수 없습니다.")
                } else {
                    print("창남 - Firebase storage에 이미지를 업로드 합니다.")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgURL: url)
                    }
                }
            }
            
        }
    }
    
    
}

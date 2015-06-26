//
//  ViewController.swift
//  sharefb_example
//
//  Created by haipt on 6/26/15.
//  Copyright (c) 2015 haipt. All rights reserved.
//

import UIKit
enum shareType {
    case dialog
    case graphApi
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var flag: shareType = .dialog
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*
        share anh xu dung dialog default
    */
    @IBAction func sharingUsingDefaultTouched() {
        flag = .dialog
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: false) { () -> Void in }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if flag == .dialog {
            var photo: FBSDKSharePhoto = FBSDKSharePhoto()
            photo.image = chosenImage
            photo.userGenerated = true
            var content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
            content.photos = [photo]
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            var facebookShareService : FacebookShareService = FacebookShareService(image: chosenImage, description: "Share image facebook")
            facebookShareService.start()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
        share anh xu dung graph api
    */
    @IBAction func sharingUsingGraphTouched() {
        flag = .graphApi
        var loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: false) { () -> Void in }
    }
}


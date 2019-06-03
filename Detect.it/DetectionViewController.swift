//
//  DetectionViewController.swift
//  Detect.it
//
//  Created by Clavian Candrian on 03/06/19.
//  Copyright © 2019 Muhammad Alief. All rights reserved.
//

import UIKit
import Photos

class DetectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectImage.image = image
        }
        
        if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset{
            let assetResources = PHAssetResource.assetResources(for: asset)
            let firstObj = assetResources.first!
            imageName.text = firstObj.originalFilename
        }
        
//        let url = info[UIImagePickerControllerImageURL] as? URL
//        print(url!.lastPathComponent)
        
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var detectionName: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    var imagePicker = UIImagePickerController()
    
    var mainMenu: MainMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectionName.text = mainMenu.namaMenu
        imagePicker.delegate = self
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("authorized")
        case .denied:
            print("denied")
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("authorized")
                }
            })
            
        case .notDetermined:
            print("not determined")
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("authorized")
                }
            })
        case .restricted:
            print("restricted")
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("authorized")
                }
            })
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



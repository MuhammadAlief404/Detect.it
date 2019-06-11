//
//  DetectionViewController.swift
//  Detect.it
//
//  Created by Clavian Candrian on 03/06/19.
//  Copyright © 2019 Muhammad Alief. All rights reserved.
//

import UIKit
import Photos
import Vision
import GoogleMobileVision

class DetectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //WAKTU SELSAI MILIH GAMBAR
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectImage.image = image
            let scaledHeight = selectImage.frame.width / image.size.width * image.size.height
            selectImage.frame = CGRect(x: 0, y: selectImage.frame.origin.y , width: selectImage.frame.width, height: scaledHeight)
            
        }
        
        if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset{
            let assetResources = PHAssetResource.assetResources(for: asset)
            let firstObj = assetResources.first!
            imageName.text = firstObj.originalFilename
        }
        resetData()
        dismiss(animated: true, completion: nil)
        
    }

    @IBOutlet weak var detectionName: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var descImage: UITextView!
    var imagePicker = UIImagePickerController()
    var pathLayer: CALayer?
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0
    var mainMenu: MainMenu!
    
    //BUAT NGITUNG JUMLAH MUKA YANG KEDETECT
    var faceCount: Int = 0
    
    //BUAT NGITUNG JUMLAH BOX TEXT YANG KEDETECT
    var textBlockCount: Int = 0
    
    
    var textDetector = GMVDetector.init(ofType: GMVDetectorTypeText, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectionName.text = mainMenu.namaMenu
        imagePicker.delegate = self
        
        //BUAT MINTA PERMISSION AKSES LIBRARY
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
    
    //BUAT ILANGIN BOX MERAH
    func resetData(){
        descImage.text = ""
        if faceCount > 0{
            for face in 1...faceCount{
                view.viewWithTag(10)?.removeFromSuperview()
            }
        }
        faceCount = 0
    }
    
    //GAMBAR PLUS GEDE BUAT PILIH GAMBAR
    @IBAction func imageClicked(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    //BUTTON CHECK IMAGE
    @IBAction func checkImage(_ sender: Any) {
        guard let image = selectImage.image else { return }
        let scaledHeight = selectImage.frame.width / image.size.width * image.size.height
        
        //KALO PAKE FACE DETECTION(APPLE VISION)
        if detectionName.text == "Face Detection"{
            
            let request = VNDetectFaceRectanglesRequest { (req, error) in
                if let err = error{
                    print(err)
                }
                req.results?.forEach({ (res) in
                    self.faceCount += 1
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.selectImage.frame.width * faceObservation.boundingBox.origin.x
                    let width = self.selectImage.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1-faceObservation.boundingBox.origin.y) - height
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    redView.tag = 10
                    self.selectImage.addSubview(redView)
                    
                })
                if self.faceCount  > 0{
                    self.descImage.text = "\(self.faceCount) face(s) detected"
                }else{
                    self.descImage.text = "No face(s) detected"
                }
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("failed to perform request: ", reqErr)
            }
        }
        
        //KALO PAKE TEXT DETECTION
        else if detectionName.text == "Text Detection"{
            var text = [String]()
            if let features = textDetector?.features(in: image, options: nil) as? [GMVTextBlockFeature]{
                
                for textBlock in features{
                    descImage.textAlignment = NSTextAlignment.left
                    text.append("Text: \(textBlock.value!)")
                    descImage.text = text.joined(separator: "\n")
                }
            }
        }
        
        //KALO PAKE BARCODE DETECTION (APPLE)
        else if detectionName.text == "Barcode Detection"{
            var barcodes = [String]()
            let barcodeRequest = VNDetectBarcodesRequest { (req, err) in
                guard let results = req.results else { return }
                for result in results{
                    if let barcode = result as? VNBarcodeObservation{
                        //PAS DAPET BARCODE, MASUKIN KE STRING
                        barcodes.append("Value: \(barcode.payloadStringValue!)")
                    }
                }
                //STRING YANG KEBACA MASIH DUPLIKAT, GATAU CARA ILANGINNYA WKWKWKWKWK
                self.descImage.text = barcodes.joined(separator: "\n")
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do {
                try handler.perform([barcodeRequest])
            } catch let reqErr {
                print("failed to perform request: ", reqErr)
            }
        }
        
        //KALO PAKE BARCODE SCANNER (GOOGLE - ERROR)
//        else if detectionName.text == "Barcode Detection"{
//            var barcodeDetector = GMVDetector.init(ofType: GMVDetectorTypeBarcode, options: options)
//            var type: String = ""
//            var value: String = ""
//            if let features = barcodeDetector?.features(in: image, options: nil) as? [GMVBarcodeFeature]{
//                for barcode in features{
//                    switch(barcode.valueFormat){
//                    case .contactInfo:
//                        type = "Contact Info"
//                        value = barcode.displayValue
//                        break
//
//                    case .email:
//                        type = "Email"
//                        value = barcode.displayValue
//                        break
//
//                    case .driversLicense:
//                        type = "Driver License"
//                        value = barcode.displayValue
//                        break
//
//                    case .product:
//                        type = "Product"
//                        value = barcode.displayValue
//
//                    case .phone:
//                        type = "Phone Number"
//                        value = barcode.displayValue
//
//                    case .geographicCoordinates:
//                        type = "Map Coordinate"
//                        value = barcode.displayValue
//
//                    case .text:
//                        type = "Plain Text"
//                        value = barcode.displayValue
//
//                    case .URL:
//                        type = "URL"
//                        value = barcode.displayValue
//
//                    case .SMS:
//                        type = "SMS"
//                        value = barcode.displayValue
//
//                    default:
//                        value = barcode.displayValue
//                        break
//                    }
//
//                    let x = selectImage.frame.width / image.size.width * barcode.bounds.origin.x
//                    let width = selectImage.frame.width / image.size.width * barcode.bounds.width
//                    let height = selectImage.frame.height / image.size.height * barcode.bounds.height
//                    let y = selectImage.frame.height / image.size.height * barcode.bounds.origin.y
//
//                    let redView = UIView()
//                    redView.backgroundColor = .red
//                    redView.alpha = 0.4
//                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
//                    redView.tag = 10
//                    self.selectImage.addSubview(redView)
//
//                    descImage.text = "Type: \(type) \nValue: \(value)"
//                }
//            }
//
//        }
    }
    
}



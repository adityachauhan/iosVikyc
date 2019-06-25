//
//  PreviewViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 13/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit
import Vision
import CoreML
import Alamofire

//import Mantis
//import CropViewController

class PreviewViewController: UIViewController, UIScrollViewDelegate {

 
    
    @IBOutlet var previewImage: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var image : UIImage?
    //var model : PanAadharClassifierMobilenet!
    var firstName : String?
    var lastName: String?
    var address: String?
    var address2: String?
    var dob: String?
    var issDate: String?
    var dlno: String?
    var exp: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        previewImage.image = self.image
        
        
        
        UIGraphicsBeginImageContextWithOptions(previewImage.bounds.size, true, 0.0)
        //UIGraphicsGetCurrentContext()
        previewImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        previewImage.image = croppedImage

//        UIImageWriteToSavedPhotosAlbum(previewImage.image!, nil, nil, nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "classificationErrorSegue"{
            let errVC = segue.destination as! ErrorViewController
            errVC.img = previewImage.image
        }
        if segue.identifier == "reviewSegue"{
            let revVC = segue.destination as! ReviewViewController
            revVC.img = previewImage.image
            revVC.firstName = firstName!
            revVC.lastname = lastName!
            revVC.add1 = address!
            revVC.add2 = address2!
            revVC.DOB = dob!
            revVC.dln = dlno!
            revVC.isD = issDate!
            revVC.exD = exp!
           
            //revVC.fname.text = firstName
        }
    }

  
    

    @IBAction func Proceed(_ sender: Any) {
        
        
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 224, height: 224), true, 2.0)
        previewImage.image?.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let normalizedCGImage = newImage?.cgImage

        guard let model = try? VNCoreMLModel(for: californiaDLClassifierMobilenetModel().model) else{return}
        
        

        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in

            guard let result = finishedReq.results as? [VNClassificationObservation] else{return}
            guard let firstObs  = result.first else{return}
            print(firstObs.identifier, firstObs.confidence)
            if (firstObs.identifier == "Front" && firstObs.confidence < 0.75){
                self.performSegue(withIdentifier: "classificationErrorSegue", sender: nil)
            }
            else if(firstObs.identifier=="Other"){
                let alertController = UIAlertController(title: "_Not California DL_", message: "Captured image doesn't correspond to Authentic California Driving License. Dissmis and Rescan with correct document", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "DISMISS", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.activityIndicator.startAnimating()
                self.detectBoundingBoxes(for: self.previewImage.image!)
            }
        }

        


        try? VNImageRequestHandler(cgImage: normalizedCGImage!).perform([request])
        //UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        
        
        
        
        
        
        
        
    }
    
    private func detectBoundingBoxes(for image: UIImage){
        GoogleCloudOCR().detect(from: image) { ocrResult in
            self.activityIndicator.stopAnimating()
            guard let ocrResult = ocrResult else{
                fatalError("Didnot get ocr data")
            }
            var ocrResultArr = ocrResult.split(separator: "\n")
            print(ocrResultArr)
            
            
            let dlnum = ocrResultArr[2].split(separator: " ")
            let expdate = ocrResultArr[5].split(separator: " ")
            let ln = ocrResultArr[6].split(separator: " ")
            let fn = ocrResultArr[7].split(separator: " ")
            let dateOfBirth = ocrResultArr[10].split(separator: " ")
            let last = ocrResultArr.popLast()
            if last!.contains(" ") {
                let lastDate = last?.split(separator: " ")
                self.issDate = String(lastDate![1].prefix(10))
            }
            else{
                self.issDate = String(last!)
            }
            
            self.dlno = String(dlnum[1])
            self.exp = String(expdate[1])
            self.lastName = String(ln[1])
            self.firstName = String(fn[1])
            self.address = String(ocrResultArr[8])
            self.address2 = String(ocrResultArr[9])
            self.dob = String(dateOfBirth[1])
            //self.issDate = String(dlnum[1])
            
            
            
            
            
            
            self.performSegue(withIdentifier: "reviewSegue", sender: nil)
            //print("Found \(ocrResult) bounding box annotations in the image!")
        }
    }
    
    
    func pixelBuffer (image:CGImage) -> CVPixelBuffer? {
        
        
        let frameSize = CGSize(width: 224, height: 224)
        
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: 224, height: 224))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
    
   



}



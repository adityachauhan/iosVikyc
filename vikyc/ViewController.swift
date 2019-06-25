//
//  ViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 11/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

//import AVKit

class ViewController: UIViewController{

    var captureSession = AVCaptureSession()
    var backCamera : AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    
    let alertService = AlertService()
    
    var photoOutput : AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    @IBOutlet var camerView: UIView!
    
    //let cropZone = CGRect(x: 42.0, y: 128.0, width: 291.0, height: 191.0)
    
    var cropArea: CGRect{
        get{
            let x = camerView.frame.origin.x
            let y = camerView.frame.origin.y
            let width = camerView.frame.width
            let height = camerView.frame.height
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) {}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertVC = alertService.alert()
        present(alertVC, animated: true)
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        setupRunningCaptureSession()
        
        // Do any additional setup after loading the view.
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch{
            print(error)
        }
        
    }
    
    func setupPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        camerView.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.position = CGPoint(x: self.camerView.frame.width/2, y: self.camerView.frame.height/2)
        cameraPreviewLayer?.bounds = camerView.frame
        //        cameraPreviewLayer?.frame = self.view.frame
        //        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func setupRunningCaptureSession(){
        captureSession.startRunning()
        
    }
    
    

    @IBAction func TakePhoto(_ sender: Any) {
        let setting = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: setting, delegate: self)
        
        //performSegue(withIdentifier: "photoPreviewSegue", sender: nil)
    }
    
    //segue.destination as? UINavigationController, let vc = nc.viewControllers.first as? EmbeddedCropViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPreviewSegue"{
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
            
        }
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            image = UIImage(data: imageData)
            
            
            //UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
            performSegue(withIdentifier: "photoPreviewSegue", sender: nil)

        }
        
        
    }
    
    
}





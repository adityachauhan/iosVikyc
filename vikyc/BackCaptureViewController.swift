//
//  BackCaptureViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 25/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit
import AVFoundation

class BackCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    
    var photoOutput : AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?

    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        setupRunningCaptureSession()
        
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
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
    
    func setupInputOutput() {
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
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.position = CGPoint(x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
        cameraPreviewLayer?.bounds = cameraView.frame
        
    }
    
    func setupRunningCaptureSession() {
        captureSession.startRunning()
        
    }
    
    

    
    @IBAction func capture(_ sender: Any) {
        let setting = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: setting, delegate: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backpreviewSegue"{
            let previewVC = segue.destination as! BackPreviewViewController
            previewVC.img = self.image
        }
    }
    
}

extension BackCaptureViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "backpreviewSegue", sender: nil)
        }
    }
}

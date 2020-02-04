//
//  QRModeViewController.swift
//  London WayFind
//
//  Created by Malgosia on 3/30/19.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import AVFoundation
import UIKit

class QRModeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var busName: String = ""
    var busID: String = ""
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scanSuccessAudio = AVAudioPlayer()
    var scanFailedAudio = AVAudioPlayer()
    
    let closeQRReader: UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    let mainInstructionView = UIImageView(image:UIImage(named: "QR Instruction")!)
    let successMessageView = UIImageView(image: UIImage(named: "QR Success")!)
    let errorMessageView = UIImageView(image: UIImage(named: "QR Error")!)
    
    let errorFeedback = UINotificationFeedbackGenerator()
    
    var scanStatus = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let successAudio = Bundle.main.path(forResource: "scansuccess" , ofType: "mp3")
        let failAudio = Bundle.main.path(forResource: "scanfailure" , ofType: "mp3")
        
        do {
            scanSuccessAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: successAudio!))
            scanFailedAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: failAudio!))
        }
            
        catch{
            print("Error!")
        }
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        // Close Button
        closeQRReader.frame = CGRect(x: 20, y: 52, width: 72, height: 72)
        closeQRReader.setBackgroundImage(UIImage(named: "Exit Mode View"), for: UIControl.State.normal)
        closeQRReader.addTarget(self, action: #selector(exitQRMode), for: .touchUpInside)
        
        mainInstructionView.frame = CGRect(x: 44, y: 800, width: 327, height: 52)
        
        successMessageView.frame = CGRect(x: 44, y: 800, width: 327, height: 52)
        successMessageView.isHidden = true
        
        errorMessageView.frame = CGRect(x: 44, y: 800, width: 327, height: 52)
        errorMessageView.isHidden = true
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        view.addSubview(closeQRReader)
        view.addSubview(mainInstructionView)
        view.addSubview(successMessageView)
        view.addSubview(errorMessageView)
        
        captureSession.startRunning()
    }
    
    //Determines if the Close button has been tapped
    @objc func exitQRMode(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
        let rateMyRideViewController = storyBoard.instantiateViewController(withIdentifier: "RateMyRideViewController") as! RateMyRideVC
        self.present(rateMyRideViewController, animated: false, completion: nil)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        if(scanStatus == 0) {
        mainInstructionView.isHidden = true
        errorMessageView.isHidden = false
        view.addSubview(errorMessageView)
        sleep(1)
        }
        else if(scanStatus == 1) {
            mainInstructionView.isHidden = true
            successMessageView.isHidden = false
            view.addSubview(successMessageView)
            sleep(1)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            errorFeedback.prepare()
            found(code: stringValue)
        }
        
        //dismiss(animated: true)
    }
    
    func found(code: String) {
        let stringOfWords = code.components(separatedBy: ",")
        if (stringOfWords.first == "8080") {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            scanStatus = 1
            mainInstructionView.isHidden = true
            successMessageView.isHidden = false
            scanSuccess()
            busName = stringOfWords[1]
            busID = stringOfWords[2]
            let rateMyRideView = self.storyboard?.instantiateViewController(withIdentifier: "RateMyRideViewController") as! RateMyRideVC
            rateMyRideView.scannedBusName = busName
            rateMyRideView.scannedBusID = busID
            self.present(rateMyRideView, animated: false)
        }
        else {
            scanStatus = 0
            errorFeedback.notificationOccurred(.error)
            mainInstructionView.isHidden = true
            errorMessageView.isHidden = false
            scanFailure()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
            let rateMyRideView = storyBoard.instantiateViewController(withIdentifier: "RateMyRideViewController") as! RateMyRideVC
            self.present(rateMyRideView, animated: false)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func scanSuccess() {
        scanSuccessAudio.play()
    }
    
    func scanFailure() {
        scanFailedAudio.play()
    }
}

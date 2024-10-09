//
//  ScannerVC.swift
//  BarodcodeApp
//
//  Created by Sambhav Singh on 07/10/24.
//

import Foundation
import UIKit
import AVFoundation


enum CameraError : String{
    case invalidDeviceInput = "You are stupid you did something wrong with device input"
    case invalidScannedValue = "you are a moron idiot and scanned a wrong thing"
}


protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurfaceError(error: CameraError)
}


final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate : ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return }
        previewLayer.frame = view.layer.bounds
    }
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else {
            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        let mataDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(mataDataOutput) {
            captureSession.addOutput(mataDataOutput)
        }else {
            scannerDelegate?.didSurfaceError(error: .invalidDeviceInput)
            return
        }
        
        mataDataOutput.setMetadataObjectsDelegate(self, queue: .main)
        mataDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
}


extension ScannerVC:AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
            return }
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
 
            return }
        guard let barCode = readableObject.stringValue else {scannerDelegate?.didSurfaceError(error: .invalidScannedValue)
 
            return }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barCode)
    }
}

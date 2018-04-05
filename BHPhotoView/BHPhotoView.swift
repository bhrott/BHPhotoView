//
//  BHPhotoView.swift
//  BHPhotoView_Tests
//
//  Created by Ben-Hur Santos Ott on 22/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public protocol BHPhotoViewDelegate {
    func onPhotoCaptured(_ view:BHPhotoView, photo: UIImage)
    func onPhotoCapturingError(_ view:BHPhotoView, error: BHPhotoViewError)
}

public struct BHPhotoViewError: Error {
    public var errorCode: String
    public var message: String
    public var rawError: Error?
    
    public init(_ code: String, message: String, error: Error? = nil) {
        self.errorCode = code
        self.message = message
        self.rawError = error
    }
}

public class BHPhotoView: UIView {
    //
    // MARK: configurable
    public var captureSession: AVCaptureSession?
    
    public var capturePhotoOutput: AVCapturePhotoOutput?
    
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    public var photoSettings: AVCapturePhotoSettings!
    
    public var cameraPosition: AVCaptureDevice.Position = .back {
        didSet {
            self.configureForCamera()
        }
    }
    
    public var delegate: BHPhotoViewDelegate? =  nil
    
    public var previewOrientation: AVCaptureVideoOrientation? {
        get {
            return self.videoPreviewLayer?.connection?.videoOrientation
        }
        set {
            guard newValue != nil else {
                return
            }
            
            if self.videoPreviewLayer?.connection?.isVideoOrientationSupported == true {
                self.videoPreviewLayer?.connection?.videoOrientation = newValue!
            }
        }
    }
    
    //
    // MARK: initialization
    public convenience init() {
        self.init(frame: .zero)
        self.configureForCamera()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.frame = frame
        self.configureForCamera()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureForCamera()
    }
    
    //
    // MARK: public methods
    public func start() {
        self.captureSession?.startRunning()
    }
    
    public func stop() {
        self.captureSession?.stopRunning()
    }
    
    public func capturePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            let err = BHPhotoViewError.init("CAPTURING_PHOTO_OUTPUT", message: "Error when capturing photo output.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        let settingsForThisCapture = AVCapturePhotoSettings.init(from: self.photoSettings)
        capturePhotoOutput.capturePhoto(with: settingsForThisCapture, delegate: self)
    }
    
    //
    // MARK: private methods
    private func configureForCamera() {
        self.photoSettings = AVCapturePhotoSettings()
        self.photoSettings.isAutoStillImageStabilizationEnabled = true
        self.photoSettings.isHighResolutionPhotoEnabled = true
        self.photoSettings.flashMode = .off
        
        let captureDevice = self.getDevice()
        
        guard captureDevice != nil else {
            let err = BHPhotoViewError.init("DEVICE_NOT_SUPPORTED", message: "Your current device not support camera capture.", error: nil)
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let videoPreviewLayerName = "BHPhotoView.AVCaptureVideoPreviewLayer"
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = self.layer.bounds
        videoPreviewLayer?.name = videoPreviewLayerName
        
        if let existingVideoPreviewLayer = self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.name == videoPreviewLayerName
        }) {
            existingVideoPreviewLayer.removeFromSuperlayer()
            existingVideoPreviewLayer.removeAllAnimations()
        }
        
        self.layer.addSublayer(videoPreviewLayer!)
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    private func getDevice() -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: self.cameraPosition)
        
        for device in deviceDescoverySession.devices {
            if device.position == self.cameraPosition {
                return device
            }
        }
        
        return nil
    }
}

extension BHPhotoView : AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                            previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings,
                            bracketSettings: AVCaptureBracketedStillImageSettings?,
                            error: Error?) {
        
        // get captured image
        // Make sure we get some photo sample buffer
        guard error == nil else {
            let err = BHPhotoViewError.init("AVFOUNDATION_ERROR", message: "Error when retrieving photo from AVFoundation.", error: error)
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        guard let photoSampleBuffer = photoSampleBuffer else {
            let err = BHPhotoViewError.init("RETRIEVING_BUFFER", message: "Error when retrieving buffer.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                let err = BHPhotoViewError.init("RETRIEVING_IMAGE_DATA", message: "Error when retrieving image data.")
                self.delegate?.onPhotoCapturingError(self, error: err)
                return
        }
        
        // Initialise a UIImage with our image data
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            let err = BHPhotoViewError.init("GENERATING_UIIMAGE", message: "Error when generating uiimage.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        self.delegate?.onPhotoCaptured(self, photo: capturedImage)
    }
}

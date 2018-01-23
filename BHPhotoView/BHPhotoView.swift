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
    public var message: String
    public var rawError: Error?
    
    public init(_ message: String, error: Error? = nil) {
        self.message = message
        self.rawError = error
    }
}

public class BHPhotoView: UIView {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var delegate: BHPhotoViewDelegate? =  nil
    
    public func start(cameraPosition: AVCaptureDevice.Position) {
        self.configureForCamera(cameraPosition: cameraPosition)
        self.captureSession?.startRunning()
    }
    
    public func stop() {
        self.captureSession?.stopRunning()
    }
    
    public func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        self.capturePhoto(usingSettings: photoSettings)
    }
    
    public func capturePhoto(usingSettings photoSettings: AVCapturePhotoSettings) {
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            let err = BHPhotoViewError.init("Error when capturing photo output.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func configureForCamera(cameraPosition: AVCaptureDevice.Position) {
        let captureDevice = self.getDevice(position: cameraPosition)
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = self.layer.bounds
        self.layer.addSublayer(videoPreviewLayer!)
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    private func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.unspecified)
        
        for device in deviceDescoverySession.devices {
            if device.position == position {
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
            let err = BHPhotoViewError.init("Error when retrieving photo from AVFoundation", error: error)
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        guard let photoSampleBuffer = photoSampleBuffer else {
            let err = BHPhotoViewError.init("Error when retrieving buffer.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                let err = BHPhotoViewError.init("Error when retrieving image data.")
                self.delegate?.onPhotoCapturingError(self, error: err)
                return
        }
        // Initialise a UIImage with our image data
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            let err = BHPhotoViewError.init("Error when generating uiimage.")
            self.delegate?.onPhotoCapturingError(self, error: err)
            return
        }
        
        self.delegate?.onPhotoCaptured(self, photo: capturedImage)
    }
}



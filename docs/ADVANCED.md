# BHPhotoView :: Advanced

## Customazing photo settings

If you want, you can pass a [AVCapturePhotoSettings](https://developer.apple.com/documentation/avfoundation/avcapturephotosettings) configuration:
```swift
// note: this is the default
let photoSettings = AVCapturePhotoSettings()
photoSettings.isAutoStillImageStabilizationEnabled = true
photoSettings.isHighResolutionPhotoEnabled = true
photoSettings.flashMode = .auto

self.photoView.photoSettings = photoSettings
```

## Exposed properties

To customize native camera components, we expose this properties:

* `.captureSession`: this is a [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession) instance.
* `.capturePhotoOutput`: this is a [AVCapturePhotoOutput](https://developer.apple.com/documentation/avfoundation/avcapturephotooutput) instance.
* `.videoPreviewLayer`: this is a [AVCaptureVideoPreviewLayer](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer) instance.


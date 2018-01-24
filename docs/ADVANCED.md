# BHPhotoView :: Advanced

## capturePhoto

To capturing a photo from camera stream, we use the `capturePhoto` method.

If you want, you can pass a [AVCapturePhotoSettings](https://developer.apple.com/documentation/avfoundation/avcapturephotosettings) configuration:
```swift
// note: this is the default
let photoSettings = AVCapturePhotoSettings()
photoSettings.isAutoStillImageStabilizationEnabled = true
photoSettings.isHighResolutionPhotoEnabled = true
photoSettings.flashMode = .off

self.myBHPhotoView.capturePhoto(usingSettings: photoSettings)
```
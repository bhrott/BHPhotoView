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

## Chaning video preview layer

If you want to make some advanced customization on [AVCaptureVideoPreviewLayer](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer):

```swift
// this is a sample for preview orientation
if self.photoView.videoPreviewLayer?.connection?.isVideoOrientationSupported == true {
    self.photoView.videoPreviewLayer?.connection?.videoOrientation = .portrait
}
```
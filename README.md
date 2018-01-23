# BHPhotoView
A ultra simple camera viewer for UIView


## Instalation
Requirements:
* Swift 4
* iOS 10.0+
* XCode 9+

Using [cocoapods](https://cocoapods.org/):

```ruby
target 'YouProject' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestCameraPod
  pod 'BHPhotoView'

end
```

## Usage

### 1 - Creating Code Base
Add a UIView to your screen:

![Adding UIView](docs/res/adding_uiview.png)

<br />
Set your uiview class to `BHPhotoView`:

![Set Custom Class](docs/res/set_custom_class.png)

<br />
In your `ViewController`:

Import the lib:
```swift
import UIKit
import BHPhotoView //<-- here

class ViewController: UIViewController {

}
```

Link a `IBOutlet` from your UIView:
![Linking IBOutlet](docs/res/linking_iboutlet.png)

### 2 - Configuring for Camera
In your `Info.plist` project, set the `Privacy - Camera Usage Description` with any text you want.

![Set Info PList](docs/res/set_info_plist.png)

In your `ViewController`, add the `BHPhotoViewDelegate`:
```swift
extension ViewController: BHPhotoViewDelegate {
    func onPhotoCaptured(_ view: BHPhotoView, photo: UIImage) {
        // when photo has been taken, this method will be called.
    }
    
    func onPhotoCapturingError(_ view: BHPhotoView, error: BHPhotoViewError) {
        // if some error occurs, this method has been called.
    }
}
```

Set the delegate:
```swift
import UIKit
import BHPhotoView

class ViewController: UIViewController  {

    @IBOutlet weak var photoView: BHPhotoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.delegate = self
    }
}
```

### 3 - Starting and capturing from camera
To start camera, call the `start` method:
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.photoView.delegate = self

    // cameraPosition can be: .front | .back | .unspecified
    self.photoView.start(cameraPosition: .front)
}
```

To capture photo, call the `capturePhoto` method:
```swift
@IBAction func onTouchMyButton(_ sender: Any) {
    // when you call this method and photo has been taken,
    // the delegate methods will be called.
    self.photoView.capturePhoto()
}
```

To stop streaming, use the `stop` method:
```swift
@IBAction func onTouchMyButton(_ sender: Any) {
    self.photoView.stop()
}
```

### 4 - Result =)
![Result](docs/res/bhphotoview.mov.gif)


## Release Notes

### 0.10.0
* Feat: adding `stop` method.

### 0.9.1
* Fix: cocoapods validation.

### 0.9.0: First release o/
Pod::Spec.new do |s|
  s.name             = 'BHPhotoView'
  s.version          = '0.11.0'
  s.summary          = 'A ultra simple UIView for camera capturing.'
 
  s.homepage         = 'https://github.com/benhurott/BHPhotoView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ben-hur Santos Ott' => 'ben-hur@outlook.com' }
  s.source           = { :git => 'https://github.com/benhurott/BHPhotoView.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'BHPhotoView/BHPhotoView.swift'
  s.frameworks   = 'UIKit', 'AVFoundation'

end
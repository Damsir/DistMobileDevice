Pod::Spec.new do |s|

  s.name         = "DistMobileDevice"
  s.version      = "1.0.4"
  s.summary      = "iOS device adaptation framework"
  s.author       = { "Damrin" => "75081647@qq.com" }
  s.homepage    = 'https://github.com/Damsir/DistMobileDevice'
  s.source      = { :git => 'https://github.com/Damsir/DistMobileDevice.git', :tag => s.version }
  s.license = "MIT"
  s.platform = :ios, "8.0"
  s.requires_arc = true
  s.source_files = "DistMobileDevice", "DistMobileDevice/**/*.{h,m}"
  # s.public_header_files = "DistSlideSegment/*.h"
  s.framework = 'UIKit'
  s.ios.deployment_target = "8.0"

end
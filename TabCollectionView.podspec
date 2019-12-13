#
# Be sure to run `pod lib lint TabCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TabCollectionView'
  s.version          = '0.1.2'
  s.summary          = 'A Light-weight Swift Library that mimics ViewPager of Android in iOS in the simplest and efficient way'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A Light-weight Swift Library that mimics ViewPager of Android in iOS in the simplest and efficient way. TabCollectionView can be used like any other View of UIKit. It follows the same architecture and delegation pattern.
                       DESC

  s.homepage         = 'https://github.com/akaashdev/TabCollectionView'
  s.screenshots     = 'https://raw.githubusercontent.com/akaashdev/TabCollectionView/master/Screenshots/screen-record-iphone-1.gif',
                      'https://raw.githubusercontent.com/akaashdev/TabCollectionView/master/Screenshots/screen-record-ipad-1.gif',
                      'https://raw.githubusercontent.com/akaashdev/TabCollectionView/master/Screenshots/screen-record-ipad-2.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Akaash Dev' => 'heatblast.akaash@gmail.com' }
  s.source           = { :git => 'https://github.com/akaashdev/TabCollectionView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/akaash_dev'

  s.ios.deployment_target = '11.0'

  s.source_files = 'TabCollectionView/Classes/**/*'
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'TabCollectionView' => ['TabCollectionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

#
# Be sure to run `pod lib lint TYLive2D.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TYLive2D'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TYLive2D.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luckytianyiyan/TYLive2D'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luckytianyiyan' => 'luckytianyiyan@gmail.com' }
  s.source           = { :git => 'https://github.com/luckytianyiyan/TYLive2D.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = ['TYLive2D/Classes/**/*', 'TYLive2D/Live2D/include/**/*']

  # s.vendored_libraries = 'TYLive2D/Live2D/lib/Release-iphoneos/libLive2D.a'
  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '${PODS_ROOT}/TYLive2D/Live2D/lib/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)/libLive2D.a',
    'GCC_PREPROCESSOR_DEFINITIONS' => 'L2D_TARGET_IPHONE'
  }

  # s.resource_bundles = {
  #   'TYLive2D' => ['TYLive2D/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

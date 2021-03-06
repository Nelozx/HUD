#
# Be sure to run `pod lib lint SLHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SLHUD'
  s.version          = '1.0.2'
  s.summary          = 'Toast & Loading & progress & custom ++'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Do yourself with Toast & Loading & progress & custom ++
                       DESC

  s.homepage         = 'https://git.saloontech.com/iOS/SLHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nelo' => 'nelozx@163.com' }
  s.source           = { :git => 'https://git.saloontech.com/iOS/SLHUD.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions   = ['5.3']

  s.source_files = 'SLHUD/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SLHUD' => ['SLHUD/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

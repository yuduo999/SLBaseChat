#
# Be sure to run `pod lib lint SLBaseChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SLBaseChat"
  s.version          = "1.0.0"
  s.summary          = "A short description of SLBaseChat."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        Sino Life IM SDK
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/SLBaseChat"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "song.zhang" => "song.zhang1@sino-life.com" }
  s.source = { :git => "/Volumes/Data/SLBaseChat", :tag => '1.0.0' }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SLBaseChat' => ['Pod/BCResources/*.png']
  }
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'MobileCoreServices', 'CFNetwork', 'CoreGraphics'
  s.libraries  = 'z.1'
  s.dependency 'MBProgressHUD', '~> 0.9.2'
  s.dependency 'ASIHTTPRequest', '~> 1.8.2'
  s.dependency 'ProtocolBuffers', '~> 1.9.10'
  s.dependency 'SocketRocket', '~> 0.5.0'

end

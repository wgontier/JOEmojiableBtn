#
# Be sure to run `pod lib lint JOEmojiableBtn.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JOEmojiableBtn"
  s.version          = "0.1.0"
  s.summary          = "Option selector that works similar to Reactions by fb"

  s.description      = "Totally customizable Options (Emoji) Selector based on Reactions"

  s.homepage         = "https://github.com/lojals/JOEmojiableBtn"
  s.license          = 'MIT'
  s.author           = { "Jorge Ovalle" => "jroz9105@gmail.com" }
  s.source           = { :git => "https://github.com/lojals/JOEmojiableBtn.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lojals_'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JOEmojiableBtn' => ['Pod/Assets/*.png']
  }
end


Pod::Spec.new do |spec|

spec.name                  = 'ZLVideoPlayerView'

spec.version               = '1.0.0'

spec.ios.deployment_target = '9.0'

spec.license               = 'MIT'

spec.homepage              = 'https://github.com/TsinHzl/ZLVideoPlayerView'

spec.author                = {"TsinHzl" => "tsinhzl@icloud.com" }

spec.summary               = '一个简单实用的视频播放框架，内部支持全屏切换功能'

spec.source                = { :git => 'https://TsinHzl@github.com/TsinHzl/ZLVideoPlayerView.git', :tag => spec.version }

spec.source_files          = "ZLVideoPlayerView/ZLVideoPlayerView/*.{h.m}"

spec.resources             = "ZLVideoPlayerView/ZLVideoPlayerView*.{xib,bundle}"

spec.frameworks            = 'UIKit'

spec.requires_arc          = true

end


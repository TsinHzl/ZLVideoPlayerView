Pod::Spec.new do |s|
s.name = 'ZLVideoPlayView'
s.version = '1.0.0'
s.summary = '一个简单实用的视频播放框架，内部支持全屏切换功能'
s.homepage = 'https://github.com/TsinHzl/ZLVideoPlayerView'
s.license = 'MIT'
s.platform = :ios
s.author = {'TsinHzl' => 'tsinhzl@icloud.com'}
s.ios.deployment_target = '8.3'
s.source = {:git => 'https://TsinHzl@github.com/TsinHzl/ZLVideoPlayerView.git', :tag => s.version}
s.source_files = 'ZLVideoPlayView/*.{h.m}'
s.resources ='ZLVideoPlayView/*.{xib,bundle}'
s.requires_arc = true
s.frameworks = 'UIKit','AVFoundation'
end

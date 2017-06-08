# ZLVideoPlayerView
简单的播放视频的框架

#简单的使用方法：一句代码解决
'''objc
导入头文件
#import "UIView+ZLVideoPlayerView.h"
'''
'''objc

[self.playView zl_setVideoPlayerViewWithUrl:@"http://baobab.wdjcdn.com/1462506457051glove_x264.mp4"];

'''

#注意：必须在AppDelegate里面实现以下代码
1. 在AppDelegate.h文件里定义下面属性，用来记录是否可以旋转
@property (nonatomic, assign) BOOL allowRotation; // 标记是否可以旋转
2. 在AppDelegaet.m里面实现以下代码
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {

    //    是非支持横竖屏

    if (_allowRotation) {

        return UIInterfaceOrientationMaskAll;

    } else{

    return UIInterfaceOrientationMaskPortrait;

}

}

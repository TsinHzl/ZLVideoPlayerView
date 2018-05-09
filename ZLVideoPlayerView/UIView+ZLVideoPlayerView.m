//
//  UIView+ZLVideoPlayerView.m
//  ZLApp
//
//  Created by MacTsin on 16/5/7.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "UIView+ZLVideoPlayerView.h"

@implementation UIView (ZLVideoPlayerView)

- (void)zl_setVideoPlayerViewWithUrl:(NSString *)url
{
    ZLVideoPlayerView *videoPlayerView = [ZLVideoPlayerView videoView];
    videoPlayerView.frame = self.bounds;
    videoPlayerView.url = url;
    [self addSubview:videoPlayerView];
}

@end

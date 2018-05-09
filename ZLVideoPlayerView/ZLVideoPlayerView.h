//
//  ZLVideoPlayerView.h
//  ZLVideoPlayerView
//
//  Created by MacTsin on 16/5/4.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

/*
 请默认设置
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/** 是否全屏通知 */
UIKIT_EXTERN NSString * const ZLVideoPlayerViewIsFullScreenNotification;
/** 是否全屏通知参数名字(这是bool类型，1:表示全屏，0：表示不是全屏) */
UIKIT_EXTERN NSString * const ZLVideoPlayerViewIsFullScreenNotificationParamsName;

@interface ZLVideoPlayerView : UIView

+ (instancetype)videoView;

/** url */
@property (nonatomic, copy) NSString *url;


@end

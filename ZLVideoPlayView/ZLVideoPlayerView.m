//
//  ZLVideoPlayerView.m
//  ZLVideoPlayerView
//
//  Created by MacTsin on 16/5/4.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "ZLVideoPlayerView.h"
#import "ZLFullViewController.h"

NSString * const ZLVideoPlayerViewIsFullScreenNotification = @"ZLIsFullScreenNotification";
NSString * const ZLVideoPlayerViewIsFullScreenNotificationParamsName = @"ZLIsFullScreen";
static CGFloat const ZLTimeInterval = 0.65;
static CGFloat const ZLAlpha = 0.65;

@interface ZLVideoPlayerView()
/** xib属性 */
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
/** 内部属性 */
/** player */
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
/** playItem */
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayer *player;
/** layer */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/* 进度定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;
/** 监听定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 全屏的window */
@property (nonatomic, strong) UIWindow *fullWindow;
/** smallF */
@property (nonatomic, assign) CGRect smallF;
/** superView */
@property (nonatomic, weak) UIView *sView;
/** screenWidth */
@property (nonatomic, assign) CGFloat screenW;
/** screenHeight */
@property (nonatomic, assign) CGFloat screenH;
@end

@implementation ZLVideoPlayerView
#pragma mark - 懒加载


- (CGFloat)screenH
{
    if (_screenH <= 0) {
        self.screenH = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenH;
}
- (CGFloat)screenW
{
    if (_screenW <= 0) {
        self.screenW = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenW;
}
- (UIWindow *)fullWindow
{
    if (!_fullWindow) {
        self.fullWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        ZLFullViewController *vc = [[ZLFullViewController alloc] init];
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, self.screenH , self.screenH);
        bgView.backgroundColor = [UIColor redColor];
        bgView.center = vc.view.center;
        [vc.view addSubview:bgView];
        self.fullWindow.rootViewController = vc;
    }
    return _fullWindow;
}

- (AVPlayer *)player
{
    if (!_player) {
        self.player = [[AVPlayer alloc] init];
    }
    return _player;
}
- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}
#pragma mark - 创建view
+(instancetype)videoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZLVideoPlayerView" owner:self options:nil] firstObject];
}
#pragma mark - 初始化消息
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}
- (void)setupView
{
    self.progressView.value = 0;
    self.timeLabel.text = @"";
    self.backButton.hidden = YES;
    [self.playImageView.layer addSublayer:self.playerLayer];
    
    [self.progressView setThumbImage:[UIImage imageNamed:@"ZLVideoPlayView.bundle/thumbImage"] forState:UIControlStateNormal];
    [self.progressView setMaximumValueImage:[UIImage imageNamed:@"ZLVideoPlayView.bundle/MaximumTrackImage"]];
    [self.progressView setMinimumValueImage:[UIImage imageNamed:@"ZLVideoPlayView.bundle/MinimumTrackImage"]];
    [self addGeustures];
   
}
- (void)addGeustures
{
    //添加双击手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twiceTap:)];
    tapGr.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGr];
    
    UISwipeGestureRecognizer *swipeGr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
//    swipeGr.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
//    swipeGr.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:swipeGr];
}
//双击手势响应事件
- (void)twiceTap:(UITapGestureRecognizer *)gr
{
    [self playBtn:self.playPauseBtn];
}

- (void)swipe:(UISwipeGestureRecognizer *)gr
{
    CGFloat delta = 0;
    NSTimeInterval c = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval d = CMTimeGetSeconds(self.player.currentItem.duration);
    if (gr.direction == UISwipeGestureRecognizerDirectionLeft) {
        delta = (c < 5.0 ? -c : -5.0);
    }else if (gr.direction == UISwipeGestureRecognizerDirectionRight) {
        delta = ((d-c) < 5.0 ? (d-c) : 5.0);
    }
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime) + delta;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self timeStringWithCurrentTime:currentTime duration:duration];
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
    self.playPauseBtn.selected = YES;
}
#pragma mark - 按钮点击方法
//播放按钮点击

- (IBAction)playBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [self addProgressTimer];
    }else {
        [self.player pause];
        [self removeProgressTimer];
    }
}
//退出按钮点击
- (IBAction)backButtonClicked:(id)sender {
    [self fullScreenBtn:self.fullScreenBtn];
    
}
//全屏按钮点击
- (IBAction)fullScreenBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.smallF = self.frame;
        self.sView = self.superview;
        [self removeFromSuperview];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size
                                .height, [UIScreen mainScreen].bounds.size.width);
        self.center = CGPointMake(self.screenH*0.5, self.screenH*0.5);
        [self.fullWindow.rootViewController.view.subviews[0] addSubview:self];
        self.fullWindow.hidden = NO;
        CGAffineTransform transform = self.fullWindow.rootViewController.view.subviews[0].transform;
        transform = CGAffineTransformRotate(transform, M_PI/2);
        self.fullWindow.rootViewController.view.subviews[0].transform = transform;
        self.backButton.hidden = NO;
        /** 发送全屏通知 */
        [[NSNotificationCenter defaultCenter] postNotificationName:ZLVideoPlayerViewIsFullScreenNotification object:nil userInfo:@{ZLVideoPlayerViewIsFullScreenNotificationParamsName : @1}];
    }else {
        [self removeFromSuperview];
        self.frame = self.smallF;
        [self.sView addSubview:self];
        self.fullWindow.hidden = YES;
        self.fullWindow.rootViewController = nil;
        self.fullWindow = nil;
        self.backButton.hidden = YES;
         /** 发送全屏通知 */
        [[NSNotificationCenter defaultCenter] postNotificationName:ZLVideoPlayerViewIsFullScreenNotification object:nil userInfo:@{ZLVideoPlayerViewIsFullScreenNotificationParamsName : @0}];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
//一次点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.toolbar.hidden) {
        [UIView animateWithDuration:ZLTimeInterval animations:^{
            self.toolbar.alpha = 0;
            self.backButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.toolbar.hidden = !self.toolbar.hidden;
        }];
    }else {
        [UIView animateWithDuration:ZLTimeInterval animations:^{
            self.toolbar.hidden = !self.toolbar.hidden;
            self.toolbar.alpha = ZLAlpha;
            self.backButton.alpha = ZLAlpha;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark - 外部方法
-(void)setUrl:(NSString *)url
{
    _url = url;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self playBtn:self.playPauseBtn];
    [self addTimer];
}


#pragma mark - 时间相关
- (NSString *)timeString
{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    return [self timeStringWithCurrentTime:currentTime duration:duration];
}
- (NSString *)timeStringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    if (ABS(currentTime) > 60*60*24) return @"0:0:0/0:00:00";
    
    NSInteger cHour = currentTime/60/60;
    NSInteger cMin = (currentTime - cHour * 60 * 60)/60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSInteger dHour = duration/60/60;
    NSInteger dMin = (duration - cHour * 60 * 60)/60;
    NSInteger dSec = (NSInteger)duration % 60;
    if (dHour > 0) {
        return [NSString stringWithFormat:@"%lu:%lu:%lu/%lu:%lu:%lu",cHour,cMin,cSec,dHour,dMin,dSec];
    }else {
        return [NSString stringWithFormat:@"%lu:%lu/%lu:%lu",cMin,cSec,dMin,dSec];
    }
}
- (IBAction)progressValueChage:(id)sender {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressView.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self timeStringWithCurrentTime:currentTime duration:duration];
}
- (IBAction)startSlide {
    [self removeProgressTimer];
}
- (IBAction)slide {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressView.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
    self.playPauseBtn.selected = YES;
}


#pragma mark - 定时器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeSelf) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
- (void)updateTimeInfo
{
    self.timeLabel.text = [self timeString];
    self.progressView.value = CMTimeGetSeconds(self.player.currentTime)*1.0/CMTimeGetSeconds(self.player.currentItem.duration);
    if (CMTimeGetSeconds(self.player.currentTime) == CMTimeGetSeconds(self.player.currentItem.duration)) {
        if (_fullWindow) {
            [self fullScreenBtn:self.fullScreenBtn];
        }
        [self removeProgressTimer];
        [self removeTimer];
        [self playBtn:self.playPauseBtn];
        self.playerItem = nil;
        [self removeFromSuperview];
    }
}

- (void)removeSelf
{
    if (!_fullWindow) {
        if (![self isShowingOnKeyWindow]) {
            [self removeProgressTimer];
            [self removeTimer];
            [self removeFromSuperview];
        }
    }
}
#pragma mark - @判断view是否显示
/**
 *  @判断view是否显示
 */
- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}
@end

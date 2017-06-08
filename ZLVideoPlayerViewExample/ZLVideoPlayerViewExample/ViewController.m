//
//  ViewController.m
//  ZLVideoPlayerViewExample
//
//  Created by MacTsin on 16/5/7.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZLVideoPlayerView.h"

@interface ViewController ()

@property(nonatomic, weak)UIView *pView;

@end

@implementation ViewController

- (UIView *)pView {
    if (!_pView) {
        UIView *playView = [[UIView alloc] init];
        playView.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 220);
        playView.backgroundColor = [UIColor redColor];
        _pView = playView;
    }
    return _pView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *playBtn = [[UIButton alloc] init];
    playBtn.backgroundColor = [UIColor yellowColor];
    playBtn.frame = CGRectMake(0, 0, 100, 45);
    playBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 100);
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    [self.view addSubview:self.pView];
}


- (void)playBtnClicked:(UIButton *)sender {
    [self.pView zl_setVideoPlayerViewWithUrl:@"http://baobab.wdjcdn.com/1462506457051glove_x264.mp4"];
    sender.selected = !sender.selected;
}

@end

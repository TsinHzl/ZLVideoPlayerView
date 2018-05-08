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

@property (weak, nonatomic) IBOutlet UIView *playView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)playBtnClicked:(UIButton *)sender {
    [self.playView zl_setVideoPlayerViewWithUrl:@"http://baobab.wdjcdn.com/1462506457051glove_x264.mp4"];
    sender.selected = !sender.selected;
}

@end

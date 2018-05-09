//
//  ZLFullViewController.m
//  ZLVideoPlayerView
//
//  Created by MacTsin on 16/5/5.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "ZLFullViewController.h"
#import "ZLVideoPlayerView.h"
#import "ZLPortraitViewController.h"


@interface ZLFullViewController ()

@end

@implementation ZLFullViewController



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ZLPortraitViewController *portraitVC = [[ZLPortraitViewController alloc] init];
    [self presentViewController:portraitVC animated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.playerView.frame = self.view.frame;
    [self.view addSubview:self.playerView];
    
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}



- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

//
//  ZLFullViewController.m
//  ZLVideoPlayerView
//
//  Created by MacTsin on 16/5/5.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "ZLFullViewController.h"



@interface ZLFullViewController ()

@end

@implementation ZLFullViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end

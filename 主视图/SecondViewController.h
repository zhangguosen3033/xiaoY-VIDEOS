//
//  SecondViewController.h
//  Video
//
//  Created by MS on 16-1-7.
//  Copyright (c) 2016年 杨志远. All rights reserved.
//
#import "AppDelegate.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "CFDanmakuView.h"
#import "CFDanmaku.h"
#import "CFDanmakuInfo.h"

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic, strong) FMGVideoPlayView *playView;

@property (nonatomic,strong)FullViewController *fullVc;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITextField * testDanma;
@property (nonatomic, strong) UIButton * sendButton;
@property (nonatomic, strong) UIButton * hiddenButton;

@property (nonatomic,copy)NSString *videourl;

@end

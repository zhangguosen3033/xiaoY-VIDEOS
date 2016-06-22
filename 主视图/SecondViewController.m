//
//  SecondViewController.m
//  Video
//
//  Created by MS on 16-1-7.
//  Copyright (c) 2016年 杨志远. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<FMGVideoPlayViewDelegate,CFDanmakuDelegate>
{
    BOOL _isShowDanmak;
    
    BOOL _isPlaying;
    
}
@end

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _isPlaying = YES;
    [self createPlayView];
    
    [self createUI];
}



-(void)createPlayView
{
    _playView = [FMGVideoPlayView videoPlayView];
    
    _fullVc = [[FullViewController alloc]init];
    
    _playView.delegate = self;
    
    [_playView setUrlString:self.videourl];
    
    _playView.frame = CGRectMake(0, 50, self.view.frame.size.width, 250);
    
    [self.view addSubview:_playView];
    
    [_playView.player play];
    
    _playView.danmakuView.delegate = self;
    
    
    _playView.contrainerViewController = self;
    
    _playView.playOrPauseBtn.selected = YES;
    
    
    
    
    
    
}

-(void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    _isPlaying = _playView.playOrPauseBtn.selected;
    

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if (isFull)
    {
        delegate.allowRotation = YES;
        [self presentViewController:_fullVc animated:NO completion:^{
            [_fullVc.view addSubview:_playView];
            
            _playView.center = _fullVc.view.center;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                _playView.frame = _fullVc.view.bounds;
                
                if (_isPlaying)
                {
                    _playView.playOrPauseBtn.selected = YES;
                    
                    [_playView.player play];
                }else
                {
                    _playView.playOrPauseBtn.selected = NO;
                    
                    [_playView.player pause];
                    
                    _isPlaying = NO;
                    
                }
                
                
                
                
            }];
        }];
        
    }else
    {
        delegate.allowRotation = NO;
        [_fullVc dismissViewControllerAnimated:NO completion:^{
            
            [self.view addSubview:_playView];
            
            _playView.frame = CGRectMake(0, 50,self.view.frame.size.width, 250);
            
        }];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    
    [_playView.player pause];
}


- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    if(_playView.progressSlider.value == 1.0) [_playView.danmakuView stop]
        ;
    return _playView.progressSlider.value*120.0;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
    return NO;
}

-(void)createUI
{
    self.testDanma = [[UITextField alloc] initWithFrame:CGRectMake(10, self.playView.frame.size.height+10+44, self.view.frame.size.width-20, 40)];
    
    self.testDanma.clipsToBounds = YES;
    
    self.testDanma.layer.cornerRadius = 10;
    
    
    self.testDanma.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_testDanma];
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(40, CGRectGetMaxY(self.testDanma.frame), 70, 40);
    [self.sendButton setTitle:@"吐槽 👻" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendButton];
    self.hiddenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hiddenButton.frame = CGRectMake(CGRectGetMaxX(self.sendButton.frame)+130, CGRectGetMinY(self.sendButton.frame), 100, CGRectGetHeight(self.sendButton.frame));
    [self.hiddenButton setTitle:@"隐藏弹幕" forState:UIControlStateNormal];
    self.hiddenButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _isShowDanmak = YES;
    [self.view addSubview:_hiddenButton];
    [self.hiddenButton addTarget:self action:@selector(hiddenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)hiddenButtonAction:(UIButton *)sender{
    if (_isShowDanmak) {
        self.playView.danmakuView.hidden =YES;
        _isShowDanmak = NO;
        [self.hiddenButton setTitle:@"显示弹幕" forState:UIControlStateNormal];
        
    }else{
        self.playView.danmakuView.hidden = NO;
        _isShowDanmak = YES;
        [self.hiddenButton setTitle:@"隐藏弹幕" forState:UIControlStateNormal];
    }
}

- (void)sendButtonAction:(UIButton *)sender{
    int time = ([self danmakuViewGetPlayTime:nil]+1);
    NSString *mString = _testDanma.text;
    CFDanmaku* danmaku = [[CFDanmaku alloc] init];
    danmaku.contentStr = [[NSMutableAttributedString alloc] initWithString:mString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : kRandomColor}];
    danmaku.timePoint = time;
    [_playView.danmakuView sendDanmakuSource:danmaku];
    self.testDanma.text = nil;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

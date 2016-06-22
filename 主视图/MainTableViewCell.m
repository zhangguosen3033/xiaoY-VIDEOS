//
//  MainTableViewCell.m
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "AFNetworking.h"
#import "UMSocial.h"

#import "CoreDataShare.h"
#import "UIImageView+WebCache.h"
#import "MainTableViewCell.h"
#define SIZE [UIScreen mainScreen].bounds.size

@implementation MainTableViewCell
{
    BaseModel *mode;
    
    Video *_video;
    
    BOOL  _isCollected;
    
    UIView *zview;
    
    NSTimer *_timer;
    
    NSString *string;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self createUI];
    }
    
    return self;
}


-(void)createUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, 200)];
    
    
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, SIZE.width-10, 200)];
    
    [view addSubview:_iconView];
    
   
    self.playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    self.playButton.center = view.center;
    
    [view addSubview:self.playButton];
    
    [self.contentView addSubview:view];
    


    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, SIZE.width-20, 40)];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self.contentView addSubview:_titleLabel];
    
    
    
    _netFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 260, 100, 20)];
    
    _netFriendLabel.textColor = [UIColor lightGrayColor];
    
    _netFriendLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:_netFriendLabel];
    
    
    _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _markButton.frame = CGRectMake(SIZE.width-120, 250, 25, 25);
    
    
    [_markButton addTarget:self action:@selector(markClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_markButton setImage:[UIImage imageNamed:@"photo_like"] forState:UIControlStateNormal];
    
    //[_markButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
    
    
    [self.contentView addSubview:_markButton];
    
    _collectButton = [[UIButton alloc]initWithFrame:CGRectMake(SIZE.width-80, 250, 25, 25)];
    
    
    [_collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_collectButton];
    
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(SIZE.width-40, 250, 25, 25)];
    

    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_shareButton];
    
    
     [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

-(void)configWithModel:(BaseModel *)model
{
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.imglink]];
    
    _titleLabel.text = model.title;
    

    _netFriendLabel.text = [NSString stringWithFormat:@"%@/%@",model.sourcename,model.duration];
    
    mode = model;
    
    string = mode.videolink;
    
     _isCollected = [[CoreDataShare shareinstance]accurateFetch:mode.videolink];
    
    
    
    if (_isCollected == YES)
    {
        [_collectButton setImage:[UIImage imageNamed:@"heart_red"] forState:UIControlStateNormal];
    }else
    {
        
        [_collectButton setImage:[UIImage imageNamed:@"heart_gray"] forState:UIControlStateNormal];
    }
    
  
    
    
}

-(void)configWithVideo:(Video *)video
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:video.iconUrl]];
    
    self.titleLabel.text = video.title;
    
    self.netFriendLabel.text = video.sourceName;
    
    _video = video;
    
    
        [_collectButton setImage:[UIImage imageNamed:@"heart_red"] forState:UIControlStateNormal];
   
    _isCollected = YES;
    
}
-(void)markClick
{
    
   
    zview = [[UIView alloc]initWithFrame:CGRectMake(SIZE.width - 105, 240, 20, 20)];
    
    
    _countlabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 20, 20)];
    
    
    
    _countlabel.clipsToBounds = YES ;
    
    _countlabel.layer.cornerRadius = 10;
    
    _countlabel.textColor = [UIColor redColor];
     _countlabel.text = [NSString stringWithFormat:@"+%d",1];
    
    [zview addSubview:_countlabel];
    
    [self.contentView addSubview:zview];
    
    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeFrame) userInfo:nil repeats:NO];
    

    
}

-(void)changeFrame
{
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _countlabel.frame = CGRectMake(SIZE.width-105, 200, 20, 20);
        
        
    } completion:^(BOOL finished) {
        [zview removeFromSuperview];

    }];
    

    
}

-(void)collectClick
{
    if (_isCollected == YES)
    {
        
        [[CoreDataShare shareinstance]deleteDataWithUrl:string];
            
        [_collectButton setImage:[UIImage imageNamed:@"heart_gray"] forState:UIControlStateNormal];
        
    
        _isCollected = NO;
       
    }else
    {
       [[CoreDataShare shareinstance]insertDataWithName:mode.videolink IconUrl:mode.imglink HeaderImage:nil Title:mode.title SourceName:mode.sourcename ID:nil ];
        
        
        [_collectButton setImage:[UIImage imageNamed:@"heart_red"] forState:UIControlStateNormal];
        
        _isCollected = YES;
    }
    
    
    
    
    
}

-(void)shareClicked
{
    [self.celldelegate presentShare:mode.videolink Img:_iconView.image];

}

-(void)playVideo
{
    [self checkedNet];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isEditing)
    {
        [self sendSubviewToBack:self.contentView];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //从0开始，对应按钮的顺序是从取消按钮依次对应提示框上的按钮
    switch (buttonIndex) {
        case 0:
        {
        }
            break;
        case 1:
        {
            
            [self.celldelegate playerPlayVideo:_playButton];
            
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 网络判断
-(void)checkedNet
{
    //<1>创建请求操作管理者对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //<2>判断网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            //  NSLog(@"WIFI");
            //模拟器或者wife 下 自动播放
            
        [self.celldelegate playerPlayVideo:_playButton];
        
        
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            // NSLog(@"3G/4G/GPRS");
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前文件较大，建议wife环境下播放" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续播放",nil];
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            
            [alertView show];
            
        }
        else if (status == AFNetworkReachabilityStatusNotReachable)
        {
            //            NSLog(@"无网络连接");
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"播放失败请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            
            [alertView show];
            
        }
        else
        {
            //  NSLog(@"网络未知");
            
            //  [self.mydelegate playvideo:_playbutton];
        }
    }];
    //<3>开启网络测试
    [manager.reachabilityManager startMonitoring];
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

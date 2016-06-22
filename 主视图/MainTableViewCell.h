//
//  MainTableViewCell.h
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "BaseModel.h"
#import <UIKit/UIKit.h>

@protocol myCellDelegate<NSObject>

-(void)presentShare:(NSString *)url Img:(UIImage *)img;

-(void)playerPlayVideo:(UIButton *)button;

@end

@interface MainTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *netFriendLabel;

@property (nonatomic,strong)UIButton *markButton;

@property (nonatomic,strong)UIButton *collectButton;
@property (nonatomic,strong)UIButton *shareButton;

@property (nonatomic,strong)UILabel *countlabel;

@property(nonatomic,strong)UIButton *playButton;

@property (nonatomic,weak)id<myCellDelegate>celldelegate;

-(void)configWithModel:(BaseModel *)model;

-(void)configWithVideo:(Video *)video;

@end

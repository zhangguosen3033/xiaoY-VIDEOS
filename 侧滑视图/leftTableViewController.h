//
//  leftTableViewController.h
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myDelegate<NSObject>
-(void)changeTypeWithStrting:(NSString *)string AndTitle:(NSString *)title;

-(void)changeTitle:(NSString *)title;
@end
@interface leftTableViewController : UITableViewController
@property (nonatomic,weak)id<myDelegate>mydelegate;

@end

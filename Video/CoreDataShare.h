//
//  CoreDataShare.h
//  CoreDataUse
//
//  Created by MS on 15-12-18.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "Video.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface CoreDataShare : NSObject

+(instancetype)shareinstance;
//插入数据
-(void)insertDataWithName:(NSString *)name IconUrl:(NSString *)iconUrl HeaderImage:(NSData *)imgData Title:(NSString *)title SourceName:(NSString *)sourceName ID:(NSNumber *)id;
//查找数据,以数组的形式返回
-(NSArray *)fetch;

//修改数据
-(void)upadte:(NSString *)name IconUrl:(NSString *)iconUrl HeaderImage:(NSData *)imgData Title:(NSString *)title SourceName:(NSString *)sourceName ID:(NSNumber *)id Video:(Video *)video;

//删除数据
-(void)deleteDataWithModel:(Video *)video;

-(void)deleteDataWithUrl:(NSString *)url;


-(BOOL)accurateFetch:(NSString *)string;


@end

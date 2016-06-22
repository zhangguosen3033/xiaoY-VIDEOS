//
//  CoreDataShare.m
//  CoreDataUse
//
//  Created by MS on 15-12-18.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//

#import "CoreDataShare.h"

@implementation CoreDataShare
{
    AppDelegate *_delegate;
}
+(instancetype)shareinstance
{
    static CoreDataShare *manager;
    
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataShare alloc]init];
    });
    
    
    
    return manager;
    
    
    
}

-(instancetype)init
{
    
    if (self = [super init])
    {
        _delegate = [UIApplication sharedApplication].delegate;
    }
    
    return self;
    
}


-(void)insertDataWithName:(NSString *)name IconUrl:(NSString *)iconUrl HeaderImage:(NSData *)imgData Title:(NSString *)title SourceName:(NSString *)sourceName ID:(NSNumber *)id ;
{
    //和表格建立关系
   Video* video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:_delegate.managedObjectContext];
    
    video.name = name;
    
    video.iconUrl = iconUrl;
    
    video.imgData = imgData;
    
    video.title = title;
    
    video.sourceName = sourceName;
    
   // video.id = id;
    

    if([_delegate.managedObjectContext save:nil])
    {
        NSLog(@"收藏成功");
    }

    
    
    
}

-(NSArray *)fetch
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:_delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    
    NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    
    return array;
    
}


-(void)upadte:(NSString *)name IconUrl:(NSString *)iconUrl HeaderImage:(NSData *)imgData Title:(NSString *)title SourceName:(NSString *)sourceName ID:(NSNumber *)id Video:(Video *)video
{
   
    video.name = name;
    
    video.iconUrl = iconUrl;
    
    video.imgData = imgData;
    
    video.title = title;
    
    video.sourceName = sourceName;
    
  //  video.id = id;
    
    
    [_delegate.managedObjectContext save:nil];
    
}


-(void)deleteDataWithModel:(Video *)video
{
    [_delegate.managedObjectContext deleteObject:video];
    [_delegate.managedObjectContext save:nil];
    NSLog(@"取消收藏成功");
}

-(void)deleteDataWithUrl:(NSString *)url
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:_delegate.managedObjectContext];
    
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"name like %@",[NSString stringWithFormat:@"*%@*",url]];
    
    request.predicate = predict;
    
    [request setEntity:entity];
    
    
    NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (array.count)
    {
        Video *video = array[0];
        
        [_delegate.managedObjectContext deleteObject:video];
        [_delegate.managedObjectContext save:nil];
        NSLog(@"取消收藏成功");
    }
    
    
    
}

-(BOOL)accurateFetch:(NSString *)string
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:_delegate.managedObjectContext];
    
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"name like %@",[NSString stringWithFormat:@"*%@*",string]];
    
    request.predicate = predict;
    
    [request setEntity:entity];
    
    
    NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    
    
    if (array.count)
    {
        return YES;
    }else
    {
        return NO;
 
    }
    
}






@end

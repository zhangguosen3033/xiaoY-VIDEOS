//
//  Video.h
//  Video
//
//  Created by MS on 16-1-5.
//  Copyright (c) 2016年 杨志远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * sourceName;
//@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * imgData;

@end

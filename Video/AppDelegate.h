//
//  AppDelegate.h
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "YRSideViewController.h"
#import "MainViewController.h"
#import "leftTableViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong)YRSideViewController *yrSide;

@property (nonatomic,strong)MainViewController *mainView;

@property (nonatomic,strong)UINavigationController *mainNav;

@property (nonatomic,strong)leftTableViewController *leftTabView;

@property (nonatomic,assign)BOOL allowRotation;



@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end


//
//  AppDelegate.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

//CoreDataフレームワーク
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Coredata用の@propertyを準備
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

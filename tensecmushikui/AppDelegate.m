//
//  AppDelegate.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "AppDelegate.h"
#import "StartController.h"
#import "ColorDefinition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [ColorDefinition getUIColorFromHex:@"222222"];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    return YES;
}

//WatchKitからのReply情報の取得をする
/*
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    //watchからのデータはuserInfoに入っている。（問題の結果を受け取る）
    NSArray *watchKitArray = [userInfo valueForKey:@"watchValue"];
    
    NSString *operationType = watchKitArray[0];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //StartControllerに表示してあげる
    StartController *sc = (StartController *)appDelegate.window.rootViewController;
    
    if([operationType isEqual:@"insert"]){
        
        //正解数・かかった時間を表示
        int correctCount = [watchKitArray[1] intValue];
        float timeCount = [watchKitArray[2] floatValue];
        
        //現在の日付を取得
        NSDate *now = [NSDate date];
        
        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSUInteger flags;
        NSDateComponents *comps;
        
        flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
        comps = [calendar components:flags fromDate:now];
        
        int targetYear  = (int)comps.year;
        int targetMonth = (int)comps.month;
        int targetDay   = (int)comps.day;
        
        sc.debugLabel.text = [NSString stringWithFormat:@"Apple Watchでの計算結果\n%d年%d月%d日: 正解数は%d問\nかかった時間は%.3f秒", targetYear,targetMonth, targetDay, correctCount, timeCount];
        
        //カウントをコアデータに格納する
        [sc addRecordToCoreData:correctCount totalSeconds:timeCount];
    }
    
    if([operationType isEqual:@"select"]){
        
        NSArray *problemArray = [sc syncProblemDataForWatch];
        NSData *problemData = [NSKeyedArchiver archivedDataWithRootObject:problemArray];
        reply(@{@"problemData":problemData});
    }
    
    if([operationType isEqual:@"reswatch"]){
        
        NSArray *todayWatchScoreArray = [sc syncTodayResultToCoreData];
        NSData *todayWatchScoreData = [NSKeyedArchiver archivedDataWithRootObject:todayWatchScoreArray];
        reply(@{@"todayWatchScoreData":todayWatchScoreData});
    }
    
    //if([operationType isEqual:@"test"]){
    //
    //}
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//CoreData用の@synthesizeを設定
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//ManagedObjectModelを返す
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//NSPersistentStoreCoordinatorのインスタンス作成
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

//ManagedObjectContextを返す
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory
//URL(格納場所)を返す
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

//
//  WKTodayController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKTodayController : WKInterfaceController

//本日の結果表示をする
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *todayDateLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *todayAvgLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *todayScoreTable;

@end

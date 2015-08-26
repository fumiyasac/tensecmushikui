//
//  WKTableCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKTableCell : NSObject

//スコアの表示用テーブルセルの部品
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *scorePercentageLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *scoreTimesLabel;

@end

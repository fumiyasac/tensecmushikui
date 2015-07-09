//
//  WKResultController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKResultController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *resultCollectionNum;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *resultTimeNum;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *syncBtn;

- (IBAction)syncYourIponeApp;

@end

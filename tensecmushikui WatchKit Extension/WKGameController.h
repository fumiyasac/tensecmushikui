//
//  WKGameController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKGameController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *answerAmount;

@property (strong, nonatomic) IBOutlet WKInterfaceTimer *secTimer;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *problemCalc;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn1element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn2element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn3element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn4element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn5element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn6element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn7element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn8element;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btn9element;

- (IBAction)btn1Tapped;
- (IBAction)btn2Tapped;
- (IBAction)btn3Tapped;
- (IBAction)btn4Tapped;
- (IBAction)btn5Tapped;
- (IBAction)btn6Tapped;
- (IBAction)btn7Tapped;
- (IBAction)btn8Tapped;
- (IBAction)btn9Tapped;

@end

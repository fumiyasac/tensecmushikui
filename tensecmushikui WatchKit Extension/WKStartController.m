//
//  InterfaceController.m
//  tensecmushikui WatchKit Extension
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "WKStartController.h"

@interface WKStartController()

@end

@implementation WKStartController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (IBAction)startBtn {
    
    //セグエなしの遷移を行う
    [self pushControllerWithName:@"Game" context:self];
}

- (IBAction)todayBtn {
    
    //セグエなしの遷移を行う
    [self pushControllerWithName:@"Today" context:self];
}

@end

//
//  AnalyticsController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ScoreTableViewCell.h"

@interface AnalyticsController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *currentDisplayLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong, nonatomic) IBOutlet UIWebView *graphWebView;
@property (strong, nonatomic) IBOutlet UITableView *scoreTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *deviceSegment;
@property (strong, nonatomic) IBOutlet UIButton *prevBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)switchDataResult:(UISegmentedControl *)sender;
- (IBAction)prevAction:(UIButton *)sender;
- (IBAction)nextAction:(UIButton *)sender;

@end

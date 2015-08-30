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
#import "ColorDefinition.h"

@interface AnalyticsController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate>

//分析結果ページ用のプロパティ
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentAvgLabel;
@property (strong, nonatomic) IBOutlet UIWebView *graphWebView;
@property (strong, nonatomic) IBOutlet UITableView *scoreTableView;
@property (strong, nonatomic) IBOutlet UIButton *prevBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *deviceSegment;

//分析結果ページ用のアクション
- (IBAction)prevAction:(UIButton *)sender;
- (IBAction)nextAction:(UIButton *)sender;
- (IBAction)deviceSegment:(UISegmentedControl *)sender;

//広告
@property (strong, nonatomic) IBOutlet ADBannerView *iAdArea;

@end

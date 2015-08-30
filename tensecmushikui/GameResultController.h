//
//  GameResultController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <CoreData/CoreData.h>
#import "UIDeviseSize.h"
#import "ColorDefinition.h"
#import "ResultLabelTableViewCell.h"
#import "ResultTextTableViewCell.h"

@interface GameResultController : UIViewController<UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate>

//フッター広告のインスタンス
@property (strong, nonatomic) IBOutlet ADBannerView *bottomBanner;

//GameResultController自身のプロパティ
@property (nonatomic ,strong) NSString *receiveCorrectNum;
@property (nonatomic ,strong) NSString *receiveTotalSec;

//結果表示とPR等表示テーブルビュー
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

//「ソーシャル連携」ボタン
@property (strong, nonatomic) IBOutlet UIButton *twitterBtn;
@property (strong, nonatomic) IBOutlet UIButton *facebookBtn;

//「結果記録」ボタン（画像・実体）
@property (strong, nonatomic) IBOutlet UIButton *syncBannerBtn;

//「ソーシャル連携」ボタンの実装
- (IBAction)twitterAction:(UIButton *)sender;
- (IBAction)facebookAction:(UIButton *)sender;

//「この結果を登録する」ボタンの実装
- (IBAction)syncScoreAction:(UIButton *)sender;

//広告
@property (strong, nonatomic) IBOutlet ADBannerView *iAdArea;

@end

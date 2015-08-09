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

@interface GameResultController : UIViewController<ADBannerViewDelegate>

//フッター広告のインスタンス
@property (strong, nonatomic) IBOutlet ADBannerView *bottomBanner;

//GameResultController自身のプロパティ
@property (nonatomic ,strong) NSString *receiveCorrectNum;
@property (nonatomic ,strong) NSString *receiveTotalSec;

//結果表示
@property (strong, nonatomic) IBOutlet UILabel *resultDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultDifficultyLabel;

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

@end

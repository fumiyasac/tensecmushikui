//
//  IntroductionController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "NewinfoTableViewCell.h"
#import "CalculatePointTableViewCell.h"
#import "UIDeviseSize.h"
#import "ColorDefinition.h"

@interface IntroductionController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ADBannerViewDelegate>

//最新情報テーブルビュー
@property (strong, nonatomic) IBOutlet UITableView *newinfoTableView;

//フッター広告のインスタンス
@property (strong, nonatomic) IBOutlet ADBannerView *bottomBanner;

//1.iphoneでゲームするボタン
//2.これまでの結果を見るボタン
@property (strong, nonatomic) IBOutlet UIButton *iphoneGameBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewResultBtn;

@end

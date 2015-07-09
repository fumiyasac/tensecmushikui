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
#import "UIDeviseSize.h"

@interface IntroductionController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ADBannerViewDelegate>

//最新情報テーブルビュー
@property (strong, nonatomic) IBOutlet UITableView *newinfoTableView;

//フッター広告のインスタンス
@property (strong, nonatomic) IBOutlet ADBannerView *footerBanner;

//1.問題の更新ボタン
//2.これまでの結果を見るボタン
//3.iphoneでゲームするボタン
//4.虫食い算のポイントボタン
@property (strong, nonatomic) IBOutlet UIButton *problemUpdateBtn;
@property (strong, nonatomic) IBOutlet UIButton *resultHistoryBtn;
@property (strong, nonatomic) IBOutlet UIButton *iphoneGameBtn;
@property (strong, nonatomic) IBOutlet UIButton *calculatePointBtn;

//「戻る」ボタンの実装
- (IBAction)backAction:(UIButton *)sender;

@end

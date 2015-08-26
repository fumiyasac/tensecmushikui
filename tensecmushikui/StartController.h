//
//  ViewController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpeningImageSlider.h"
#import "UIDeviseSize.h"
#import "ColorDefinition.h"

@interface StartController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate>

//デバッグラベル（本運用時は非活性）
@property (strong, nonatomic) IBOutlet UILabel *debugLabel;

//ボタンのインスタンス
@property (strong, nonatomic) IBOutlet UIButton *startBtn;

//スクロールビュー
@property (strong, nonatomic) IBOutlet UIScrollView *startScrollView;

//ページコントロール
@property (strong, nonatomic) IBOutlet UIPageControl *startPageControl;

//コアデータに格納するインスタンスメソッド
-(void)addRecordToCoreData:(int)score totalSeconds:(float)seconds;

//デバッグ用のラベル表示を切り替える
-(void)switchDebugLabel:(BOOL)flag;

//データの同期を行う
-(NSArray *)syncProblemDataForWatch;
-(NSArray *)syncTodayResultToCoreData;

@end


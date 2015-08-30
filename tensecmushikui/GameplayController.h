//
//  GameplayController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIDeviseSize.h"

@interface GameplayController : UIViewController<ADBannerViewDelegate>

//フッター広告のインスタンス
@property (strong, nonatomic) IBOutlet ADBannerView *bottomBanner;

//問題・残り時間
@property (strong, nonatomic) IBOutlet UILabel *answerAmount;
@property (strong, nonatomic) IBOutlet UILabel *pastTime;
@property (strong, nonatomic) IBOutlet UILabel *targetProblem;

//解答ボタンのインスタンス
@property (strong, nonatomic) IBOutlet UIButton *answer1btn;
@property (strong, nonatomic) IBOutlet UIButton *answer2btn;
@property (strong, nonatomic) IBOutlet UIButton *answer3btn;
@property (strong, nonatomic) IBOutlet UIButton *answer4btn;
@property (strong, nonatomic) IBOutlet UIButton *answer5btn;
@property (strong, nonatomic) IBOutlet UIButton *answer6btn;
@property (strong, nonatomic) IBOutlet UIButton *answer7btn;
@property (strong, nonatomic) IBOutlet UIButton *answer8btn;
@property (strong, nonatomic) IBOutlet UIButton *answer9btn;

//解答ボタンのアクション
- (IBAction)answer1Action:(UIButton *)sender;
- (IBAction)answer2Action:(UIButton *)sender;
- (IBAction)answer3Action:(UIButton *)sender;
- (IBAction)answer4Action:(UIButton *)sender;
- (IBAction)answer5Action:(UIButton *)sender;
- (IBAction)answer6Action:(UIButton *)sender;
- (IBAction)answer7Action:(UIButton *)sender;
- (IBAction)answer8Action:(UIButton *)sender;
- (IBAction)answer9Action:(UIButton *)sender;

//戻った際のGameControllerで作動しているタイマーを破棄する
- (void)killTimerAnotherController;

//広告
@property (strong, nonatomic) IBOutlet ADBannerView *iAdArea;

@end

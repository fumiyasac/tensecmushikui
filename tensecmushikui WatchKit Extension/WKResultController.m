//
//  WKResultController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "WKResultController.h"

@interface WKResultController(){
    //受け取ったゲーム結果を入れる
    NSArray *resultArray;
    NSArray *sendTargetArray;
    
    int answerCorrectCount;
    float totalSeconds;
}
@end

@implementation WKResultController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.syncBtn.enabled = YES;
    [self.syncBtn setTitle:@"スコアを記録する"];
    
    //受け取った値を配列に格納
    resultArray = context;
}

- (void)willActivate {
    [super willActivate];
    
    //表示する値を作成
    totalSeconds = [resultArray[0][1] floatValue];
    answerCorrectCount = [resultArray[0][0] intValue];
    
    //ラベルに結果を表示
    [self.resultCollectionNum setText:[NSString stringWithFormat:@"正解:10問中%d問",answerCorrectCount]];
    [self.resultTimeNum setText:[NSString stringWithFormat:@"時間:%.3f秒",totalSeconds]];
}

//アプリ側に結果を投げつけるアクション
- (IBAction)syncYourIponeApp {
    
    NSString *answerCorrectCountToStr = [NSString stringWithFormat:@"%d",answerCorrectCount];
    NSString *totalSecondsToStr = [NSString stringWithFormat:@"%.3f",totalSeconds];
    sendTargetArray = @[@"insert",answerCorrectCountToStr ,totalSecondsToStr];
    
    [WKInterfaceController openParentApplication:@{
            
            //watchからiPhoneへ送るデータ
            @"watchValue":sendTargetArray
        }
        reply:^(NSDictionary *replyInfo, NSError *error){
            
            //iPhoneからwatchへ送られたデータ（今回はねぇや...）
        }
     ];
    
    //ボタンを押せなくする
    self.syncBtn.enabled = NO;
    [self.syncBtn setTitle:@"戻って再挑戦してね！"];
}

- (void)didDeactivate {
    [super didDeactivate];
}

@end

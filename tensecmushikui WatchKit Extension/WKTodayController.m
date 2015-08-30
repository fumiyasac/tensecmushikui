//
//  WKTodayController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "WKTodayController.h"
#import "WKTableCell.h"

@interface WKTodayController ()
{
    //結果表示
    NSArray *results;
    NSArray *sendTargetArray;
}

@end

@implementation WKTodayController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    //データの読み込みを行う
    [self setTodayResults];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

//今日の結果を本体から取得する（AppleWatchでの結果のみ）
- (void)setTodayResults {
    
    sendTargetArray = @[@"reswatch"];
    
    [WKInterfaceController openParentApplication:@{
                                                   
        //watchからiPhoneへ送るデータ
        @"watchValue":sendTargetArray
                                                   
    }reply:^(NSDictionary *replyInfo, NSError *error){
                                                       
        //iPhoneからwatchへ送られたデータ
        NSData *todayWatchScoreData = replyInfo[@"todayWatchScoreData"];
        results = [NSKeyedUnarchiver unarchiveObjectWithData:todayWatchScoreData];
        
        //テーブルビューを組み立てる
        [self tableDataLoad];
        
        [self setAvgScoreOfLabel];
    }];
}

//テーブルビューの組み立てを行うメソッド
- (void)tableDataLoad {
    
    //項目配列の初期化
    int counter = (int)results.count;
    
    if (counter > 0) {

        [self.todayScoreTable setNumberOfRows:counter withRowType:@"theRow"];
        
        //テーブルビューを表示する
        for (int i = 0; i < counter; i++) {
            
            WKTableCell *theRow = [self.todayScoreTable rowControllerAtIndex:i];
            
            NSDictionary *scoreDictionary = [results objectAtIndex:i];
            NSString *scoreCorrect = scoreDictionary[@"score"];
            NSString *scoreSum = scoreDictionary[@"sum"];
            
            [theRow.scorePercentageLabel setText:[NSString stringWithFormat:@"%@問正解", scoreCorrect]];
            [theRow.scoreTimesLabel setText:[NSString stringWithFormat:@"(%@回)", scoreSum]];
        }
    }
}

//平均点を算出して表示するメソッド
-(void)setAvgScoreOfLabel {

    float avgScore;
    
    //計算結果データの配列が存在したら
    if (results.count > 0) {
        
        //それぞれの値を加算して表示
        int wholeScore = 0;
        int countScore = 0;
        
        for (int i=0; i<results.count; i++) {
            NSDictionary *countData = [results objectAtIndex:i];
            int perScore = [[countData objectForKey:@"score"] integerValue];
            int perSum = [[countData objectForKey:@"sum"] integerValue];
            
            wholeScore += perScore * perSum;
            countScore += perSum;
        }
        avgScore = (float) wholeScore / countScore;
        [self.todayAvgLabel setText:[NSString stringWithFormat:@"平均%.2f点", avgScore]];
    } else {
        [self.todayAvgLabel setText:@"同期失敗"];
    }

}
@end




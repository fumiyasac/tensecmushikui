//
//  WKGameController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "WKGameController.h"

@interface WKGameController(){
    
    //問題数・タイマー・遅延時間
    int counter;
    NSTimer *doneTimer;
    float duration;
    
    //問題
    NSArray *problems;
    NSArray *sendTargetArray;
    
    //問題を解き始めた時間を算出（本当はアカンけど...）
    NSDate *timeProblem0Solve;
    NSDate *timeProblem1Solve;
    NSDate *timeProblem2Solve;
    NSDate *timeProblem3Solve;
    NSDate *timeProblem4Solve;
    NSDate *timeProblem5Solve;
    NSDate *timeProblem6Solve;
    NSDate *timeProblem7Solve;
    NSDate *timeProblem8Solve;
    NSDate *timeProblem9Solve;
    NSDate *timeProblem10Solve;
    
    //正解数
    int correctNum;
    float totalSec;
}
@end

@implementation WKGameController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    [super willActivate];
    
    //初期化
    counter = 0;
    duration = 10;
    correctNum = 0;
    totalSec = 0.000;
    
    //文言の初期化
    [self.problemCalc setText:@"問題読み込み中..."];
    
    //読み込む前は全てのボタンを非活性にしておく
    [self allAnswerBtnDisabled];
    
    //計算配列のセット
    [self setPloblems];
    
    //開始時はタイマーを止めておく
    [self.secTimer stop];
}

- (void)didDeactivate {
    [super didDeactivate];
}

//10秒経過時は不正解として次の問題を読み込む
- (void)timerDone:(NSTimer *)timer{
    
    //メンバ変数totalSecへ+10.000
    totalSec = totalSec + 10.000;
    
    if(counter == 0){
        
        timeProblem1Solve = [NSDate date];
        
    }else if (counter == 1){
        
        timeProblem2Solve = [NSDate date];
        
    }else if (counter == 2){
        
        timeProblem3Solve = [NSDate date];
        
    }else if (counter == 3){
        
        timeProblem4Solve = [NSDate date];
        
    }else if (counter == 4){
        
        timeProblem5Solve = [NSDate date];
        
    }else if (counter == 5){
        
        timeProblem6Solve = [NSDate date];
        
    }else if (counter == 6){
        
        timeProblem7Solve = [NSDate date];
        
    }else if (counter == 7){
        
        timeProblem8Solve = [NSDate date];
        
    }else if (counter == 8){
        
        timeProblem9Solve = [NSDate date];
        
    }else if (counter == 9){
        
        timeProblem10Solve = [NSDate date];
    }
    
    //カウントアップ
    counter = counter + 1;
    [self reloadTimerFunction];
}


//問題と解答を突っ込むメソッド
- (void)setPloblems {
    
    sendTargetArray = @[@"select"];
    
    [WKInterfaceController openParentApplication:@{
                                                   
        //watchからiPhoneへ送るデータ
        @"watchValue":sendTargetArray
        
    }reply:^(NSDictionary *replyInfo, NSError *error){
                                               
        //iPhoneからwatchへ送られたデータ
        NSData *problemData = replyInfo[@"problemData"];
        problems = [NSKeyedUnarchiver unarchiveObjectWithData:problemData];
        
        //問題を取得する
        [self createNextProblem];
        
        //ボタンを全て活性
        [self allAnswerBtnEnabled];
        
        //第1問の解き始めた時間を保持
        timeProblem0Solve = [NSDate date];
        
        //今日の日付から指定秒数後の時間を取得
        NSDate *targetDate = [NSDate dateWithTimeIntervalSinceNow:duration];
        [self.secTimer setDate:targetDate];
        [self.secTimer start];
        
        //指定秒数後にtimerDone関数を呼び出す
        doneTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerDone:) userInfo:nil repeats:NO];
    }];

}

//タイマーを破棄して再起動を行うメソッド
-(void)reloadTimerFunction {
    
    //タイマーを破棄
    [doneTimer invalidate];
    
    //開始時はタイマーを止めておく
    [self.secTimer stop];
    
    //遷移or次の問題
    [self compareNextOrResult];
}


//遷移するか次の問題を表示するかを決めるメソッド
- (void)compareNextOrResult {
    
    if (counter == 10) {
        
        //終わったらボタンは非活性にしておきたい
        [self allAnswerBtnDisabled];
        
        //10問終わったら結果画面へ遷移
        NSString *correct = [NSString stringWithFormat:@"%d", correctNum];
        NSString *sec = [NSString stringWithFormat:@"%f", totalSec];
        
        NSMutableArray *result = [NSMutableArray array];
        [result addObject:@[correct,sec]];
        
        [self pushControllerWithName:@"Result" context:result];
        
    } else {
        
        //ボタンは活性にする
        [self allAnswerBtnEnabled];
        
        //次の問題を表示
        [self createNextProblem];
        
        //今日の日付から指定秒数後の時間を取得
        NSDate *targetDate = [NSDate dateWithTimeIntervalSinceNow:duration];
        [self.secTimer setDate:targetDate];
        
        [self.secTimer start];
        
        //指定秒数後にtimerDone関数を呼び出す
        doneTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerDone:) userInfo:nil repeats:NO];
    }
}

//問題を表示するメソッド
- (void)createNextProblem {
    
    NSDictionary *calcData = problems[counter];
    [self.answerAmount setText:[NSString stringWithFormat:@"第%@問",calcData[@"amount"]]];
    [self.problemCalc setText:calcData[@"calcurate"]];
}

//正解か不正解かを判定するメソッド
- (void)judgeCurrentAnswer:(int)btnNum{
    
    [self allAnswerBtnDisabled];
    
    float tmp;
    
    //問題にかかった秒数を加算する（これもアカンと思うけど...）
    if(counter == 0){
        
        timeProblem1Solve = [NSDate date];
        tmp= [timeProblem1Solve timeIntervalSinceDate:timeProblem0Solve];
        
    }else if (counter == 1){
        
        timeProblem2Solve = [NSDate date];
        tmp= [timeProblem2Solve timeIntervalSinceDate:timeProblem1Solve];
        
    }else if (counter == 2){
        
        timeProblem3Solve = [NSDate date];
        tmp= [timeProblem3Solve timeIntervalSinceDate:timeProblem2Solve];
        
    }else if (counter == 3){
        
        timeProblem4Solve = [NSDate date];
        tmp= [timeProblem4Solve timeIntervalSinceDate:timeProblem3Solve];
        
    }else if (counter == 4){
        
        timeProblem5Solve = [NSDate date];
        tmp= [timeProblem5Solve timeIntervalSinceDate:timeProblem4Solve];
        
    }else if (counter == 5){
        
        timeProblem6Solve = [NSDate date];
        tmp= [timeProblem6Solve timeIntervalSinceDate:timeProblem5Solve];
        
    }else if (counter == 6){
        
        timeProblem7Solve = [NSDate date];
        tmp= [timeProblem7Solve timeIntervalSinceDate:timeProblem6Solve];
        
    }else if (counter == 7){
        
        timeProblem8Solve = [NSDate date];
        tmp= [timeProblem8Solve timeIntervalSinceDate:timeProblem7Solve];
        
    }else if (counter == 8){
        
        timeProblem9Solve = [NSDate date];
        tmp= [timeProblem8Solve timeIntervalSinceDate:timeProblem8Solve];
        
    }else if (counter == 9){
        
        timeProblem10Solve = [NSDate date];
        tmp= [timeProblem10Solve timeIntervalSinceDate:timeProblem9Solve];
        
    }
    totalSec = totalSec + tmp;
    
    NSDictionary *calcData = problems[counter];
    NSString *answerText = calcData[@"answer"];
    int answer = answerText.intValue;
    
    //カウントアップ
    counter = counter + 1;
    
    //選択した答えの判定
    if(btnNum == answer)correctNum = correctNum + 1;
    
    //タイマー再設定
    [self reloadTimerFunction];
}

- (void)allAnswerBtnEnabled {
    self.btn1element.enabled = YES;
    self.btn2element.enabled = YES;
    self.btn3element.enabled = YES;
    self.btn4element.enabled = YES;
    self.btn5element.enabled = YES;
    self.btn6element.enabled = YES;
    self.btn7element.enabled = YES;
    self.btn8element.enabled = YES;
    self.btn9element.enabled = YES;
}

- (void)allAnswerBtnDisabled {
    self.btn1element.enabled = NO;
    self.btn2element.enabled = NO;
    self.btn3element.enabled = NO;
    self.btn4element.enabled = NO;
    self.btn5element.enabled = NO;
    self.btn6element.enabled = NO;
    self.btn7element.enabled = NO;
    self.btn8element.enabled = NO;
    self.btn9element.enabled = NO;
}

- (IBAction)btn1Tapped {
    [self judgeCurrentAnswer:1];
}

- (IBAction)btn2Tapped {
    [self judgeCurrentAnswer:2];
}

- (IBAction)btn3Tapped {
    [self judgeCurrentAnswer:3];
}

- (IBAction)btn4Tapped {
    [self judgeCurrentAnswer:4];
}

- (IBAction)btn5Tapped {
    [self judgeCurrentAnswer:5];
}

- (IBAction)btn6Tapped {
    [self judgeCurrentAnswer:6];
}

- (IBAction)btn7Tapped {
    [self judgeCurrentAnswer:7];
}

- (IBAction)btn8Tapped {
    [self judgeCurrentAnswer:8];
}

- (IBAction)btn9Tapped {
    [self judgeCurrentAnswer:9];
}

@end

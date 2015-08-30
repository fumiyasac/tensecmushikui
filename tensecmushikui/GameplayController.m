//
//  GameplayController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "AppDelegate.h"
#import "GameplayController.h"
#import "GameResultController.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COUNTER 10
#define TIMEOUT_SEC 10.000
#define MAX_COUNT_NUM 10
#define FETCH_DATA_COUNT 10

@interface GameplayController() {
    
    //問題数・タイマー・遅延時間
    int counter;
    int pastCounter;
    NSTimer *perSecTimer;
    NSTimer *doneTimer;
    float duration;
    
    //問題
    NSArray *problems;
    int dataCount;
    
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
    
    //データ格納用の配列
    NSArray *fetchDataArray;
    
    //ボタンのプロパティ(SetCornerRadius = buttonSize / 2)
    float buttonSize;
}
@end

@implementation GameplayController

- (void)viewWillAppear:(BOOL)animated {
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    UIImage *backgroundImage;
    CGFloat btnCircleRect;
    CGFloat btnCircleX1;
    CGFloat btnCircleX2;
    CGFloat btnCircleX3;
    CGFloat btnCircleY1;
    CGFloat btnCircleY2;
    CGFloat btnCircleY3;
    CGFloat fontSize;
    
    //iPhone4s
    if ([deviceName isEqual:@"iPhone4s"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone4s_background.jpg"];
        btnCircleRect = 55.0;
        btnCircleX1 = 52;
        btnCircleX2 = ([UIDeviseSize getNowDisplayWidth] - btnCircleRect)/2;
        btnCircleX3 = [UIDeviseSize getNowDisplayWidth] - 52 - btnCircleRect;
        fontSize = 27.0;
        
    //iPhone5またはiPhone5s
    } else if ([deviceName isEqual:@"iPhone5"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone5_background.jpg"];
        btnCircleRect = 70.0;
        btnCircleX1 = 30;
        btnCircleX2 = ([UIDeviseSize getNowDisplayWidth] - btnCircleRect)/2;
        btnCircleX3 = [UIDeviseSize getNowDisplayWidth] - 30 - btnCircleRect;
        fontSize = 35.0;
        
    //iPhone6
    } else if ([deviceName isEqual:@"iPhone6"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6_background.jpg"];
        btnCircleRect = 82.0;
        btnCircleX1 = 30;
        btnCircleX2 = ([UIDeviseSize getNowDisplayWidth] - btnCircleRect)/2;
        btnCircleX3 = [UIDeviseSize getNowDisplayWidth] - 30 - btnCircleRect;
        fontSize = 38.0;
        
    //iPhone6 plus
    } else if ([deviceName isEqual:@"iPhone6plus"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6plus_background.jpg"];
        btnCircleRect = 95.0;
        btnCircleX1 = 30;
        btnCircleX2 = ([UIDeviseSize getNowDisplayWidth] - btnCircleRect)/2;
        btnCircleX3 = [UIDeviseSize getNowDisplayWidth] - 30 - btnCircleRect;
        fontSize = 44.0;
    }
    
    btnCircleY1 = 200;
    btnCircleY2 = 200 + btnCircleRect + 20;
    btnCircleY3 = 200 + (btnCircleRect + 20) * 2;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    self.answer1btn.frame = CGRectMake(btnCircleX1, btnCircleY1, btnCircleRect, btnCircleRect);
    self.answer2btn.frame = CGRectMake(btnCircleX2, btnCircleY1, btnCircleRect, btnCircleRect);
    self.answer3btn.frame = CGRectMake(btnCircleX3, btnCircleY1, btnCircleRect, btnCircleRect);
    
    [self.answer1btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer2btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer3btn.layer setCornerRadius:btnCircleRect/2];
    
    [self.answer1btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer2btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer3btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    self.answer4btn.frame = CGRectMake(btnCircleX1, btnCircleY2, btnCircleRect, btnCircleRect);
    self.answer5btn.frame = CGRectMake(btnCircleX2, btnCircleY2, btnCircleRect, btnCircleRect);
    self.answer6btn.frame = CGRectMake(btnCircleX3, btnCircleY2, btnCircleRect, btnCircleRect);

    [self.answer4btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer5btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer6btn.layer setCornerRadius:btnCircleRect/2];

    [self.answer4btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer5btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer6btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    self.answer7btn.frame = CGRectMake(btnCircleX1, btnCircleY3, btnCircleRect, btnCircleRect);
    self.answer8btn.frame = CGRectMake(btnCircleX2, btnCircleY3, btnCircleRect, btnCircleRect);
    self.answer9btn.frame = CGRectMake(btnCircleX3, btnCircleY3, btnCircleRect, btnCircleRect);

    [self.answer7btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer8btn.layer setCornerRadius:btnCircleRect/2];
    [self.answer9btn.layer setCornerRadius:btnCircleRect/2];
    
    [self.answer7btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer8btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.answer9btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //初期化
    counter     = 0;
    duration    = 10;
    correctNum  = 0;
    totalSec    = 0.000;
    pastCounter = 10;
    
    //ボタンを全て活性
    [self allAnswerBtnEnabled];
    
    //計算配列のセット
    [self setProblems];
    
    //問題を取得する
    [self createNextProblem];
    
    //第1問の解き始めた時間を保持
    timeProblem0Solve = [NSDate date];
    self.pastTime.text = [NSString stringWithFormat:@"あと%d秒",pastCounter];
    
    //毎秒ごとに走るタイマー
    perSecTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(perSecTimerDone:) userInfo:nil repeats:YES];
    
    //指定秒数後にtimerDone関数を呼び出す
    doneTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerDone:) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self killTimerAnotherController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //タイトル
    self.navigationItem.title = @"ゲーム開始";
    
    //iAd
    [self switchiAdDisplay:false];
}

//iAd表示
-(void)switchiAdDisplay:(BOOL)flag {
    if (flag) {
        self.iAdArea.alpha = 1;
    }else {
        self.iAdArea.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//1秒経過時はラベル文字を変更する
- (void)perSecTimerDone:(NSTimer *)timer{
    pastCounter = pastCounter - 1;
    self.pastTime.text = [NSString stringWithFormat:@"あと%d秒",pastCounter];
}

//10秒経過時は不正解として次の問題を読み込む
- (void)timerDone:(NSTimer *)timer{
    
    //メンバ変数totalSecへ+10.000
    totalSec = totalSec + TIMEOUT_SEC;
    pastCounter = DEFAULT_COUNTER;
    
    if (counter == 0) {
        
        timeProblem1Solve = [NSDate date];
        
    } else if (counter == 1) {
        
        timeProblem2Solve = [NSDate date];
        
    } else if (counter == 2) {
        
        timeProblem3Solve = [NSDate date];
        
    } else if (counter == 3) {
        
        timeProblem4Solve = [NSDate date];
        
    } else if (counter == 4) {
        
        timeProblem5Solve = [NSDate date];
        
    } else if (counter == 5) {
        
        timeProblem6Solve = [NSDate date];
        
    } else if (counter == 6) {
        
        timeProblem7Solve = [NSDate date];
        
    } else if (counter == 7) {
        
        timeProblem8Solve = [NSDate date];
        
    } else if (counter == 8) {
        
        timeProblem9Solve = [NSDate date];
        
    } else if (counter == 9) {
        
        timeProblem10Solve = [NSDate date];
    }
    //カウントアップ
    counter = counter + 1;
    [self reloadTimerFunction];
}

//問題と解答を突っ込むメソッド(仮)
- (void)setProblems {
    
    //問題を突っ込む用
    NSMutableArray *problem = [NSMutableArray array];

    //CSVデータのディレクトリを探してくる
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"problem_download" ofType:@"csv" inDirectory:@"csvdata"];
    
    //エラー・エンコード方式が入る
    NSError* error = nil;
    NSStringEncoding encoding;
    NSString *content = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
    
    dataCount = 10;
    
    //ファイル内容を行毎に分解して最初と末尾を切る
    NSMutableArray *rows = [[content componentsSeparatedByString:@"\n"] mutableCopy];
    [rows removeObjectAtIndex:0];
    [rows removeObjectAtIndex:(NSInteger)rows.count-1];

    //シャッフル
    int tmpCount = (int)[rows count];
    for (int a = tmpCount - 1; a > 0; a--) {
        int randomNum = arc4random() % a;
        [rows exchangeObjectAtIndex:a withObjectAtIndex:randomNum];
    }
    
    //上から10件だけ表示する関数
    for (int i = 0; i < dataCount; i++) {
        NSArray *row = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
        [problem addObject:@{@"amount":[NSString stringWithFormat:@"%d",i+1], @"calcurate":row[1], @"answer":row[2]}];
    }
    problems = problem;
}

//タイマーを破棄して再起動を行うメソッド
-(void)reloadTimerFunction {
    
    //タイマーを破棄
    [perSecTimer invalidate];
    [doneTimer invalidate];
    
    //遷移or次の問題
    [self compareNextOrResult];
}

//遷移するか次の問題を表示するかを決めるメソッド
- (void)compareNextOrResult {
    
    if (counter == MAX_COUNT_NUM) {
        
        //10問終わったら結果画面へ遷移
        NSString *correct = [NSString stringWithFormat:@"%d", correctNum];
        NSString *sec = [NSString stringWithFormat:@"%.3f", totalSec];
        
        NSMutableArray *result = [NSMutableArray array];
        [result addObject:@[correct,sec]];
        
        //タイマーを殺す
        [perSecTimer invalidate];
        [doneTimer invalidate];
        
        [self performSegueWithIdentifier:@"displayResult" sender:self];
        
    } else {
        
        //ボタンを全て活性
        [self allAnswerBtnEnabled];
        
        //次の問題を表示
        [self createNextProblem];
        self.pastTime.text = [NSString stringWithFormat:@"あと%d秒",pastCounter];
        
        //毎秒ごとに走るタイマー
        perSecTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(perSecTimerDone:) userInfo:nil repeats:YES];
        
        //指定秒数後にtimerDone関数を呼び出す
        doneTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerDone:) userInfo:nil repeats:NO];
    }
}

//
//セグエの際に値を渡す
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //あるビューから複数のセグエが出ている際は行き先を指定しないとダメなのでキッチリ書くこと
    if ([segue.identifier isEqualToString:@"displayResult"]) {
        
        //結果表示画面へ
        GameResultController *gameResultController = [segue destinationViewController];
        
        //値を引き渡す
        gameResultController.receiveCorrectNum = [NSString stringWithFormat:@"%d",correctNum];
        gameResultController.receiveTotalSec = [NSString stringWithFormat:@"%.3f",totalSec];
    }
}

//問題を表示するメソッド
- (void)createNextProblem {
    
    NSDictionary *calcData = problems[counter];
    self.answerAmount.text = [NSString stringWithFormat:@"第%@問",calcData[@"amount"]];
    self.targetProblem.text = [NSString stringWithFormat:@"%@",calcData[@"calcurate"]];
}

//正解か不正解かを判定するメソッド
- (void)judgeCurrentAnswer:(int)btnNum {
    
    //ボタンを全て非活性
    [self allAnswerBtnDisabled];
    
    pastCounter = DEFAULT_COUNTER;
    float tmp;
    
    //問題にかかった秒数を加算する（これもアカンと思うけど...）
    if (counter == 0) {
        
        timeProblem1Solve = [NSDate date];
        tmp= [timeProblem1Solve timeIntervalSinceDate:timeProblem0Solve];
        
    } else if (counter == 1) {
        
        timeProblem2Solve = [NSDate date];
        tmp= [timeProblem2Solve timeIntervalSinceDate:timeProblem1Solve];
        
    } else if (counter == 2) {
        
        timeProblem3Solve = [NSDate date];
        tmp= [timeProblem3Solve timeIntervalSinceDate:timeProblem2Solve];
        
    } else if (counter == 3) {
        
        timeProblem4Solve = [NSDate date];
        tmp= [timeProblem4Solve timeIntervalSinceDate:timeProblem3Solve];
        
    } else if (counter == 4) {
        
        timeProblem5Solve = [NSDate date];
        tmp= [timeProblem5Solve timeIntervalSinceDate:timeProblem4Solve];
        
    } else if (counter == 5) {
        
        timeProblem6Solve = [NSDate date];
        tmp= [timeProblem6Solve timeIntervalSinceDate:timeProblem5Solve];
        
    } else if (counter == 6) {
        
        timeProblem7Solve = [NSDate date];
        tmp= [timeProblem7Solve timeIntervalSinceDate:timeProblem6Solve];
        
    } else if (counter == 7) {
        
        timeProblem8Solve = [NSDate date];
        tmp= [timeProblem8Solve timeIntervalSinceDate:timeProblem7Solve];
        
    } else if (counter == 8) {
        
        timeProblem9Solve = [NSDate date];
        tmp= [timeProblem8Solve timeIntervalSinceDate:timeProblem8Solve];
        
    } else if (counter == 9) {
        
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
    if(btnNum == answer) correctNum = correctNum + 1;
    //タイマー再設定
    [self reloadTimerFunction];
}

- (void)killTimerAnotherController {

    [perSecTimer fire];
    [doneTimer invalidate];
}

- (void)allAnswerBtnEnabled {
    
    self.answer1btn.enabled = YES;
    self.answer2btn.enabled = YES;
    self.answer3btn.enabled = YES;
    self.answer4btn.enabled = YES;
    self.answer5btn.enabled = YES;
    self.answer6btn.enabled = YES;
    self.answer7btn.enabled = YES;
    self.answer8btn.enabled = YES;
    self.answer9btn.enabled = YES;
}

- (void)allAnswerBtnDisabled {
    
    self.answer1btn.enabled = NO;
    self.answer2btn.enabled = NO;
    self.answer3btn.enabled = NO;
    self.answer4btn.enabled = NO;
    self.answer5btn.enabled = NO;
    self.answer6btn.enabled = NO;
    self.answer7btn.enabled = NO;
    self.answer8btn.enabled = NO;
    self.answer9btn.enabled = NO;
}

- (IBAction)answer1Action:(UIButton *)sender {
    [self judgeCurrentAnswer:1];
}

- (IBAction)answer2Action:(UIButton *)sender {
    [self judgeCurrentAnswer:2];
}

- (IBAction)answer3Action:(UIButton *)sender {
    [self judgeCurrentAnswer:3];
}

- (IBAction)answer4Action:(UIButton *)sender {
    [self judgeCurrentAnswer:4];
}

- (IBAction)answer5Action:(UIButton *)sender {
    [self judgeCurrentAnswer:5];
}

- (IBAction)answer6Action:(UIButton *)sender {
    [self judgeCurrentAnswer:6];
}

- (IBAction)answer7Action:(UIButton *)sender {
    [self judgeCurrentAnswer:7];
}

- (IBAction)answer8Action:(UIButton *)sender {
    [self judgeCurrentAnswer:8];
}

- (IBAction)answer9Action:(UIButton *)sender {
    [self judgeCurrentAnswer:9];
}

@end

//
//  GameResultController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "GameResultController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <Social/Social.h>

@interface GameResultController () {
    int targetYear;
    int targetMonth;
    int targetDay;
    
    //正解数・かかった時間を表示
    int correctCount;
    float timeCount;
}
@end

@implementation GameResultController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //タイトル
    self.navigationItem.title = @"計算結果";
    
    //計算結果を保存する
    correctCount = [self.receiveCorrectNum intValue];
    timeCount = [self.receiveTotalSec floatValue];
    
    [self setCalendarDate];
    [self setResultLabels];
}

//ラベルにゲーム結果を表示する
- (void)setResultLabels {
    self.resultDateLabel.text = [NSString stringWithFormat:@"挑戦日：%d年%d月%d日", targetYear,targetMonth, targetDay];
    self.resultScoreLabel.text = [NSString stringWithFormat:@"正解：10問中%d問", correctCount];
    self.resultSecondLabel.text = [NSString stringWithFormat:@"時間：%.3f秒", timeCount];
    //@note:将来的には1:ふつう, 2:ムズイ, 3:マジ鬼とする
    self.resultDifficultyLabel.text = @"難易度：ふつう";
}

//[CoreData]コアデータ（Answer）に1件の新規データを追加する
-(void)addRecordToCoreData:(int)score totalSeconds:(float)seconds {
    
    //NSManagedObjectContextのインスタンス作成
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //カウントを取って0だったら1、1より大きければデータの中でanswer_idの最大値に+1をする
    int max_answer_id = 1;
    if([self getMaxAnswerId] > 0){
        max_answer_id = (int)[self getMaxAnswerId] + 1;
    }
    
    //データ追加用のオブジェクトを作成する
    NSManagedObject *addObject = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:managedObjectContext];
    
    //オブジェクトにデータを追加する
    [addObject setValue:@(max_answer_id) forKeyPath:@"answer_id"];
    [addObject setValue:@(targetYear) forKeyPath:@"year"];
    [addObject setValue:@(targetMonth) forKeyPath:@"month"];
    [addObject setValue:@(targetDay) forKeyPath:@"day"];
    [addObject setValue:@(score) forKeyPath:@"score"];
    [addObject setValue:@(seconds) forKeyPath:@"seconds"];
    [addObject setValue:@(1) forKeyPath:@"devise"];
    
    //@note:今のところは1で固定だけど将来的には1:ふつう, 2:ムズイ, 3:マジ鬼とする
    [addObject setValue:@(1) forKeyPath:@"difficulty"];
    
    //データ保存実行
    NSError *error;
    [managedObjectContext save:&error];
}

//[CoreData]answer_idの最大値を取得する
- (NSInteger)getMaxAnswerId {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //NSFetchRequestの中身をディクショナリにして返す
    [request setResultType:NSDictionaryResultType];
    
    //NSExpressionを作成する
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"answer_id"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    //NSExpressionDescriptionを作る
    [expressionDescription setName:@"maxAnswerId"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    [request setPropertiesToFetch:@[expressionDescription]];
    
    //NSFetchRequestにセット
    NSError *error = nil;
    NSArray *obj = [managedObjectContext executeFetchRequest:request error:&error];
    NSInteger maxValue = NSNotFound;
    
    //オブジェクトが取れているかをチェック
    if(obj == nil){
        NSLog(@"error");
    }else if([obj count] > 0){
        maxValue = [obj[0][@"maxAnswerId"] integerValue];
    }
    return maxValue;
}

- (void)setCalendarDate {
    
    //現在の日付を取得
    NSDate *now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    targetYear  = (int)comps.year;
    targetMonth = (int)comps.month;
    targetDay   = (int)comps.day;
}

//カウントをコアデータに格納する
- (IBAction)syncScoreAction:(UIButton *)sender {
    [self addRecordToCoreData:correctCount totalSeconds:timeCount];
}

//twitterへ連携
- (IBAction)twitterAction:(UIButton *)sender {
    SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self socialPostContent:twitterController];
    [self presentViewController:twitterController animated:YES completion:NULL];
}

//facebookへ連携
- (IBAction)facebookAction:(UIButton *)sender {
    SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self socialPostContent:facebookController];
    [self presentViewController:facebookController animated:YES completion:NULL];
}

//ソーシャル投稿用メソッド
-(void)socialPostContent:(SLComposeViewController *)controller {
    
    NSString *commentMsg = [NSString stringWithFormat:@"%d年%d月%d日:10秒虫食い算に挑戦したよ！\n正解数：%d問\nかかった時間：%.3f秒", targetYear,targetMonth, targetDay, correctCount, timeCount];
    
    //メッセージ中身
    [controller setInitialText:commentMsg];
    
    //表示URL中身
    //[controller addURL:[NSURL URLWithString:@"http://qiita.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

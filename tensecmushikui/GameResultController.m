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

@interface GameResultController() {
    
    //カレンダー用の年・月・日を表示
    int targetYear;
    int targetMonth;
    int targetDay;
    
    //正解数・かかった時間を表示
    int correctCount;
    float timeCount;
    
    //メンバ変数（テーブル用）
    UIImage *prImage1;
    UIImage *prImage2;
}
@end

@implementation GameResultController

- (void)viewWillAppear:(BOOL)animated {
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    UIImage *backgroundImage;
    UIImage *backgroundImage3;
    UIImage *alterAdImage;
    
    //iPhone4s
    if ([deviceName isEqual:@"iPhone4s"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone4s_background.jpg"];
        backgroundImage3 = [UIImage imageNamed:@"iphone4s_btn3.jpg"];
        alterAdImage     = [UIImage imageNamed:@"iphone4s_website.jpg"];
        prImage1 = [UIImage imageNamed:@"iphone4s_cell1.jpg"];
        prImage2 = [UIImage imageNamed:@"iphone4s_cell2.jpg"];

    //iPhone5またはiPhone5s
    } else if ([deviceName isEqual:@"iPhone5"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone5_background.jpg"];
        backgroundImage3 = [UIImage imageNamed:@"iphone5_btn3.jpg"];
        alterAdImage     = [UIImage imageNamed:@"iphone5_website.jpg"];
        prImage1 = [UIImage imageNamed:@"iphone5_cell1.jpg"];
        prImage2 = [UIImage imageNamed:@"iphone5_cell2.jpg"];
        
    //iPhone6
    } else if ([deviceName isEqual:@"iPhone6"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6_background.jpg"];
        backgroundImage3 = [UIImage imageNamed:@"iphone6_btn3.jpg"];
        alterAdImage     = [UIImage imageNamed:@"iphone6_website.jpg"];
        prImage1 = [UIImage imageNamed:@"iphone6_cell1.jpg"];
        prImage2 = [UIImage imageNamed:@"iphone6_cell2.jpg"];
        
    //iPhone6 plus
    } else if ([deviceName isEqual:@"iPhone6plus"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6plus_background.jpg"];
        backgroundImage3 = [UIImage imageNamed:@"iphone6plus_btn3.jpg"];
        alterAdImage     = [UIImage imageNamed:@"iphone6plus_website.jpg"];
        prImage1 = [UIImage imageNamed:@"iphone6plus_cell1.jpg"];
        prImage2 = [UIImage imageNamed:@"iphone6plus_cell2.jpg"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //配置済みプロパティの再調整
    self.syncBannerBtn.frame = CGRectMake(10, [UIDeviseSize getNowDisplayHeight]-190, [UIDeviseSize getNowDisplayWidth]-20, 80);
    [self.syncBannerBtn setBackgroundImage:backgroundImage3 forState:UIControlStateNormal];
    [self.syncBannerBtn.layer setBorderColor:[ColorDefinition getUIColorFromHex:@"ffffff"].CGColor];
    [self.syncBannerBtn.layer setBorderWidth:1.0];
    
    self.twitterBtn.frame = CGRectMake(0, [UIDeviseSize getNowDisplayHeight]-100, (double)ceil([UIDeviseSize getNowDisplayWidth]/2), 50);
    self.facebookBtn.frame = CGRectMake((double)ceil([UIDeviseSize getNowDisplayWidth]/2), [UIDeviseSize getNowDisplayHeight]-100, (double)ceil([UIDeviseSize getNowDisplayWidth]/2), 50);
    
    self.resultTableView.frame = CGRectMake(0, 102, [UIDeviseSize getNowDisplayWidth], [UIDeviseSize getNowDisplayHeight]-302);
    
    [self.adAlter setBackgroundImage:alterAdImage forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    //タイトル
    self.navigationItem.title = @"計算結果";

    //デリゲート
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    
    //ボタンを活性にする
    self.syncBannerBtn.enabled = true;
    self.syncBannerBtn.alpha = 1.0;
    [self.syncBannerBtn setTitle:@"スコアを記録する" forState:UIControlStateNormal];
    
    //ボタンのサイズ調整
    [self.twitterBtn setBackgroundColor:[ColorDefinition getUIColorFromHex:@"80c0e9"]];
    [self.facebookBtn setBackgroundColor:[ColorDefinition getUIColorFromHex:@"344b8b"]];
    
    //計算結果を保存する
    correctCount = [self.receiveCorrectNum intValue];
    timeCount = [self.receiveTotalSec floatValue];
    
    //Xibを読み込む
    UINib *resultLabelCell = [UINib nibWithNibName:@"ResultLabelTableViewCell" bundle:nil];
    UINib *resultTextCell = [UINib nibWithNibName:@"ResultTextTableViewCell" bundle:nil];
    
    [self.resultTableView registerNib:resultLabelCell forCellReuseIdentifier:@"resultLabelCell"];
    [self.resultTableView registerNib:resultTextCell forCellReuseIdentifier:@"resultTextCell"];
    
    //カレンダーの値をセットする
    [self setCalendarDate];
    
    //iAd
    [self switchiAdDisplay:false];
}

//iAd表示
-(void)switchiAdDisplay:(BOOL)flag {
    if (!flag) {
        self.adAlter.enabled = false;
    }
}

//ラベルにゲーム結果を表示する
//ロード時に呼び出されて、セクション数を返す ※必須
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section){
        case 0:
            return 4;
        case 1:
            return 2;
        default:
            return 0;
    }
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ResultLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultLabelCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[ResultLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultLabelCell"];
        }
        
        //各々のセルに値を入れる
        if (indexPath.row == 0) {
            
            cell.resultTypeLabel.text = @"挑戦日";
            cell.resultValueLabel.text = [NSString stringWithFormat:@"%d年%d月%d日", targetYear,targetMonth, targetDay];
        
        } else if (indexPath.row == 1) {
            
            cell.resultTypeLabel.text = @"正解数";
            cell.resultValueLabel.text = [NSString stringWithFormat:@"10問中%d問", correctCount];
        
        } else if (indexPath.row == 2) {
            
            cell.resultTypeLabel.text = @"時間";
            cell.resultValueLabel.text = [NSString stringWithFormat:@"%.3f秒", timeCount];
        
        } else if (indexPath.row == 3) {
            
            cell.resultTypeLabel.text = @"難易度";
            //@note:将来的には1:ふつう, 2:ムズイ, 3:マジ鬼とする
            cell.resultValueLabel.text = @"ふつう";
            
        } else {
            
            cell.resultTypeLabel.text = @"";
            cell.resultValueLabel.text = @"";
        }
        
        //クリック時のハイライトをオフにする
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //アクセサリタイプの指定
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        ResultTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultTextCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[ResultTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultTextCell"];
        }
        
        if (indexPath.row == 0) {
            
            cell.prTextTitle.text = @"いかがです？なかなか難問でしょ？";
            cell.prTextImage.image = prImage1;
            cell.prTextDetail.text = @"「10秒虫食い算」をプレイしてくれてありがとうございますm(_ _)m\n虫食い算の暗算って実は以外と難しいんですよね。すでに舐めてかかったあなたは、もうすごーく痛い目を見たかも？だけどもこれに懲りずに再チャレンジをしてみて下さい。またFacebookやTwitterで今日の計算結果やプレイの感想・機能改善の要望等もご遠慮なく是非とも宜しくお願いします！\n※誹謗中傷や罵詈雑言等の投稿等はしない方向でお願いします。";
            
        } else if (indexPath.row == 1) {
            
            cell.prTextTitle.text = @"今後はApple Watchでに対応するかも？";
            cell.prTextImage.image = prImage2;
            cell.prTextDetail.text = @"2015年4月に新たに発売されたApple Watchですがわずか半年の間にその特色や特性を生かしたアプリも生まれています。今の所はまだ対応をしてはいませんが次回のアップデートではApple Watchにも対応して行こうと思いますので乞うご期待ください。※ただし難易度は今まで以上に難しく？する予定なので宜しくお願い致します。";
            
        } else {
            
            cell.prTextTitle.text = @"";
            cell.prTextDetail.text = @"";
        }
        cell.prTextDetail.textColor = [UIColor whiteColor];
        
        //クリック時のハイライトをオフにする
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //アクセサリタイプの指定
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    return nil;
}

//セルの高さを返す ※任意
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return 44.0;
        case 1:
            return 350.0;
        default:
            return 0;
    }
}

//[CoreData]コアデータ（Answer）に1件の新規データを追加する
-(void)addRecordToCoreData:(int)score totalSeconds:(float)seconds {
    
    //NSManagedObjectContextのインスタンス作成
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //カウントを取って0だったら1、1より大きければデータの中でanswer_idの最大値に+1をする
    int max_answer_id = 1;
    if ([self getMaxAnswerId] > 0) {
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
    if (obj == nil) {
        NSLog(@"error");
    } else if([obj count] > 0) {
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
    
    //スコアを登録する
    [self addRecordToCoreData:correctCount totalSeconds:timeCount];
    
    //ボタンを非活性にする
    self.syncBannerBtn.enabled = false;
    self.syncBannerBtn.alpha = 0.6;
    [self.syncBannerBtn setTitle:@"戻って再挑戦してね！" forState:UIControlStateNormal];
    
    //iOS7.0以降
    if ([UIAlertController class]) {
        
        //UIAlertControllerで呼び出す
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"スコア登録完了!" message:@"今回のスコアが登録されました!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        //UIAlertControllerでアラートビューを表示
        [self presentViewController:alertController animated:YES completion:nil];
        
    //それ以前（まあ一応ね）
    } else {

        //UIAlertViewでアラートビューを表示
        UIAlertView *alert = [UIAlertView new];
        alert.title = @"スコア登録完了!";
        alert.message = @"今回のスコアが登録されました!";
        alert.delegate = self;
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
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
    
    //@todo:表示URL中身 ※Phase2でサイトができてからする
    //[controller addURL:[NSURL URLWithString:@"http://qiita.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

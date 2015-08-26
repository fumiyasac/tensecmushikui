//
//  AnalyticsController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticsController.h"
#import "UIDeviseSize.h"
#import "ColorDefinition.h"

//CALayerクラスのインポート
#import <QuartzCore/QuartzCore.h>

//CoreDataクラスのインポート
#import <CoreData/CoreData.h>

@interface AnalyticsController() {
    
    //表示年月のメンバ変数
    NSDate *now;
    int year;
    int month;
    int day;
    
    //カレンダークラス利用の際に必要なメンバ変数
    NSUInteger flags;
    NSDateComponents *comps;
    
    //その月の全科目の合計値
    int allCountPrice;
    
    //CoreData取得データ格納用メンバ変数
    int fetchCount;
    NSArray *fetchDataArray;
    
    //デバイスタイプ
    int deviseType;
    int segmentIndex;
    
    //データごとの色分け
    NSArray *colorArray;
    
    //科目ごとのパーセンテージ
    NSArray *percentArray;
}
@end

@implementation AnalyticsController

- (void)viewWillAppear:(BOOL)animated {
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    UIImage *backgroundImage;
    
    //iPhone4s
    if ([deviceName isEqual:@"iPhone4s"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone4s_background.jpg"];
        
    //iPhone5またはiPhone5s
    } else if ([deviceName isEqual:@"iPhone5"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone5_background.jpg"];
        
    //iPhone6
    } else if ([deviceName isEqual:@"iPhone6"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6_background.jpg"];
        
    //iPhone6 plus
    } else if ([deviceName isEqual:@"iPhone6plus"]) {
        
        backgroundImage  = [UIImage imageNamed:@"iphone6plus_background.jpg"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.graphWebView.frame = CGRectMake(0, 126, [UIDeviseSize getNowDisplayWidth], 170);
    self.scoreTableView.frame = CGRectMake(0, 296, [UIDeviseSize getNowDisplayWidth], [UIDeviseSize getNowDisplayHeight]-296-110);
    
    //下のボタンとセグメントの色つけ
    [self.prevBtn setBackgroundColor:[ColorDefinition getUIColorFromHex:@"222222"]];
    [self.nextBtn setBackgroundColor:[ColorDefinition getUIColorFromHex:@"222222"]];
    [self.deviceSegment setBackgroundColor:[ColorDefinition getUIColorFromHex:@"222222"]];
    [self.deviceSegment setTintColor:[ColorDefinition getUIColorFromHex:@"ffffff"]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //ボタンに丸みをつける
    [self.prevBtn.layer setCornerRadius:20.0];
    [self.nextBtn.layer setCornerRadius:20.0];
    [self.prevBtn.layer setBorderWidth:1.0];
    [self.nextBtn.layer setBorderWidth:1.0];
    [self.prevBtn.layer setBorderColor:[ColorDefinition getUIColorFromHex:@"ffffff"].CGColor];
    [self.nextBtn.layer setBorderColor:[ColorDefinition getUIColorFromHex:@"ffffff"].CGColor];
    
    //色の配列を設定する
    colorArray = @[@"f8c6c7",@"f2cb24",@"87c9a3",@"b9e4f7",@"face83",@"d2cce6",@"ccdc47",@"81b7ea",@"434348",@"d79759",@"9e9e9e"];
    
    //タイトル
    self.navigationItem.title = @"これまでのスコア";
    
    //デバイスタイプ
    deviseType = 1;
    segmentIndex = 0;
    
    //忘れずデリゲート（webViewDidFinishLoadを拾うため）
    self.graphWebView.delegate = self;
    
    //忘れずデリゲート（tableViewを使用するため）
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    
    //現在の日付を取得
    now = [NSDate date];
    
    //カレンダーから現在の年月を取得
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    NSInteger orgYear = comps.year;
    NSInteger orgMonth = comps.month;
    NSInteger orgDay = comps.day;
    
    //年月を取得(NSIntegerをintへ変換)
    year = (int)orgYear;
    month = (int)orgMonth;
    day = (int)orgDay;
    
    //Xibを読み込む
    UINib *newinfoCell = [UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil];
    [self.scoreTableView registerNib:newinfoCell forCellReuseIdentifier:@"ScoreCell"];
    
    //グラフデータをinit
    [self initGraphDataFromCoreData];
}

//WebViewをLoadする
- (void)loadWebViewResource {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"piechart" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.graphWebView loadRequest:req];
}

//グラフのベースを読み込む
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self initializePieChart];
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fetchCount;
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell" forIndexPath:indexPath];
    
    //セルの中に値を入れる
    NSDictionary *scoreDictionary = [fetchDataArray objectAtIndex:indexPath.row];
    NSString *scoreCorrect = scoreDictionary[@"score"];
    NSString *scoreSum = scoreDictionary[@"sum"];
    
    //パーセンテージを算出
    cell.graphColorOfTbl.backgroundColor = [ColorDefinition getUIColorFromHex:colorArray[indexPath.row]];
    cell.graphColorOfTbl.text = [NSString stringWithFormat:@"%@", percentArray[indexPath.row]];
    cell.correctNumOfTbl.text = [NSString stringWithFormat:@"%@/10", scoreCorrect];
    cell.totalSecOfTbl.text = [NSString stringWithFormat:@"%@回", scoreSum];
    
    //クリック時のハイライトをオフにする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //アクセサリタイプの指定
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //セルを返す
    return cell;
}

//セルの高さを返す ※任意
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

//平均点を算出して表示するメソッド
-(void)setAvgScoreOfLabel {
    
    float avgScore;
    
    //計算結果データの配列が存在したら
    if (fetchDataArray.count > 0) {
        
        //それぞれの値を加算して表示
        int wholeScore = 0;
        int countScore = 0;
        
        for (int i=0; i<fetchDataArray.count; i++) {
            NSDictionary *countData = [fetchDataArray objectAtIndex:i];
            int perScore = (int)[[countData objectForKey:@"score"] integerValue];
            int perSum = (int)[[countData objectForKey:@"sum"] integerValue];
            
            wholeScore += perScore * perSum;
            countScore += perSum;
        }
        avgScore = (float)wholeScore / countScore;
        
    } else {
        avgScore = 0.0;
    }
    self.currentAvgLabel.text = [NSString stringWithFormat:@"%.2f点", avgScore];
}

//日付を表示するメソッド
-(void)setSelectedDayOfLabel {
    self.currentDateLabel.text = [NSString stringWithFormat:@"%d年%d月%d日", year, month, day];
}

//cellのリロード ※任意
-(void)reloadData {
    [self.scoreTableView reloadData];
}

//合計支出の多い順にソートした配列を格納する（バーチャート・パイチャート用）
-(void)selectRecordAndCountToCoreData {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(year = %d) AND (month = %d) AND (day = %d) AND (devise = %d)", year, month, day, deviseType];
    [request setPredicate:predicate];
    
    //NSFetchRequestの中身をディクショナリにして返す
    [request setResultType:NSDictionaryResultType];
    
    //NSExpressionを作成する
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"score"];
    NSExpression *sumExpression = [NSExpression expressionForFunction:@"count:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    //NSExpressionDescriptionを作る
    [expressionDescription setName:@"sumScoreCountByDay"];
    [expressionDescription setExpression:sumExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    //カラム名：scoreでGroupByをかける
    [request setPropertiesToFetch:@[@"score", expressionDescription]];
    [request setPropertiesToGroupBy:@[@"score"]];
    
    //NSFetchRequestにセット
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    //メンバ変数に値を格納する
    fetchCount = (int)objects.count;
    NSLog(@"%d", fetchCount);
    
    //空の可変配列を作成する
    NSMutableArray *beforeSortArray = [NSMutableArray new];
    
    //取得分のデータを可変配列に格納する
    for (int i = 0; i < objects.count; i++) {
        
        //データをオブジェクト→文字列に変換して取得
        NSManagedObject *object = [objects objectAtIndex:i];
        NSString *score = [object valueForKey:@"score"];
        NSString *sumMoneyByYearAndMonth = [object valueForKey:@"sumScoreCountByDay"];
        
        //ディクショナリに格納する
        NSMutableDictionary *loopDictionary = [NSMutableDictionary new];
        [loopDictionary setObject:sumMoneyByYearAndMonth forKey:@"sum"];
        [loopDictionary setObject:score forKey:@"score"];
        
        //ディクショナリを配列に格納する
        [beforeSortArray addObject:loopDictionary];
    }
    
    //配列の[キー：sum]に対してソートする
    NSSortDescriptor *sortDescCondition = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    
    //NSSortDescriptorは配列に入れてNSArrayに渡す
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDescCondition, nil];
    
    //ソートを実行してメンバ変数配列に格納する
    fetchDataArray = [beforeSortArray sortedArrayUsingDescriptors:sortDescArray];
}

//並び順のデータからパーセンテージを取得する
- (NSMutableArray *)getPercentageArray:(NSArray *)array {
    
    NSMutableArray *percentageList = [NSMutableArray new];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *countData = [array objectAtIndex:i];
        NSString *percentageScore = [countData objectForKey:@"sum"];
        
        //割り算をしてパーセンテージをあらかじめ取っておく
        int scoreCountFloatNum = (int)percentageScore.integerValue;
        float scorePercentage = (scoreCountFloatNum / (float) allCountPrice) * 100;
        [percentageList addObject:[NSString stringWithFormat:@"%.2f%%", scorePercentage]];
    }
    return percentageList;
}

- (void)initializePieChart {
    
    //連結文字列の初期値を設定する
    NSString *targetString = @"";
    
    for (int i=0; i<fetchDataArray.count; i++) {
        
        //CoreDataから取得したデータをそれぞれの配列に格納する
        NSDictionary *graphData = [fetchDataArray objectAtIndex:i];
        NSString *graphSum      = [graphData objectForKey:@"sum"];
        NSString *graphExpense  = [graphData objectForKey:@"score"];
        
        //パイチャート内のデータを入れる
        if (fetchDataArray.count == 1) {
            //データが1つの場合
            targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"[{value:%@,color:'#%@',label:'%@'}]", graphSum, colorArray[i], graphExpense]];
        } else {
            //データが2つ以上の場合
            if (i == 0) {
                targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"[{value:%@,color:'#%@',label:'%@'},", graphSum, colorArray[i], graphExpense]];
            } else if (i == fetchDataArray.count - 1){
                targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"{value:%@,color:'#%@',label:'%@'}]", graphSum, colorArray[i], graphExpense]];
            } else {
                targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"{value:%@,color:'#%@',label:'%@'},", graphSum, colorArray[i], graphExpense]];
            }
        }
    }
    
    if (fetchDataArray.count > 0) {
        //実行するjsのファンクションと、dataを配列で渡す
        NSString *initPieChart = [NSString stringWithFormat:@"drawPieChart(%@);", targetString];
        
        //パイチャートのデータをinitする
        [self.graphWebView stringByEvaluatingJavaScriptFromString:initPieChart];
        self.graphWebView.alpha = 1.0;
    } else {
        self.graphWebView.alpha = 0.0;
    }
}

//月の全科目の合計値を取得
- (int)calculateWholeSumPerDay:(NSArray *)array {
    
    //合計値のローカル変数
    int wholeSum = 0;
    
    //配列が存在すれば全体の合計値を計算
    if (array.count > 0) {
        
        for(int i=0; i<array.count; i++){
            NSDictionary *countData = [array objectAtIndex:i];
            NSString *countSum = [countData objectForKey:@"sum"];
            wholeSum = wholeSum + (int)countSum.integerValue;
        }
        
    }
    return wholeSum;
}

//セグメントコントロールの値によって表示するグラフを変える
- (IBAction)deviceSegment:(UISegmentedControl *)sender {
    
    //iPhone版とAppleWatch版
    switch (sender.selectedSegmentIndex) {
        case 0:
            deviseType = 1;
            break;
        case 1:
            deviseType = 2;
            break;
    }
    segmentIndex = sender.selectedSegmentIndex;
    
    //取得するデータの値を変更する
    [self initGraphDataFromCoreData];
}

//グラフデータを切り替える
-(void)initGraphDataFromCoreData {
    
    //WebViewのロード
    [self loadWebViewResource];
    
    //コアデータより科目ごとの合計・月全体の合計を取得する
    [self selectRecordAndCountToCoreData];
    [self reloadData];
    
    //この月全体の合計値を取得する
    allCountPrice = [self calculateWholeSumPerDay:fetchDataArray];
    
    //この月全体の合計値を取得する
    percentArray = [self getPercentageArray:fetchDataArray];
    NSLog(@"%@", percentArray);
    
    //ラベルに表示する
    [self setAvgScoreOfLabel];
    [self setSelectedDayOfLabel];
    
    //グラフを表示する
    [self initializePieChart];
}

//前の日のパラメータを作成する関数
- (IBAction)prevAction:(UIButton *)sender {
    [self setupPrevCalendarData];
}

//次の日のパラメータを作成する関数
- (IBAction)nextAction:(UIButton *)sender {
    [self setupNextCalendarData];
}


//prevボタン押下に該当するデータを取得
- (void)setupPrevCalendarData {
    
    day = day - 1;
    NSCalendar *prevCalendar = [NSCalendar currentCalendar];
    NSDateComponents *prevComps = [[NSDateComponents alloc] init];
    [prevComps setYear:year];
    [prevComps setMonth:month];
    [prevComps setDay:day];
    NSDate *prevDate = [prevCalendar dateFromComponents:prevComps];
    
    [self recreateCalendarParameter:prevCalendar dateObject:prevDate];
    
}

//nextボタン押下に該当するデータを取得
- (void)setupNextCalendarData {
    
    day = day + 1;
    NSCalendar *nextCalendar = [NSCalendar currentCalendar];
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    [nextComps setYear:year];
    [nextComps setMonth:month];
    [nextComps setDay:day];
    NSDate *nextDate = [nextCalendar dateFromComponents:nextComps];
    
    [self recreateCalendarParameter:nextCalendar dateObject:nextDate];
}

//カレンダーのパラメータを作成する関数
- (void)recreateCalendarParameter:(NSCalendar *)currentCalendar dateObject:(NSDate *)currentDate {
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [currentCalendar components:flags fromDate:currentDate];
    
    NSInteger currentYear = comps.year;
    NSInteger currentMonth = comps.month;
    NSInteger currentDay = comps.day;
    
    //年月日を取得(NSIntegerをintへ変換)
    year = (int)currentYear;
    month = (int)currentMonth;
    day = (int)currentDay;
    
    //取得するデータの値を変更する
    [self initGraphDataFromCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

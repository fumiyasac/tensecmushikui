//
//  ViewController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "StartController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface StartController() {
    
    //ページ画像の可変配列
    NSMutableArray *pages;
    
    //ページ番号のメンバ変数
    int pageNumber;
    
    //問題
    int dataCount;
    
    //デバイス幅・高さ
    int deviceHeight;
    int deviceWidth;
}
@end

@implementation StartController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //ページデータ（辞書オブジェクト）の配列を作る
    pages = [NSMutableArray array];
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    //iPhone4s
    if ([deviceName isEqual:@"iPhone4s"]) {
        
        [pages addObject:@{@"imageName":@"iphone4s_image1.jpg"}];
        [pages addObject:@{@"imageName":@"iphone4s_image2.jpg"}];
        [pages addObject:@{@"imageName":@"iphone4s_image3.jpg"}];
        
    //iPhone5またはiPhone5s
    } else if ([deviceName isEqual:@"iPhone5"]) {
        
        [pages addObject:@{@"imageName":@"iphone5_image1.jpg"}];
        [pages addObject:@{@"imageName":@"iphone5_image2.jpg"}];
        [pages addObject:@{@"imageName":@"iphone5_image3.jpg"}];
        
    //iPhone6
    } else if ([deviceName isEqual:@"iPhone6"]) {
        
        [pages addObject:@{@"imageName":@"iphone6_image1.jpg"}];
        [pages addObject:@{@"imageName":@"iphone6_image2.jpg"}];
        [pages addObject:@{@"imageName":@"iphone6_image3.jpg"}];
        
    //iPhone6 plus
    } else if ([deviceName isEqual:@"iPhone6plus"]) {
        
        [pages addObject:@{@"imageName":@"iphone6plus_image1.jpg"}];
        [pages addObject:@{@"imageName":@"iphone6plus_image2.jpg"}];
        [pages addObject:@{@"imageName":@"iphone6plus_image3.jpg"}];
    }
    
    //ページコントロール（ドット）の設定
    self.startPageControl.pageIndicatorTintColor = [ColorDefinition getUIColorFromHex:@"cccccc"];
    self.startPageControl.currentPageIndicatorTintColor = [ColorDefinition getUIColorFromHex:@"222222"];
    [self.startBtn setBackgroundColor:[ColorDefinition getUIColorFromHex:@"222222"]];
    
    self.startPageControl.numberOfPages = pages.count;
    self.startPageControl.currentPage = 0;
    pageNumber = (int)self.startPageControl.currentPage;
    
    //スクロールビューのデリゲート設定
    self.startScrollView.delegate = self;
    
    //スクロールビューの各種設定
    self.startScrollView.scrollEnabled = YES;
    self.startScrollView.pagingEnabled = YES;
    self.startScrollView.showsHorizontalScrollIndicator = NO;
    self.startScrollView.showsVerticalScrollIndicator = NO;
    [self.startScrollView setBounces:NO];
    
    //1ページのフレームサイズ
    CGRect targetFrame = self.startScrollView.frame;
    
    //スクロールするコンテンツのサイズ
    self.startScrollView.contentSize = CGSizeMake(targetFrame.size.width * pages.count, targetFrame.size.height);
    
    //コンテンツのセッティング
    for (int i=0; i<pages.count; i++) {
        
        //1ページ分の情報を取り出す
        NSDictionary *pageDictionaryImage = pages[i];
        NSString *imageName = pageDictionaryImage[@"imageName"];
        
        //x座標の基準点をページ分だけずらす
        CGRect pageFrame;
        pageFrame.origin.x = targetFrame.size.width * i;
        pageFrame.origin.y = 0;
        pageFrame.size = targetFrame.size;
        
        //OpeningImageSliderクラスで1ページ分のコンテンツ（サブビュー）を作る
        OpeningImageSlider *targetSlider = [[OpeningImageSlider alloc] initWithOpeningView:(NSString *)imageName frame:(CGRect)pageFrame];
        
        //スクロールビューにページを追加する
        [self.startScrollView addSubview:targetSlider];
    }
    
    //ページコントロールを一番前に持ってくる
    [self.view bringSubviewToFront:self.startPageControl];
    
    //デバッグモード
    [self switchDebugLabel:false];
}

//スクロールのデリゲートメソッド
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    //現在のページ番号を調べる
    CGFloat pageWidth = self.startScrollView.frame.size.width;
    pageNumber = floor( ( self.startScrollView.contentOffset.x - pageWidth / 2 ) / pageWidth ) + 1;
    self.startPageControl.currentPage = pageNumber;
}

//[デバッグ用]AppleWatchからの計算結果表示
-(void)switchDebugLabel:(BOOL)flag {
    
    if (flag) {
        self.debugLabel.alpha = 1;
    }else {
        self.debugLabel.alpha = 0;
    }
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
    
    //現在の日付を取得
    NSDate *now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    int targetYear  = (int)comps.year;
    int targetMonth = (int)comps.month;
    int targetDay   = (int)comps.day;
    
    //オブジェクトにデータを追加する
    [addObject setValue:@(max_answer_id) forKeyPath:@"answer_id"];
    [addObject setValue:@(targetYear) forKeyPath:@"year"];
    [addObject setValue:@(targetMonth) forKeyPath:@"month"];
    [addObject setValue:@(targetDay) forKeyPath:@"day"];
    [addObject setValue:@(score) forKeyPath:@"score"];
    [addObject setValue:@(seconds) forKeyPath:@"seconds"];
    [addObject setValue:@(2) forKeyPath:@"devise"];
    
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

//本日のAppleWatchでのプレイ結果を取得する
-(NSArray *)syncTodayResultToCoreData {
    
    //NSManagedObjectContextのインスタンスを作成する
    NSManagedObjectContext *managedObjectContext = [[AppDelegate new] managedObjectContext];
    
    //現在の日付を取得
    NSDate *now = [NSDate date];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:flags fromDate:now];
    
    int targetYear  = (int)comps.year;
    int targetMonth = (int)comps.month;
    int targetDay   = (int)comps.day;
    
    //NSFetchRequestのインスタンス作成
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //検索対象のエンティティを作成する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //検索条件を指定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(year = %d) AND (month = %d) AND (day = %d) AND (devise = 2)", targetYear, targetMonth, targetDay];
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
    
    //配列の[キー：score]に対してソートする
    NSSortDescriptor *sortDescCondition = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    
    //NSSortDescriptorは配列に入れてNSArrayに渡す
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDescCondition, nil];
    
    //ソートを実行してメンバ変数配列に格納する
    NSArray *fetchDataArray = [beforeSortArray sortedArrayUsingDescriptors:sortDescArray];
    return fetchDataArray;
}

//問題の同期用メソッド
-(NSArray *)syncProblemDataForWatch {
    
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
    int tmpCount = [rows count];
    for(int a = tmpCount - 1; a > 0; a--){
        int randomNum = arc4random() % a;
        [rows exchangeObjectAtIndex:a withObjectAtIndex:randomNum];
    }
    
    //上から10件だけ表示する関数
    for(int i = 0; i < dataCount; i++){
        NSArray *row = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
        [problem addObject:@{@"amount":[NSString stringWithFormat:@"%d",i+1], @"calcurate":row[1], @"answer":row[2]}];
    }
    return problem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

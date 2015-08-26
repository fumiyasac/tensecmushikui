//
//  IntroductionController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "IntroductionController.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>

@interface IntroductionController() {
    
    //メインボタンの幅・高さ
    
    //最新情報のプロパティ
    NSMutableArray *newinfos;
    int newinfoCount;
    NSMutableArray *rulePage;
    int rulepageCount;
}

//最新情報データの配列
@property (nonatomic, strong) NSArray *items;

@end

@implementation IntroductionController

- (void)viewWillAppear:(BOOL)animated {
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    //ボタン画像
    UIImage *backgroundImage;
    UIImage *backgroundImage1;
    UIImage *backgroundImage2;
    
    //iPhone4s
    if ([deviceName isEqual:@"iPhone4s"]) {
        
        backgroundImage   = [UIImage imageNamed:@"iphone4s_background.jpg"];
        backgroundImage1  = [UIImage imageNamed:@"iphone4s_btn1.jpg"];
        backgroundImage2  = [UIImage imageNamed:@"iphone4s_btn2.jpg"];

    //iPhone5またはiPhone5s
    } else if ([deviceName isEqual:@"iPhone5"]) {
        
        backgroundImage   = [UIImage imageNamed:@"iphone5_background.jpg"];
        backgroundImage1  = [UIImage imageNamed:@"iphone5_btn1.jpg"];
        backgroundImage2  = [UIImage imageNamed:@"iphone5_btn2.jpg"];
        
    //iPhone6
    } else if ([deviceName isEqual:@"iPhone6"]) {
        
        backgroundImage   = [UIImage imageNamed:@"iphone6_background.jpg"];
        backgroundImage1  = [UIImage imageNamed:@"iphone6_btn1.jpg"];
        backgroundImage2  = [UIImage imageNamed:@"iphone6_btn2.jpg"];
        
    //iPhone6 plus
    } else if ([deviceName isEqual:@"iPhone6plus"]) {
        
        backgroundImage   = [UIImage imageNamed:@"iphone6plus_background.jpg"];
        backgroundImage1  = [UIImage imageNamed:@"iphone6plus_btn1.jpg"];
        backgroundImage2  = [UIImage imageNamed:@"iphone6plus_btn2.jpg"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //配置済みプロパティの再調整
    self.iphoneGameBtn.frame = CGRectMake(10, [UIDeviseSize getNowDisplayHeight]-230, [UIDeviseSize getNowDisplayWidth]-20, 80);
    self.viewResultBtn.frame = CGRectMake(10, [UIDeviseSize getNowDisplayHeight]-140, [UIDeviseSize getNowDisplayWidth]-20, 80);
    
    [self.iphoneGameBtn setBackgroundImage:backgroundImage1 forState:UIControlStateNormal];
    [self.viewResultBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    
    [self.iphoneGameBtn.layer setBorderColor:[ColorDefinition getUIColorFromHex:@"ffffff"].CGColor];
    [self.iphoneGameBtn.layer setBorderWidth:1.0];

    [self.viewResultBtn.layer setBorderColor:[ColorDefinition getUIColorFromHex:@"ffffff"].CGColor];
    [self.viewResultBtn.layer setBorderWidth:1.0];
    
    self.newinfoTableView.frame = CGRectMake(0, 64, [UIDeviseSize getNowDisplayWidth], [UIDeviseSize getNowDisplayHeight]-304);
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //データのセット
    [self setNewinfo];
    [self setRulePage];
    
    //デリゲート
    self.navigationController.delegate = self;
    self.newinfoTableView.delegate = self;
    self.newinfoTableView.dataSource = self;
    
    //ナビゲーションバーのカスタマイズ
    self.navigationItem.title = @"Menu";
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Top" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:barItem];
    [self.navigationItem setHidesBackButton:YES];
    
    //Xibを読み込む
    UINib *newinfoCell = [UINib nibWithNibName:@"NewinfoTableViewCell" bundle:nil];
    UINib *calcPointCell = [UINib nibWithNibName:@"CalculatePointTableViewCell" bundle:nil];
    
    [self.newinfoTableView registerNib:newinfoCell forCellReuseIdentifier:@"newinfoCell"];
    [self.newinfoTableView registerNib:calcPointCell forCellReuseIdentifier:@"calcPointCell"];
}

//前の画面に戻すアクション
- (void)backButtonAction:(UIBarButtonItem *)barItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//ロード時に呼び出されて、セクション数を返す ※必須
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//ヘッダーの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

//ヘッダーの中に何かを設定
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //ビューのインスタンスを作成
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIDeviseSize getNowDisplayWidth], 25)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIDeviseSize getNowDisplayWidth]-30, 25)];
    
    //ヘッダーの名称の切り替え
    if (section == 0) {
        headerLabel.text = @"お知らせや更新情報";
    } else if (section == 1) {
        headerLabel.text = @"四則演算のルールと遊び方";
    } else {
        headerLabel.text = @"";
    }
    
    headerView.backgroundColor = [ColorDefinition getUIColorFromHex:@"555555"];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section){
        case 0:
            return newinfoCount;
        case 1:
            return rulepageCount;
        default:
            return 0;
    }
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        NewinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newinfoCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[NewinfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newinfoCell"];
        }
        
        NSDictionary *dictionary = newinfos[indexPath.row];
        
        cell.newinfoCategory.text = [NSString stringWithFormat:@"%@",dictionary[@"category"]];
        cell.newinfoDate.text = [NSString stringWithFormat:@"%@",dictionary[@"update"]];
        cell.newinfoDetail.text = [NSString stringWithFormat:@"%@",dictionary[@"text"]];
        
        //クリック時のハイライトをオフにする
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //アクセサリタイプの指定
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        CalculatePointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calcPointCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[CalculatePointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"calcPointCell"];
        }
        
        NSDictionary *ruleDictionary = rulePage[indexPath.row];
        
        cell.ruleTitle.text = [NSString stringWithFormat:@"%@",ruleDictionary[@"calcRuleTitle"]];
        cell.ruleDetail.text = [NSString stringWithFormat:@"%@",ruleDictionary[@"calcRuleText"]];
        
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
    
    switch(indexPath.section){
        case 0:
            return 95.0;
        case 1:
            return 120.0;
        default:
            return 0;
    }
}

//最新情報のロードを行う
- (void)setNewinfo {
    
    newinfos = [NSMutableArray array];
    
    //CSVデータのディレクトリを探してくる
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"newinfo_download" ofType:@"csv" inDirectory:@"csvdata"];
    
    //エラー・エンコード方式が入る
    NSError* error = nil;
    NSStringEncoding encoding;
    NSString *content = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
    
    //ファイル内容を行毎に分解して最初と末尾を切る
    NSMutableArray *rows = [[content componentsSeparatedByString:@"\n"] mutableCopy];
    [rows removeObjectAtIndex:0];
    [rows removeObjectAtIndex:(NSInteger)rows.count-1];
    
    //上から10件だけ表示する関数
    for (int i = 0; i < rows.count; i++) {
        NSArray *row = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
        [newinfos addObject:@{@"amount":[NSString stringWithFormat:@"%d",i], @"category":row[1], @"title":row[2], @"text":row[3], @"update":row[4]}];
    }
    newinfoCount = (int)newinfos.count;
}

//10秒虫食い算のルールテキストをセットする
- (void)setRulePage {
    
    rulePage = [NSMutableArray array];
    
    //ページデータ（辞書オブジェクト）の配列を作る
    [rulePage addObject:@{@"calcRuleTitle":@"ルール1: 割り算(×),掛け算(÷)が先", @"calcRuleText":@"四則の混じった計算をする場合は割り算と掛け算を先に計算するのが決まりです。今の所はこのレベルの問題ですが、今後はもっともっと難しい問題も追加していく予定です。"}];
    
    [rulePage addObject:@{@"calcRuleTitle":@"ルール2: 10秒以内に計算しないとNG", @"calcRuleText":@"10秒で問題を解けないと強制終了で不正解になっちゃいます。当てずっぽうでやったとしても決して当たらないから、きちんと計算しないと正解はできませんよ！"}];
    
    [rulePage addObject:@{@"calcRuleTitle":@"ルール3: ベストスコアが出たら記録！", @"calcRuleText":@"今の所は全問正解はかなり不可能に近い？とテスト段階の評価だったこのアプリ。もしベストスコアが叩き出せたら是非とも結果を記録しておこう。"}];

    rulepageCount = (int)rulePage.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

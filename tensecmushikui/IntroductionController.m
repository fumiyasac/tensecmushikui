//
//  IntroductionController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/17.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "IntroductionController.h"
#import <CoreData/CoreData.h>

@interface IntroductionController ()
{
    //メインボタンの幅・高さ
    //int buttonPosY;
    int buttonImageLeftWidth;
    int buttonImageRightWidth;
    int buttonImageHeight;
}

//最新情報データの配列
@property (nonatomic, strong) NSArray *items;

@end

@implementation IntroductionController

- (void)viewWillAppear:(BOOL)animated {
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    
    //ボタン高さ
    buttonImageHeight = 80;
    
    //iPhone4s
    if([deviceName isEqual:@"iPhone4s"]){
        
        //buttonPosY = 0;
        buttonImageLeftWidth  = 160;
        buttonImageRightWidth = 160;
        buttonImageHeight     = 80;
        
    //iPhone5またはiPhone5s
    }else if ([deviceName isEqual:@"iPhone5"]){
        
        //buttonPosY = 0;
        buttonImageLeftWidth  = 160;
        buttonImageRightWidth = 160;
        buttonImageHeight     = 80;
        
    //iPhone6
    }else if ([deviceName isEqual:@"iPhone6"]){
        
        //buttonPosY = 0;
        buttonImageLeftWidth  = 187;
        buttonImageRightWidth = 186;
        buttonImageHeight     = 80;
        
    //iPhone6 plus
    }else if ([deviceName isEqual:@"iPhone6plus"]){
        
        //buttonPosY = 0;
        buttonImageLeftWidth  = 207;
        buttonImageRightWidth = 207;
        buttonImageHeight     = 80;
    }
    
    //配置済みプロパティの再調整
    
    //現在日付のメンバ変数に取得
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //デリゲート
    self.navigationController.delegate = self;
    self.newinfoTableView.delegate = self;
    self.newinfoTableView.dataSource = self;
    
    //ナビゲーションバーのカスタマイズ
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"Menu";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:barItem];
    [self.navigationItem setHidesBackButton:YES];
    
    //Xibを読み込む
    UINib *newinfoCell = [UINib nibWithNibName:@"NewinfoTableViewCell" bundle:nil];
    [self.newinfoTableView registerNib:newinfoCell forCellReuseIdentifier:@"newinfoCell"];
}

//前の画面に戻すアクション
- (void)backButtonAction:(UIBarButtonItem *)barItem{

    //前の画面に戻す
    [self dismissViewControllerAnimated:YES completion:nil];
}

//ロード時に呼び出されて、セクション数を返す ※必須
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newinfoCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewinfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newinfoCell"];
    }
    cell.newinfoCategory.text = @"問題追加";
    cell.newinfoDate.text = @"2015.04.18";
    cell.newinfoDetail.text = @"新たに100問の問題が追加されました！さあ、君にこの謎が解けるか？新たに100問の問題が追加されました！さあ、君にこの謎が解けるか？";
    
    //クリック時のハイライトをオフにする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //アクセサリタイプの指定
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//セルの高さを返す ※任意
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//「戻る」ボタン
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

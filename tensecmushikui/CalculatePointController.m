//
//  CalculatePointController.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "CalculatePointController.h"

@interface CalculatePointController ()

@end

@implementation CalculatePointController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //タイトル
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"計算Point";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

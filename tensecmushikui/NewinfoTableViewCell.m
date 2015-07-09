//
//  TableViewCell.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "NewinfoTableViewCell.h"
#import "UIDeviseSize.h"

@implementation NewinfoTableViewCell {
    CGFloat tableViewCellWidth;
    CGFloat tableViewCellHeight;
}

- (void)awakeFromNib {
    
    //デバイスサイズ調整用の処理
    tableViewCellWidth = [UIDeviseSize getNowDisplayWidth];
    tableViewCellHeight = 95;
    
    //位置の調整を行う
    self.frame = CGRectMake(0, 0, tableViewCellWidth, tableViewCellHeight);
    self.newinfoCategory.frame = CGRectMake(10, 10, 60, 20);
    self.newinfoDate.frame     = CGRectMake(80, 10, 100, 20);
    self.newinfoDetail.frame   = CGRectMake(10, 35, tableViewCellWidth-35, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

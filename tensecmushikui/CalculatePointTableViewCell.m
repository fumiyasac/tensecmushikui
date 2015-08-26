//
//  CalculatePointTableViewCell.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/28.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "CalculatePointTableViewCell.h"
#import "UIDeviseSize.h"

@implementation CalculatePointTableViewCell {
    CGFloat tableViewCellWidth;
    CGFloat tableViewCellHeight;
}

- (void)awakeFromNib {
    
    //デバイスサイズ調整用の処理
    tableViewCellWidth = [UIDeviseSize getNowDisplayWidth];
    tableViewCellHeight = 120;
    
    //位置の調整を行う
    self.frame = CGRectMake(0, 0, tableViewCellWidth, tableViewCellHeight);
    self.ruleTitle.frame = CGRectMake(15, 10, tableViewCellWidth - 30, 20);
    self.ruleDetail.frame = CGRectMake(15, 30, tableViewCellWidth - 30, 80);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

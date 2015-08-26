//
//  ResultTextTableViewCell.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "ResultTextTableViewCell.h"
#import "UIDeviseSize.h"

@implementation ResultTextTableViewCell {
    
    CGFloat tableViewCellWidth;
    CGFloat tableViewCellHeight;
}

- (void)awakeFromNib {
    
    // Initialization code
    
    //デバイスサイズ調整用の処理
    tableViewCellWidth = [UIDeviseSize getNowDisplayWidth];
    tableViewCellHeight = 350;
    
    //位置の調整を行う
    self.frame = CGRectMake(0, 0, tableViewCellWidth, tableViewCellHeight);
    self.prTextTitle.frame = CGRectMake(15, 10, tableViewCellWidth - 30, 20);
    self.prTextImage.frame = CGRectMake(15, 40, tableViewCellWidth - 30, 170);
    self.prTextDetail.frame = CGRectMake(10, 210, tableViewCellWidth - 20, 130);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

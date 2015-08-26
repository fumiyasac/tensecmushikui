//
//  ResultTextTableViewCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTextTableViewCell : UITableViewCell

//PRテキスト表示用のテーブルプロパティの一覧
@property (strong, nonatomic) IBOutlet UILabel *prTextTitle;
@property (strong, nonatomic) IBOutlet UITextView *prTextDetail;
@property (strong, nonatomic) IBOutlet UIImageView *prTextImage;

@end

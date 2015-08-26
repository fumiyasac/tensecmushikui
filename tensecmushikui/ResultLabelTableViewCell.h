//
//  ResultLabelTableViewCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/08/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultLabelTableViewCell : UITableViewCell

//リザルト表示用テーブルプロパティの一覧
@property (strong, nonatomic) IBOutlet UILabel *resultTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultValueLabel;

@end

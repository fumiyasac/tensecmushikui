//
//  CalculatePointTableViewCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/28.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatePointTableViewCell : UITableViewCell

//四則演算のルールを書いたプロパティ
@property (strong, nonatomic) IBOutlet UILabel *ruleTitle;
@property (strong, nonatomic) IBOutlet UILabel *ruleDetail;
@end

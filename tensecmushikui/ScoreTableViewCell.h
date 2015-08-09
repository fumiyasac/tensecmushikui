//
//  ScoreTableViewCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/24.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *correctNumOfTbl;
@property (strong, nonatomic) IBOutlet UILabel *totalSecOfTbl;
@property (strong, nonatomic) IBOutlet UILabel *graphColorOfTbl;

@end

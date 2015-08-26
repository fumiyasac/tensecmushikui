//
//  NewinfoTableViewCell.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewinfoTableViewCell : UITableViewCell

//最新情報のプロパティ
@property (strong, nonatomic) IBOutlet UILabel *newinfoCategory;
@property (strong, nonatomic) IBOutlet UILabel *newinfoDate;
@property (strong, nonatomic) IBOutlet UILabel *newinfoDetail;

@end

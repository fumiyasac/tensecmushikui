//
//  Answer.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/06/24.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * answer_id;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * devise;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * seconds;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * difficulty;

@end

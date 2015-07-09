//
//  Problem.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/29.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Problem : NSManagedObject

@property (nonatomic, retain) NSNumber * problem_id;
@property (nonatomic, retain) NSString * calculate;
@property (nonatomic, retain) NSNumber * answer;
@property (nonatomic, retain) NSNumber * difficulty;

@end

//
//  ColorDefinition.h
//  coffre_old
//
//  Created by 酒井文也 on 2014/11/27.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorDefinition : UIColor

//16進数のカラーコードをiOSの設定に変換するメソッド
+ (UIColor *)getUIColorFromHex:(NSString*)hex;

//カラーコード変換用の関数
+ (unsigned int)getNumberFromHex:(NSString*)hex rangeFrom:(int)from;

@end

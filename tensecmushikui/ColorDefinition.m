//
//  ColorDefinition.m
//  coffre_old
//
//  Created by 酒井文也 on 2014/11/27.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import "ColorDefinition.h"

@implementation ColorDefinition

//16進数のカラーコードをiOSの設定に変換するメソッド
+ (UIColor *)getUIColorFromHex:(NSString*)hex {
    
    return [UIColor
    colorWithRed:[self getNumberFromHex:hex rangeFrom:0]/255.0
     green:[self getNumberFromHex:hex rangeFrom:2]/255.0
     blue:[self getNumberFromHex:hex rangeFrom:4]/255.0
     alpha:1.0f];
}

//カラーコード変換用の関数
+ (unsigned int)getNumberFromHex:(NSString*)hex rangeFrom:(int)from {
    
    NSString *hexString = [hex substringWithRange:NSMakeRange(from, 2)];
    NSScanner* hexScanner = [NSScanner scannerWithString:hexString];
    unsigned int intColor;
    [hexScanner scanHexInt:&intColor];
    return intColor;
}

@end
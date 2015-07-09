//
//  UIDeviseSize.h
//  plaisir
//
//  Created by 酒井文也 on 2015/01/28.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * デバイスのサイズや使用しているデバイス名を取得するクラス
 */

@interface UIDeviseSize : UIView

//現在起動中のデバイスの高さを取得
+ (int)getNowDisplayHeight;

//現在起動中のデバイスの幅を取得
+ (int)getNowDisplayWidth;

//現在起動中のデバイス名の取得
+ (NSString *)getNowDisplayDevice;

@end

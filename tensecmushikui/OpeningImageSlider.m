//
//  OpeningImageSlider.m
//  plaisir
//
//  Created by 酒井文也 on 2015/02/08.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "OpeningImageSlider.h"

@implementation OpeningImageSlider

//イニシャライザ
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //initialization code.
    }
    return self;
}

//カスタムイニシャライザ(一応カスタマイズ等の余地を残すためこの形)
-(id)initWithOpeningView:(NSString *)imageName frame:(CGRect)frame caption:(NSString *)caption
{
    //イニシャライザで初期化済のインスタンスを取得する
    self = [self initWithFrame:frame];
    
    //ラベルの高さ
    int labelHeight = 25;
    
    //絵を表示したイメージビューを作成する
    CGRect imageFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //キャプションの入ったラベルを作成する
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.text = caption;
    myLabel.frame = CGRectMake(0, frame.size.height-labelHeight, frame.size.width, labelHeight);
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor grayColor];
    
    //イメージビューとラベルをサブビューとして追加する
    [self addSubview:imageView];
    [self addSubview:myLabel];
    
    //出来上がったページを返す
    return self;
}

@end

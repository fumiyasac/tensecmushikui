//
//  ScoreImageSlider.m
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/06/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "ScoreImageSlider.h"
#import "UIDeviseSize.h"

@implementation ScoreImageSlider

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
-(id)initWithScoreView:(NSString *)imageName frame:(CGRect)frame caption:(NSString *)caption
{
    //イニシャライザで初期化済のインスタンスを取得する
    self = [self initWithFrame:frame];
    
    //現在起動中のデバイスを取得
    NSString *deviceName = [UIDeviseSize getNowDisplayDevice];
    int imageViewHeight;
    int imageViewWidth;
    
    //Debug.仮の値で決め打ち
    imageViewHeight = 300;
    
    //iPhone4s
    if([deviceName isEqual:@"iPhone4s"]){
        
        imageViewWidth  = 300;
        //imageViewHeight = ;
        
    //iPhone5またはiPhone5s
    }else if ([deviceName isEqual:@"iPhone5"]){
        
        imageViewWidth  = 300;
        //imageViewHeight = ;
        
    //iPhone6
    }else if ([deviceName isEqual:@"iPhone6"]){
        
        imageViewWidth  = 355;
        //imageViewHeight = ;
        
    //iPhone6 plus
    }else if ([deviceName isEqual:@"iPhone6plus"]){
        
        imageViewWidth  = 394;
        //imageViewHeight = ;
    }
    
    //ラベルの高さ
    int labelHeight = 25;
    
    //絵を表示したイメージビューを作成する
    CGRect imageFrame = CGRectMake(10, 200, imageViewWidth, imageViewHeight);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //キャプションの入ったラベルを作成する
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.text = caption;
    myLabel.frame = CGRectMake(0, imageViewHeight-labelHeight, imageViewWidth, labelHeight);
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor blackColor];
    
    //イメージビューとラベルをサブビューとして追加する
    [self addSubview:imageView];
    [self addSubview:myLabel];
    
    //出来上がったページを返す
    return self;
}

@end

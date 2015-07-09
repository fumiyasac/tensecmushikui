//
//  CalculatePointController.h
//  tensecmushikui
//
//  Created by 酒井文也 on 2015/04/18.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface CalculatePointController : UIViewController<ADBannerViewDelegate>

//計算のポイントのWebview
@property (strong, nonatomic) IBOutlet UIWebView *pointWebView;

@end

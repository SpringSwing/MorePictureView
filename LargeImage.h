//
//  LargeImage.h
//  闪游资讯
//
//  Created by SHF on 15/10/22.
//  Copyright © 2015年 SHF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVOSCloud/AVOSCloud.h>
#import "Lean_data.h"
#import "ZoomInsideView.h"

@interface LargeImage : UIViewController<UIScrollViewDelegate>


//Your Image Data's Index
@property (strong,nonatomic)  Lean_data* data;
//Your Image Data's Index

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic,strong) NSMutableArray* imageArr;

@property (nonatomic,strong) ZoomInsideView* zoomScrollView;

@end

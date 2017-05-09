//
//  JXCircleRatioView.h
//  circleViewDome
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXCircleRatioView : UIView

@property(nonatomic, strong) NSMutableArray *dataArray; // 数据数组
@property(nonatomic , assign) CGFloat circleRadius;// 半径

- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray CircleRadius:(CGFloat)circleRadius;

@end

//
//  JXCircleRatioView.m
//  circleViewDome
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCircleRatioView.h"
#import "JXCircleModel.h"

/*! 白色圆的半径 */
static CGFloat const whiteCircleRadius = 25.0;
/*! 指引线的小圆 */
static CGFloat const smallCircleRadius = 4.0;
/*! 指引线的文字字体大小 */
static CGFloat const nameTextFont = 10.0;
/*! 指引线的宽度 */
static CGFloat const lineWidth = 60.0;
/*! 折线的宽度 */
static CGFloat const foldLineWidth = 10.0;

#define degreesToRadian(x) ( 180.0 / PI * (x))


@implementation JXCircleRatioView


- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray CircleRadius:(CGFloat)circleRadius{
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataArray = dataArray;
        self.circleRadius = circleRadius;
        
    }
    return self;
}

/// 比例
- (CGFloat)getShareNumber:(NSMutableArray *)arr{
    CGFloat f = 0.0;
    for (int  i = 0; i < arr.count; i++) {
        
        JXCircleModel *model = arr[i];
        f += [model.number floatValue];
    }
    //NSLog(@"总量：%.2f  比例:%.2f",f,360.0 / f);
    return M_PI*2 / f;
}

- (void)drawRect:(CGRect)rect {
    
    // 1.所占比例
    CGFloat bl = [self getShareNumber:self.dataArray];

  
    
    // 2.开启上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat angle_start = 0; //开始时的弧度  －－－－－ 旋转200度
    CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        
        
        JXCircleModel *model = self.dataArray[i];
        
        CGFloat angle_end =  [model.number floatValue] * bl + ff;  //结束
        
        ff += [model.number floatValue] * bl;
        
        NSLog(@"angle_end == %f",angle_end);
        
        /*!参数：
         // 1.上下文
         // 2.中心点
         // 3.开始
         // 4.结束
         // 5.颜色
         */
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor:model.color andInt:i];
        
        angle_start = angle_end;
    }
    //3.添加中心圆
    [self addCenterCircle];
    
}


/// 添加中心白色圆
-(void)addCenterCircle{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:whiteCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [[UIColor whiteColor] set];
    [arcPath fill];
    [arcPath stroke];
    
}



/**
 画圆弧
 
 @param ctx 上下文
 @param point 圆心
 @param angle_start 开始角度
 @param angle_end 结束角度
 @param color 颜色
 @param n 表示第几个弧行
 */
-(void)drawArcWithCGContextRef:(CGContextRef)ctx
                  andWithPoint:(CGPoint) point
            andWithAngle_start:(float)angle_start
              andWithAngle_end:(float)angle_end
                  andWithColor:(UIColor *)color
                        andInt:(int)n{
    
    // 1.开始画线
    CGContextMoveToPoint(ctx, point.x, point.y);

    // 2.颜色空间填充
    CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor));
    
    // 3.画圆
    CGContextAddArc(ctx, point.x, point.y, self.circleRadius, angle_start, angle_end, 0);
    
    // 4.填充
    CGContextFillPath(ctx);
    
    // 5.弧度的中心角度
    CGFloat h = (angle_end + angle_start) / 2.0;
    
    // 6.小圆的中心点
    CGFloat xx = self.frame.size.width / 2 + (_circleRadius + 10) * cos(h);
    CGFloat yy = self.frame.size.height / 2 + (_circleRadius + 10) * sin(h);
    
    // 7.画折线
    [self addLineAndnumber:color andCGContextRef:ctx andX:xx andY:yy andInt:n angele:h];
    
}

/**
 * @color 颜色
 * @ctx CGContextRef
 * @x 小圆的中心点的x
 * @y 小圆的中心点的y
 * @n 表示第几个弧行
 * @angele 弧度的中心角度
 */

//画线
-(void)addLineAndnumber:(UIColor *)color
        andCGContextRef:(CGContextRef)ctx
                   andX:(CGFloat)x
                   andY:(CGFloat)y
                 andInt:(int)n
                 angele:(CGFloat)angele{
    
    // 1.小圆的圆心
    CGFloat smallCircleCenterPointX = x;
    CGFloat smallCircleCenterPointY = y;
    
    
    // 2.折点
    CGFloat lineLosePointX = 0.0 ; //指引线的折点
    CGFloat lineLosePointY = 0.0 ; //
    
    // 3.指引线的终点
    CGFloat lineEndPointX ; //
    CGFloat lineEndPointY ; //
    
    // 4.数字的起点
    CGFloat numberStartX;
    CGFloat numberStartY;
    
    // 5.文字的起点
    CGFloat textStartX;
    CGFloat textStartY;
    
    // 6.数字的长度
    JXCircleModel *model = self.dataArray[n];
    NSString *number = model.number;
    CGSize numberSize = [number sizeWithAttributes:@{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:16.0]
                                                     }];
    
    // 文字size
    CGSize textSize = [model.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameTextFont]}];
    
    
    // 设置折点
    lineLosePointX = smallCircleCenterPointX + foldLineWidth * cos(angele);
    lineLosePointY = smallCircleCenterPointY + foldLineWidth * sin(angele);
    
    
    // 7.画小圆
    if (smallCircleCenterPointX > self.bounds.size.width * 0.5) {
        
        // 指引线终点
        lineEndPointX = lineLosePointX + lineWidth;
        lineEndPointY = lineLosePointY;
        
        // 数字
        numberStartX = lineEndPointX - numberSize.width;
        numberStartY = lineEndPointY - numberSize.height;
        
        // 文字
        textStartX = lineEndPointX - textSize.width;
        textStartY = lineEndPointY;
        
    }else{
        
        // 指引线终点
        lineEndPointX = lineLosePointX - lineWidth;
        lineEndPointY = lineLosePointY;
        
        // 数字
        numberStartX = lineEndPointX;
        numberStartY = lineEndPointY - numberSize.height;
        
        // 文字
        textStartX = lineEndPointX;
        textStartY = lineEndPointY;
        
    }
    
    // 8.画小圆
    /*!创建圆弧
     参数：
     center->圆点
     radius->半径
     startAngle->起始位置
     endAngle->结束为止
     clockwise->是否顺时针方向
     */
    
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(smallCircleCenterPointX, smallCircleCenterPointY) radius:smallCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [color set];
    // 填充
    [arcPath fill];
    // 描边，路径创建需要描边才能显示出来
    [arcPath stroke];
    
    // 9.画指引线
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, smallCircleCenterPointX, smallCircleCenterPointY);
    
    CGContextAddLineToPoint(ctx, lineLosePointX, lineLosePointY);
    CGContextAddLineToPoint(ctx, lineEndPointX, lineEndPointY);
    CGContextSetLineWidth(ctx, 1);
    
    //填充颜色
    CGContextSetFillColorWithColor(ctx , color.CGColor);
    CGContextStrokePath(ctx);
    
    // 10.画指引线上的数字
     [model.number drawAtPoint:CGPointMake(numberStartX, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:color}];
    
    // 11.画指引线下的文字
    // 11.1设置段落风格
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSTextAlignmentRight;
    
    if (lineEndPointX < [UIScreen mainScreen].bounds.size.width / 2.0) {
        paragraph.alignment = NSTextAlignmentLeft;
    }
    
    [model.name drawInRect:CGRectMake(textStartX, textStartY, textSize.width, textSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameTextFont],NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    
    
}

/// 重绘
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [self setNeedsDisplay];
}


@end

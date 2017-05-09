//
//  ViewController.m
//  circleViewDome
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "JXCircleModel.h"
#import "JXCircleRatioView.h"


#define PIE_HEIGHT  250
#define Radius 70.5 //圆形比例图的半径



@interface ViewController ()

@property(nonatomic, strong) JXCircleRatioView *circleView_one;
@property(nonatomic, strong) JXCircleRatioView *circleView_two;
@property(nonatomic, strong) NSMutableArray *data1;
@property(nonatomic, strong) NSMutableArray *data2;
@end


@implementation ViewController

- (NSMutableArray *)data1{
    if (_data1 == nil) {
        _data1 = [NSMutableArray array];
        
        NSArray *colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor blueColor]];
        NSArray *numbers = @[@"100",@"200",@"400"];
        NSArray *names = @[@"信托产品\n(买的+收益)",@"粤财汇\n(代收/冻结/可用金额+收益)",@"投资\n(三个公司投资总额+收益)"];
        
        
        for (int i = 0; i < numbers.count; i++) {
            JXCircleModel *model = [[JXCircleModel alloc]init];
            model.color = colors[i];
            model.number = numbers[i];
            model.name = names[i];
            
            
            
            [_data1  addObject:model];
        }
        
    }
    return _data1;
}


- (NSMutableArray *)data2{
    if (_data2 == nil) {
        _data2 = [NSMutableArray array];
        
        NSArray *colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor]];
        NSArray *numbers = @[@"100",@"200",@"300",@"400",@"100"];
        NSArray *names = @[@"担保产品",@"粤财汇",@"信托产品",@"投资",@"资产产品"];
        
        
        for (int i = 0; i < numbers.count; i++) {
            JXCircleModel *model = [[JXCircleModel alloc]init];
            model.color = colors[i];
            model.number = numbers[i];
            model.name = names[i];
            
            
            
            [_data2  addObject:model];
        }
        
    }
    return _data2;
}



- (JXCircleRatioView *)circleView_one{
    if (!_circleView_one) {
        
        _circleView_one = [[JXCircleRatioView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, PIE_HEIGHT)  andDataArray:self.data1 CircleRadius:Radius];
        _circleView_one.backgroundColor = [UIColor whiteColor];
    }
    return _circleView_one;
}

- (JXCircleRatioView *)circleView_two
{
    if (!_circleView_two) {
        _circleView_two = [[JXCircleRatioView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, PIE_HEIGHT)  andDataArray:self.data2 CircleRadius:Radius];
        _circleView_two.backgroundColor = [UIColor whiteColor];
    }
    return _circleView_two;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"圆形比例图";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addButton]; //添加选择按钮
    
    //添加圆形比例图
    [self.view addSubview:self.circleView_one];
    
    UIButton *bt = [self.view viewWithTag:101];
    bt.selected = YES;
}


-(void)addButton{
    
    NSArray *arr = @[@"融资",@"投资"];
    
    for (int i = 0; i < arr.count; i++) {
        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width / arr.count, 64, self.view.frame.size.width / arr.count, 40)];
        bt.tag = 101 + i;
        [bt setTitle:arr[i] forState:0];
        [bt setTitleColor:[UIColor blueColor] forState:0];
        [bt setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bt];
    }
    
}


-(void)click:(UIButton *)sender
{
    
    if ([sender.titleLabel.text isEqualToString:@"融资"]) {
        //
        [self.circleView_one removeFromSuperview];
        [self.circleView_two removeFromSuperview];
        //添加圆形比例图
        [self.view addSubview:self.circleView_one];
        
        
    }else if ([sender.titleLabel.text isEqualToString:@"投资"]){
        //
        [self.circleView_one removeFromSuperview];
        [self.circleView_two removeFromSuperview];
        //添加圆形比例图
        [self.view addSubview:self.circleView_two];
    }
    sender.selected = YES;
    
    if (sender.tag == 101) {
        UIButton *bt = [self.view viewWithTag:102];
        bt.selected = NO;
    }else if (sender.tag == 102){
        UIButton *bt = [self.view viewWithTag:101];
        bt.selected = NO;
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

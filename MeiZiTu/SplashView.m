//
//  SplashView.m
//  NetEaseNews
//
//  Created by Vokie on 2016/10/19.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "SplashView.h"

#define LOADING_WIDTH 40

#define LOADING_OFFSET 10

@interface SplashView()

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat addValue; //增量值
@end

@implementation SplashView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(APP_SCREEN_WIDTH - LOADING_WIDTH - LOADING_OFFSET, LOADING_OFFSET, LOADING_WIDTH, LOADING_WIDTH);//设置shapeLayer的尺寸和位置
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    self.shapeLayer.strokeStart = 0.0f;
    self.shapeLayer.strokeEnd = 1.0f;
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 3.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    CGPoint center = CGPointMake(LOADING_WIDTH / 2.0, LOADING_WIDTH/ 2.0);  //设置圆心位置
    CGFloat radius = LOADING_WIDTH / 2.0 - 4;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = M_PI_2 * 3;  //圆终点位置
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.layer addSublayer:self.shapeLayer];
    
    
    CAShapeLayer *grayBackground = [CAShapeLayer layer];
    grayBackground.frame = CGRectMake(APP_SCREEN_WIDTH - LOADING_WIDTH - LOADING_OFFSET, LOADING_OFFSET, LOADING_WIDTH, LOADING_WIDTH);//设置shapeLayer的尺寸和位置
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath1 = [UIBezierPath bezierPathWithArcCenter:center radius:(radius-1) startAngle:startA endAngle:endA clockwise:YES];
    
    grayBackground.path = circlePath1.CGPath;
    grayBackground.fillColor = [UIColor grayColor].CGColor;
    //添加并显示
    [self.layer addSublayer:grayBackground];
    
    
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFontSize:12];
    label.wrapped = YES;
    [label setFrame:CGRectMake(APP_SCREEN_WIDTH - LOADING_WIDTH - LOADING_OFFSET, (LOADING_WIDTH - 16) / 2.0 + LOADING_OFFSET, LOADING_WIDTH, 15)];
    [label setString:@"跳过"];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor whiteColor] CGColor]];
    label.contentsScale = [UIScreen mainScreen].scale;
    label.wrapped = YES;
    [self.layer addSublayer:label];
    
    self.timer.fireDate = [NSDate distantPast];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setShowTime:(CGFloat)showTime {
    _showTime = showTime;
    _addValue = 1.0 / (showTime * 10.0);

}

//定时器方法
- (void)timeAction {
//    NSLog(@"start: %f, end:%f", self.shapeLayer.strokeStart, self.shapeLayer.strokeEnd);
    if(self.shapeLayer.strokeStart < self.shapeLayer.strokeEnd) {
        self.shapeLayer.strokeStart += _addValue;
    }
    
    
}

- (void)showInView {
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    
    [UIView animateWithDuration:0.2 delay:_showTime options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeAndCleanUp];
        [self removeFromSuperview];
    }];
}

- (void)removeAndCleanUp {
    //取消定时器
    [self.timer invalidate];
    self.timer = nil;
}

@end

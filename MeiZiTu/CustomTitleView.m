//
//  CustomTitleView.m
//  MeiZiTu
//
//  Created by Vokie on 2017/9/12.
//  Copyright © 2017年 Vokie. All rights reserved.
//

#import "CustomTitleView.h"

@implementation CustomTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mainTitle = [[UILabel alloc] init];
        _mainTitle.textColor = [UIColor whiteColor];
        _mainTitle.font = [UIFont systemFontOfSize:16];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_mainTitle];
        
        _mainTitle.frame = CGRectMake(0, 0, frame.size.width, frame.size.height * 0.6);
        
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor whiteColor];
        _subTitle.font = [UIFont systemFontOfSize:13];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitle];
        
        _subTitle.frame = CGRectMake(0, CGRectGetMaxY(_mainTitle.frame), frame.size.width, frame.size.height * 0.4);
    }
    
    return self;
}

@end

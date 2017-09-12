//
//  CHTCollectionViewWaterfallHeader.m
//  Demo
//
//  Created by Neil Kimmett on 21/10/2013.
//  Copyright (c) 2013 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallHeader.h"
#import <UIImageView+WebCache.h>

@implementation CHTCollectionViewWaterfallHeader

#pragma mark - Accessors
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/MrVokie/MeiZiTu/0b8ed13a54bece761c05569ec6295c915ba09b02/home.jpg"] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageProgressiveDownload];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    return self;
}

@end

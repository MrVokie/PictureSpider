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
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://avatars0.githubusercontent.com/u/5802573?v=4&s=460"] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageProgressiveDownload];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    return self;
}

@end

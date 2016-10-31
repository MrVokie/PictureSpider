//
//  CHTCollectionViewWaterfallFooter.m
//  Demo
//
//  Created by Neil Kimmett on 28/10/2013.
//  Copyright (c) 2013 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallFooter.h"
#import <UIImageView+WebCache.h>

@implementation CHTCollectionViewWaterfallFooter

#pragma mark - Accessors
- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
      [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cdn.cocimg.com/bbs/attachment/upload/85/5221851449654525.jpg"] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageProgressiveDownload];
      imageView.contentMode = UIViewContentModeScaleAspectFill;
      imageView.clipsToBounds = YES;
      [self addSubview:imageView];
  }
  return self;
}

@end

//
//  PhotoCollectionViewCell.m
//  Photo Album
//
//  Created by Bakytzhan Baizhikenov on 2/9/15.
//  Copyright (c) 2015 Bakytzhan Baizhikenov. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#define IMAGEVIEW_BORDER_LENGTH 2

@implementation PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClipsToBounds:YES]; 
    [self.contentView addSubview:self.imageView];
}

@end

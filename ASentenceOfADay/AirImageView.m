//
//  AirImageView.m
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/4.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "AirImageView.h"


IB_DESIGNABLE
@interface AirImageView () {
    IBInspectable CGFloat cornerRadius;
    IBInspectable BOOL masksToBounds;
}

@end

@implementation AirImageView

//from code
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

//from storyboard
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = masksToBounds;
}

- (void)prepareForInterfaceBuilder {
    [self setup];
}
@end

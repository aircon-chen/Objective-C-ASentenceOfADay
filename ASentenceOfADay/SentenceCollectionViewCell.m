//
//  SentenceCollectionViewCell.m
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/4.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "SentenceCollectionViewCell.h"
#define defaultOrange UIColorFromRGB(0xf07630)
#define defaultShadow UIColorFromRGB(0x993300)

IB_DESIGNABLE
@interface SentenceCollectionViewCell(){
    IBInspectable CGFloat cornerRadius;
    IBInspectable BOOL masksToBounds;
}

@end

@implementation SentenceCollectionViewCell
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

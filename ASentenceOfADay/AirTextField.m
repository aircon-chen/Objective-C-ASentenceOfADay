//
//  AirTextField.m
//  SuperBike
//
//  Created by Chen Hsin Hsuan on 2015/2/18.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "AirTextField.h"
IB_DESIGNABLE
@interface AirTextField(){
    IBInspectable CGFloat cornerRadius;
    IBInspectable BOOL masksToBounds;
    
    IBInspectable CGRect padding;
    IBInspectable UIColor *placeHolderColor;
}
@end

@implementation AirTextField

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
    
    //padding
    UIView *paddingView = [[UIView alloc] initWithFrame:padding];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    //place holder color
    if (placeHolderColor) {
        [self setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)prepareForInterfaceBuilder {
    [self setup];
}

@end

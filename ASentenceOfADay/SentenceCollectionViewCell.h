//
//  SentenceCollectionViewCell.h
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/4.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirImageView.h"
#import "AirButton.h"
@interface SentenceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet AirImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *sentenceENLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentenceTWLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet AirButton *deleteButton;

@end

//
//  WKBDateCell.m
//  CalendarDemo
//
//  Created by zj on 2017/6/24.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "WKBDateCell.h"

@implementation WKBDateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.cellLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.cellLabel.textAlignment = NSTextAlignmentCenter;
    self.cellLabel.layer.cornerRadius = CGRectGetWidth(self.contentView.frame) / 2.0;
    self.cellLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.cellLabel];
}


@end

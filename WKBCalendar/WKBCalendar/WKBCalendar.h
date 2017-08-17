//
//  WKBCalendar.h
//  CalendarDemo
//
//  Created by zj on 2017/6/24.
//  Copyright © 2017年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectedDateBlock)(NSDate * date);

@interface WKBCalendar : UICollectionView

@property (nonatomic,assign)NSInteger year;
@property (nonatomic,assign)NSInteger month;
@property (nonatomic,assign)NSInteger day;
@property (nonatomic,copy) DidSelectedDateBlock  selectedDateBlock;

-(void)LastMonthClick;
-(void)NextbuttonClick;

@end

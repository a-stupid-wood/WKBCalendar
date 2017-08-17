//
//  WKBCalendar.m
//  CalendarDemo
//
//  Created by zj on 2017/6/24.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "WKBCalendar.h"
#import "WKBDateCell.h"
#import "WKBDateModel.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString * weekDayCellId = @"weekDayCellId";
static NSString * dateCellId = @"dateCellId";
@interface WKBCalendar ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
/*
 ****用来存放天数的数组
 */
@property (nonatomic,strong)NSArray * weekArray;
@property (nonatomic,strong)NSMutableArray * dayArray;
@property (nonatomic,strong)NSDateComponents * nowDate;
@property (nonatomic,strong)NSCalendar *calendar;

@end

@implementation WKBCalendar

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[WKBDateCell class] forCellWithReuseIdentifier:weekDayCellId];
        [self registerClass:[WKBDateCell class] forCellWithReuseIdentifier:dateCellId];
        self.backgroundColor = [UIColor whiteColor];
        [self initDataSource];
    }
    return self;
}

#pragma mark - 初始化数据
-(void)initDataSource{
    
    self.weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    self.dayArray = [[NSMutableArray alloc] init];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.nowDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    self.year = self.nowDate.year;
    self.month = self.nowDate.month;
    self.day = self.nowDate.day;
    
    [self setMydayArrayWithYear:self.year AndMonth:self.month AndDay:self.day];//给dayarray赋值
}


#pragma mark - 请求下一个月的数据
-(void)NextbuttonClick{
    
    [self.dayArray removeAllObjects];
    if (self.month == 12) {
        self.month = 1;
        self.year++;
    }else{
        self.month++;
    }
    [self setMydayArrayWithYear:self.year AndMonth:self.month AndDay:self.day];
    [self reloadData];
    
}
#pragma mark - 请求上一个月的数据
-(void)LastMonthClick{
    
    [self.dayArray removeAllObjects];
    
    if (self.month == 1) {
        self.month = 12;
        self.year--;
    }else{
        self.month--;
    }
    [self setMydayArrayWithYear:self.year AndMonth:self.month AndDay:self.day];
    [self reloadData];
    
}

#pragma mark - 获得上个月的某一天
-(NSDate*)setDayWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = nil;
    date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,day]];
    return date;
}

#pragma mark - 请求数据
-(void)setMydayArrayWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //添加第一周中上个月的几天
    NSDate * firstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,1]];
    [self appendLastMonthDayWithFirstDate:firstDate lastMonthDate:[self setDayWithYear:year AndMonth:month == 1 ? 12 : month - 1  AndDay:day]];
    
    //添加本月的日期
    NSDate * nowDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,day]];
    NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowDate];
    [self appendCurrentMonthDaysWithDateRange:dayRange];
    
    //添加最后一周中下个月的几天
    NSDate * lastDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,dayRange.length]];
    [self appendNextMothDaysWithLastDay:lastDate];
    
}

#pragma mark - 添加第一周中上个月的几天
- (void)appendLastMonthDayWithFirstDate:(NSDate *)firstDate lastMonthDate:(NSDate *)lastMonthDay
{
    NSRange lastdayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDay];
    NSDateComponents * firstDay = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:firstDate];
    for (NSInteger i = lastdayRange.length - firstDay.weekday + 2; i <= lastdayRange.length; i++)
    {
        WKBDateModel * dateModel = [[WKBDateModel alloc] init];
        dateModel.date = @"";
        [self.dayArray addObject:dateModel];
    }
}

#pragma mark - 添加本月的日期
- (void)appendCurrentMonthDaysWithDateRange:(NSRange)dayRange
{
    for (NSInteger i = 1; i <= dayRange.length ; i++)
    {
        WKBDateModel * dateModel = [[WKBDateModel alloc] init];
        dateModel.date = [NSString stringWithFormat:@"%d",i];
        dateModel.isNow = (i == self.day && self.nowDate.month == self.month && self.nowDate.year == self.year) ? YES : NO;
        dateModel.canSelected = YES;
        [self.dayArray addObject:dateModel];
    }
    
}

#pragma mark - 添加最后一周中下个月的几天
- (void)appendNextMothDaysWithLastDay:(NSDate *)lastDate
{
    NSDateComponents * lastDay = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:lastDate];
    for (NSInteger i = 1; i <= (7 - lastDay.weekday); i++) {
        WKBDateModel * dateModel = [[WKBDateModel alloc] init];
        dateModel.date = @"";
        [self.dayArray addObject:dateModel];
    }
}


#pragma mark - 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section == 0 ? self.weekArray.count : self.dayArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? CGSizeMake((WIDTH-26)/7, (WIDTH-50)/7) : CGSizeMake((WIDTH-26)/7,(WIDTH-26)/7);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKBDateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:indexPath.section == 0 ? weekDayCellId : dateCellId forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        cell.cellLabel.text = self.weekArray[indexPath.row];
        cell.userInteractionEnabled = NO;
        
    }else
    {
        WKBDateModel * dateModel = self.dayArray[indexPath.row];
        cell.cellLabel.text = dateModel.date;
        cell.cellLabel.backgroundColor = dateModel.isNow ?  [UIColor cyanColor] : [UIColor clearColor];
        cell.userInteractionEnabled = dateModel.canSelected ? YES : NO;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = dateModel.canSelected ? [UIColor greenColor] : [UIColor clearColor];
        cell.selectedBackgroundView.layer.cornerRadius = CGRectGetWidth(cell.contentView.frame) / 2.0;
    }
    cell.cellLabel.textColor = (indexPath.row % 7 == 0 || indexPath.row % 7 == 6) ? [UIColor lightGrayColor] : [UIColor blackColor];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKBDateModel * dateModel = self.dayArray[indexPath.row];
    //添加第一周中上个月的几天
    if (self.selectedDateBlock)
    {
        NSDate * date = [self setDayWithYear:self.year AndMonth:self.month AndDay:dateModel.date.integerValue];
        self.selectedDateBlock(date);
    }
}

//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    return UIEdgeInsetsMake(1, 10, 0, 10);
}
//设置水平间距与竖直间距 默认为10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
    
}


@end

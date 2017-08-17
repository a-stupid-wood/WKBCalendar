//
//  ViewController.m
//  WKBCalendar
//
//  Created by zj on 2017/6/24.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "ViewController.h"
#import "WKBCalendar.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong)WKBCalendar * calendar;
@property (nonatomic, strong) UIButton * lastMonth;
@property (nonatomic, strong) UIButton * nextMonth;
@property (nonatomic, strong) UILabel * selectedDateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    
    [self createUI];;
    
}

- (void)initNavigationBar
{
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    self.lastMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lastMonth setTitle:@"上个月" forState:UIControlStateNormal];
    [self.lastMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lastMonth.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.lastMonth addTarget:self action:@selector(LastClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lastMonth.frame = CGRectMake(0, 0, 60, 40);
    [self.view addSubview:self.lastMonth];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.lastMonth];
    
    
    self.nextMonth = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextMonth setTitle:@"下个月" forState:UIControlStateNormal];
    [self.nextMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextMonth.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.nextMonth addTarget:self action:@selector(NextClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextMonth.frame = CGRectMake(0, 0, 60, 40);
    [self.view addSubview:self.nextMonth];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextMonth];
}

- (void)createUI
{
    [self initCollectionView];
    self.selectedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame), WIDTH, 50)];
    self.selectedDateLabel.textAlignment = NSTextAlignmentCenter;
    self.selectedDateLabel.textColor = [UIColor greenColor];
    [self.view addSubview:self.selectedDateLabel];
}

-(void)initCollectionView{
    
    //日历说白了就是一个CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 5.0f;
    //cell行距
    layout.minimumLineSpacing = 1.0f;
    
    self.calendar = [[WKBCalendar alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 330) collectionViewLayout:layout] ;
    [self.view addSubview:self.calendar];
    
    __weak typeof(self) weakSelf = self;
    self.calendar.selectedDateBlock = ^(NSDate *date) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];;
        NSString * dateStr = [dateFormatter stringFromDate:date];
        weakSelf.selectedDateLabel.text = dateStr;
    };
    
    self.title = [NSString stringWithFormat:@"%d年%d月",self.calendar.year,self.calendar.month];
    
}
- (void)NextClick:(UIButton *)sender {
    
    [self.calendar NextbuttonClick];
    self.title = [NSString stringWithFormat:@"%d年%d月",self.calendar.year,self.calendar.month];
}
- (void)LastClick:(UIButton *)sender {
    
    [self.calendar LastMonthClick];
    self.title = [NSString stringWithFormat:@"%d年%d月",_calendar.year,_calendar.month];
}


@end

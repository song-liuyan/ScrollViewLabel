//
//  PlatformTopView.h
//  PingAnBank
//
//  Created by 清正 on 16/3/9.
//  Copyright © 2016年 qz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ItemFoundSize 16


/*
 
 @property (nonatomic, strong) PlatformTopView *topView;
 
 self.topView = [[PlatformTopView alloc]initWithFrame:CGRectMake(<#0#>, <#0#>, <#320#>, <#50#>)];
 self.topView.defaultFontColor =[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
 self.topView.selectFontColor =[UIColor redColor];
 self.topView.lineColor =[UIColor clearColor];
 self.topView.selectIndex = <#0#>;
 self.topView.backgroundColor =[UIColor whiteColor];
 self.topView.cornerRadius =10;
 [self.topView showString:nil withDataArray:<#数据源#>];
 [self.topView didButtonClickBlock:^(UIButton *button, NSInteger index) {
 NSLog(@"点击===%ld", index);
 }];
 [self.view addSubview:self.topView];
 
 */


typedef void(^selectBtn)(UIButton *button, NSInteger index);

@interface PlatformTopView : UIScrollView

/// 选中文字颜色 (默认:蓝色 系统默认颜色)
@property(strong, nonatomic) UIColor *selectFontColor;
@property(strong, nonatomic) UIColor *defaultFontColor;
/// item 之间的距离 (默认:20.0 初始化数据源之前赋值)
@property(assign, nonatomic) CGFloat itemMinSpace;
/// 选择底部占位线颜色 (默认:蓝色 系统默认颜色)
@property(strong, nonatomic) UIColor *lineColor;
/// 选中第几个
@property(assign, nonatomic) NSInteger selectIndex;

/** 初始化数据源
 *  遍历数组中的类型 并找到指定属性对应的值
 *
 *  @param propertyName 属性名
 *  @param dataArray    数据源
 */
- (void)showString:(NSString *)propertyName withDataArray:(NSMutableArray*)dataArray;

@property(copy,nonatomic)selectBtn buttonBlock;
/// 点击标签回调
- (void)didButtonClickBlock:(selectBtn)newBlock;

@end

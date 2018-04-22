//
//  PlatformTopView.m
//  PingAnBank
//
//  Created by 清正 on 16/3/9.
//  Copyright © 2016年 qz. All rights reserved.
//

#import "PlatformTopView.h"
#import "NSString+Other.h"
#include <objc/runtime.h>

@interface PlatformTopView () {
    UIView *_lineView;
    UIButton *_oldButton;
    NSMutableArray *_offsetXArray;
}

@property(nonatomic,strong)NSMutableArray *btnArray;

@end

@implementation PlatformTopView

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_selectIndex == selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    if (selectIndex < _btnArray.count) {
        UIButton * button = _btnArray[selectIndex];
        button.userInteractionEnabled =NO;
        button.selected = YES;
        _oldButton.selected =NO;
        _oldButton.userInteractionEnabled =YES;
        _oldButton =button;
        
        NSString *btnTitle =[button titleForState:UIControlStateNormal];
        _lineView.bounds =CGRectMake(0, 0, [btnTitle stringOfSize:ItemFoundSize]+5, 2);
        _lineView.center =CGPointMake(CGRectGetWidth(button.frame)/2.0, CGRectGetHeight(button.frame)-8);
        [_oldButton addSubview:_lineView];
        
        if (self.contentSize.width <self.frame.size.width) {
            return;
        }
        CGRect rect = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);
        CGFloat float0 = button.center.x;
        CGFloat widthX = rect.size.width/2.0 + rect.origin.x;
        CGFloat float1 =widthX -float0;
        if (float0 <self.frame.size.width/2.0) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (float0 > self.contentSize.width-self.frame.size.width/2.0) {
            [self setContentOffset:CGPointMake(self.contentSize.width-self.frame.size.width, 0) animated:YES];
        } else {
            [self setContentOffset:CGPointMake(self.contentOffset.x-float1, 0) animated:YES];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArray=[NSMutableArray array];
        _offsetXArray =[NSMutableArray array];
        _itemMinSpace =20.0;
        self.selectFontColor =[UIColor colorWithRed:0.20 green:0.59 blue:0.97 alpha:1.00];
        self.lineColor =[UIColor colorWithRed:0.20 green:0.59 blue:0.97 alpha:1.00];
    }
    return self;
}
//遍历数组中的类型 并找到指定属性对应的值
- (void)showString:(NSString *)propertyName withDataArray:(NSMutableArray*)dataArray {
    NSMutableArray *dataSource = [[NSMutableArray alloc]init];
    if(dataArray.count <= 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数据源不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        id object = dataArray[0];
        //如果是字符串
        if ([object isKindOfClass:[NSString class]]) {
            dataSource =dataArray;
        } else if ([object isKindOfClass:[NSDictionary class]]) {   //如果是字典
            NSDictionary * dict = dataArray[0];
            BOOL isExit = NO;
            for (NSString * key in dict.allKeys) {
                if([key isEqualToString:propertyName]){
                    isExit = YES;
                    break;
                }
            }
            if (!isExit) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的字典没有你指定的key:%@", propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else {
                for (NSDictionary *dataDict in dataArray) {
                    [dataSource addObject:dataDict[propertyName]];
                }
            }
        } else {    //如果是对象
            NSMutableArray *props = [NSMutableArray array];
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList([object class], &outCount);
            for (i = 0; i<outCount; i++) {
                objc_property_t property = properties[i];
                const char* char_f = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_f];
                [props addObject:propertyName];
            }
            free(properties);
            BOOL isExit = NO;
            for (NSString * property in props) {
                if([property isEqualToString:propertyName]){
                    isExit = YES;
                    break;
                }
            }
            if (!isExit) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的Model没有你指定的属性:%@",propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else {
                for (id object in dataArray) {
                    NSString *tempString = [object valueForKey:propertyName];
                    [dataSource addObject:tempString?tempString:@""];
                }
            }
        }
    }
    [self reloadViewWithArray:dataSource];
}

- (void)creactViewWithArray:(NSArray*)array {
    CGFloat last_item_max_X =0.0f;
    for (NSInteger i=0; i<array.count; i++) {
        UIButton *textBtn =nil;
        if (self.btnArray.count>i) {
            textBtn =self.btnArray[i];
        } else {
            textBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:textBtn];
            [_btnArray addObject:textBtn];
        }
        CGFloat length = [_offsetXArray[i] floatValue];
        CGFloat totalLength =[_offsetXArray[i+1] floatValue];
        
        textBtn.frame =CGRectMake(length+(_itemMinSpace*i), 0, (totalLength-length)+5, self.frame.size.height);
        [textBtn setTitle:array[i] forState:UIControlStateNormal];
        textBtn.titleLabel.font =[UIFont systemFontOfSize:ItemFoundSize];
        [textBtn setTitleColor:self.defaultFontColor?self.defaultFontColor:[UIColor grayColor] forState:UIControlStateNormal];
        [textBtn setTitleColor:self.selectFontColor?self.selectFontColor:[UIColor blackColor] forState:UIControlStateSelected];
        if (i ==_selectIndex) {
            textBtn.selected =YES;
            textBtn.userInteractionEnabled =NO;
            _oldButton =textBtn;
        }
        [textBtn addTarget:self action:@selector(textButtonClock:) forControlEvents:UIControlEventTouchUpInside];
        textBtn.tag =360+i;
        last_item_max_X =CGRectGetMaxX(textBtn.frame);
    }
    if (last_item_max_X < CGRectGetWidth(self.frame)) {
        CGFloat item_width =CGRectGetWidth(self.frame)/(_btnArray.count*1.0);
        for (NSInteger i=0; i<_btnArray.count; i++) {
            UIButton *button =_btnArray[i];
            button.center =CGPointMake(item_width/2 + item_width *i, self.frame.size.height/2.0);
        }
    }
    
    if (!_lineView) {
        _lineView =[[UIView alloc]init];
    }
    _lineView.backgroundColor =self.lineColor;
    _lineView.bounds =CGRectMake(0, 0, [array[_selectIndex] stringOfSize:ItemFoundSize]+5, 2);
    _lineView.center =CGPointMake(CGRectGetWidth(_oldButton.frame)/2, CGRectGetHeight(_oldButton.frame)-8);
    [_oldButton addSubview:_lineView];
}

- (void)textButtonClock:(UIButton*)button {
    if (button.tag-360 !=self.selectIndex) {
        self.selectIndex =button.tag-360;
        if (self.buttonBlock) {
            self.buttonBlock(button, _selectIndex);
        }
    }
}
- (void)didButtonClickBlock:(selectBtn)newBlock {
    self.buttonBlock =newBlock;
}

- (void)reloadViewWithArray:(NSArray<NSString*>*)texts {
    if (texts.count ==0) {
        NSLog(@"标签数据为空!");
        return;
    }
    [_offsetXArray removeAllObjects];
    CGFloat float0 =20.0;
    [_offsetXArray insertObject:@(float0) atIndex:0];
    for (NSString *title in texts) {
        CGFloat float1 = [title stringOfSize:ItemFoundSize+0.5];
        float0 += float1;
        
        [_offsetXArray addObject:@(float0)];
    }
    self.contentSize =CGSizeMake([[_offsetXArray lastObject] floatValue]+(_itemMinSpace*(_offsetXArray.count-2))+20.0, 0);
    self.showsHorizontalScrollIndicator =NO;
    [self creactViewWithArray:texts];
}

- (void)deviceOrientationDidChange {
    self.contentSize =CGSizeMake([[_offsetXArray lastObject] floatValue]+(_itemMinSpace*(_offsetXArray.count-2))+20.0, 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

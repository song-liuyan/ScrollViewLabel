# ScrollViewLabel
iOS开发 UIScrollView封装滚动标签

### 主要功能:
优点
1.自适应标签文字大小(单个标签文字长度不建议超过屏幕宽度),
2.标签个数不限,超出屏幕可左右滚动,不够屏幕宽度平分,
3.当标签个数超出屏幕时,点击标签会自动滚动到屏幕中央,没超屏幕时,不会滚动,
4.使用简单, block 回调,

缺点
1.不支持 Auto Layout 布局,只支持 frame 布局(好像也不支持横竖屏调整),
2.底部选中标识线不支持滚动动画
### 主要代码
```
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
```
### 使用:

使用地址:https://www.jianshu.com/p/cf03c29ac645


//
//  JSSelectViewTool.m
//  JSFAddressSelect
//
//  Created by nuomi on 2017/11/21.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import "JSSelectViewTool.h"


@interface JSSelectViewTool ()
{
    NSMutableDictionary *province,*city;//省市字典
    NSMutableArray *areaArr;//
    NSString *tempProvince,*tempCity,*codeProvince,*codeCity;
    NSArray *finalProvinceArr,*finalCityArr,*finalAreaArr;
    NSString *seletedStr,*selectProvinceCode,*selectCityCode,*selectCodeStr;
    long currentRow;
}

@property (nonatomic, strong)NSMutableArray * monthArr;
@property (nonatomic, strong)NSMutableArray * currentMonthArr;
@property (nonatomic, strong)NSMutableArray * yearArr;
@property (nonatomic, copy) NSString * indexID;

@end

@implementation JSSelectViewTool

+ (JSSelectViewTool *)sharedManager {
    static JSSelectViewTool * sharedManager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedManager = [[self alloc] initWithFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 240)];
    });
    
    return sharedManager;
}


- (void)customAddressPickerView{

    [[UIApplication sharedApplication].keyWindow  addSubview:self.bgView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    [[UIApplication sharedApplication].keyWindow  addGestureRecognizer:self.tap];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    [self.topView addSubview:self.leftBtn];
    [self.topView addSubview:self.rightBtn];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.pickerView];
    [self.bottomView addSubview:self.lineView];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-240 , ScreenWidth, 240);
    } completion:^(BOOL finished) {
    }];
}

//手势
- (void)removeSelfView:(UITapGestureRecognizer *)tap{
    if (_cancelBlock) {
        self.cancelBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 240);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.bgView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:tap];
}

//确认
-(void)sureClick:(UIButton *)sender
{
    if (sender.tag==1000) {
        if (self.selectType == CurrentUseAddress) {
            NSString *pro =[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0];
            NSString *cit =[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1];
            NSString *are = [self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:2] forComponent:2];
            if ([pro isEqualToString:cit]) {
                seletedStr =[NSString stringWithFormat:@"%@ %@",pro,are];
            } else {
               seletedStr =[NSString stringWithFormat:@"%@ %@ %@",pro,isEmpytLabelOrField(cit),isEmpytLabelOrField(are)];
            }
            NSArray * keyArr = [province allKeys];
            for (NSString * keyStr in keyArr) {
                if ([[NSString stringWithFormat:@"%@Code",pro] isEqualToString:keyStr]) {
                    selectProvinceCode = [province objectForKey:keyStr];
                    NSDictionary * cityDict = [province objectForKey:pro];
                    NSArray * cityArr = [cityDict allKeys];
                    if (cityArr.count>0) {
                        for (NSString * cityKey in cityArr) {
                            if ([[NSString stringWithFormat:@"%@Code",cit] isEqualToString:cityKey]) {
                                selectCityCode = [cityDict objectForKey:cityKey];
                            }
                        }
                    }
                }
            }
            
            if (finalAreaArr.count>0) {
                for (NSInteger i=0; i<finalAreaArr.count; i++) {
                    NSString * str = finalAreaArr[i];
                    if ([str isEqualToString:are]) {
                        selectCodeStr = finalAreaArr[i+1];
                    }
                    
                }
            }
            if (self.myBlock) {
                if ([seletedStr isEqualToString:@"澳门特别行政区  "]||[seletedStr isEqualToString:@"香港特别行政区  "]||[seletedStr isEqualToString:@"台湾省  "]) {
                    self.myBlock(seletedStr,selectProvinceCode);
                } else {
                    self.myBlock(seletedStr,isEmpytLabelOrField(selectCodeStr));
                }
                
            }
            
            if (self.codeBlock) {
                self.codeBlock(seletedStr, selectProvinceCode, isEmpytLabelOrField(selectCityCode), isEmpytLabelOrField(selectCodeStr));
            }
            
        } else if(self.selectType == CurrentUseSingle){
            if (_callBackBlock) {
                if (self.dataArray.count > 0&&self.dataArray.count>currentRow) {
                    _callBackBlock(self.dataArray[currentRow],currentRow);
                }
            }
        }else{
            NSString *yearStr =[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1];
            NSString *monthStr =[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0];
            NSString *deleteYear = [yearStr stringByReplacingOccurrencesOfString:@" 年" withString:@""];
            NSString * year = [deleteYear substringFromIndex:deleteYear.length-2 ];
            NSString *month = [monthStr stringByReplacingOccurrencesOfString:@" 月" withString:@""];
            if ([month integerValue]<10) {
                month = [NSString stringWithFormat:@"0%@",month];
            }
            if (self.dateBlock) {
                self.dateBlock(month,year);
            }
        }
    }
    if (_cancelBlock) {
        self.cancelBlock();
    }
    [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tap];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 240);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.bgView removeFromSuperview];
}

- (void)getCityFromPickerView:(CityBlock)block
{
    [self.pickerView selectRow: 0 inComponent:0 animated:NO];
    self.selectType = CurrentUseAddress;
    [self getInitData];
    [self customAddressPickerView];
    self.myBlock = block;
    [self.pickerView reloadAllComponents];
}

- (void)getCityAndCodeFromPickerView:(CityCodeBlock)block
{
    [self.pickerView selectRow: 0 inComponent:0 animated:NO];
    self.selectType = CurrentUseAddress;
    [self getInitData];
    [self customAddressPickerView];
    self.codeBlock = block;
    [self.pickerView reloadAllComponents];
}


-(void)getInitData
{
    NSString *xmlFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"districts_bak" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:xmlFilePath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    NSArray * keyArr = [province allKeys];
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * keyStr in keyArr) {
        if ([keyStr rangeOfString:@"Code"].location == NSNotFound) {
            [array addObject:keyStr];
        }
    }
    [array removeObject:@"浙江省"];
    [array removeObject:@"广东省"];
    [array removeObject:@"山东省"];
    [array insertObject:@"浙江省" atIndex:0];
    [array insertObject:@"广东省" atIndex:1];
    [array insertObject:@"山东省" atIndex:2];
    finalProvinceArr = [NSArray arrayWithArray:array];
    if (finalProvinceArr.count>0) {
        NSDictionary *tempCityDic = [province objectForKey:[finalProvinceArr objectAtIndex:0]];
        NSArray * cityKeyArr = [tempCityDic allKeys];
        NSMutableArray * arr = [NSMutableArray array];
        for (NSString * keyStr in cityKeyArr) {
            if ([keyStr rangeOfString:@"Code"].location == NSNotFound) {
                [arr addObject:keyStr];
            }
        }
        if ([arr containsObject:@"金华市"]) {
            [arr removeObject:@"金华市"];
            [arr insertObject:@"金华市" atIndex:0];
        }
        
        if ([arr containsObject:@"青岛市"]) {
            [arr removeObject:@"青岛市"];
            [arr insertObject:@"青岛市" atIndex:0];
        }
        
        if ([arr containsObject:@"广州市"]) {
            [arr removeObject:@"广州市"];
            [arr insertObject:@"广州市" atIndex:0];
        }
        finalCityArr = [NSArray arrayWithArray:arr];
        NSMutableArray * areaArray = [NSMutableArray array];
        areaArray = [tempCityDic objectForKey:[finalCityArr objectAtIndex:0]];
        if ([areaArray containsObject:@"义乌市"]) {
            NSInteger index = [areaArray indexOfObject:@"义乌市"];
            NSString * str = areaArray[index];
            NSString * str1 = areaArray[index+1];
            [areaArray removeObject:str];
            [areaArray insertObject:str atIndex:0];
            [areaArray removeObject:str1];
            [areaArray insertObject:str1 atIndex:1];
        }
        finalAreaArr = [NSArray arrayWithArray:areaArray];
    }
    
}

-(void)inpour:(NSMutableArray *)dataArray currentIndexd:(NSInteger)currentIndex confirmBlock:(void(^)(id obj,NSInteger currentIndex))confirmBlock cancelBlock:(void(^)(void))cancelBlock
{
    self.selectType = CurrentUseSingle;
    [self customAddressPickerView];
    self.callBackBlock = confirmBlock;
    self.cancelBlock = cancelBlock;
    self.dataArray = dataArray;
    currentRow = currentIndex;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:currentIndex inComponent:0 animated:NO];
}


- (void)getdateFromPickerView:(DateBlock)block
{
    self.selectType = CurrentUseMonthAndDay;
    [self selectBankDate];
    [self customAddressPickerView];
    self.dateBlock = block;
    [self.pickerView reloadAllComponents];
}

- (void)selectBankDate
{
    self.indexID = @"indexFrist";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY"];
    NSInteger dateTime = [[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger monthTime = [[formatter stringFromDate:date] integerValue];
    self.monthArr = [NSMutableArray array];
    self.currentMonthArr = [NSMutableArray array];
    self.yearArr = [NSMutableArray array];
    for ( NSInteger i=0; i<12; i++) {
        [self.monthArr addObject:[NSString stringWithFormat:@"%ld 月",i+1]];
    }
    for ( NSInteger i=0; i<13-monthTime; i++) {
        [self.currentMonthArr addObject:[NSString stringWithFormat:@"%ld 月",i+monthTime]];
    }
    for ( NSInteger i=0; i<30; i++) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%ld 年",dateTime+i]];
    }
}

# pragma mark - xml解析代理
//开始解析的代理方法
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    province = [NSMutableDictionary new];
    city = [NSMutableDictionary new];
}

//开始解析某个节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"province"]) {
        tempProvince = [attributeDict objectForKey:@"name"];
        codeProvince = [attributeDict objectForKey:@"zipcode"];
    }
    if ([elementName isEqualToString:@"city"]) {
        tempCity = [attributeDict objectForKey:@"name"];
        codeCity = [attributeDict objectForKey:@"zipcode"];
        areaArr = [NSMutableArray new];
    }else if ([elementName isEqualToString:@"district"]) {
        [areaArr addObject:[attributeDict objectForKey:@"name"]];
        [areaArr addObject:[attributeDict objectForKey:@"zipcode"]];
    }
}

//获取节点之间的值
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}

//某个节点结束取值
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"city"]) {
        NSMutableArray *temp =[[NSMutableArray alloc] initWithArray:areaArr];
        [city setValue:temp forKey:tempCity];
        [city setValue:codeCity forKey:[NSString stringWithFormat:@"%@Code",tempCity]];
        [areaArr removeAllObjects];
    }else if ([elementName isEqualToString:@"province"]) {
        NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:city];
        [province setValue:tempDic forKey:tempProvince];
        [province setValue:codeProvince forKey:[NSString stringWithFormat:@"%@Code",tempProvince]];
        [city removeAllObjects];
    }
    
    
}

//结束解析
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析结果-------%@",finalProvinceArr);
}

-(void)parser:(NSXMLParser* )parser parseErrorOccurred:(NSError* )parseError {
    NSLog(@"解析出现错误-------%@",parseError.description);
}

#pragma mark-----------UIPickerViewDataSource的方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.selectType == CurrentUseAddress) {
        return 3;
    } else if (self.selectType == CurrentUseSingle) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.selectType == CurrentUseAddress) {
        if(component==0) {
            return [finalProvinceArr count];
        }else if (component==1) {
            return [finalCityArr count];
        }else {
            return [finalAreaArr count]/2;
        }
    } else if (self.selectType == CurrentUseSingle){
        return self.dataArray.count;
    } else {
        if(component==1) {
            return [self.yearArr count];
        }else {
            if ([self.indexID isEqualToString:@"indexFrist"]) {
                return self.currentMonthArr.count;
            }else{
                return [self.monthArr count];
            }
        }
    }
    
}

#pragma mark--------UIPickerViewDelegate的方法------

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.selectType == CurrentUseAddress) {
        if (component==0) {
            return finalProvinceArr[row];
        }else if (component==1) {
            if (finalCityArr.count>0) {
                return finalCityArr[row];
            }
        }else{
            if (finalAreaArr.count>0) {
                return finalAreaArr[row*2];
            }
        }
    } else  if (self.selectType == CurrentUseSingle){
        //数组越界判断
        if (self.dataArray.count == 0 || self.dataArray.count==row || self.dataArray.count<row) {
            return @"";
        }
        if ([self.dataArray[row] isKindOfClass:[NSString class]]) {
          return self.dataArray[row];
        }else{
            return @"";
        }
        
    }else{
        if (component==1) {
            return self.yearArr[row];
        }else{
            if ([self.indexID isEqualToString:@"indexFrist"]) {
                return self.currentMonthArr[row];
            }else{
                return self.monthArr[row];
            }
            
        }
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)
        {
            speartorView.layer.borderWidth = 1.f;
            speartorView.layer.borderColor = kUIColorFromRGB(0xebe8e8).CGColor;
            speartorView.backgroundColor = kUIColorFromRGB(0xebe8e8);
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            pickerLabel.textAlignment = NSTextAlignmentCenter;
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        }
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.selectType == CurrentUseAddress) {
        if (component==0) {
            NSArray * cityKeyArr = [[province objectForKey:[finalProvinceArr objectAtIndex:row]] allKeys];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSString * keyStr in cityKeyArr) {
                if ([keyStr rangeOfString:@"Code"].location == NSNotFound) {
                    [arr addObject:keyStr];
                }
            }
            if ([arr containsObject:@"金华市"]) {
                [arr removeObject:@"金华市"];
                [arr insertObject:@"金华市" atIndex:0];
            }
            
            if ([arr containsObject:@"青岛市"]) {
                [arr removeObject:@"青岛市"];
                [arr insertObject:@"青岛市" atIndex:0];
            }
            
            if ([arr containsObject:@"广州市"]) {
                [arr removeObject:@"广州市"];
                [arr insertObject:@"广州市" atIndex:0];
            }
            finalCityArr = [NSArray arrayWithArray:arr];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            
            if ([finalCityArr count]!=0) {
                NSString *selectedProvince = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
                NSString *selectedCity = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:1] forComponent:1];
                finalAreaArr = [[province objectForKey:selectedProvince] objectForKey:selectedCity];
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:2];
            }else{
                finalAreaArr = nil;
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:2];
            }
        }else if (component==1) {
            NSString *selectedProvince = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
            NSString *selectedCity = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:1] forComponent:1];
            NSMutableArray * areaArray = [NSMutableArray array];
            areaArray = [[province objectForKey:selectedProvince] objectForKey:selectedCity];
            if ([areaArray containsObject:@"义乌市"]) {
                NSInteger index = [areaArray indexOfObject:@"义乌市"];
                NSString * str = areaArray[index];
                NSString * str1 = areaArray[index+1];
                [areaArray removeObject:str];
                [areaArray insertObject:str atIndex:0];
                [areaArray removeObject:str1];
                [areaArray insertObject:str1 atIndex:1];
            }
            finalAreaArr = [NSArray arrayWithArray:areaArray];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
    } else   if (self.selectType == CurrentUseSingle){
        currentRow = row;
    } else {
        if (component==1) {
            if (row==0) {
                self.indexID = @"indexFrist";
            } else {
                self.indexID = @"other";
            }
            [pickerView selectRow:0 inComponent:0 animated:NO];
            [pickerView reloadComponent:0];
        }
    }
    
}


# pragma mark - lazy-----

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
    }
    return _bgView;
}

-(UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfView:)];
    }
    return _tap;
}

-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.cornerRadius = 10;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

-(UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(12.5, 5, 60, 30);
        [_leftBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = FontTextNormal;
        [_leftBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(ScreenWidth - 72.5, 5, 60, 30);
        [_rightBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = FontTextNormal;
        [_rightBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag = 1000;
    }
    return _rightBtn;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _lineView.backgroundColor = kUIColorFromRGB(0xebe8e8);
    }
    return _lineView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, self.frame.size.height-40)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

@end

//
//  VDSCEntitlementServices.m
//  iPadDragon
//
//  Created by Lion User on 04/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCEntitlementServices.h"
#import "OCCalendarViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCOnlineCashTransferViewController.h"
#import "VDSCOTPView.h"
#import "VDSCPush2DateListViewController.h"


@implementation VDSCEntitlementServices{
    VDSCCommonUtils *utils;
    OCCalendarViewController *calVC;
    UIWebView *loading;
    NSMutableArray *array;
    NSMutableArray *array_statusList;
    VDSCOTPView *otp;
    NSDate *fdate;
    NSDate *tdate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    @try{
        [super awakeFromNib];
        array = [[NSMutableArray alloc] init];
        array_statusList = [[NSMutableArray alloc] init];
        utils =[[VDSCCommonUtils alloc]init];
        self.tableList.delegate=self;
        self.tableList.dataSource=self;
        
        [self initControls];
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    
}
-(void) initControls
{
    otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp.frame = CGRectMake(-10, 0, 360, 30);
    [self.otpView addSubview:otp];
    [self registerForKeyboardNotifications];
    
    NSDate *startDate = [NSDate date];
    self.txtTuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
    self.txtDenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
    
    fdate = tdate=[startDate copy];
    
    [self performSelectorInBackground:@selector(loadEntitlementHistory) withObject:nil];
    
}

-(void)loadEntitlementHistory
{
    NSArray *arr ;
    NSDictionary *allDataDictionary;
    @try {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"entitlementHistory"]];
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_FROMDATE", self.txtTuNgay.text
               , @"KW_TODATE", self.txtDenNgay.text
               , nil];
        NSString *post = [utils postValueBuilder:arr];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        [array removeAllObjects];
        [array_statusList removeAllObjects];
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            NSArray *
            data=[allDataDictionary objectForKey:@"statusList"];
            
            if(![data isEqual:[NSNull null]]){
                for(NSArray *item in data){
                    [array_statusList addObject:item];
                }
            }
            
            data=[allDataDictionary objectForKey:@"list"];
            if(![data isEqual:[NSNull null]]){
                for(NSArray *item in data){
                    VDSCEntitlementEntity *entity = [[VDSCEntitlementEntity alloc] init];
                    entity.startRegDate = [item objectAtIndex:0];
                    entity.stockId = [item objectAtIndex:1];
                    entity.buyPrice = [[item objectAtIndex:2] floatValue];
                    entity.remainQty = [[item objectAtIndex:3] integerValue];
                    entity.amount = [[item objectAtIndex:4] doubleValue];
                    entity.status = [self getStatus:[item objectAtIndex:5]];
                    entity.note = [item objectAtIndex:6];
                    
                    [array addObject:entity];
                    [entity release];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading = nil;
        }
        
        [self.tableList reloadData];
        
        [arr release];
        [allDataDictionary release];
    }
    
}

-(NSString *)getStatus:(NSString*)status
{
    for(NSArray *arr in array_statusList)
        if([[arr objectAtIndex:0] isEqualToString:status])
            return [arr objectAtIndex:1];
    
    return status;
}

- (IBAction)btn_TuNgay_touch:(id)sender {
    if(calVC ==nil){
        CGPoint insertPoint = ((UIButton*)sender).frame.origin;
        insertPoint.y = 350;
        calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
        calVC.delegate = self;
        calVC.sender = sender;
        
        [calVC setStartDate:fdate];
        [calVC setEndDate:fdate];
        
        [self addSubview:calVC.view];
    }
    
}

- (IBAction)btn_DenNgay_touch:(id)sender {
    if(calVC ==nil){
        CGPoint insertPoint = ((UIButton*)sender).frame.origin;
        insertPoint.y = 350;
        calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
        calVC.delegate = self;
        calVC.sender = sender;
        
        [calVC setStartDate:tdate];
        [calVC setEndDate:tdate];
        
        [self addSubview:calVC.view];
    }
}



- (void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if(((UIButton*)calVC.sender).tag==0)
    {
        self.txtTuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = [startDate copy];
    }
    else
    {
        self.txtDenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        tdate=[startDate copy];
    }
    [calVC.view removeFromSuperview];
    
    calVC.delegate = nil;
    [calVC release];
    calVC = nil;
    
}
-(void) completedWithNoSelection{
    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
    [calVC release];
    calVC= nil;
}
- (void)dealloc {
    [_btn_DenNgay release];
    [_txtDenNgay release];
    [_btn_TuNgay release];
    [_txtTuNgay release];
    [_btn_MaCK release];
    [_tableList release];
    [_f_stockName release];
    [_f_endDate release];
    //[_f_startRegDate release];
    [_f_endRegDate release];
    [_f_ratio release];
    [_f_currQty release];
    [_f_buyPrice release];
    [_f_roomQty release];
    [_f_remainQty release];
    [_txt_regQty release];
    [_f_amount release];
    [_otpView release];
    [otp release];
    //[self unregisterForKeyboardNotifications];
    [super dealloc];
}

- (IBAction)btn_MaCK_touch:(id)sender {
    VDSCPush2DateListViewController *popover_push2DateList =  [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_push2DateList.delegate=self;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=((UIButton*)sender).frame;//CGRectMake(((UIButton*)sender).frame.origin.x, ((UIButton*)sender).frame.origin.y+35, 50, 30);
    [self.popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
-(void)setData2Controls
{
    [self.btn_MaCK setTitle:self.entitlementEntity.stockId forState:UIControlStateNormal];
    self.f_stockName.text = self.entitlementEntity.stockName;
    self.f_endDate.text = self.entitlementEntity.endDate;
    //self.f_startRegDate.text = self.entitlementEntity.startRegDate;
    self.f_endRegDate.text = [NSString stringWithFormat:@"%@ - %@",self.entitlementEntity.startRegDate, self.entitlementEntity.lastRegDate];
    self.f_ratio.text = self.entitlementEntity.ratio;
    self.f_currQty.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.entitlementEntity.currQty]];
    self.f_buyPrice.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithFloat:self.entitlementEntity.buyPrice]];
    self.f_roomQty.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.entitlementEntity.roomQty]];
    self.f_remainQty.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.entitlementEntity.remainQty]];
    self.txt_regQty.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.entitlementEntity.remainQty]];
    
    double d = [[self.f_buyPrice.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    self.f_amount.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d*self.entitlementEntity.remainQty]];
}

- (IBAction)txt_regQty_change:(id)sender {
    [self calAmount];
}
- (IBAction)btn_confirm_touch:(id)sender {
    if([self checkInput])
    {
        NSArray *arr ;
        NSDictionary *allDataDictionary;
        @try {
            int d = [[self.txt_regQty.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            
            NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"entitlement"]];
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_ENTITLEMENT_STOCKID", self.entitlementEntity.entitlementStock
                   , @"KW_MARKETID", self.entitlementEntity.marketId
                   , @"KW_ENTITLEMENT_ID", self.entitlementEntity.entitlementId
                   , @"KW_ENTITLEMENT_LOCATIONID", self.entitlementEntity.locationId
                   , @"KW_ENTITLEMENT_QUANTITY", [NSString stringWithFormat:@"%d", d]
                   , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                   , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                   , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                   , nil];
            NSString *post = [utils postValueBuilder:arr];
            allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.entitlement.buySuccess"] messageContent:nil dismissAfter:1];
                [self resetInput];
                [self loadEntitlementHistory];
            }
            else{
                [utils showMessage:@"Đăng ký không mua thành công." messageContent:[allDataDictionary objectForKey:@"errCode"]];
            }
        }
        @catch (NSException *exception) {
            NSLog(exception.description);
        }
        @finally {
            [arr release];
            [allDataDictionary release];
        }
    }
}
-(double)LoadCash
{
    NSString *post = [NSString stringWithFormat:@"info=KW_WS_EXECPWD:::%@@@@KW_CLIENTSECRET:::%@@@@KW_CLIENTID:::%@@@@KW_ACCOUNTTYPE:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],utils.clientInfo.secret,utils.clientInfo.clientID, utils.clientInfo.accountType];
    
    NSString *url =[[NSUserDefaults standardUserDefaults]stringForKey:@"clientCashInfo"];
    NSDictionary *dic = [utils getDataFromUrl:url method:@"POST" postData:post];
    bool success = [[dic objectForKey:@"success"] boolValue];
    //------------------------------------------------
    
    if(success)
    {
        return [[dic objectForKey:@"DrawableBal"] doubleValue];
    }
    return 0;
}
-(BOOL)checkInput
{
    NSString *message=@"";
    double d = [[self.txt_regQty.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    double amount = [[self.f_amount.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    if([self.btn_MaCK.titleLabel.text isEqualToString:@""])
    {
        message=[utils.dic_language objectForKey:@"ipad.services.entitlement.selectStock"];
    }
    else if(d<=0||d>self.entitlementEntity.remainQty)
    {
        message=[utils.dic_language objectForKey:@"ipad.services.entitlement.worngQty"];
    }
    else{
        if(amount>[self LoadCash])
        {
            message=[utils.dic_language objectForKey:@"ipad.services.entitlement.notEnoughBalance"];
        }
        else
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"saveOTP"])
            {
                if([otp checkInput]){
                    BOOL result = [utils otpCherker:otp.otp_number1.text OTPPosition2:otp.otp_number2.text OTPPosition1_Value:otp.otp_number1Value.text OTPPosition2_value:otp.otp_number2Value.text isSave:NO];
                    if(!result)
                    {
                        message=[utils.dic_language objectForKey:@"ipad.otp.saveFail"] ;
                    }
                }
                else return NO;
            }
    }
    if(message.length>0)
        [ utils showMessage:message messageContent:nil];
    
    return message.length==0;
}

- (IBAction)btn_cancel_touch:(id)sender {
    [self resetInput];
}

- (IBAction)btn_refresh_touch:(id)sender {
    if(loading==nil && [self checkDate])
    {
        loading = [utils showLoading:self.tableList];
        [self performSelectorInBackground:@selector(loadEntitlementHistory) withObject:nil];
    }
}
-(BOOL) checkDate{
    NSString *start = self.txtTuNgay.text;
    NSString *end = self.txtDenNgay.text;
    
    
    NSDate *startDate = [utils.shortDateFormater dateFromString:start];
    NSDate *endDate = [utils.shortDateFormater dateFromString:end];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:(NSDayCalendarUnit|NSMonthCalendarUnit)
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    [gregorianCalendar release];
    if(components.month>3 || (components.month==3 && components.day>0))
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.common.max3MonthQuery"] messageContent:nil dismissAfter:1];
        return NO;
    }
    return YES;
}
-(void)resetInput
{
    self.txt_regQty.text=@"0";
    self.f_amount.text=self.f_buyPrice.text=self.f_currQty.text=self.f_endDate.text=self.f_endRegDate.text=self.f_ratio.text=self.f_remainQty.text=self.f_roomQty.text=self.f_startRegDate.text=self.f_stockName.text=@"";
    [self.btn_MaCK setTitle:@"" forState:UIControlStateNormal];
    [otp resetOtpPosition];
}
-(void) calAmount
{
    double price = [[self.f_buyPrice.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double d = [[[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[self.txt_regQty.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.f_amount.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:price*d]];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_regQty resignFirstResponder];
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
    
    double d = [[self.txt_regQty.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.txt_regQty.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    UIView *bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bg_view.backgroundColor= [UIColor darkGrayColor];
    cell.backgroundView = bg_view;
    //}
    NSInteger i=indexPath.row;
    VDSCEntitlementEntity *item = [array objectAtIndex:i];
    UIColor *color = [UIColor lightGrayColor];
    
    int x=0;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 113, utils.rowHeight-1);
    label.text = item.startRegDate;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=10;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 95, utils.rowHeight-1);
    label.text = item.stockId;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 104, utils.rowHeight-1);
    label.text = [utils.numberFormatter stringFromNumber:[NSNumber numberWithInt: item.remainQty]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 58, utils.rowHeight-1);
    label.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.buyPrice]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 132, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.amount]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 120, utils.rowHeight-1);
    label.text = item.status;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 352, utils.rowHeight-1);
    label.text = item.note;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:13];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    return cell;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    //if(fieldMaBaoVe.editing)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    //[self bringSubviewToFront:self];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y-50, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    //[self bringSubviewToFront:self.view_confirm];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y+50, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}
@end

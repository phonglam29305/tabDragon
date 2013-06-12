//
//  VDSCCashTranferServices.m
//  iPadDragon
//
//  Created by Lion User on 02/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCCashTranferServices.h"
#import "VDSCEntitlementServices.h"
#import "VDSCCommonUtils.h"
#import "HMSegmentedControl.h"
#import "VDSCCashTranferServicesCell.h"
#import "VDSCMarginTransServices.h"
#import "VDSCOrderConfirmServices.h"
#import "OCCalendarViewController.h"
#import "VDSCListCashTranfer_VC.h"
#import "VDSCOnlineCashTransferViewController.h"
#import "VDSCOTPView.h"
#import "VDSCOjectCashTransfer.h"
#import "VDSCCashTranferServicesCell.h"
#import "RadioButton.h"
#import "ASIFormDataRequest.h"
#import "VDSCMainViewController.h"



@interface VDSCCashTranferServices(){
    UILabel *toolTipLabel;
    VDSCCommonUtils *utils;
    VDSCEntitlementServices *Entitlement;
    VDSCMarginTransServices *MarginTrans;
    VDSCOrderConfirmServices *OrderConfirm;
    OCCalendarViewController *CalendarView;
    VDSCOTPView *otp;
    NSMutableArray *array_ObjectCashTranfer;
    UIWebView *loading;
    double TongTienCoTheChuyen;
    
    NSTimer *timer;
    int currentTab;
    
    NSDate *fdate;
    NSDate *tdate;
    
    RadioButton *rb1;
    NSOperationQueue *queue;
}

@end
@implementation VDSCCashTranferServices


@synthesize  tab=_tab;
@synthesize tabDetailCashTranfer=_tabDetailCashTranfer;
@synthesize txtTienCoTheChuyen=_txtTienCoTheChuyen;
@synthesize popover;
@synthesize segmentedControl;


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
    @try {
        [super awakeFromNib];
        //utils =((VDSCMainViewController*) self.delegate).utils;//[[VDSCCommonUtils alloc]init];
        utils =[[VDSCCommonUtils alloc]init];
        NSDate *startDate = [NSDate date];
        self.txt_TuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        self.txt_DenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = tdate=[startDate copy];
        [self initControls];
        [self registerForKeyboardNotifications];
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    
}
-(void) initControls
{
    @try {
        //tab: tao mot tab ngang co nhieu tab con
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"    Chuyển tiền    ", @" Giao dịch ký quỹ ", @"  Thực hiện quyền  ",@"   Ký phiếu lệnh   "]];
        [segmentedControl setFrame:CGRectMake(0, 0, 560, 30)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl setTag:1];
        segmentedControl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]];
        segmentedControl.textColor = [UIColor whiteColor];
        segmentedControl.font = [UIFont fontWithName:@"Arial" size:15];
        
        [[self tab] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]]];
        [self.tab addSubview:segmentedControl];
        //-----------------
        [self.tabDetailCashTranfer setDelegate:self];
        [self.tabDetailCashTranfer setDataSource:self];
        
        
        otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
        otp.frame = CGRectMake(-10, 0, 360, 30);
        [self.viewOTP addSubview:otp];
        
        array_ObjectCashTranfer = [[NSMutableArray alloc]init];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        [timer fire];
        
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    
}
-(void)loadData
{
    [self LoadCash];
    [self LoadHistoryCashTransfer];
}

- (IBAction)grabURLInTheBackground:(ASIFormDataRequest *)request
{
    if (!queue) {
        [queue=[NSOperationQueue alloc] init];
    }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [queue addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(ASIFormDataRequest *)request
{
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            //------------------------------------------------
            
            if(success)
            {
                //1
                
                self.txtMaTK.text=[NSString stringWithFormat:@"033%@", utils.clientInfo.clientID];
                self.txtTenTaiKhoan.text=utils.clientInfo.clientName;
                self.txtTienCoTheChuyen.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"DrawableBal"]];
                TongTienCoTheChuyen=[[allDataDictionary objectForKey:@"DrawableBal"] doubleValue];
                
                self.txtTienMatThucCo.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"realCash"] doubleValue]]];
            }
        }
        else if(request.tag==200)
        {
            [array_ObjectCashTranfer removeAllObjects];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                VDSCOjectCashTransfer *Object = nil;
                NSArray *data = [allDataDictionary objectForKey:@"list"];
                if(![data isEqual:[NSNull null]])
                    //  for (NSDictionary *item in [allDataDictionary objectForKey:@"list"])
                    for (NSArray *arrayOfEntity in data)
                    {
                        Object = [[VDSCOjectCashTransfer alloc] init];
                        Object.fGhiChu = [NSString stringWithFormat:@"%@", [arrayOfEntity objectAtIndex:5]];
                        Object.fNgayGiaoDich=[NSString stringWithFormat:@"%@", [arrayOfEntity objectAtIndex:0]] ;
                        if( [[arrayOfEntity objectAtIndex:3] isEqual:@"FROM"])
                        {
                            Object.fNguoiTraPhi=@"Người chuyển";
                        }
                        if( [[arrayOfEntity objectAtIndex:3] isEqual:@"DEST"])
                        {
                            Object.fNguoiTraPhi=@"Người nhận";
                        }
                        Object.fNgayXacNhan=[arrayOfEntity objectAtIndex:9];
                        double Phi;
                        Phi=[[arrayOfEntity objectAtIndex:2]doubleValue];
                        Object.fPhiChuyenKhoan=[[arrayOfEntity objectAtIndex:2]doubleValue];
                        Object.fSoTien=[[arrayOfEntity objectAtIndex:1]doubleValue];
                        Object.fTaiKhoan=[NSString stringWithFormat:@"%@", [arrayOfEntity objectAtIndex:7]];
                        if([[arrayOfEntity objectAtIndex:4]isEqual:@"A"])
                        {
                            Object.fTrangThai=@"Thành công";
                        }
                        if([[arrayOfEntity objectAtIndex:4]isEqual:@"P"])
                        {
                            Object.fTrangThai=@"Chờ xử lý";
                        }
                        [array_ObjectCashTranfer addObject:Object];
                        [Object release];
                    }
                
            }
            [self.tabDetailCashTranfer reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
          [allDataDictionary release];
    }
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}




-(void)LoadCash
{
    NSArray *arr;
    @try {
        
        
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
               , nil];
        NSString *post = [utils postValueBuilder:arr];
        NSString *urlStr =[[NSUserDefaults standardUserDefaults]stringForKey:@"clientCashInfo"];
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=100;
        
        [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(arr !=nil)
          [arr release];
    }
}
// -- su kien sau khi thay doi cac tab con cua tab cha
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    @try{
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        //[MarginTrans unregisterForKeyboardNotifications];
        [self unregisterForKeyboardNotifications];
        [Entitlement unregisterForKeyboardNotifications];
        [OrderConfirm unregisterForKeyboardNotifications];
        switch (segmentedControl.selectedIndex) {
                
            case 1:
                if(![utils.clientInfo.accountType isEqualToString:@"M"])
                {
                    [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.common.marginOnly"] messageContent:nil];
                    segmentedControl.selectedIndex=currentTab;
                    return;
                }
                if(MarginTrans==nil)
                {
                    MarginTrans = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarginTransServices" owner:self options:nil] objectAtIndex:0];
                    MarginTrans.frame = CGRectMake(0, 30, width, height-30);
                    //  Entitlement.backgroundColor=[UIColor blackColor];
                    [self addSubview:MarginTrans];
                }
                //[MarginTrans registerForKeyboardNotifications];
                ((VDSCMainViewController*)self.delegate).activeView = MarginTrans;
                [self bringSubviewToFront:MarginTrans];
                [MarginTrans setHidden:NO];
                break;
            case 2:
                if(Entitlement==nil)
                {
                    Entitlement = [[[NSBundle mainBundle] loadNibNamed:@"VDSCEntitlementServices" owner:self options:nil] objectAtIndex:0];
                    Entitlement.frame = CGRectMake(0, 30, width, height-30);
                    //  Entitlement.backgroundColor=[UIColor blackColor];
                    [self addSubview:Entitlement];
                }
                [Entitlement registerForKeyboardNotifications];
                ((VDSCMainViewController*)self.delegate).activeView = self;
                [self bringSubviewToFront:Entitlement];
                [Entitlement setHidden:NO];
                
                break;
            case 3:
                if(OrderConfirm ==nil)
                {
                    OrderConfirm=[[[NSBundle mainBundle] loadNibNamed:@"VDSCOrderConfirmServices"  owner:self options:nil] objectAtIndex:0];
                    OrderConfirm.frame=CGRectMake(0, 30, width, height-30);
                    [self addSubview:OrderConfirm];
                }
                [OrderConfirm registerForKeyboardNotifications];
                ((VDSCMainViewController*)self.delegate).activeView = self;
                [self bringSubviewToFront:OrderConfirm];
                [OrderConfirm setHidden:NO];
                break;
            default:
                if(Entitlement!=nil)
                    [Entitlement setHidden:YES];
                if(OrderConfirm!=nil)
                    [OrderConfirm setHidden:YES];
                if(MarginTrans!=nil)
                    [MarginTrans setHidden:YES];
                
                [self registerForKeyboardNotifications];
                break;
        }
        
        currentTab = segmentedControl.selectedIndex;
    }
    @catch (NSException *exception) {
        NSLog([NSString stringWithFormat:@"%@", exception.description]);
    }
}

- (void)dealloc {
    
    [timer invalidate];
    timer = nil;
    
    [_tab release];
    [_txt_TuNgay release];
    [_txt_DenNgay release];
    [_btn_DenNgay release];
    [_btn_TuNgay release];
    //[_cb_TaiKhoanNhan release];
    [_txtMaTK release];
    [_txtTenTaiKhoan release];
    [_txtTienCoTheChuyen release];
    [_txtTienMatThucCo release];
    [_txtMucPhiChuyenKhoan release];
    [_txtSoTienChuyen release];
    [_txtChuTaiKhoan release];
    [_txtNganHang release];
    [_txtNoiDungChuyen release];
    [_btn_taikhoannhan release];
    [_segNguoiTraPhi release];
    [_viewOTP release];
    [queue release];
    
    [self unregisterForKeyboardNotifications];
    [super dealloc];
}

- (IBAction)btn_TuNgay_touch:(id)sender {
    CGPoint insertPoint = self.btn_TuNgay.bounds.origin;
    
    insertPoint.x = insertPoint.x+300;
    insertPoint.y = insertPoint.y+380;
    
    CalendarView = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
    CalendarView.delegate = self;
    CalendarView.sender = sender;
    
    [CalendarView setStartDate:fdate];
    [CalendarView setEndDate:fdate];
    
    [self addSubview:CalendarView.view];}

- (IBAction)btn_DenNgay_touch:(id)sender {
    //  [self.txt_ma resignFirstResponder];
    CGPoint insertPoint = self.btn_DenNgay.bounds.origin;
    insertPoint.x = insertPoint.x+530;
    insertPoint.y = insertPoint.y+380;
    
    
    CalendarView = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
    CalendarView.delegate = self;
    CalendarView.sender = sender;
    
    [CalendarView setStartDate:tdate];
    [CalendarView setEndDate:tdate];
    
    [self addSubview:CalendarView.view];
}


- (void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    if(((UIButton*)CalendarView.sender).tag==0)
    {
        self.txt_TuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = [startDate copy];
    }
    else
    {
        self.txt_DenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        tdate=[startDate copy];
    }
    [CalendarView.view removeFromSuperview];
    
    CalendarView.delegate = nil;
    [CalendarView release];
    CalendarView = nil;
    
}
-(void) completedWithNoSelection{
    [CalendarView.view removeFromSuperview];
    CalendarView.delegate = nil;
    [CalendarView release];
    CalendarView = nil;
}
- (IBAction)btn_TaiKhoanNhan_touch:(id)sender {
    
    
    VDSCOnlineCashTransferViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"onlineCashTransferList"];
    popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    //popover.delegate = self;
    //CGRect rect=CGRectMake(-100, -140, 200,300);//((UIButton*)sender).frame;
    popover_Vew.delegate =self;
    [popover presentPopoverFromRect:self.btn_taikhoannhan.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(BOOL)CheckBeforAction
{
    BOOL  result;
    NSString *message;
    message=@"";
    
    double TienDuocPhepChuyen=TongTienCoTheChuyen;
    double SoTienChuyen;
    if([self.txtTaiKhoanNhan.text  isEqualToString:@""])
    {
        message=[NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.cashTransfer.idAccountTo"]];
    }
    
    if([self.txtSoTienChuyen.text  isEqualToString:@""])
    {
        message=[utils.dic_language objectForKey:@"ipad.cashTransfer.idTranfCash"];
    }
    else
    {
        //-----kiem tra so tien khong duoc nhap chu-------
        
        //-----kiem tra so tien phai >0-------------------
        SoTienChuyen=[[self.txtSoTienChuyen.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
        if(SoTienChuyen<=0)
            message=[utils.dic_language objectForKey:@"ipad.cashTransfer.idInteger"];
        else{
            double PhanTramPhi;double TienPhi;
            
            
            
            if(self.segNguoiTraPhi.selectedSegmentIndex==0)
            {
                PhanTramPhi=[self.txtMucPhiChuyenKhoan.text doubleValue];
                TienPhi=SoTienChuyen*PhanTramPhi/100;
                if(SoTienChuyen+TienPhi>TienDuocPhepChuyen)
                {
                    message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.cashTransfer.idCashFeeUsable"]];
                }
            }
            else
            {
                if(SoTienChuyen>TienDuocPhepChuyen)
                {
                    message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.cashTransfer.idCashUsable"]];
                }
            }
            //-------------------------------------------------
            
        }
    }
    
    
    //kiem tra otp
    
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
    
    if(message.length!=0)
    {
        [utils showMessage:message messageContent:nil];
    }
    
    return message.length<=0;
}

- (IBAction)btn_XacNhan:(id)sender
{
    [self touchesBegan:0 withEvent:nil];
    if([self CheckBeforAction])
    {
        [utils showConfirmMessae:sender delegate:self message:[utils.dic_language objectForKey:@"ipad.cashTransfer.confirmCash"]];
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"transferCash"]];
        NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
        /*
         int NguoiChuyenTra1NguoiNhan0=0;
         if(self.segNguoiTraPhi.selectedSegmentIndex==1)
         NguoiChuyenTra1NguoiNhan0=1;
         */
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"KW_WS_EXECPWD",[NSString stringWithFormat:@"Abc123XYZ2013_%@",
                                          [utils.shortDateFormater stringFromDate: [NSDate date]]]
                        ,@"KW_CLIENTSECRET",utils.clientInfo.secret
                        ,@"KW_CLIENTID", utils.clientInfo.clientID
                        , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                        , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                        , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                        ,@"KW_CASH_TRANSFER_ACCOUNTID",self.btn_taikhoannhan.titleLabel.text
                        ,@"KW_CASH_TRANSFER_AMOUNT",  [self.txtSoTienChuyen.text stringByReplacingOccurrencesOfString:@"," withString:@""]
                        ,@"KW_CASH_TRANSFER_FEEBY",[NSString stringWithFormat:@"%d",self.segNguoiTraPhi.selectedSegmentIndex]
                        ,@"KW_CASH_TRANSFER_REMARK",  self.txtNoiDungChuyen.text
                        ,nil
                        ];
        NSString *post = [utils postValueBuilder:arr];
        NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            //[self performSelectorInBackground:@selector(LoadCash) withObject:nil ];
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.cashTransfer.idTranSuccess"] messageContent:nil dismissAfter:1];
            
            loading=[utils showLoading:self.tabDetailCashTranfer];
            [self performSelectorInBackground:@selector(LoadHistoryCashTransfer) withObject:nil];
            [self LoadCash];
            [self resetInput];
        }
        else{
            NSString *errCode = [allDataDictionary objectForKey:@"errCode"];
            if([errCode isEqualToString:@"ERRCODE_CASH_TRANFER_LESSTHAN_FEE"])
                errCode=@"Số tiền chuyển không đủ để trả phí. Quý khách vui lòng nhập lại số tiền chuyển.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chuyển tiền không thành công!" message:errCode delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
            [alert show];
        }
        [arr release];
    } else {
        // be nice with the world, maybe initiate some Ecological action as a bonus
    }
}

- (IBAction)btn_cancel_touch:(id)sender {
    [self resetInput];
}
-(void)resetInput
{
    self.txtChuTaiKhoan.text=self.txtNganHang.text= self.txtNoiDungChuyen.text= self.txtSoTienChuyen.text=@"";self.txtTaiKhoanNhan.text=@"";
    [self.btn_taikhoannhan setTitle:@"" forState:UIControlStateNormal];
    [otp resetOtpPosition];
}

- (IBAction)segNguyenChuyen0Nhan1:(id)sender {
    
    UISegmentedControl *SegmentRound = (UISegmentedControl *)sender;
    UIColor *newSelectedTintColor= [UIColor colorWithRed: 98/255.0 green:156/255.0 blue:247/255.0 alpha:1.0];
    
    if([SegmentRound selectedSegmentIndex] == 0)
    {
        [[[SegmentRound subviews] objectAtIndex:1] setTintColor:newSelectedTintColor];
        [[[SegmentRound subviews] objectAtIndex:0] setTintColor:daylight];
    }
    if([SegmentRound selectedSegmentIndex] == 1)
    {
        [[[SegmentRound subviews] objectAtIndex:1] setTintColor:daylight];
        [[[SegmentRound subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
    }
}

- (IBAction)btn_LoadHisCashTransfer:(id)sender {
    if(loading==nil && [self checkDate])
    {
        loading=[utils showLoading:self.tabDetailCashTranfer];
        [self performSelectorInBackground:@selector(LoadHistoryCashTransfer) withObject:nil];
    }
}
-(BOOL) checkDate{
    NSString *start = self.txt_TuNgay.text;
    NSString *end = self.txt_DenNgay.text;
    
    
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

-(void)LoadHistoryCashTransfer
{
    NSArray *arr;
    @try {
        [array_ObjectCashTranfer removeAllObjects];
        
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_FROMDATE", self.txt_TuNgay.text
               , @"KW_TODATE", self.txt_DenNgay.text, nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"cashTransferHistory"];
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=200;
        
        [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
        
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        [self.tabDetailCashTranfer reloadData];
        if(loading!=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading =nil;
        }
        //if(allDataDictionary!=nil)
        //    [allDataDictionary release];
        if(arr !=nil)
            [arr release];
    }
}

//----4444444444444444444444444------------------------

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 26;
}
//------------------------------------------------------
//------555555555555555---------------------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (array_ObjectCashTranfer!=nil && array_ObjectCashTranfer.count>0)
        return array_ObjectCashTranfer.count;
    else
        return  0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCCashTranferServicesCell";
    VDSCCashTranferServicesCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    @try
    {
        //------5.11111111111111111
        if(cell == nil)
        {
            cell = [[VDSCCashTranferServicesCell alloc] init];
        }
        //------5.22222222222222222
        
        if (array_ObjectCashTranfer != nil && array_ObjectCashTranfer.count>0)
        {
            VDSCOjectCashTransfer *obj=[array_ObjectCashTranfer objectAtIndex:indexPath.row];
            [cell setData2Cell :obj];
        }
        
        //--------------------------
    }
    @catch (NSException *exception)
    {
        // NSLog([NSString stringWithFormat:@"%@", exception.description]);
    }
    @finally
    {
        //updating = NO;
    }
    return cell;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtSoTienChuyen resignFirstResponder];
    [self.txtNoiDungChuyen resignFirstResponder];
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
    
    if(Entitlement!=nil)
        [ Entitlement touchesBegan:nil withEvent:nil];
    if(MarginTrans!=nil)
        [ MarginTrans touchesBegan:nil withEvent:nil];
    if(OrderConfirm!=nil)
        [ OrderConfirm touchesBegan:nil withEvent:nil];
    
    double d = [[self.txtSoTienChuyen.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.txtSoTienChuyen.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
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
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y-20, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y+20, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    //}
}

@end

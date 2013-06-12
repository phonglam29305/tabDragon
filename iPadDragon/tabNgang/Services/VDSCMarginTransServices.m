
//
//  VDSCMarginTransServices.m
//  iPadDragon
//
//  Created by Lion User on 04/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMarginTransServices.h"
#import "VDSCCommonUtils.h"
#import "OCCalendarViewController.h"
#import "VDSCOnlineCashTransferViewController.h"
#import "VDSCPush2DateListViewController.h"
#import "SSCheckBoxView.h"
#import "VDSCOTPView.h"
#import "ASIFormDataRequest.h"


@implementation VDSCMarginTransServices{
    VDSCCommonUtils *utils;
    OCCalendarViewController *CalendarVC;
    UIWebView *loading;
    NSMutableArray *array_TKUQ;
    NSMutableArray *array;
    
    NSDate *fdate;
    NSDate *tdate;
    
    VDSCOTPView *otp;
    SSCheckBoxView *cbv;
    double pendingOut;
    BOOL warningExpiredDate;
    BOOL pendingExtendContract;
    BOOL pendingInterestTran;
    BOOL isCreateTrans;
    NSString *time4CreateTrans;
    
    NSTimer *timer;
    double tienCoTheGiam ;
    NSOperationQueue *queue;
}

@synthesize loaiGD1_listLoaiGD2_TKUQ3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc {
    [_btn_DenNgay release];
    [_txtDenNgay release];
    [_btn_TuNgay release];
    [_txtTuNgay release];
    [_viGDTangDuNo release];
    [_viGDGiamDuNo release];
    [_viGDGiamHopDong release];
    
    [_btn_switchServices release];
    [_f_tienCoTheTraNo release];
    [_txt_giamNoGoc release];
    [_f_tienLai release];
    [_otpView release];
    [_txt_tienTangNo release];
    [_f_tienDcGhiNo release];
    [_btn_TKUyQuyen release];
    [_f_ngayHetHan release];
    [_f_ngayHetHanTiepThep release];
    [_f_tyleKQ release];
    [_f_phiGiaHan release];
    [_f_taiTroMuaTrongNgay release];
    [_f_tienDcPhepGhiNo release];
    [_txt_tangNo release];
    [_f_tienMatThucCo release];
    [_f_tienUngTruoc release];
    [_f_duNoKQ release];
    [_f_laiKQ release];
    [_f_tongKhopMua release];
    [_btn_LoaiGD release];
    [_table_list release];
    [timer invalidate];
    timer = nil;
    [super dealloc];
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    @try{
        utils =[[VDSCCommonUtils alloc]init];
        array_TKUQ = [[NSMutableArray alloc] init];
        array = [[NSMutableArray alloc] init];
        [self registerForKeyboardNotifications];
        
        NSDate *startDate = [NSDate date];
        self.txtTuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        self.txtDenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = tdate=[startDate copy];
        
        //[self performSelectorInBackground:@selector(LoadCash) withObject:nil];
        
        CGRect frame = self.f_tienLai.frame;//CGRectMake(940, -5, 30, 30);
        frame.origin.x=frame.origin.x+self.f_tienLai.frame.size.width-25;
        frame.origin.y=frame.origin.y-5;
        SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
        BOOL checked = NO;
        cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:style
                                            checked:checked];
        [self.viGDGiamDuNo addSubview:cbv];
        
        
        otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
        otp.frame = CGRectMake(-10, 0, 360, 30);
        [self.otpView addSubview:otp];
        
        self.txt_giamNoGoc.keyboardType = UIKeyboardTypeNumberPad;
        self.txt_tangNo.keyboardType = UIKeyboardTypeNumberPad;
        self.txt_tienTangNo.keyboardType = UIKeyboardTypeNumberPad;
        
        self.table_list.delegate=self;
        self.table_list.dataSource=self;
        
        timer  = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        [timer fire];
        self.btn_switchServices.tag=2;
        [self switchServices];
        
        [self loadData];
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
}

-(void)loadData{
    if(loading==nil)
    {
        loading = [utils showLoading:self];
        [self LoadMarginInfo];
        [self loadMarginHistory];
    }
}

-(void)switchServices
{
    [self bringSubviewToFront:self.viGDGiamDuNo];
    [self bringSubviewToFront:self.viGDGiamHopDong];
    [self bringSubviewToFront:self.viGDTangDuNo];
    switch (self.btn_switchServices.tag) {
        case 0:
            self.viGDGiamDuNo.hidden=YES;
            self.viGDTangDuNo.hidden=YES;
            self.viGDGiamHopDong.hidden=YES;
            
            break;
        case 1:
            self.viGDGiamDuNo.hidden=YES;
            self.viGDTangDuNo.hidden=NO;
            self.viGDGiamHopDong.hidden=YES;
            
            break;
        case 2:
            self.viGDGiamDuNo.hidden=NO;
            self.viGDTangDuNo.hidden=YES;
            self.viGDGiamHopDong.hidden=YES;
            break;
        case 3:
            self.viGDGiamDuNo.hidden=YES;
            self.viGDTangDuNo.hidden=YES;
            self.viGDGiamHopDong.hidden=NO;
            
            break;
    }
    
}

- (IBAction)btn_TuNgay_touch:(id)sender {
    CGPoint insertPoint = self.btn_TuNgay.bounds.origin;
    
    insertPoint.x = insertPoint.x+420;
    insertPoint.y = insertPoint.y+300;
    
    CalendarVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
    CalendarVC.delegate = self;
    CalendarVC.sender = sender;
    CalendarVC.startDate=fdate;
    CalendarVC.endDate=fdate;
    [self addSubview:CalendarVC.view];
    
}

- (IBAction)btn_DenNgay_touch:(id)sender {
    //  [self.txt_ma resignFirstResponder];
    CGPoint insertPoint = self.btn_DenNgay.bounds.origin;
    insertPoint.x = insertPoint.x+660;
    insertPoint.y = insertPoint.y+300;
    
    
    CalendarVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
    CalendarVC.delegate = self;
    CalendarVC.sender = sender;
    CalendarVC.startDate=tdate;
    CalendarVC.endDate=tdate;
    [self addSubview:CalendarVC.view];
}
- (void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    if(((UIButton*)CalendarVC.sender).tag==0)
    {
        self.txtTuNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = [startDate copy];
    }
    else
    {
        self.txtDenNgay.text = [utils.shortDateFormater stringFromDate: startDate];
        tdate=[startDate copy];
    }
    [CalendarVC.view removeFromSuperview];
    
    CalendarVC.delegate = nil;
    [CalendarVC release];
    CalendarVC = nil;
    
}
-(void) completedWithNoSelection{
    [CalendarVC.view removeFromSuperview];
    CalendarVC.delegate = nil;
    [CalendarVC release];
    CalendarVC= nil;
}


- (IBAction)btn_LoaiGiaoDich:(id)sender {
    loaiGD1_listLoaiGD2_TKUQ3=2;
    VDSCPush2DateListViewController *popover_push2DateList =  [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_push2DateList.delegate=self;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=((UIButton*)sender).frame;
    //rect.origin.x = ((UIButton*)sender).frame.origin.x;
    [self.popoverController presentPopoverFromRect:rect inView:((UIButton*)sender).superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btn_confirm_touch:(id)sender {
    if([self checkInput])
    {
        NSArray *arr;
        NSDictionary *allDataDictionary;
        @try {
            
            NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
            double temp = [[self.txt_tangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                   , @"KW_MARGIN_AMOUNT", [NSString stringWithFormat:@"%f", temp]
                   , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                   , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                   , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                   , nil];
            
            NSString *url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginIncreaseDebt"];
            if(self.btn_switchServices.tag==0)//chuyen suc mua
            {
                url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginTransferBuyingPower"];
                temp = [[self.txt_tienTangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                       , @"KW_CLIENTID", utils.clientInfo.clientID
                       , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                       , @"KW_MARGIN_AMOUNT", [NSString stringWithFormat:@"%f", temp]
                       , @"KW_MARGIN_DEST_CLIENTID", self.btn_TKUyQuyen.titleLabel.text
                       , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                       , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                       , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                       , nil];
            }
            if(self.btn_switchServices.tag==2)//giam no
            {
                temp = [[self.txt_giamNoGoc.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                double phi = [[self.f_laiKQ.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginDecreaseDebt"];
                arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                       , @"KW_CLIENTID", utils.clientInfo.clientID
                       , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                       , @"KW_MARGIN_AMOUNT", [NSString stringWithFormat:@"%f", temp]
                       , @"KW_MARGIN_FEE", cbv.checked?[NSString stringWithFormat:@"%f", phi*-1]:@"0"
                       , @"KW_MARGIN_CHKINTEREST", cbv.checked?@"1":@"0"
                       , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                       , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                       , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                       , nil];
            }
            if(self.btn_switchServices.tag==3)//gia han
            {
                temp = [[self.f_phiGiaHan.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginExtendContract"];
                arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                       , @"KW_CLIENTID", utils.clientInfo.clientID
                       , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                       , @"KW_MARGIN_FEE", [NSString stringWithFormat:@"%f", temp]
                       , @"KW_FROMDATE", self.f_ngayHetHan.text
                       , @"KW_TODATE", self.f_ngayHetHanTiepThep.text
                       , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                       , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                       , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                       , nil];
            }
            
            NSString *post = [utils postValueBuilder:arr];
            
            allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            //------------------------------------------------
            
            if(success)
            {
                if(self.btn_switchServices.tag==0)
                    [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.margin.transferDebt.success"] messageContent:nil];
                else
                    if(self.btn_switchServices.tag==1)
                        [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.margin.inCreaseDebt.success"] messageContent:nil dismissAfter:1];
                    else
                        if(self.btn_switchServices.tag==2)
                            [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.success"] messageContent:nil];
                        else [utils showMessage:[utils.dic_language objectForKey:@"ipad.services.margin.extraMargin.success"] messageContent:nil];
                
                [self loadData];
                [self resetInput];
            }
            else{
                NSString *errCode = [allDataDictionary objectForKey:@"errCode"];
                if([errCode isEqualToString:@"ERRCODE_MARGIN_CHECK_INTEREST"])
                    errCode = [utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.cantPayFee"];
                [utils showMessage:errCode messageContent:nil];
                [otp resetOtpPosition];
            }
        }
        @catch (NSException *exception) {
            NSLog(exception.description);
        }
        @finally {
            if(allDataDictionary!=nil)
                [allDataDictionary release];
            if(arr !=nil)
                [arr release];
        }
        
    }
}

-(void)resetInput
{
    [self.btn_TKUyQuyen setTitle:@"" forState:UIControlStateNormal];
    self.txt_tienTangNo.text=self.txt_tangNo.text=self.txt_giamNoGoc.text=@"0";
    cbv.checked=NO;
    [otp resetOtpPosition];
    
    //[self performSelectorInBackground:@selector(LoadMarginInfo) withObject:nil];
    
}
-(BOOL)checkInput
{
    NSString *message=@"";
    if(!isCreateTrans)
        message=[NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.services.common.time4CreateTrans"], time4CreateTrans];
    else{
        if(self.btn_switchServices.tag==0)//chuyen suc mua
        {
            NSString* tkUQ = self.btn_TKUyQuyen.titleLabel.text;
            if(tkUQ==nil || tkUQ.length==0)
            {
                message=[utils.dic_language objectForKey:@"ipad.services.margin.transferDebt.chooseAsignAccount"];
            }
            else{
                double tienCoTheTang = [[self.f_tienDcGhiNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                double tienTangNo = [[self.txt_tienTangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                if(tienTangNo<=0||tienTangNo>tienCoTheTang)
                    message = [utils.dic_language objectForKey:@"ipad.services.margin.transferDebt.worngAmount"];
                else
                {
                    NSString *url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginInfoOfAuthorized"];
                    NSArray* arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                                    , @"KW_CLIENTID", utils.clientInfo.clientID
                                    , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                                    , @"KW_MARGIN_AUTHORIZED_ACCOUNTYPE", [[array_TKUQ objectAtIndex:self.btn_TKUyQuyen.tag] objectAtIndex:1]
                                    , @"KW_MARGIN_AUTHORIZED_CLIENTID", self.btn_TKUyQuyen.titleLabel.text
                                    , nil];
                    NSString *post = [utils postValueBuilder:arr];
                    NSDictionary *data = [utils getDataFromUrl:url method:@"POST" postData:post];
                    if(![data isEqual:[NSNull null]])
                    {
                        if([[data objectForKey:@"success"] boolValue])
                        {
                            double d = [[data objectForKey:@"amountOfAuthorized"] doubleValue];
                            if(d<tienTangNo)
                                message = [utils.dic_language objectForKey:@"ipad.services.transferDebtmargin.worngAmount"];
                        }
                        else
                            message = @"";
                    }
                }
            }
        }
        else if(self.btn_switchServices.tag==1) //tang no
        {
            double tienCoTheTang = [[self.f_tienDcPhepGhiNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            double tienTangNo = [[self.txt_tangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            
            if(tienTangNo<=0||tienTangNo>tienCoTheTang)
                message = [utils.dic_language objectForKey:@"ipad.services.margin.inCreaseDebt.worngAmount"];
        }
        else if(self.btn_switchServices.tag==2) //giam no
        {
            if(pendingInterestTran && cbv.checked)
            {
                message=[utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.pendingTrans"];
            }
            else{
                double dunoKQ = [[self.f_duNoKQ.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]*-1;
                double tienGiamNo = [[self.txt_giamNoGoc.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                double laiKQ  = [[self.f_laiKQ.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                // Chỉ tick được khi tiền mặt thực có +tiền có thể ứng trước-Fix Loan-Conf Buy Order-Pending Out> Debit Int, nếu o tick được phải hiện Pop Up không đủ tiền trả lãi
                
                double a=fmax(fmin(tienCoTheGiam*1000,dunoKQ*1000),0);
                if(tienGiamNo<0 || tienGiamNo*1000>round(a))
                    message = [utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.worngAmount"];
                if(dunoKQ>0 && tienGiamNo*1000<round(a) && cbv.checked)
                    message = [utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.payDebtFirst"];
                else if (tienGiamNo==0 && !cbv.checked)
                    message = [utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.notPayDebtOrFee"];
                else if(cbv.checked && laiKQ==0)
                    message = [utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.notFee2Pay"];
                else
                {
                    double tiemMat=[[self.f_tienMatThucCo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                    double tienUng=[[self.f_tienUngTruoc.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                    double fixLoan=[[self.f_duNoKQ.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                    double confirmBuy=[[self.f_tongKhopMua.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                    double laiKQ=[[self.f_laiKQ.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                    
                    if(cbv.checked && tiemMat+tienUng-fixLoan-confirmBuy-pendingOut<laiKQ)
                        message=[utils.dic_language objectForKey:@"ipad.services.margin.deCreaseDebt.notEnoughBalance"];
                }
            }
        }
        else//gia han
        {
            if(!warningExpiredDate)
                message=[utils.dic_language objectForKey:@"ipad.services.margin.extraMargin.worngTime"];
            else if(pendingExtendContract)
                message=[utils.dic_language objectForKey:@"ipad.services.margin.extraMargin.pendingTrans"];
            
        }
    }
    
    if(message.length==0)
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
        [utils showMessage:message messageContent:nil];
    
    return message.length==0;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_tienTangNo resignFirstResponder];
    [self.txt_tangNo resignFirstResponder];
    [self.txt_giamNoGoc resignFirstResponder];
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
    
    double d = [[self.txt_tienTangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.txt_tienTangNo.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
    
    d = [[self.txt_tangNo.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.txt_tangNo.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
    
    d = [[self.txt_giamNoGoc.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    self.txt_giamNoGoc.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
}

- (IBAction)btn_cancel_touch:(id)sender {
    [self resetInput];
}

- (IBAction)btn_TKUyQuyenNhanChuyenKhoanSucMua_touch:(id)sender {
    loaiGD1_listLoaiGD2_TKUQ3=3;
    VDSCPush2DateListViewController *popover_push2DateList =  [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_push2DateList.delegate=self;
    popover_push2DateList.array_TKUQ = array_TKUQ;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=((UIButton*)sender).frame;
    [self.popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
            [array_TKUQ removeAllObjects];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                isCreateTrans = [[allDataDictionary objectForKey:@"isCreateTrans"] boolValue];
                time4CreateTrans = [allDataDictionary objectForKey:@"time4CreateTrans"] ;
                warningExpiredDate=[[allDataDictionary objectForKey:@"warningExpiredDate"] boolValue];
                pendingExtendContract = [[allDataDictionary objectForKey:@"pendingExtendContract"] boolValue];
                pendingInterestTran=[[allDataDictionary objectForKey:@"pendingInterestTran"] boolValue];
                
                if(warningExpiredDate)// && !pendingExtendContract)
                {
                    self.f_ngayHetHan.textColor = [UIColor redColor];
                }
                else self.f_ngayHetHan.textColor = self.f_ngayHetHanTiepThep.textColor;
                NSArray *data = [allDataDictionary objectForKey:@"listUQ"];
                if(![data isEqual:[NSNull null]])
                    for (NSArray *arrayOfEntity in data)
                    {
                        //NSString *acc = [NSString stringWithFormat:@"%@", [arrayOfEntity objectAtIndex:2]];
                        [array_TKUQ addObject:arrayOfEntity];
                    }
                data = [allDataDictionary objectForKey:@"account"];
                if(![data isEqual:[NSNull null]]){
                    NSDictionary *dic = [data objectAtIndex:0];
                    if(![dic isEqual:[NSNull null]])
                    {
                        double tienmat=[[allDataDictionary objectForKey:@"realCash"] doubleValue];
                        double ungtruoc=[[allDataDictionary objectForKey:@"avaiAdvCash"] doubleValue];
                        self.f_tienMatThucCo.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tienmat]];
                        
                        self.f_tienDcPhepGhiNo.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:fmax([[allDataDictionary objectForKey:@"maxAmount4IncreaseDebt"] doubleValue],0)]];
                        tienCoTheGiam = [[allDataDictionary objectForKey:@"maxAmount4DecreaseDebt"] doubleValue];
                        
                        self.f_tienCoTheTraNo.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:tienmat+ungtruoc]];
                        
                        self.f_laiKQ.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[dic objectForKey:@"DebitInterest"] doubleValue]]];
                        
                        self.f_duNoKQ.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[dic objectForKey:@"MarginLoans"] doubleValue]]];
                        
                        self.f_tongKhopMua.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[dic objectForKey:@"DueBuy"] doubleValue]]];
                        
                        self.f_tienMatThucCo.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"realCash"] doubleValue]]];
                        
                        self.f_tienUngTruoc.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"avaiAdvCash"] doubleValue]]];
                        
                        self.f_tongKhopMua.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[allDataDictionary objectForKey:@"todayConfirmedBuy"] doubleValue]]];
                        
                        pendingOut = [[dic objectForKey:@"PendingOut"] doubleValue];
                    }
                }
                data = [allDataDictionary objectForKey:@"listGH"];
                if(![data isEqual:[NSNull null]])
                {
                    data = [data objectAtIndex:0];
                    //gia han
                    self.f_ngayHetHan.text = [data objectAtIndex:0];
                    self.f_ngayHetHanTiepThep.text = [data objectAtIndex:1];
                    self.f_tyleKQ.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[data objectAtIndex:2] doubleValue]]];
                    self.f_phiGiaHan.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[data objectAtIndex:3] doubleValue]]];
                }
                
            }
        }
        else if(request.tag==200)
        {
            [array removeAllObjects];
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                NSArray *data=[allDataDictionary objectForKey:@"list"];
                if(![data isEqual:[NSNull null]]){
                    for(NSArray *item in data){
                        [array addObject:item];
                    }
                }
                
            }
            [self.table_list reloadData];
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

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}



- (IBAction)btn_loaiGD_touch:(id)sender {
    loaiGD1_listLoaiGD2_TKUQ3=1;
    VDSCPush2DateListViewController *popover_push2DateList =  [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"Push2DateList"];
    popover_push2DateList.delegate=self;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:popover_push2DateList];
    CGRect rect=((UIButton*)sender).frame;
    [self.popoverController presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)LoadMarginInfo
{
    NSArray *arr;
    @try {
        
        
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID, nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"marginInfo"];
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
        
        if(loading!=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading =nil;
        }
        if(arr !=nil)
            [arr release];
    }
}
-(void)getAmountOfAuthorized
{
    if(self.btn_TKUyQuyen.titleLabel.text.length!=0){
        NSString *url =[[NSUserDefaults standardUserDefaults]stringForKey:@"marginInfoOfAuthorized"];
        NSArray* arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                        , @"KW_CLIENTID", utils.clientInfo.clientID
                        , @"KW_ACCOUNTTYPE", utils.clientInfo.accountType
                        , @"KW_MARGIN_AUTHORIZED_ACCOUNTYPE", [[array_TKUQ objectAtIndex:self.btn_TKUyQuyen.tag] objectAtIndex:1]
                        , @"KW_MARGIN_AUTHORIZED_CLIENTID", self.btn_TKUyQuyen.titleLabel.text
                        , nil];
        NSString *post = [utils postValueBuilder:arr];
        NSDictionary *data = [utils getDataFromUrl:url method:@"POST" postData:post];
        if(![data isEqual:[NSNull null]])
        {
            if([[data objectForKey:@"success"] boolValue])
            {
                double d = [[data objectForKey:@"amountOfAuthorized"] doubleValue];
                self.f_tienDcGhiNo.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
            }
        }
    }
}

- (IBAction)btn_refresh_touch:(id)sender {
    if(loading==nil && [self checkDate])
    {
        loading = [utils showLoading:self.table_list];
        [self loadMarginHistory];
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
-(int)marginKind
{
    switch (self.btn_LoaiGD.tag) {
        case 1://chuyen suc mua
            return 3;
            break;
        case 2://tang no
            return 2;
            break;
        case 3://giam no
            return 1;
            break;
        case 4://gia han
            return 4;
            break;
        default:
            return 0;
            break;
    }
}
-(void)loadMarginHistory
{
    NSArray *arr ;
    @try {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"marginHistory"]];
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_FROMDATE", self.txtTuNgay.text
               , @"KW_TODATE", self.txtDenNgay.text
               , @"KW_MARGIN_KIND", [NSString stringWithFormat:@"%d", [self marginKind]]
               , nil];
        NSString *post = [utils postValueBuilder:arr];
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
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading = nil;
        }
        
        [self.table_list reloadData];
        if(arr!=nil)
            [arr release];
    }
    
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
    NSArray *item = [array objectAtIndex:i];
    UIColor *color = [UIColor lightGrayColor];
    
    int x=0;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 106, utils.rowHeight-1);
    label.text = [item objectAtIndex:0];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=10;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 224, utils.rowHeight-1);
    label.text = [item objectAtIndex:1];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 127, utils.rowHeight-1);
    
    if([[item objectAtIndex:1] isEqual:@"Chuyển sức mua"])
        label.text = [[item objectAtIndex:2] substringToIndex:7];
    else
        label.text = [item objectAtIndex:2];
    
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    [label setAdjustsFontSizeToFitWidth:YES];
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 120, utils.rowHeight-1);
    label.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble: [[item objectAtIndex:3] doubleValue]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 97, utils.rowHeight-1);
    label.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:[[item objectAtIndex:4] doubleValue]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 119, utils.rowHeight-1);
    label.text = [item objectAtIndex:5];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    UITextView *textField = [[UITextView alloc] init];
    textField.frame = CGRectMake(x, 0, 181, utils.rowHeight-1);
    textField.text = [item objectAtIndex:9];
    textField.backgroundColor = utils.cellBackgroundColor;
    textField.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    textField.textColor = color;
    textField.textAlignment = UITextAlignmentLeft;
    textField.tag=11;
    [textField setEditable:NO];
    [cell addSubview:textField];
    [textField release];
    
    
    return cell;
}
@end

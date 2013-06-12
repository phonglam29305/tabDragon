//
//  VDSCSMSRegisterViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCSMSRegisterViewController.h"
#import "SSCheckBoxView.h"
#import "VDSCCommonUtils.h"
#import "VDSCOTPView.h"
#import "VDSCAccountInfoView.h"

@interface VDSCSMSRegisterViewController ()
{
    SSCheckBoxView *cbv_khopLenh;
    SSCheckBoxView *cbv_chungKhoan;
    SSCheckBoxView *cbv_tien;
    SSCheckBoxView *cbv_margin;
    SSCheckBoxView *cbv_soDu;
    SSCheckBoxView *cbv_dieuKhoan;
    SSCheckBoxView *cbv_dichVu;
    VDSCCommonUtils *utils;
    UIWebView *loading;
    VDSCOTPView *otp;
    BOOL isRegisted;
    BOOL hasPendingTrade;
    NSString *oldNumber;
}
@end

@implementation VDSCSMSRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    utils = [[VDSCCommonUtils alloc] init];
    [self registerForKeyboardNotifications];
    
    CGRect frame = CGRectMake(0, 0, self.v_khoplenh.frame.size.width, 50);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    BOOL checked = NO;
    cbv_khopLenh = [[SSCheckBoxView alloc] initWithFrame:frame
                                                   style:style
                                                 checked:checked];
    [cbv_khopLenh setText:@"Thông báo khớp lệnh"];
    [cbv_khopLenh setFont:@"Arial" fontSize:15];
    [self.v_khoplenh addSubview:cbv_khopLenh];
    self.v_khoplenh.backgroundColor = [UIColor clearColor];
    
    frame = CGRectMake(0, 0, self.v_chungKhoan.frame.size.width, 50);
    cbv_chungKhoan = [[SSCheckBoxView alloc] initWithFrame:frame
                                                     style:style
                                                   checked:checked];
    [cbv_chungKhoan setText:@"Thông báo các giao dịch chứng khoán"];
    [cbv_chungKhoan setFont:@"Arial" fontSize:15];
    [self.v_chungKhoan addSubview:cbv_chungKhoan];
    self.v_chungKhoan.backgroundColor = [UIColor clearColor];
    
    
    frame = CGRectMake(0, 0, self.v_tien.frame.size.width, 50);
    cbv_tien = [[SSCheckBoxView alloc] initWithFrame:frame
                                               style:style
                                             checked:checked];
    [cbv_tien setText:@"Thông báo các giao dịch tiền"];
    [cbv_tien setFont:@"Arial" fontSize:15];
    [self.v_tien addSubview:cbv_tien];
    self.v_tien.backgroundColor = [UIColor clearColor];
    
    frame = CGRectMake(0, 0, self.v_margin.frame.size.width, 50);
    cbv_margin = [[SSCheckBoxView alloc] initWithFrame:frame
                                                 style:style
                                               checked:checked];
    [cbv_margin setText:@"Thông báo dành riêng cho tài khoản Margin"];
    [cbv_margin setFont:@"Arial" fontSize:15];
    [self.v_margin addSubview:cbv_margin];
    self.v_margin.backgroundColor = [UIColor clearColor];
    
    frame = CGRectMake(0, 0, self.v_soDu.frame.size.width, 50);
    cbv_soDu = [[SSCheckBoxView alloc] initWithFrame:frame
                                               style:style
                                             checked:checked];
    [cbv_soDu setText:@"Truy vấn số dư trên tài khoản"];
    [cbv_soDu setFont:@"Arial" fontSize:15];
    [self.v_soDu addSubview:cbv_soDu];
    self.v_soDu.backgroundColor = [UIColor clearColor];
    frame = CGRectMake(0, 0, self.v_dieuKhoan.frame.size.width, 50);
    cbv_dieuKhoan = [[SSCheckBoxView alloc] initWithFrame:frame
                                                    style:style
                                                  checked:checked];
    [cbv_dieuKhoan setFont:@"Arial" fontSize:15];
    [cbv_dieuKhoan setText:@"Điều khoản sử dụng"];
    [cbv_dieuKhoan setTextColor: utils.c_giam];
    [self.v_dieuKhoan addSubview:cbv_dieuKhoan];
    self.v_dieuKhoan.backgroundColor = [UIColor clearColor];
    
    frame = CGRectMake(0, 0, self.v_dichVu.frame.size.width, 50);
    cbv_dichVu = [[SSCheckBoxView alloc] initWithFrame:frame style:style checked:checked];
    [cbv_dichVu setText:@"Thông báo dịch vụ"];
    [cbv_dichVu setFont:@"Arial" fontSize:15];
    [self.v_dichVu addSubview:cbv_dichVu];
    self.v_dichVu.backgroundColor = [UIColor clearColor];
    
    
    otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp.frame = CGRectMake(-10, 0, 360, 30);
    [self.otpView addSubview:otp];
    
    cbv_soDu.checked=cbv_tien.checked=cbv_margin.checked=cbv_khopLenh.checked=cbv_dieuKhoan.checked=cbv_dichVu.checked=cbv_chungKhoan.checked=YES;
    self.f_hoTen.text=utils.clientInfo.clientName;
    self.f_soTK.text = utils.clientInfo.clientID;
    self.txt_sdt.text=utils.clientInfo.phone;
    
    loading = [utils showLoading:self.view];
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}

-(void)loadData
{
    NSArray *arr;
    NSDictionary *allDataDictionary;
    @try {
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID ,nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"SMSInfo"];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            
            hasPendingTrade = [[allDataDictionary objectForKey:@"isPending"] intValue]==1;
            if(hasPendingTrade)
                [utils showMessage:@"Yêu cầu của quý khách đang được thực hiện, Quý khách vui lòng quay lại sau." messageContent:nil];
            self.btn_confirm.enabled= self.txt_sdt.enabled = cbv_tien.enabled = cbv_soDu.enabled = cbv_margin.enabled = cbv_khopLenh.enabled=cbv_chungKhoan.enabled=cbv_dichVu.enabled=!hasPendingTrade;
            NSArray *data = [[allDataDictionary objectForKey:@"services"] objectAtIndex:0];
            
            if(![data isEqual:[NSNull null]]){
                self.txt_sdt.text= [NSString stringWithFormat:@"%@",[data objectAtIndex:9]];
                oldNumber = [[NSString stringWithFormat:@"%@",[data objectAtIndex:9]] retain];
                cbv_chungKhoan.checked = [[data objectAtIndex:4] intValue]==1;
                cbv_tien.checked = [[data objectAtIndex:5] intValue]==1;
                cbv_khopLenh.checked = [[data objectAtIndex:3] intValue]==1;
                cbv_margin.checked = [[data objectAtIndex:6] intValue]==1;
                cbv_soDu.checked = [[data objectAtIndex:7] intValue]==1;
                cbv_dichVu.checked = [[data objectAtIndex:2] intValue]==1;
                
                isRegisted = [[data objectAtIndex:1] intValue]==1;
                if(isRegisted) self.f_loaiDK.selectedSegmentIndex=1;
                self.btn_confirm.enabled=!hasPendingTrade;
                
                if(!isRegisted)
                {
                    self.txt_sdt.text=utils.clientInfo.phone;
                }
            }
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
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_f_soTK release];
    [_f_hoTen release];
    [_f_loaiDK release];
    [_txt_sdt release];
    [_v_khoplenh release];
    [_v_tien release];
    [_v_margin release];
    [_v_soDu release];
    [_v_dieuKhoan release];
    [_otpView release];
    [_v_dichVu release];
    [utils release];
    [otp release];
    [_btn_confirm release];
    [cbv_dichVu release];
    [cbv_khopLenh release];
    [cbv_chungKhoan release];
    [cbv_tien release];
    [cbv_margin release];
    [cbv_soDu release];
    [_viewConfirm release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setF_soTK:nil];
    [self setF_hoTen:nil];
    [self setF_loaiDK:nil];
    [self setTxt_sdt:nil];
    [self setV_khoplenh:nil];
    [self setV_tien:nil];
    [self setV_margin:nil];
    [self setV_soDu:nil];
    [self setV_dieuKhoan:nil];
    [self setOtpView:nil];
    [self setV_dichVu:nil];
    [self setBtn_confirm:nil];
    [self setViewConfirm:nil];
    [super viewDidUnload];
}
- (IBAction)seg_hinhThuc:(id)sender {
    
    if(!isRegisted && (self.f_loaiDK.selectedSegmentIndex!=0))
    {
        self.f_loaiDK.selectedSegmentIndex=0;
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.SMS.notRegis"] messageContent:nil];
    }
    else if(isRegisted && (self.f_loaiDK.selectedSegmentIndex==0))
    {
        self.f_loaiDK.selectedSegmentIndex=1;
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.SMS.registed"] messageContent:nil];
    }
    else{
        if(self.f_loaiDK.selectedSegmentIndex==2 || hasPendingTrade)
        {
            self.txt_sdt.enabled = cbv_tien.enabled = cbv_soDu.enabled = cbv_margin.enabled = cbv_khopLenh.enabled=cbv_chungKhoan.enabled=cbv_dichVu.enabled=NO;
        }
        else self.txt_sdt.enabled = cbv_tien.enabled = cbv_soDu.enabled = cbv_margin.enabled = cbv_khopLenh.enabled=cbv_chungKhoan.enabled=cbv_dichVu.enabled=YES;
    }
}
- (IBAction)btn_confirm_touch:(id)sender {
    /*KW_WS_EXECPWD
     KW_CLIENTSECRET
     KW_CLIENTID
     KW_SMS_UPDATEMETHOD
     KW_SMS_INFO
     KW_SMS_ORDER
     KW_SMS_STOCK
     KW_SMS_MARGIN
     KW_SMS_LOOKUP
     KW_SMS_CASH
     KW_SMS_NUMBER
     KW_OTP_ROWIDX
     KW_OTP_COLIDX
     KW_OTP_VALUE*/
    if([self checkInput]){
        if(self.f_loaiDK.selectedSegmentIndex==0)
        {
            NSString *content= [utils.dic_language objectForKey:@"ipad.SMS.termsAndConditions"];
            content = [content stringByReplacingOccurrencesOfString:@"***" withString:@"\n"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Điều khoản sử dụng" message:content delegate:self cancelButtonTitle:@"Bỏ qua" otherButtonTitles:@"Đồng ý", nil];
            
            [alert show];
        }
        else [self sendRequest];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
    {
        [self sendRequest];
    }
}
-(void) sendRequest
{
    NSArray *arr;
    NSDictionary *allDataDictionary;
    @try {
        NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
        
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_SMS_UPDATEMETHOD",(self.f_loaiDK.selectedSegmentIndex==0?@"REG":self.f_loaiDK.selectedSegmentIndex==1?@"CHN":@"REM")
               , @"KW_SMS_INFO",cbv_dichVu.checked?@"1":@"0"
               , @"KW_SMS_ORDER",cbv_khopLenh.checked?@"1":@"0"
               , @"KW_SMS_STOCK",(cbv_chungKhoan.checked?@"1":@"0")
               , @"KW_SMS_MARGIN",(cbv_margin.checked?@"1":@"0")
               , @"KW_SMS_LOOKUP",(cbv_soDu.checked?@"1":@"0")
               , @"KW_SMS_CASH",(cbv_tien.checked?@"1":@"0")
               , @"KW_SMS_NUMBER",self.txt_sdt.text
               , @"KW_SMS_OLDNUMBER", oldNumber ==nil?@"":oldNumber
               , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
               , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
               , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
               ,nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"updateSmsService"];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            if(self.f_loaiDK.selectedSegmentIndex==0)
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.SMS.regisSuccess"] messageContent:nil];
            else if(self.f_loaiDK.selectedSegmentIndex==1)
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.SMS.editSuccess"] messageContent:nil];
            else
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.SMS.cancelSuccess"] messageContent:nil];
            [((VDSCAccountInfoView*)self.delegate) loadClientInfo];
            [((VDSCAccountInfoView*)self.delegate).popover_sms dismissPopoverAnimated:YES];
        }
        else
        {
            
            if(self.f_loaiDK.selectedSegmentIndex==0)
                [utils showMessage:@"Quý khách đã đăng ký dịch vụ không thành công" messageContent:nil];
            else if(self.f_loaiDK.selectedSegmentIndex==1)
                [utils showMessage:@"Quý khách đã gửi yêu cầu thay đổi không thành công" messageContent:nil];
            else
                [utils showMessage:@"Quý khách đã gửi yêu cầu huỷ không thành công" messageContent:nil];
            
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
-(BOOL)checkInput
{
    NSString *message=@"";
    if(isRegisted && self.f_loaiDK.selectedSegmentIndex==0)
        message = @"Quý khách đã đăng ký dịch vụ";
    else{
        if(self.txt_sdt.text.length==0)
            message = [utils.dic_language objectForKey:@"ipad.SMS.notPhoneInput"];
        else{
            NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            NSString *firstChar = [self.txt_sdt.text substringWithRange:NSMakeRange(0, 1)];
            
            if(self.txt_sdt.text.length>11 || self.txt_sdt.text.length<10 ||  ![firstChar isEqualToString:@"0"] || [self.txt_sdt.text rangeOfCharacterFromSet:set].location != NSNotFound)
                message=[utils.dic_language objectForKey:@"ipad.SMS.notPhoneInput"];
            else{
                int i=0;
                i+=cbv_dichVu.checked?1:0;
                i+=cbv_khopLenh.checked?1:0;
                i+=cbv_chungKhoan.checked?1:0;
                i+=cbv_tien.checked?1:0;
                i+=cbv_soDu.checked?1:0;
                i+=cbv_margin.checked?1:0;
                if(i<2)
                    message=[utils.dic_language objectForKey:@"ipad.SMS.minServices"];
                else{
                    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"saveOTP"])
                    {
                        if([otp checkInput]){
                            BOOL result = [utils otpCherker:otp.otp_number1.text OTPPosition2:otp.otp_number2.text OTPPosition1_Value:otp.otp_number1Value.text OTPPosition2_value:otp.otp_number2Value.text isSave:NO];
                            if(!result)
                            {
                                message=[utils.dic_language objectForKey:@"ipad.otp.saveFail"];
                                
                            }
                            
                        }
                        else return NO;
                    }
                }
            }
        }
    }
    
    if(message.length!=0)
    {
        [utils showMessage:message messageContent:nil];
    }
    
    return message.length==0;
}
- (IBAction)btn_cancel_touch:(id)sender {
    [((VDSCAccountInfoView*)self.delegate).popover_sms dismissPopoverAnimated:YES];
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
    self.viewConfirm.frame= CGRectMake(self.viewConfirm.frame.origin.x, self.viewConfirm.frame.origin.y-155, self.viewConfirm.frame.size.width, self.viewConfirm.frame.size.height);
    [UIView commitAnimations];
    //}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //if(activeField == fieldMaBaoVe)
    //{
    [UIView beginAnimations:@"nove" context:NULL];
    [UIView setAnimationDuration:0.25];
    self.viewConfirm.frame= CGRectMake(self.viewConfirm.frame.origin.x, self.viewConfirm.frame.origin.y+155, self.viewConfirm.frame.size.width, self.viewConfirm.frame.size.height);
    [UIView commitAnimations];
    //}
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_sdt resignFirstResponder];
    [otp.otp_number1Value resignFirstResponder];
    [otp.otp_number2Value resignFirstResponder];
}

@end

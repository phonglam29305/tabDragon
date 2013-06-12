//
//  VDSCChangeAccountInfoViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCChangeAccountInfoViewController.h"
#import "VDSCOTPView.h"
#import "VDSCCommonUtils.h"
#import "VDSCAccountInfoView.h"

@interface VDSCChangeAccountInfoViewController ()
{
    VDSCOTPView *otp;
    VDSCCommonUtils *utils;
}

@end

@implementation VDSCChangeAccountInfoViewController

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
    
    otp = [[[NSBundle mainBundle] loadNibNamed:@"VDSCOTPView" owner:self options:nil] objectAtIndex:0];
    otp.frame = CGRectMake(-10, 0, 360, 30);
    [self.otpView addSubview:otp];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_otpView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOtpView:nil];
    [super viewDidUnload];
}
- (IBAction)btn_cancel_touch:(id)sender {
    [((VDSCAccountInfoView*)self.delegate).popover_changeInfo dismissPopoverAnimated:YES];
}

- (IBAction)btn_confirm_touch:(id)sender {
    if([self checkInput]){
        VDSCAccountInfoView *account=((VDSCAccountInfoView*)self.delegate);
        NSArray *arr;
        NSDictionary *allDataDictionary;
        @try {
            NSArray *arr_otp = [utils getOPTPosition:otp.otp_number1.text OTPPosition2:otp.otp_number2.text];
            
            arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_CLIENTINFO_MAIL",(self.txt_email.text.length==0?@"":self.txt_email.text)
                   , @"KW_CLIENTINFO_PHONE",self.txt_sdt.text
                   , @"KW_CLIENTINFO_CURMAIL",(account.btn_email.titleLabel.text.length==0?@"":account.btn_email.titleLabel.text)
                   , @"KW_CLIENTINFO_CURPHONE",account.btn_phone.titleLabel.text
                   , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                   , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                   , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otp.otp_number1Value.text,otp.otp_number2Value.text]
                   ,nil];
            NSString *post = [utils postValueBuilder:arr];
            
            NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"updatePersonalInfo"];
            allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
            
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.accountInfo.updateSuccess"] messageContent:nil];
                [account.btn_phone setTitle:self.txt_sdt.text forState:UIControlStateNormal];
                [account.btn_email setTitle:self.txt_email.text forState:UIControlStateNormal];
                [account.popover_changeInfo dismissPopoverAnimated:YES];
            }
            else
            {
                [utils showMessage:@"Quý khách đã cập nhật thông tin không thành công" messageContent:nil];
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
-(BOOL)checkInput
{
    NSString *message=@"";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if(self.txt_sdt.text.length == 0)
    {
        message=[utils.dic_language objectForKey:@"ipad.accountInfo.notPhoneInput"];
    }
    else{
    NSString *firstChar = [self.txt_sdt.text substringWithRange:NSMakeRange(0, 1)];
    
    if(self.txt_sdt.text.length>11 || self.txt_sdt.text.length<8 ||  ![firstChar isEqualToString:@"0"] || [self.txt_sdt.text rangeOfCharacterFromSet:set].location != NSNotFound)
        message=[utils.dic_language objectForKey:@"ipad.accountInfo.worngPhone"];
    else
        if(self.txt_email.text.length>0 && ![utils NSStringIsValidEmail:self.txt_email.text])
            message=[utils.dic_language objectForKey:@"ipad.accountInfo.worngEmail"];
        else
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
    if(message.length>0)
        [utils showMessage:message messageContent:nil];
    
    return message.length==0;
}

@end

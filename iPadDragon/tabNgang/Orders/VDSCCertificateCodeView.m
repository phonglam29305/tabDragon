//
//  VDSCCertificateCodeView.m
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCCertificateCodeView.h"
#import "VDSCCommonUtils.h"

@implementation VDSCCertificateCodeView
{
    VDSCCommonUtils *utils;
}

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
-(void) awakeFromNib
{
    [super awakeFromNib];
    utils = [[VDSCCommonUtils alloc] init];
    self.f_otpNumber.text = [NSString stringWithFormat:@"Số thẻ - %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"OTPNumber"] ];
    
    NSArray *arr = [utils OTPRandomPosition];
    self.otp_number1.text = [arr objectAtIndex:0];
    self.otp_number2.text = [arr objectAtIndex:1];
}

- (void)dealloc {
    [_otp_number1 release];
    [_otp_number2 release];
    [_otp_number1Value release];
    [_otp_number2Value release];
    [_f_otpNumber release];
    [utils release];
    [super dealloc];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.otp_number1Value resignFirstResponder];
    [self.otp_number2Value resignFirstResponder];
}
- (IBAction)btn_saveOTP_touch:(id)sender {
    if([utils otpCherker:self.otp_number1.text OTPPosition2:self.otp_number2.text OTPPosition1_Value:self.otp_number1Value.text OTPPosition2_value:self.otp_number2Value.text isSave:YES])
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveSuccess"] messageContent:nil dismissAfter:1];
        [self setHidden:YES];
    }
    else
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveFail"] messageContent:nil dismissAfter:1];
    }
}
@end

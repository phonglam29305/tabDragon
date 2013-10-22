//
//  VDSCOTPView.m
//  iPadDragon
//
//  Created by vdsc on 4/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOTPView.h"
#import "VDSCCommonUtils.h"

@implementation VDSCOTPView
{
    VDSCCommonUtils *utils;
    NSTimer *timer;
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
    [self resetOtpPosition];
    self.backgroundColor = self.superview.backgroundColor;
    self.f_otpNumber.text=[NSString stringWithFormat:@"Số thẻ - %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"OTPNumber"]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showContent) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)showContent
{
    [self setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"saveOTP"] boolValue]];
    self.f_otpNumber.text=[NSString stringWithFormat:@"Số thẻ - %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"OTPNumber"]];}

- (IBAction)btn_saveOTP_Touch:(id)sender {
    @try{
    if([self checkInput]){
        if([utils otpCherker:self.otp_number1.text OTPPosition2:self.otp_number2.text OTPPosition1_Value:self.otp_number1Value.text OTPPosition2_value:self.otp_number2Value.text isSave:YES])
        {
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveSuccess"] messageContent:nil dismissAfter:3];
            [self setHidden:YES];
        }
        else
        {
            [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveFail"] messageContent:nil dismissAfter:3];
        }
    }
    }
    @catch (NSException *ex) {
        NSLog(ex.description);
    }
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.otp_number1Value resignFirstResponder];
    [self.otp_number2Value resignFirstResponder];
}
-(void) resetOtpPosition
{
    
    NSArray *arr = [utils OTPRandomPosition];
    self.otp_number1.text = [arr objectAtIndex:0];
    self.otp_number2.text = [arr objectAtIndex:1];
    self.otp_number1Value.text=self.otp_number2Value.text=@"";
    //[arr release];
}
-(BOOL)checkInput
{
    if([self.otp_number1Value.text isEqualToString:@""] && [self.otp_number2Value.text isEqualToString:@""])
    {
        [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.notInput"] messageContent:nil dismissAfter:3];
        return NO;
    }
    
    return YES;
}
-(void) dealloc
{
    [_otp_number1 release];
    [_otp_number1Value release];
    [_otp_number2 release];
    [_otp_number2Value release];
    [timer invalidate];
    timer =nil;
    [super dealloc];
}

@end

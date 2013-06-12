//
//  VDSCOTPView.h
//  iPadDragon
//
//  Created by vdsc on 4/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCOTPView : UIView

@property (retain, nonatomic) IBOutlet UILabel *otp_number1;
@property (retain, nonatomic) IBOutlet UILabel *otp_number2;
@property (retain, nonatomic) IBOutlet UITextField *otp_number1Value;
@property (retain, nonatomic) IBOutlet UITextField *otp_number2Value;
@property (retain, nonatomic) IBOutlet UILabel *f_otpNumber;

- (IBAction)btn_saveOTP_Touch:(id)sender;
-(void) resetOtpPosition;
-(BOOL)checkInput;
@end

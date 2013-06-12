//
//  VDSCCertificateCodeView.h
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCCertificateCodeView : UIView
@property (retain, nonatomic) IBOutlet UILabel *otp_number1;
@property (retain, nonatomic) IBOutlet UILabel *otp_number2;
@property (retain, nonatomic) IBOutlet UITextField *otp_number1Value;
@property (retain, nonatomic) IBOutlet UITextField *otp_number2Value;
- (IBAction)btn_saveOTP_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *f_otpNumber;

@end

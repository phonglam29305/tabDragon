//
//  VDSCChangeAccountInfoViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCChangeAccountInfoViewController : UIViewController


@property (retain, nonatomic) IBOutlet UITextField *txt_email;
@property (retain, nonatomic) IBOutlet UITextField *txt_sdt;
@property (retain, nonatomic) IBOutlet UIView *otpView;

- (IBAction)btn_cancel_touch:(id)sender;
- (IBAction)btn_confirm_touch:(id)sender;

@property (retain, nonatomic) id delegate;

@end

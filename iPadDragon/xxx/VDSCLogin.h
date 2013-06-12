//
//  VDSCLogin.h
//  iPadDragon
//
//  Created by vdsc on 12/26/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCLogin : UIView

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *fieldMaTK;
@property (weak, nonatomic) IBOutlet UITextField *fieldMatKhau;
@property (weak, nonatomic) IBOutlet UITextField *fieldMaBaoVe;
@property (weak, nonatomic) IBOutlet UIImageView *capcha;
- (IBAction)btnLogin:(id)sender;

@end

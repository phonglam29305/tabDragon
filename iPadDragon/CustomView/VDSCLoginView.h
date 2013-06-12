//
//  VDSCLoginView.h
//  iPadDragon
//
//  Created by vdsc on 12/25/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface VDSCLoginView : UIView<UITextFieldDelegate>

@property (assign, nonatomic) IBOutlet UIView *loginView;
@property (assign, nonatomic) IBOutlet UITextField *fieldMaTK;
@property (assign, nonatomic) IBOutlet UITextField *fieldMatKhau;
@property (assign, nonatomic) IBOutlet UITextField *fieldMaBaoVe;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (assign, nonatomic) IBOutlet UIImageView *capcha;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableArray *array;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property(assign, nonatomic) UITextField *activeField;

- (IBAction)btnLogin:(id)sender;
@end

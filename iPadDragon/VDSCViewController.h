//
//  VDSCViewController.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCLoginView.h"
#import "VDSCCommonUtils.h"

@interface VDSCViewController : UIViewController<UITextFieldDelegate>


//- (IBAction)login:(id)sender;
- (IBAction)showMainView:(id)sender;
-(void) hideLoginView;
-(void) showLoginView;

@property (assign, nonatomic) IBOutlet UIButton *loginButton;
@property (assign, nonatomic) IBOutlet UIView *viewBackground;
//@property (assign, nonatomic) VDSCLoginView *loginView;
@property (retain, nonatomic) IBOutlet UIView *v_login;


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
@property (retain, nonatomic) IBOutlet UILabel *lbl_danhmuc;
@property (retain, nonatomic) IBOutlet UILabel *lbl_taikhoan;
@property (retain, nonatomic) IBOutlet UILabel *lbl_sodu;
@property (retain, nonatomic) IBOutlet UILabel *lbl_thitruong;
@property (retain, nonatomic) IBOutlet UILabel *lbl_lenh;
@property (retain, nonatomic) IBOutlet UILabel *lbl_dichvu;

- (IBAction)btn_huongDan_touch:(id)sender;
@end

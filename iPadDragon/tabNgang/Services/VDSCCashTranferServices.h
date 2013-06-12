//
//  VDSCCashTranferServices.h
//  iPadDragon
//
//  Created by Lion User on 02/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"
#import "VDSCOrderTypeView.h"
#import "VDSCOTPView.h"
#import "RadioButton.h"
#import "ASIHTTPRequest.h"
#import "HMSegmentedControl.h"



@interface VDSCCashTranferServices : UIView<UITableViewDelegate,UITableViewDataSource,OCCalendarDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate>


@property (retain, nonatomic) IBOutlet UIView *tab;
@property (retain, nonatomic) IBOutlet UITableView *tabDetailCashTranfer;
- (IBAction)btn_DenNgay_touch:(id)sender;
- (IBAction)btn_TuNgay_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_TuNgay;
@property (retain, nonatomic) IBOutlet UITextField *txt_DenNgay;

@property (retain, nonatomic) IBOutlet UIButton *btn_DenNgay;
@property (retain, nonatomic) IBOutlet UIButton *btn_TuNgay;
@property (retain, nonatomic) IBOutlet VDSCOrderTypeView *cb_TaiKhoanNhan;


@property (retain, nonatomic) IBOutlet UILabel *txtMaTK;
@property (retain, nonatomic) IBOutlet UITextView *txtTenTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *txtTienCoTheChuyen;
@property (retain, nonatomic) IBOutlet UILabel *txtTienMatThucCo;
@property (retain, nonatomic) IBOutlet UILabel *txtMucPhiChuyenKhoan;

@property (retain, nonatomic) IBOutlet UITextField *txtSoTienChuyen;
@property (retain, nonatomic) IBOutlet UILabel *txtChuTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *txtNganHang;
@property (retain, nonatomic) IBOutlet UITextView *txtNoiDungChuyen;
- (IBAction)btn_TaiKhoanNhan_touch:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *txtTaiKhoanNhan;
@property (retain, nonatomic) IBOutlet UIButton *btn_taikhoannhan;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segNguoiTraPhi;
@property (retain, nonatomic) UIPopoverController *popover;

- (IBAction)btn_XacNhan:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *viewOTP;

- (IBAction)segNguyenChuyen0Nhan1:(id)sender;
- (IBAction)btn_LoadHisCashTransfer:(id)sender;

- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;
@property (strong, nonatomic) id delegate;
@property (retain, nonatomic) HMSegmentedControl *segmentedControl;
@end

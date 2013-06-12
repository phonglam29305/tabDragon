//
//  VDSCSMSRegisterViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCSMSRegisterViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *f_soTK;
@property (retain, nonatomic) IBOutlet UILabel *f_hoTen;
@property (retain, nonatomic) IBOutlet UISegmentedControl *f_loaiDK;
@property (retain, nonatomic) IBOutlet UITextField *txt_sdt;
@property (retain, nonatomic) IBOutlet UIView *v_khoplenh;
@property (retain, nonatomic) IBOutlet UIView *v_chungKhoan;
@property (retain, nonatomic) IBOutlet UIView *v_tien;
@property (retain, nonatomic) IBOutlet UIView *v_margin;
@property (retain, nonatomic) IBOutlet UIView *v_soDu;
@property (retain, nonatomic) IBOutlet UIView *v_dieuKhoan;
@property (retain, nonatomic) IBOutlet UIView *otpView;
- (IBAction)seg_hinhThuc:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *v_dichVu;
- (IBAction)btn_confirm_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_confirm;
- (IBAction)btn_cancel_touch:(id)sender;

@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UIView *viewConfirm;

@end

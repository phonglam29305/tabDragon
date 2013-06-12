//
//  VDSCMarginTransServices.h
//  iPadDragon
//
//  Created by Lion User on 04/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"
#import "VDSCMarginTransType.h"

@interface VDSCMarginTransServices : UIView<UITableViewDelegate,UITableViewDataSource, OCCalendarDelegate,UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btn_DenNgay;
@property (retain, nonatomic) IBOutlet UIButton *btn_TuNgay;

- (IBAction)btn_DenNgay_touch:(id)sender;
- (IBAction)btn_TuNgay_touch:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *txtDenNgay;
@property (retain, nonatomic) IBOutlet UITextField *txtTuNgay;

@property (retain, nonatomic) IBOutlet UIView *viGDTangDuNo;
@property (retain, nonatomic) IBOutlet UIView *viGDGiamDuNo;
@property (retain, nonatomic) IBOutlet UIView *viGDGiamHopDong;

@property (retain, nonatomic) IBOutlet UIButton *btn_switchServices;

- (IBAction)btn_confirm_touch:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;

- (IBAction)btn_TKUyQuyenNhanChuyenKhoanSucMua_touch:(id)sender;
- (IBAction)btn_loaiGD_touch:(id)sender;

- (IBAction)btn_LoaiGiaoDich:(id)sender;
-(void)switchServices;

- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;

-(void)getAmountOfAuthorized;
@property (retain, nonatomic) IBOutlet UITableView *table_list;

- (IBAction)btn_refresh_touch:(id)sender;

@property (assign, nonatomic) int loaiGD1_listLoaiGD2_TKUQ3;
@property (retain, nonatomic)  UIPopoverController *popoverController;
@property (retain, nonatomic) IBOutlet UILabel *f_tienCoTheTraNo;
@property (retain, nonatomic) IBOutlet UITextField *txt_giamNoGoc;
@property (retain, nonatomic) IBOutlet UILabel *f_tienLai;
@property (retain, nonatomic) IBOutlet UIView *otpView;
@property (retain, nonatomic) IBOutlet UIButton *btn_TKUyQuyen;
@property (retain, nonatomic) IBOutlet UITextField *txt_tangNo;
@property (retain, nonatomic) IBOutlet UILabel *f_tienDcGhiNo;
@property (retain, nonatomic) IBOutlet UITextField *txt_tienTangNo;
@property (retain, nonatomic) IBOutlet UILabel *f_ngayHetHan;
@property (retain, nonatomic) IBOutlet UILabel *f_tyleKQ;
@property (retain, nonatomic) IBOutlet UILabel *f_phiGiaHan;
@property (retain, nonatomic) IBOutlet UILabel *f_taiTroMuaTrongNgay;
@property (retain, nonatomic) IBOutlet UILabel *f_tienDcPhepGhiNo;
@property (retain, nonatomic) IBOutlet UILabel *f_tienMatThucCo;
@property (retain, nonatomic) IBOutlet UILabel *f_tienUngTruoc;
@property (retain, nonatomic) IBOutlet UILabel *f_duNoKQ;
@property (retain, nonatomic) IBOutlet UILabel *f_laiKQ;
@property (retain, nonatomic) IBOutlet UILabel *f_tongKhopMua;
@property (retain, nonatomic) IBOutlet UIButton *btn_LoaiGD;

@property (retain, nonatomic) IBOutlet UILabel *f_ngayHetHanTiepThep;
@end

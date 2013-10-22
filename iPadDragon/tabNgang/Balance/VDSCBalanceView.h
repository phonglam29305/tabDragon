//
//  VDSCBalanceView.h
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCBalanceView : UIView
@property (retain, nonatomic) IBOutlet UIView *tabbBalance;
//------------------
@property (retain, nonatomic) IBOutlet UILabel *txtTienCoTheRut;
@property (retain, nonatomic) IBOutlet UILabel *txtTienMatThucCo;
@property (retain, nonatomic) IBOutlet UILabel *txtTienCoTheUngTruoc;
@property (retain, nonatomic) IBOutlet UILabel *txtTienDaUngTruoc;
@property (retain, nonatomic) IBOutlet UILabel *txtTongMuaKhopTrongNgay;
//-----------------
@property (retain, nonatomic) IBOutlet UILabel *txtLaiTienGui;
@property (retain, nonatomic) IBOutlet UILabel *txtTienLaiKyQuy;
@property (retain, nonatomic) IBOutlet UILabel *txtDuNoKyQuy;
@property (retain,nonatomic) IBOutlet UILabel *txtDuNoCamCo;
@property (retain, nonatomic) IBOutlet UILabel *txtChuaThanhToan;
//-----------------
@property (retain, nonatomic) IBOutlet UILabel *txtTongTienBanChungKhoan;
//@property (retain, nonatomic) IBOutlet UILabel *txtTongTienBanChungKhoan;
@property (retain, nonatomic) IBOutlet UILabel *txtGiaTriNgay_T;
@property (retain, nonatomic) IBOutlet UILabel *txtGiaTriNgay_T_1;
@property (retain, nonatomic) IBOutlet UILabel *txtGiaTriNgay_T_2;
//-----------------
@property (retain, nonatomic) IBOutlet UILabel *txtTongGiaTriTaiKhoan;

@property (retain, nonatomic) IBOutlet UILabel *txtGiaTriTien;
@property (retain, nonatomic) IBOutlet UILabel *lbColorGiaTriTien;
@property (retain, nonatomic) IBOutlet UILabel *txtGiaTriCK;
@property (retain, nonatomic) IBOutlet UILabel *lbColorGiaTriCK;
@property (retain, nonatomic) IBOutlet UILabel *txtTongTaiSan;
@property (retain, nonatomic) IBOutlet UILabel *lbColorTongTaiSan;
@property(retain, nonatomic) id delegate;


@property(retain, nonatomic) NSArray *array_ObjectStockBaklance;
@property(retain, nonatomic) NSArray *array_ObjectStockStatus;
@property (nonatomic,assign)  double TongTienGiaTriChungKhoan;
@property (nonatomic,assign)  double TongTienKhaNangNhanNo;

@property(retain, nonatomic) NSTimer *timer;
@end

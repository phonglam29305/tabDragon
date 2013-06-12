//
//  VDSCCashTranferServicesCell.h
//  iPadDragon
//
//  Created by Lion User on 03/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VDSCOjectCashTransfer.h>


@interface VDSCCashTranferServicesCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lbNgayGD;
@property (retain, nonatomic) IBOutlet UILabel *lbTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lbSoTien;

@property (retain, nonatomic) IBOutlet UILabel *lbPhiChuyenKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lbNguoiTraPhi;
@property (retain, nonatomic) IBOutlet UILabel *lbTrangThai;
@property (retain, nonatomic) IBOutlet UILabel *lbNguoiXacNhan;

@property (retain, nonatomic) IBOutlet UILabel *lbGhiChu;
-(void)setData2Cell:(VDSCOjectCashTransfer*)Entity;

@end

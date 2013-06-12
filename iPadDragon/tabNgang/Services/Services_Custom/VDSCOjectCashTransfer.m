//
//  VDSCOjectCashTransfer.m
//  iPadDragon
//
//  Created by Lion User on 16/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOjectCashTransfer.h"

@implementation VDSCOjectCashTransfer
-(VDSCOjectCashTransfer*) init
{
    self.fNgayGiaoDich=[NSDate date];
    self.fTaiKhoan=@"";
    self.fSoTien=0;
    self.fPhiChuyenKhoan=0;
    self.fNguoiTraPhi=@"";
    self.fTrangThai=@"";
    self.fNgayXacNhan=@"";
    self.fGhiChu=@"";
    
    return self;
}

@end

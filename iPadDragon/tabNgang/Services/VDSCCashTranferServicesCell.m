//
//  VDSCCashTranferServicesCell.m
//  iPadDragon
//
//  Created by Lion User on 03/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCCashTranferServicesCell.h"
#import "VDSCCommonUtils.h"
#import "VDSCOjectCashTransfer.h"

@implementation VDSCCashTranferServicesCell{
    VDSCCommonUtils *utils;

}

@synthesize lbGhiChu=_lbGhiChu;
@synthesize lbNgayGD=_lbNgayGD;
@synthesize lbNguoiTraPhi=_lbNguoiTraPhi;
@synthesize lbNguoiXacNhan=_lbNguoiXacNhan;
@synthesize lbPhiChuyenKhoan=_lbPhiChuyenKhoan;
@synthesize lbSoTien=_lbSoTien;
@synthesize lbTaiKhoan=_lbTaiKhoan;
@synthesize lbTrangThai=_lbTrangThai;


//--111111111111111-----------
-(void)awakeFromNib
{
    [super awakeFromNib];
    utils =[[VDSCCommonUtils alloc]init];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"VDSCCashTranferServicesCell"];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"VDSCCashTranferServicesCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)setData2Cell:(VDSCOjectCashTransfer *)EntityCashTransfer
{
    
    @try{
      //  VDSCOjectCashTransfer *object=EntityCashTransfer;
        if(EntityCashTransfer != nil)
        {
         self.lbGhiChu.text=EntityCashTransfer.fGhiChu;
         self.lbNgayGD.text=EntityCashTransfer.fNgayGiaoDich;
            
        double d= EntityCashTransfer.fSoTien;            
          self.lbSoTien.text=[NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
        d= EntityCashTransfer.fPhiChuyenKhoan;
          self.lbPhiChuyenKhoan.text=[NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
          self.lbNguoiTraPhi.text=  EntityCashTransfer.fNguoiTraPhi;
          self.lbNguoiXacNhan.text= EntityCashTransfer.fNgayXacNhan;
          self.lbTaiKhoan.text= EntityCashTransfer.fTaiKhoan;
          self.lbTrangThai.text=EntityCashTransfer.fTrangThai;
            
        }
        else
        {
           
            
        }
        
    }
    @catch (NSException *er) {
        // NSLog([NSString stringWithFormat:@"Loi set data 2 cell (stockstatus): %s",er.description]);
        
    }
    @finally {
    }
    
}
- (void)dealloc {
    [_lbNgayGD release];
    [_lbTaiKhoan release];
    [_lbSoTien release];
    [_lbPhiChuyenKhoan release];
    [_lbNguoiTraPhi release];
    [_lbTrangThai release];
    [_lbNguoiXacNhan release];
    [_lbGhiChu release];
    [super dealloc];
}
@end

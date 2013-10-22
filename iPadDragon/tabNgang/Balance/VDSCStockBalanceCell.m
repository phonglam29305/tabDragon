//
//  VDSCStockBalanceCell.m
//  iPadDragon
//
//  Created by Lion User on 01/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCStockBalanceCell.h"
#import "VDSCObjectStockBalance.h"
#import "VDSCCommonUtils.h"

@implementation VDSCStockBalanceCell
{
    VDSCCommonUtils *utils;
}
@synthesize lb_BanChoThanhToan;
@synthesize lb_GiaThiTruong;
@synthesize lb_TyLeVay;
@synthesize lb_GiaTriThiTruong;
@synthesize lb_KhaNangNhanNo;
@synthesize lb_MaCK;
@synthesize lb_KhoiLuong;
@synthesize lb_GiaoDich;
@synthesize lb_CKMuaChoKhop;
@synthesize lb_MuaChoVeT;
@synthesize lb_MuaChoVeT1;
@synthesize lb_MuaChoVeT2;
@synthesize lb_MuaChoVeT3;


//--111111111111111-----------
-(void)awakeFromNib
{
    [super awakeFromNib];
    utils=[[VDSCCommonUtils alloc]init];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{      
    self = [super initWithStyle:style reuseIdentifier:@"VDSCStockBalanceCell"];
    if (self) {      
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
}
//---------------------------------------------------------------------

-(void)setData2Cell:(VDSCObjectStockBalance *) entityStockBalance
{
    //VDSCObjectStockBance * entityStockBalance   =[[VDSCObjectStockBance alloc]init];
    @try{
            
        if (entityStockBalance!=nil)
        {                     
            self.lb_MaCK.text= [NSString stringWithFormat:@"%@",entityStockBalance.MaCK];
              
            double d=entityStockBalance.TongSoLuong ;
            self.lb_KhoiLuong.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            d=entityStockBalance.GiaoDich ;
            self.lb_GiaoDich.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d=entityStockBalance.CKMuaChoKhop ;
            self.lb_CKMuaChoKhop.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
           
            
            d=entityStockBalance.MuaChoVe_T ;
            self.lb_MuaChoVeT.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
           
            
            d=entityStockBalance.MuaChoVe_T1 ;
            self.lb_MuaChoVeT1.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
              
             
            d=entityStockBalance.MuaChoVe_T2 ;
            self.lb_MuaChoVeT2.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
            d=entityStockBalance.MuaChoVe_T3 ;
            self.lb_MuaChoVeT3.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d=entityStockBalance.BanChoThanhToan ;
            self.lb_BanChoThanhToan.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d=entityStockBalance.TyLeVay ;
            self.lb_TyLeVay.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            d=entityStockBalance.GiaThiTruong ;
            self.lb_GiaThiTruong.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]];
            
            d=entityStockBalance.GiaTriThiTruong ;
            self.lb_GiaTriThiTruong.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d=entityStockBalance.KhaNangNhanNo ;
            self.lb_KhaNangNhanNo.text= [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
                       
        }
    }
    @catch (NSException *ex)
        {
       // NSLog([NSString stringWithFormat:@"Loi set Data2Cell (so du chung khoan): %@",ex.description]);
    }
    @finally {
            
        }
   // lb_KhoiLuong.text=entityStockBalance.SoLuong;
    
}
//------------------------------------------------------------------------
- (void)dealloc {

    [lb_MaCK release];
    [lb_KhoiLuong release];
    [lb_GiaoDich release];
    [lb_CKMuaChoKhop release];
    [lb_MuaChoVeT release];
    [lb_MuaChoVeT1 release];
    [lb_MuaChoVeT2 release];
    [lb_MuaChoVeT3 release];
    [lb_BanChoThanhToan release];
    [lb_TyLeVay release];
    [lb_GiaThiTruong release];
    [lb_GiaTriThiTruong release];
    [lb_KhaNangNhanNo release];
    [super dealloc];
}
@end

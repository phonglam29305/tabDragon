//
//  VDSCStockStatusCell_.m
//  iPadDragon
//
//  Created by Lion User on 01/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCStockStatusCell_.h"
#import "VDSCObjectStockBalance.h"
#import "VDSCCommonUtils.h"



@implementation VDSCStockStatusCell_{
    VDSCCommonUtils *Utils;
}
@synthesize lb_MaCK;
@synthesize lb_TongKL;
@synthesize lb_GiaoDich;
@synthesize lb_MuaChoVe;
@synthesize lb_BanChoThanhToan;
@synthesize lb_HanCheChuyenNhuong;
@synthesize lb_CamCo;
@synthesize lb_PhongToa;
@synthesize lb_ChoGiaoDich;
@synthesize lb_QuyenChoPhanBo;
@synthesize lb_BanChoKhop;
@synthesize CellData=_CellData;

//--111111111111111-----------
-(void)awakeFromNib
{
    [super awakeFromNib];
    Utils=[[VDSCCommonUtils alloc]init];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"VDSCStockStatusCell_"];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"VDSCStockStatusCell_" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        //[self setBackgroundView:[nibArray objectAtIndex:1]];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)SetData2Cell:(VDSCObjectStockBalance *)EntityStockStatus
//-(void)SetData2Cell:(NSString *)abc
{
    
    @try{
      if(self.CellData!=nil && EntityStockStatus != nil)
      {
         self.lb_MaCK.text=EntityStockStatus.MaCK;
          
        double d= EntityStockStatus.TongSoLuong;
          
        self.lb_TongKL.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.GiaoDich ;
        self.lb_GiaoDich.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        
        d=EntityStockStatus.TongMuaChoVe ;
        self.lb_MuaChoVe.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.BanChoKhop ;
        self.lb_BanChoKhop.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.BanChoThanhToan ;
        self.lb_BanChoThanhToan.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.HanCheChuyenNhuong ;
        self.lb_HanCheChuyenNhuong.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.CamCo ;
        self.lb_CamCo.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.PhongToa ;
        self.lb_PhongToa.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.ChoGiaoDich ;
        self.lb_ChoGiaoDich.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=EntityStockStatus.QuyenChoPhanBo ;
        self.lb_QuyenChoPhanBo.text=[NSString stringWithFormat:@"%@  ",[Utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
      }
    else
    {
        self.lb_MaCK.text=@"--";        
        self.lb_TongKL.text=@"0  ";
        self.lb_GiaoDich.text=@"0  ";
        self.lb_MuaChoVe.text=@"0  ";
        self.lb_BanChoKhop.text=@"0  ";
        self.lb_BanChoThanhToan.text=@"0  ";
        self.lb_HanCheChuyenNhuong.text=@"0  ";
        self.lb_CamCo.text=@"0  ";
        self.lb_PhongToa.text=@"0  ";
        self.lb_ChoGiaoDich.text=@"0  ";
        self.lb_QuyenChoPhanBo.text=@"0  ";
        
     }
        
    }
    @catch (NSException *er) {
       // NSLog([NSString stringWithFormat:@"Loi set data 2 cell (stockstatus): %s",er.description]);
       
    }
    @finally {
    }
   
}

- (void)dealloc {
    [lb_MaCK release];
    [lb_TongKL release];
    [lb_GiaoDich release];
    [lb_MuaChoVe release];
    [lb_BanChoThanhToan release];
    [lb_HanCheChuyenNhuong release];
    [lb_CamCo release];
    [lb_PhongToa release];
    [lb_ChoGiaoDich release];
    [lb_QuyenChoPhanBo release];
    [lb_BanChoKhop release];
    [super dealloc];
}


@end

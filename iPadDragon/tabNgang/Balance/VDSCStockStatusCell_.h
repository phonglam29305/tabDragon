//
//  VDSCStockStatusCell_.h
//  iPadDragon
//
//  Created by Lion User on 01/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VDSCObjectStockBalance.h>

@interface VDSCStockStatusCell_ : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lb_MaCK;
@property (retain, nonatomic) IBOutlet UILabel *lb_TongKL;
@property (retain, nonatomic) IBOutlet UILabel *lb_GiaoDich;

@property (retain, nonatomic) IBOutlet UILabel *lb_MuaChoVe;
@property (retain, nonatomic) IBOutlet UILabel *lb_BanChoThanhToan;
@property (retain, nonatomic) IBOutlet UILabel *lb_HanCheChuyenNhuong;
@property (retain, nonatomic) IBOutlet UILabel *lb_CamCo;
@property (retain, nonatomic) IBOutlet UILabel *lb_PhongToa;

@property (retain, nonatomic) IBOutlet UILabel *lb_ChoGiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *lb_QuyenChoPhanBo;

@property (retain, nonatomic) IBOutlet UILabel *lb_BanChoKhop;

@property (strong,nonatomic) VDSCStockStatusCell_ *CellData;
-(void)SetData2Cell:(VDSCObjectStockBalance *)OjectStockStatusEntity;

@end

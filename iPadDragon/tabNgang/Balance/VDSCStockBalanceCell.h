//
//  VDSCStockBalanceCell.h
//  iPadDragon
//
//  Created by Lion User on 01/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VDSCObjectStockBalance.h>

@interface VDSCStockBalanceCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lb_MaCK;
@property (retain, nonatomic) IBOutlet UILabel *lb_KhoiLuong;
@property (retain, nonatomic) IBOutlet UILabel *lb_GiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *lb_CKMuaChoKhop;
@property (retain, nonatomic) IBOutlet UILabel *lb_MuaChoVeT;
@property (retain, nonatomic) IBOutlet UILabel *lb_MuaChoVeT1;
@property (retain, nonatomic) IBOutlet UILabel *lb_MuaChoVeT2;
@property (retain, nonatomic) IBOutlet UILabel *lb_MuaChoVeT3;

@property (retain, nonatomic) IBOutlet UILabel *lb_BanChoThanhToan;
@property (retain, nonatomic) IBOutlet UILabel *lb_GiaThiTruong;

@property (retain, nonatomic) IBOutlet UILabel *lb_TyLeVay;

@property (retain, nonatomic) IBOutlet UILabel *lb_GiaTriThiTruong;
@property (retain, nonatomic) IBOutlet UILabel *lb_KhaNangNhanNo;

-(void)setData2Cell:(VDSCObjectStockBalance*)Entity;

@end









//
//  VDSCPriceBoardEntity.h
//  iPadDragon
//
//  Created by vdsc on 12/29/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCPriceBoardEntity : NSObject
@property (assign, nonatomic) bool loadOK;
@property (strong, nonatomic) NSString *f_tenCty;
@property (strong, nonatomic) NSArray *f_ma;
@property (strong, nonatomic) NSArray *f_tran;
@property (strong, nonatomic) NSArray *f_san;
@property (strong, nonatomic) NSArray *f_thamchieu;


@property (strong, nonatomic) NSArray *f_mua4_kl;
@property (strong, nonatomic) NSArray *f_mua3_gia;
@property (strong, nonatomic) NSArray *f_mua3_kl;
@property (strong, nonatomic) NSArray *f_mua2_gia;
@property (strong, nonatomic) NSArray *f_mua2_kl;
@property (strong, nonatomic) NSArray *f_mua1_gia;
@property (strong, nonatomic) NSArray *f_mua1_kl;


@property (strong, nonatomic) NSArray *f_kl_gia;
@property (strong, nonatomic) NSArray *f_kl_kl;
@property (strong, nonatomic) NSArray *f_kl_tangGiam;
@property (strong, nonatomic) NSArray *f_kl_tongkl;

@property (strong, nonatomic) NSArray *f_ban1_gia;
@property (strong, nonatomic) NSArray *f_ban1_kl;
@property (strong, nonatomic) NSArray *f_ban2_gia;
@property (strong, nonatomic) NSArray *f_ban2_kl;
@property (strong, nonatomic) NSArray *f_ban3_gia;
@property (strong, nonatomic) NSArray *f_ban3_kl;
@property (strong, nonatomic) NSArray *f_ban4_kl;

@property (strong, nonatomic) NSArray *f_moCua;
@property (strong, nonatomic) NSArray *f_cao;
@property (strong, nonatomic) NSArray *f_thap;
@property (strong, nonatomic) NSArray *f_trungBinh;

@property (strong, nonatomic) NSArray *f_nuocNgoai_mua;
@property (strong, nonatomic) NSArray *f_nuocNgoai_ban;
@property (strong, nonatomic) NSArray *f_room;

@property (strong, nonatomic) NSString *f_maCK;
@property (strong, nonatomic) NSString *f_sanGD;
@property (assign, nonatomic) int f_marginPer;



@end

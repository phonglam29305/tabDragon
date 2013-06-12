//
//  VDSCPriceBoardEntity.m
//  iPadDragon
//
//  Created by vdsc on 12/29/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCPriceBoardEntity.h"

@implementation VDSCPriceBoardEntity
-(VDSCPriceBoardEntity*)init
{
    VDSCPriceBoardEntity *entity = [VDSCPriceBoardEntity alloc];
    
    entity.f_tran = [[NSArray alloc] initWithObjects:@"0", @"", nil];
    entity.f_san = [[NSArray alloc] initWithObjects:@"0", @"", nil];
    entity.f_thamchieu = [[NSArray alloc] initWithObjects:@"0", @"", nil];
    entity.f_trungBinh = [[NSArray alloc] initWithObjects:@"0", @"", nil];
    
    return entity;
}

-(void) dealloc
{
    [_f_ma release];
    _f_ma = nil;
    [_f_tran release];
    _f_tran=nil;
    [_f_san release];
    _f_san=nil;
    [_f_thamchieu release];
    _f_thamchieu =nil;
    [_f_mua3_gia release];
    _f_mua3_gia=nil;
    [_f_mua3_kl release];
    _f_mua3_kl=nil;
    [_f_mua2_gia release];
    _f_mua2_gia=nil;
    [_f_mua2_kl release];
    _f_mua2_kl=nil;
    [_f_mua1_gia release];
    _f_mua1_gia=nil;
    [_f_mua1_kl release];
    _f_mua1_kl =nil;
    [_f_kl_gia release];
    _f_kl_gia =nil;
    [_f_kl_kl release];
    _f_kl_kl =nil;
    [_f_kl_tangGiam release];
    _f_kl_tangGiam  =nil;
    [_f_kl_tongkl release];
    _f_kl_tongkl =nil;
    [_f_ban1_gia release];
    _f_ban1_gia  =nil;
    [_f_ban1_kl release];
    _f_ban1_kl =nil;
    [_f_ban2_gia release];
    _f_ban2_gia =nil;
    [_f_ban2_kl release];
    _f_ban2_kl =nil;
    [_f_ban3_gia release];
    _f_ban3_gia=nil;
    [_f_ban3_kl release];
    _f_ban3_kl=nil;
    [_f_nuocNgoai_mua release];
    _f_nuocNgoai_mua  =nil;
    [_f_moCua release];
    _f_moCua=nil;
    [_f_cao release];
    _f_cao =nil;
    [_f_thap release];
    _f_thap=nil;
    [_f_trungBinh release];
    _f_trungBinh=nil;
    [super dealloc];
}
@end

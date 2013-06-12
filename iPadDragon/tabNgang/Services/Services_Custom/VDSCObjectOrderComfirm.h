//
//  VDSCObjectOrderComfirm.h
//  iPadDragon
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDSCObjectOrderComfirm.h"

@interface VDSCObjectOrderComfirm : NSObject

@property (nonatomic,assign) int fSTT;
@property (nonatomic,strong)NSString *fNgayGD;
@property (nonatomic,strong)NSString *fLenh;
@property (nonatomic,strong)NSString *fMuaBan;
@property (nonatomic,strong)NSString *fLoai;
@property (nonatomic,strong)NSString *fSan;
@property (nonatomic,strong)NSString *fMaCK;
@property (nonatomic,assign)double fKLDat;
@property (nonatomic,assign)double fGiaDat;
@property (nonatomic,assign)double fKLHuy;
@property (nonatomic,strong)NSString *fOrderID;
@property (nonatomic,assign)BOOL checked;
@end

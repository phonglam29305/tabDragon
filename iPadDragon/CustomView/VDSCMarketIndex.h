//
//  VDSCMarketIndex.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCIndexEntity.h"

@interface VDSCMarketIndex : UIView
@property (retain, nonatomic) IBOutlet UILabel *marketName;
@property (retain, nonatomic) IBOutlet UILabel *changePer;
@property (retain, nonatomic) IBOutlet UILabel *value;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UILabel *mark;
@property (retain, nonatomic) IBOutlet UILabel *change;

-(void)initValue:(VDSCIndexEntity *)indexEntity;
@end

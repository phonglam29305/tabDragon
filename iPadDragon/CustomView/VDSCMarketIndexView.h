//
//  VDSCMarketIndexView.h
//  iPadDragon
//
//  Created by vdsc on 1/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCMarketIndex.h"

@interface VDSCMarketIndexView : UIView

@property (strong, nonatomic) VDSCMarketIndex *ho_index;
@property (strong, nonatomic) VDSCMarketIndex *ho30_index;
@property (strong, nonatomic) VDSCMarketIndex *ha_index;
@property (strong, nonatomic) VDSCMarketIndex *ha30_index;
@property (strong, nonatomic) VDSCMarketIndex *upcom_index;

@property (retain, nonatomic) IBOutlet UIView *marketIndex;
@property (strong, nonatomic) id delegate;
-(void) loadData;
-(NSString*)htmlBuilder;
@end

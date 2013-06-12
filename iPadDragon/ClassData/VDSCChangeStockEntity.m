//
//  VDSCChangeStockEntity.m
//  iPadDragon
//
//  Created by vdsc on 1/8/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCChangeStockEntity.h"

@implementation VDSCChangeStockEntity

-(void) dealloc
{
    [_code release];
    _code =nil;
    [_value release];
    _value=nil;
    [_color release];
    _color=nil;
    [super dealloc];
    
}
@end

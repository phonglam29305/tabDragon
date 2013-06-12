//
//  VDSCIndexEntity.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCIndexEntity.h"

@implementation VDSCIndexEntity
-(VDSCIndexEntity*)init
{
    VDSCIndexEntity *entity = [VDSCIndexEntity alloc];
    entity.marketName=@"";
    entity.mark=@"0";
    entity.value = @"0";
    entity.changePer = @"0";
    entity.change = @"0";
    entity.amount = @"0";
    entity.color = @"0";
    return entity;
}

-(VDSCIndexEntity*)initWithObjects: (NSString*)marketName :(NSString*)value :(NSString*)changePer :(NSString*)mark :(NSString*) change : (NSString*) amount : (NSString*)color
{
    VDSCIndexEntity *entity = [VDSCIndexEntity alloc];
    entity.marketName = marketName;
    entity.value = value;
    entity.changePer = changePer;
    entity.mark = mark;
    entity.change = change;
    entity.amount = amount;
    entity.color = color;
    
    return entity;
}
@end

//
//  VDSCSystemParams.m
//  iPadDragon
//
//  Created by vdsc on 4/1/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCSystemParams.h"
#import "VDSCCommonUtils.h"

@implementation VDSCSystemParams

-(VDSCSystemParams*) init
{
    self.orderStatusList = [[NSMutableArray alloc] init];
    self.hsxOrderType = [[NSMutableArray alloc] init];
    self.hnxOrderType = [[NSMutableArray alloc] init];
    self.upcomOrderType = [[NSMutableArray alloc] init];
    self.hoseStepPrice = [[NSMutableArray alloc] init];
    self.hnxStepPrice = [[NSMutableArray alloc] init];
    self.upcomStepPrice = [[NSMutableArray alloc] init];
    
    VDSCCommonUtils *utils = [[VDSCCommonUtils alloc] init];
    //VDSCSystemParams *params = [VDSCSystemParams alloc];
    
    NSArray *arr = [[NSArray alloc] initWithObjects: nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"systemParams"];
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    //NSArray *data = [[allDataDictionary objectForKey:@"list"] copy];
    for(NSArray *obj in [allDataDictionary objectForKey:@"orderStatusList"] )
    {
        [self.orderStatusList addObject:obj];
    }
    for(NSArray *obj in [allDataDictionary objectForKey:@"hsxOrderType"] )
    {
        [self.hsxOrderType addObject:obj];
    }
    for(NSArray *obj in [allDataDictionary objectForKey:@"hnxOrderType"] )
    {
        [self.hnxOrderType addObject:obj];
    }
    for(NSArray *obj in [allDataDictionary objectForKey:@"upcomOrderType"] )
    {
        [self.upcomOrderType addObject:obj];
    }
    //[self.hoseStepPrice addObject:[allDataDictionary objectForKey:@"hoseStepPrice"]];
    //[self.hnxStepPrice addObject:[allDataDictionary objectForKey:@"hnxStepPrice"]];
    //[self.upcomStepPrice addObject:[allDataDictionary objectForKey:@"upcomStepPrice"]];
    for(NSArray *obj in [allDataDictionary objectForKey:@"hoseStepPrice"] )
    {
        [self.hoseStepPrice addObject:obj];
    }
    for(NSArray *obj in [allDataDictionary objectForKey:@"hnxStepPrice"] )
    {
        [self.hnxStepPrice addObject:obj];
    }
    for(NSArray *obj in [allDataDictionary objectForKey:@"upcomStepPrice"] )
    {
        [self.upcomStepPrice addObject:obj];
    }
    self.hoseMaxOrderQty = [[allDataDictionary objectForKey:@"hoseMaxOrderQty"] doubleValue];
    self.hnxMaxOrderQty = [[allDataDictionary objectForKey:@"hnxMaxOrderQty"] doubleValue];
    self.upcomMaxOrderQty = [[allDataDictionary objectForKey:@"upcomMaxOrderQty"] doubleValue];
    
    [arr release];
    //[post release];
    //[url release];
    //[allDataDictionary release];
    [utils release];
    
    return self;
}
-(NSArray*) getStepPrice:(NSString*)marketId
{
    if([marketId isEqualToString:@"HO"])
        return self.hoseStepPrice;
    else if([marketId isEqualToString:@"HA"])
        return self.hnxStepPrice;
    else
        return self.upcomStepPrice;
}
-(NSString*) getOrderType:(NSString*)marketId type:(NSString*)type
{
    if([marketId isEqualToString:@"HO"])
    {
        for(NSArray *arr in self.hsxOrderType)
        {
            if([[arr objectAtIndex:0] isEqualToString:type])
                return [arr objectAtIndex:1];
        }
    }
    else
        if([marketId isEqualToString:@"HA"])
        {
            for(NSArray *arr in self.hnxOrderType)
            {
                if([[arr objectAtIndex:0] isEqualToString:type])
                    return [arr objectAtIndex:1];
            }
        }
        else
            if([marketId isEqualToString:@"UPCOM"])
            {
                for(NSArray *arr in self.upcomOrderType)
                {
                    if([[arr objectAtIndex:0] isEqualToString:type])
                        return [arr objectAtIndex:1];
                }
            }
    return type;
}
-(NSString*) getOrderStatus:(NSString*)status langue:(int)VN0_EN1
{
    for(NSArray *arr in self.orderStatusList)
    {
        if([[arr objectAtIndex:0] isEqualToString:status]){
            if(VN0_EN1==0)
                return [arr objectAtIndex:1];
            else
                return [arr objectAtIndex:2];
        }
    }
    return status;
}
-(void) dealloc
{
    [_orderStatusList release];
    [_hsxOrderType release];
    [_hnxOrderType release];
    [_upcomOrderType release];
    [_hoseStepPrice release];
    [_hnxStepPrice release];
    [_upcomStepPrice release];
    [super dealloc];
}

@end

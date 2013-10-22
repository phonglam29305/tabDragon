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
@synthesize orderStatusList;
@synthesize hsxOrderType;
@synthesize hnxOrderType;
@synthesize upcomOrderType;
@synthesize hoseStepPrice;
@synthesize hnxStepPrice;
@synthesize  upcomStepPrice;

-(id) init
{
    self = [super init];
    
    orderStatusList = [[NSMutableArray alloc] init];
    hsxOrderType = [[NSMutableArray alloc] init];
    hnxOrderType = [[NSMutableArray alloc] init];
    upcomOrderType = [[NSMutableArray alloc] init];
    hoseStepPrice = [[NSMutableArray alloc] init];
    hnxStepPrice = [[NSMutableArray alloc] init];
    upcomStepPrice = [[NSMutableArray alloc] init];
    
    VDSCCommonUtils *utils = [[VDSCCommonUtils alloc] init];
    //VDSCSystemParams *params = [VDSCSystemParams alloc];
    
    NSArray *arr = [[NSArray alloc] initWithObjects: nil];
    NSString *post = [utils postValueBuilder:arr];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"systemParams"];
    NSDictionary *allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
    if([allDataDictionary isEqual:[NSNull null]])return self;
    //NSArray *data = [[allDataDictionary objectForKey:@"list"] copy];
    //for (id key in allDataDictionary) {
    //    NSLog(@"key: %@, value: %@ \n", key, [allDataDictionary objectForKey:key]);
    //}
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
    
    self.marketStatus = [allDataDictionary objectForKey:@"marketStatus"];
    self.timeChangeOnlineData = [[allDataDictionary objectForKey:@"timeChangeOnlineData"] doubleValue];
    self.timeChangePriceboard = [[allDataDictionary objectForKey:@"timeChangePriceboard"] doubleValue];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setDouble:self.timeChangeOnlineData forKey:@"timeChangeOnlineData"];
    [user setDouble:self.timeChangePriceboard forKey:@"timeChangePriceboard"];
    [user synchronize];
    self.ternLink = [allDataDictionary objectForKey:@"ternLink"];
    self.supportLink = [allDataDictionary objectForKey:@"supportLink"];
    self.instructionLink = [allDataDictionary objectForKey:@"intructionLink"];
    
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
        if( self.hsxOrderType!=nil &&  self.hsxOrderType.count>0)
        for(NSArray *arr in self.hsxOrderType)
        {
            if([[arr objectAtIndex:0] isEqualToString:type])
                return [arr objectAtIndex:1];
        }
    }
    else
        if([marketId isEqualToString:@"HA"])
        {
            if( self.hnxOrderType!=nil &&  self.hnxOrderType.count>0)
            for(NSArray *arr in self.hnxOrderType)
            {
                if([[arr objectAtIndex:0] isEqualToString:type])
                    return [arr objectAtIndex:1];
            }
        }
        else
            if([marketId isEqualToString:@"UPCOM"])
            {
                if( self.upcomOrderType!=nil &&  self.upcomOrderType.count>0)
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
    if( self.orderStatusList!=nil &&  self.orderStatusList.count>0)
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
    [orderStatusList release];
    [hsxOrderType release];
    [hnxOrderType release];
    [upcomOrderType release];
    [hoseStepPrice release];
    [hnxStepPrice release];
    [upcomStepPrice release];
    [super dealloc];
}

@end

//
//  VDSCStock4OrderEntity.h
//  iPadDragon
//
//  Created by vdsc on 4/12/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCStock4OrderEntity : NSObject

@property (assign, nonatomic) float reference;
@property (assign, nonatomic) double ceiling;
@property (assign, nonatomic) double floor;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *nameEN;
@property (strong, nonatomic) NSString *marketId;
@property (strong, nonatomic) NSString *marketStatus;
@property (assign, nonatomic) double usable;
@property (assign, nonatomic) double block;

@end

//
//  VDSCIndexEntity.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCIndexEntity : NSObject

@property (strong, nonatomic) NSString *marketName;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *changePer;
@property (strong, nonatomic) NSString *mark;
@property (strong, nonatomic) NSString *change;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *color;

-(VDSCIndexEntity*)initWithDefault:(NSString*)marketName;
-(VDSCIndexEntity*)initWithObjects: (NSString*)marketName :(NSString*)value :(NSString*)changePer :(NSString*)mark :(NSString*) change : (NSString*) amount : (NSString*)color;
@end

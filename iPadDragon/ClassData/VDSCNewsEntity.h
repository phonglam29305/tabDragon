//
//  VDSCNewsEntity.h
//  iPadDragon
//
//  Created by vdsc on 1/24/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCNewsEntity : NSObject

@property (strong, nonatomic) NSObject *f_ID;
@property (strong, nonatomic) NSString *f_date;
@property (strong, nonatomic) NSString *f_title;
@property (strong, nonatomic) NSString *f_content;

@property (assign, nonatomic) BOOL *isWebLink;

@end

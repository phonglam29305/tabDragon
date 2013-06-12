//
//  VDSCMarginTransType.h
//  iPadDragon
//
//  Created by vdsc on 4/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCMarginTransType : UIScrollView


@property (strong,nonatomic)NSString *TransType;

-(void)InitSource:(NSArray*)ArraySource;
- (NSString*)GetTransType;

@end

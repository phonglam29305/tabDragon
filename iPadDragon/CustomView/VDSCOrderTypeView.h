//
//  VDSCOrderTypeView.h
//  iPadDragon
//
//  Created by vdsc on 1/31/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCOrderTypeView : UIScrollView

@property (strong, nonatomic)NSString* orderType;
-(void) initSource: (NSArray*) source;
-(void) initSourceOrderType: (NSMutableArray*) source;
-(NSString*) getOrderType;
@end

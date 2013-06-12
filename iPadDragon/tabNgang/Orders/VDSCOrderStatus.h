//
//  VDSCOrderStatus.h
//  iPadDragon
//
//  Created by vdsc on 3/28/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCOrderStatus : NSObject
@property (strong, nonatomic) NSString *tran_date;
@property (strong, nonatomic) NSString *settled_date;
@property (strong, nonatomic) NSString *floor;
@property (strong, nonatomic) NSString *stock;
@property (strong, nonatomic) NSString *side;
@property (assign, nonatomic) double buy_qty;
@property (assign, nonatomic) double buy_price;
@property (assign, nonatomic) double sell_qty;
@property (assign, nonatomic) double sell_price;
@property (assign, nonatomic) double buy_amount;
@property (assign, nonatomic) double sell_amount;
@property (assign, nonatomic) double tax_ratio;
@property (assign, nonatomic) double tax_val;
@property (assign, nonatomic) double fee_ratio;
@property (assign, nonatomic) double fee_val;
@property (assign, nonatomic) double settled_amount;
/*
@property (strong, nonatomic) NSString *order_time;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *order_type;
@property (assign, nonatomic) double cancel_qty;
@property (assign, nonatomic) double match_qty;
@property (assign, nonatomic) double wty_qty;
@property (assign, nonatomic) double match_price;
@property (strong, nonatomic) NSString *order_status;
@property (strong, nonatomic) NSString *order_chanel;
@property (strong, nonatomic) NSString *order_gtd;*/

@end

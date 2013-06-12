//
//  VDSCAccountInfo.h
//  iPadDragon
//
//  Created by vdsc on 1/23/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCClientInfo : NSObject

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientName;
@property (strong, nonatomic) NSString *tradingAccSeq;
@property (strong, nonatomic) NSString *accountType;
@property (strong, nonatomic) NSString *secret;

@property (strong, nonatomic) NSString *idCard;
@property (strong, nonatomic) NSString *isuseDate;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *OTPNumber;



@end

//
//  VDSCMarketIndex.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCMarketIndex.h"
#import "VDSCCommonUtils.h"

@interface VDSCMarketIndex()
{
    NSNumberFormatter *xxx;
    VDSCCommonUtils *utils;
}

@end
@implementation VDSCMarketIndex


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    // Drawing code
    //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"index.jpg"]]];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    utils = [[VDSCCommonUtils alloc] init];
}

-(void) initValue:(VDSCIndexEntity *)indexEntity
{
    if(indexEntity!=nil && indexEntity.marketName!=nil
       && indexEntity.value!=nil
       && ![indexEntity.marketName isEqual:[NSNull null]]
       && ![indexEntity.changePer isEqual:[NSNull null]]
       && ![indexEntity.mark isEqual:[NSNull null]]
       && ![indexEntity.change isEqual:[NSNull null]]
       && ![indexEntity.amount isEqual:[NSNull null]]
       && ![indexEntity.value isEqual:[NSNull null]]
       )
    {
    [[self marketName] setText:indexEntity.marketName];
    double d = [indexEntity.value doubleValue]/1000000;
    [self.value setText:[NSString stringWithFormat:@"KL: %@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]]];
        NSString *symbol = [indexEntity.changePer substringToIndex:1];
    [self.changePer setText:[NSString stringWithFormat:@"%@%%", [indexEntity.changePer stringByReplacingOccurrencesOfString:symbol withString:@""]]];
    [self.mark setText:[NSString stringWithFormat:@"%@", [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:[indexEntity.mark doubleValue]]]]];
    [self.change setText:[NSString stringWithFormat:@"%@%@",symbol,[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:[indexEntity.change doubleValue]]]]];
    d = [indexEntity.amount doubleValue]/1000000000;
    [self.amount setText:[NSString stringWithFormat:@"GT: %@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]]];
    
    self.backgroundColor = [utils getColor:indexEntity.color];
    }
}


- (void)dealloc {
    [_marketName release];
    [_changePer release];
    [_value release];
    [_amount release];
    [_mark release];
    [_change release];
    [utils release];
    [super dealloc];
}
@end

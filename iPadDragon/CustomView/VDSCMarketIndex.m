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
{@try{
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
        NSString *newvalue=[NSString stringWithFormat:@"KL: %@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        BOOL change = [self.value.text isEqualToString:newvalue];
        [self.value setText:newvalue];
        if(!change){
            [self highLight:self.value];
        }
        
        NSString *symbol = [indexEntity.changePer substringToIndex:1];
        newvalue=[NSString stringWithFormat:@"%@%%", [indexEntity.changePer stringByReplacingOccurrencesOfString:symbol withString:@""]];
        change = [self.changePer.text isEqualToString:newvalue];
        [self.changePer setText:newvalue];
        if(!change){
            [self highLight:self.changePer];
        }
        
        newvalue=[NSString stringWithFormat:@"%@", [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:[indexEntity.mark doubleValue]]]];
        change = [self.mark.text isEqualToString:newvalue];
        [self.mark setText:newvalue];
        if(!change){
            [self highLight:self.mark];
        }
        
        newvalue=[NSString stringWithFormat:@"%@%@",symbol,[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:[indexEntity.change doubleValue]]]];
        change = [self.change.text isEqualToString:newvalue];
        [self.change setText:newvalue];
        if(!change){
            [self highLight:self.change];
        }
        
        d = [indexEntity.amount doubleValue]/1000000000;
        newvalue = [NSString stringWithFormat:@"GT: %@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        change = [self.amount.text isEqualToString:newvalue];
        [self.amount setText:newvalue];
        if(!change){
            [self highLight:self.amount];
        }
        self.backgroundColor = [utils getColor:indexEntity.color];
    }
}
    @catch (NSException *ex) {
        NSLog(ex.description);
    }
}
-(void)highLight:(UILabel*)label
{
    @try{
    UILabel *label_tem = [[UILabel alloc]initWithFrame:label.frame];
    label_tem.font = label.font;
    label_tem.textAlignment = label.textAlignment;
    label_tem.textColor=[UIColor darkGrayColor];
    label_tem.text = label.text;
    label_tem.backgroundColor = [UIColor whiteColor];
    [self addSubview:label_tem];
    
    [UIView animateWithDuration:2 animations:^{[label_tem setAlpha:1];
        [label_tem setAlpha:0];} completion:^(BOOL finised){[label_tem removeFromSuperview]; [label_tem release]; }];
}
    @catch (NSException *ex) {
        NSLog(ex.description);
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

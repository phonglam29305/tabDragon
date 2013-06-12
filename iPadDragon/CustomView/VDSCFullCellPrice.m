//
//  VDSCFullCellPriceCell.m
//  iPadDragon
//
//  Created by vdsc on 12/27/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCFullCellPrice.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCFullPriceBoard_PopoverViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCFullCellPrice.h"

@interface VDSCFullCellPrice()
{
    //NSArray *nibArray;
    VDSCCommonUtils *utils;
}
@end

@implementation VDSCFullCellPrice


@synthesize cellData=_cellData;
@synthesize f_ma;
@synthesize f_mua3_gia;
@synthesize f_mua3_kl;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"VDSCFullCellPrice"];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"VDSCFullCellPrice" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        
        if([reuseIdentifier isEqual: @"VDSCFullCellPrice_1"])
            [self setBackgroundView:[nibArray objectAtIndex:1]];
        else
            [self setBackgroundView:[nibArray objectAtIndex:2]];
        
        //[self sendSubviewToBack:self.backgroundView];
    }
    return self;
}
-(void) awakeFromNib
{
    utils = [[VDSCCommonUtils alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //NSLog(self.f_ma.text);
    [super setSelected:selected animated:animated];

    
}

-(void) setCellValue:(VDSCPriceBoardEntity *) price
{
    @try{
        if (price!=nil) {
            self.f_ma.text= [price.f_ma objectAtIndex:0];
            
            self.f_mua3_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_mua3_gia  objectAtIndex:0] doubleValue]]]];
            double d = [[price.f_mua3_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua3_kl.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_mua2_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_mua2_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_mua2_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua2_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            if( [[price.f_mua1_gia  objectAtIndex:0] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
            {
                double d = [[price.f_mua1_gia  objectAtIndex:0] doubleValue]/10;
                self.f_mua1_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            }
            else {
                
                self.f_mua1_gia.text=  [price.f_mua1_gia  objectAtIndex:0];
            }
            
            d = [[price.f_mua1_kl objectAtIndex:0] doubleValue]/10;
            self.f_mua1_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            self.f_kl_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_kl_gia  objectAtIndex:0] doubleValue]]]];            d = [[price.f_kl_kl objectAtIndex:0] doubleValue]/10;
            self.f_kl_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_kl_tangGiam.text= [NSString stringWithFormat:@"%@",[price.f_kl_tangGiam objectAtIndex:0]];
            d = [[price.f_kl_tongkl objectAtIndex:0] doubleValue]/10;
            self.f_kl_tongKL.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            if( [[price.f_ban1_gia  objectAtIndex:0] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
            {
                double d = [[price.f_ban1_gia  objectAtIndex:0] doubleValue]/10;
                self.f_ban1_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            }
            else {
                
                self.f_ban1_gia.text=  [price.f_ban1_gia  objectAtIndex:0];
            }
            
            d = [[price.f_ban1_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban1_kl.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            //self.f_ban1_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban1_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_ban2_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban2_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_ban2_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban2_gia  objectAtIndex:0] doubleValue]]]];
            d = [[price.f_ban3_kl objectAtIndex:0] doubleValue]/10;
            self.f_ban3_kl.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            self.f_ban3_gia.text= [NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: [[price.f_ban3_gia  objectAtIndex:0] doubleValue]]]];
            
            d = [[price.f_nuocNgoai_mua objectAtIndex:0] doubleValue]/10;
            self.f_nnMua.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [[price.f_nuocNgoai_ban objectAtIndex:0] doubleValue]/10;
            self.f_nnBan.text=[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            
            if([[price.f_ma objectAtIndex:1] isEqualToString:@"Z"])
            {
                [self.f_ma setBackgroundColor:[UIColor greenColor]];
                self.f_ma.textColor=[UIColor blueColor];
            }
            else [utils setLabelColor:[price.f_ma objectAtIndex:1] label:self.f_ma];
            
            [utils setLabelColor:[price.f_mua3_gia objectAtIndex:1] label:self.f_mua3_gia];
            [utils setLabelColor:[price.f_mua3_kl objectAtIndex:1] label:self.f_mua3_kl];
            [utils setLabelColor:[price.f_mua2_gia objectAtIndex:1] label:self.f_mua2_gia];
            [utils setLabelColor:[price.f_mua2_kl objectAtIndex:1] label:self.f_mua2_kl];
            [utils setLabelColor:[price.f_mua1_gia objectAtIndex:1] label:self.f_mua1_gia];
            [utils setLabelColor:[price.f_mua1_kl objectAtIndex:1] label:self.f_mua1_kl];
            
            [utils setLabelColor:[price.f_kl_gia objectAtIndex:1] label:self.f_kl_gia];
            [utils setLabelColor:[price.f_kl_kl objectAtIndex:1] label:self.f_kl_kl];
            [utils setLabelColor:[price.f_kl_tangGiam objectAtIndex:1] label:self.f_kl_tangGiam];
            [utils setLabelColor:[price.f_kl_tongkl objectAtIndex:1] label:self.f_kl_tongKL];
            
            [utils setLabelColor:[price.f_ban3_gia objectAtIndex:1] label:self.f_ban3_gia];
            [utils setLabelColor:[price.f_ban3_kl objectAtIndex:1] label:self.f_ban3_kl];
            [utils setLabelColor:[price.f_ban2_gia objectAtIndex:1] label:self.f_ban2_gia];
            [utils setLabelColor:[price.f_ban2_kl objectAtIndex:1] label:self.f_ban2_kl];
            [utils setLabelColor:[price.f_ban1_gia objectAtIndex:1] label:self.f_ban1_gia];
            [utils setLabelColor:[price.f_ban1_kl objectAtIndex:1] label:self.f_ban1_kl];
            
            [utils setLabelColor:[price.f_nuocNgoai_ban objectAtIndex:1] label:self.f_nnBan];
            [utils setLabelColor:[price.f_nuocNgoai_mua objectAtIndex:1] label:self.f_nnMua];
            
            
        }
    }
@catch (NSException *ex) {
    NSLog([NSString stringWithFormat:@"full cell: %@",ex.description]);
}

}

- (void)dealloc {
    [_cellData release];
    [f_ma release];
    [_f_tran release];
    [_f_san release];
    [_f_thamChieu release];
    [f_mua3_gia release];
    [f_mua3_kl release];
    [_f_mua2_gia release];
    [_f_mua2_kl release];
    [_f_mua1_gia release];
    [_f_mua1_kl release];
    [_f_kl_gia release];
    [_f_kl_kl release];
    [_f_kl_tangGiam release];
    [_f_kl_tongKL release];
    [_f_ban1_gia release];
    [_f_ban1_kl release];
    [_f_ban2_gia release];
    [_f_ban2_kl release];
    [_f_ban3_gia release];
    [_f_ban3_kl release];
    //[nibArray release];
    //[[self backgroundColor]release];
    [_f_nnMua release];
    [_f_nnBan release];
    [super dealloc];
}
- (IBAction)btn_showDetail:(id)sender {
    
        VDSCFullPriceBoard_PopoverViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"FullPriceBoard_Popover"];
        //VDSCFullCellPrice *cell = (VDSCFullCellPrice *)[tableView cellForRowAtIndexPath:indexPath];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
        popover.delegate = self.delegate;
        popover_Vew.delegate = self.delegate;
        CGRect rect=CGRectMake(((UIButton*)sender).bounds.origin.x+500, ((UIButton*)sender).bounds.origin.y+5, 50, 30);
        popover_Vew.priceEntity = self.cellData;
        [popover_Vew assignDataToControl];
        popover_Vew.marketInfo = self.delegate;
        [popover presentPopoverFromRect:rect inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
@end

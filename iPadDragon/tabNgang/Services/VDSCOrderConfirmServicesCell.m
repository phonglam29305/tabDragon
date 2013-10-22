//
//  VDSCOrderConfirmServicesCell.m
//  iPadDragon
//
//  Created by vdsc on 4/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderConfirmServicesCell.h"
#import "VDSCCommonUtils.h"
#import "SSCheckBoxView.h"
#import "VDSCOrderConfirmServices.h"


@implementation VDSCOrderConfirmServicesCell
{
    VDSCCommonUtils *utils;

}
@synthesize Entity;

-(void)awakeFromNib
{
    [super awakeFromNib];
    utils=[[VDSCCommonUtils alloc]init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"VDSCOrderConfirmServicesCell"];
    if (self) {
        
    }
    return self;
}

-(void)setData2Cell
{
    @try{
   
    if(Entity != nil)
    {
        
        double d=Entity.fGiaDat;
        if(d==0)
            self.lbGiaDat.text=@"";
        else self.lbGiaDat.text=[NSString stringWithFormat:@"%@  ",[utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=Entity.fSTT;
        
        self.lbSTT.text=[NSString stringWithFormat:@"%@  ",[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];        
        
        d=Entity.fKLDat;
        self.lbKhoiLuongDat.text= [NSString stringWithFormat:@"%@ ",[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
        d=Entity.fKLHuy;
        if(d==0)self.lbKhoiLuongHuy.text=@"";
        else self.lbKhoiLuongHuy.text= [NSString stringWithFormat:@"%@ ",[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:d]]];
        self.lbLenh.text=Entity.fLenh;
        self.lbLoai.text=Entity.fLoai;
        self.lbMaChungKhoan.text=Entity.fMaCK;
        self.lbMuaBan.text=Entity.fMuaBan;
        self.lbNgayGD.text=Entity.fNgayGD;
        self.lbSan.text=Entity.fSan;
        
        CGRect frame = CGRectMake(940, -5, 30, 30);
        SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
        BOOL checked = Entity.checked;
        SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:frame style:style checked:checked];
        cbv.tag=Entity.fSTT;
        cbv.enabled = YES;
        [cbv setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
        [self addSubview:cbv];
        [self bringSubviewToFront:cbv];
        [cbv release];
        
    }
    else
    {
        
        
    }
    
  }
    @catch (NSException *er) {
         NSLog([NSString stringWithFormat:@"Loi set data 2 cell: %@",er.description]);
        
    }
    @finally {
    }

}
- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    Entity.checked=cbv.checked;
}

- (void)dealloc {
    [_lbNgayGD release];
    [_lbLenh release];
    [_lbMuaBan release];
    [_lbLoai release];
    [_lbSan release];
    [_lbMaChungKhoan release];
    [_lbKhoiLuongDat release];
    [_lbGiaDat release];
    [_lbKhoiLuongHuy release];
    [_lbSTT release];
    [super dealloc];
}
@end

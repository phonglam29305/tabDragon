//
//  VDSCMarketInfo.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCMiniPriceBoard.h"

@interface VDSCMarketInfo : UIView<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    NSMutableDictionary *allDataDictionary;
    NSMutableArray *data_tmp;
}
@property (retain, nonatomic)  NSMutableDictionary *allDataDictionary;
@property (nonatomic, retain)  NSMutableArray *data_tmp;
@property (strong, nonatomic) IBOutlet UIView *marketIndex;
@property (strong, nonatomic) IBOutlet UITableView *priceBoard_header;
@property (retain, nonatomic) NSMutableArray *root_array_price;
@property (retain, nonatomic) NSMutableArray *array_price;

@property (retain, nonatomic) NSMutableArray *array_price_change;
@property (retain, nonatomic) IBOutlet UIButton *btn_add;

@property (retain, nonatomic) VDSCMiniPriceBoard *miniPriceBoard;

@property (retain, nonatomic) IBOutlet UITableView *priceBoard;
@property (retain, nonatomic) IBOutlet UITextField *f_keyWord;
- (IBAction)f_keyWordValueChanged:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lbl_San;
- (IBAction)btn_San_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_San;
- (IBAction)btn_Nganh_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_nganh;
@property (retain, nonatomic) IBOutlet UIView *bar_search;
@property (retain, nonatomic) IBOutlet UILabel *lbl_Nganh;
@property (retain, nonatomic)NSTimer *timer_price;

- (IBAction)showMiniPriceBoard:(id)sender;
- (IBAction)btn_add_touch:(id)sender;

//-(void) loadMarketIndex;
-(void) dismissPopoverController:(UIPopoverController *)popover;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) id delegate;
//@property (strong, nonatomic) VDSCMiniPriceBoard *miniPriceBoard;
@property (retain, nonatomic) IBOutlet UIButton *btn_showMiniPriceBoard;

@end

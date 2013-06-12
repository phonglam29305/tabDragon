//
//  VDSCListSettingViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/2/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCObjectStockBalance.h"

@interface VDSCListSettingViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *txt_giaChotLoi;
@property (retain, nonatomic) IBOutlet UITextField *txt_giaCatLo;
@property (retain, nonatomic) IBOutlet UITextField *txt_giaVon;
@property (retain, nonatomic) IBOutlet UITextField *txt_tyLeChotLoi;
@property (retain, nonatomic) IBOutlet UITextField *txt_tyLeCatLo;
@property (retain, nonatomic) IBOutlet UILabel *f_maCK;
- (IBAction)btn_confirm_touch:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;
@property (strong, nonatomic) VDSCObjectStockBalance *stockEntity;
- (IBAction)txt_textChange:(id)sender;
-(void) initData;
@property (retain, nonatomic) id delegate;
@end

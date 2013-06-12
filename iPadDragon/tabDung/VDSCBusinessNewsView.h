//
//  VDSCBusinessNewsView.h
//  iPadDragon
//
//  Created by vdsc on 1/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCBusinessNewsView : UIView<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *marketInfo;
@property (retain, nonatomic) IBOutlet UILabel *f_ma;
@property (retain, nonatomic) IBOutlet UILabel *f_ten;
@property (retain, nonatomic) IBOutlet UILabel *f_nganh;
@property (retain, nonatomic) IBOutlet UITextField *f_keyWord;
@property (retain, nonatomic) IBOutlet UITableView *tableNews;
@property (retain, nonatomic) IBOutlet UITextView *f_content;
@property (retain, nonatomic) IBOutlet UILabel *f_title;
@property (retain, nonatomic) IBOutlet UILabel *f_date;
@property (retain, nonatomic) IBOutlet UIWebView *f_webContent;

- (IBAction)txt_ma_ValueChanged:(id)sender;
- (IBAction)btn_clear:(id)sender;
@end

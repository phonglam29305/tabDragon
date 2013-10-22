//
//  VDSCBalanceView.m
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCBalanceView.h"
#import "VDSCStockBalance.h"
#import "VDSCStockStatus.h"
#import "HMSegmentedControl.h"
//#import "GDataXMLNode.h"
#import "VDSCCommonUtils.h"
#import "VDSCMainViewController.h"
#import "VDSCObjectStockBalance.h"
#import "ASIFormDataRequest.h"


@implementation VDSCBalanceView{
    
    
    VDSCStockBalance *StockBalance;
    VDSCStockStatus *StockStatus;
    VDSCCommonUtils *utils;
    NSMutableData *webData;
    NSURLConnection *connection;
    NSMutableArray *array;
    double DepositoryFree;
    double fixedLoan;
    UIWebView *loading;
    
    
    NSMutableArray *array_ObjectStockBaklance_root;
    NSMutableArray *array_ObjectStockStatus_root;
    
    NSOperationQueue *queue;
    double GTTien ;double GTChungKhoan;
}
@synthesize txtTongTienBanChungKhoan;
@synthesize txtGiaTriNgay_T;
@synthesize txtGiaTriNgay_T_1;
@synthesize txtGiaTriNgay_T_2;
@synthesize tabbBalance;
@synthesize txtTienCoTheRut;
@synthesize txtTienMatThucCo;
@synthesize txtTienCoTheUngTruoc;
@synthesize txtTienDaUngTruoc;
@synthesize txtTongMuaKhopTrongNgay;
@synthesize txtLaiTienGui;
@synthesize txtTienLaiKyQuy;
@synthesize txtDuNoKyQuy;
@synthesize txtDuNoCamCo;
@synthesize txtChuaThanhToan;
@synthesize txtTongGiaTriTaiKhoan;
@synthesize txtGiaTriTien;
@synthesize lbColorGiaTriTien;
@synthesize txtGiaTriCK;
@synthesize lbColorGiaTriCK;
@synthesize txtTongTaiSan;
@synthesize lbColorTongTaiSan;
@synthesize timer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//----1-Ham loadform chay dau tien khi vao form
-(void)awakeFromNib
{
    
    [super awakeFromNib];
    //utils =((VDSCMainViewController*) self.delegate).utils;//[[VDSCCommonUtils alloc]init];
    utils =[[VDSCCommonUtils alloc]init];
    array_ObjectStockBaklance_root=[[NSMutableArray alloc] init];
    array_ObjectStockStatus_root=[[NSMutableArray alloc] init];
    
    
    [self initControls];
    loading = [utils showLoading:self];
    [self sheduleData];
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sheduleData) userInfo:nil repeats:YES];
    [timer fire];
}
-(void) sheduleData
{
    [self LoadThongTinKhachHang];
    [self LoadBalance];
    //loading = [utils showLoading:self];
    [self LoadTongGiaTriTienChungKhoan];
    //[self LoadMap];
}
-(void) initControls
{
    //tab: tao mot tab ngang co nhieu tab con
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"      Tiền        ", @"     Chứng khoán      ", @"Trạng thái chứng khoán"]];
    [segmentedControl setFrame:CGRectMake(0, 0, 560, 30)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
    segmentedControl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]];
    segmentedControl.textColor = [UIColor whiteColor];
    segmentedControl.font = [UIFont fontWithName:@"Arial" size:15];
    [self.tabbBalance addSubview:segmentedControl];
    
    [[self tabbBalance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-menu.png"]]];
    
    
}
-(void) LoadThongTinKhachHang
{
    NSString *post = [NSString stringWithFormat:@"info=KW_WS_EXECPWD:::%@@@@KW_CLIENTSECRET:::%@@@@KW_CLIENTID:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],utils.clientInfo.secret,utils.clientInfo.clientID];
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientInfo"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=300;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
}

-(void) LoadBalance
{
    NSString *post = [NSString stringWithFormat:@"info=KW_WS_EXECPWD:::%@@@@KW_CLIENTSECRET:::%@@@@KW_CLIENTID:::%@@@@KW_ACCOUNTTYPE:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],utils.clientInfo.secret,utils.clientInfo.clientID, utils.clientInfo.accountType];
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientCashInfo"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=100;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
   
}
-(void)LoadTongGiaTriTienChungKhoan
{
    NSString *post = [NSString stringWithFormat:@"info=KW_WS_EXECPWD:::%@@@@KW_CLIENTSECRET:::%@@@@KW_CLIENTID:::%@",[NSString stringWithFormat:@"Abc123XYZ2013_%@", [utils.shortDateFormater stringFromDate: [NSDate date]]],utils.clientInfo.secret,utils.clientInfo.clientID];
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientStockInfo"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=200;
    
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
}
- (IBAction)grabURLInTheBackground:(ASIFormDataRequest *)request
{
    if (!queue) {
        [queue=[NSOperationQueue alloc] init];
    }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [queue addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(ASIFormDataRequest *)request
{
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            if(success)
            {
                //1
                self.txtTienCoTheRut.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"DrawableBal"]];
                //---------------------
                double realCash;
                double AvailAvd;
                NSString *accountType= [NSString stringWithFormat:@"%@",[allDataDictionary objectForKey:@"AccountType"]];
                
                double ReserveAmount,CTodayOut,MvPenddingWithdrawMoney,SettledBalance;
                
                ReserveAmount =   [ [allDataDictionary objectForKey:@"ReserveAmount"] doubleValue];
                CTodayOut     =   [ [allDataDictionary objectForKey:@"CTodayOut"] doubleValue];
                MvPenddingWithdrawMoney   =   [ [allDataDictionary objectForKey:@"MvPenddingWithdrawMoney"] doubleValue];
                SettledBalance  =[ [allDataDictionary objectForKey:@"SettledBalance"] doubleValue];
                
                if(  [accountType isEqualToString:@"M"])
                {
                    realCash =  ReserveAmount      -  CTodayOut   - MvPenddingWithdrawMoney;
                    if(ReserveAmount-CTodayOut-MvPenddingWithdrawMoney>0)
                    {
                        AvailAvd=[ [allDataDictionary objectForKey:@"MvAvailAdvanceMoney"] doubleValue];
                    }
                    else
                    {
                        AvailAvd=(MAX(ReserveAmount-CTodayOut-MvPenddingWithdrawMoney+[ [allDataDictionary objectForKey:@"MvAvailAdvanceMoney"] doubleValue], 0));
                    }
                    
                }
                else
                {
                    realCash = SettledBalance   - MvPenddingWithdrawMoney ;
                    if(SettledBalance-MvPenddingWithdrawMoney>0)
                    {
                        AvailAvd=[ [allDataDictionary objectForKey:@"MvAvailAdvanceMoney"] doubleValue];
                        
                    }
                    else
                    {
                        AvailAvd=([ [allDataDictionary objectForKey:@"MvAvailAdvanceMoney"] doubleValue]+SettledBalance-MvPenddingWithdrawMoney );
                    }
                    
                }
                if(realCash<0)
                    realCash=0;
                if(AvailAvd<0)
                    AvailAvd=0;
                self.txtTienMatThucCo.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:realCash]];
                self.txtTienCoTheUngTruoc.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:AvailAvd]];
                
                self.txtTienDaUngTruoc.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"TotalOutAdvance"]];
                self.txtTongMuaKhopTrongNgay.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"CTodayConfirmBuy"]];
                //2
                self.txtLaiTienGui.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"CreditInterest"]];
                self.txtTienLaiKyQuy.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"DebitInterest"]];
                self.txtDuNoKyQuy.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:fixedLoan]];
                self.txtDuNoCamCo.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"OutstandingRepoAmount"]];
                
                self.txtChuaThanhToan.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:DepositoryFree]];
                //3
                double TongTienBanChungKhoan;
                
                TongTienBanChungKhoan=[[allDataDictionary objectForKey:@"CTodayConfirmSell"] doubleValue]+[[allDataDictionary objectForKey:@"T1UnSettleSell"] doubleValue]+[[allDataDictionary objectForKey:@"T2UnSettleSell"]doubleValue];
                
                self.txtTongTienBanChungKhoan.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:TongTienBanChungKhoan]];
                self.txtGiaTriNgay_T.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"CTodayConfirmSell"]];
                self.txtGiaTriNgay_T_1.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"T1UnSettleSell"]];
                self.txtGiaTriNgay_T_2.text=[utils.numberFormatter3Digits stringFromNumber:[allDataDictionary objectForKey:@"T2UnSettleSell"]];
                //4
                
                double TongGiaTriTien;
                TongGiaTriTien=realCash
                +AvailAvd
                -[[allDataDictionary objectForKey:@"CTodayConfirmBuy"]   doubleValue]
                +[[allDataDictionary objectForKey:@"CreditInterest"]doubleValue]
                +[[allDataDictionary objectForKey:@"DebitInterest"]doubleValue]
                +fixedLoan
                -[[allDataDictionary objectForKey:@"OutstandingRepoAmount"]doubleValue]
                -DepositoryFree;
                GTTien=TongGiaTriTien;
                //double TongGiaTriTienChungKhoan=[self LoadTongGiaTriTienChungKhoan];
                //[self LoadMap:TongGiaTriTien:TongGiaTriTienChungKhoan];
                
            }
            else
            {
                //1
                
                self.txtTienCoTheRut.text=@"0";
                self.txtTienMatThucCo.text=@"0";
                self.txtTienCoTheUngTruoc.text=@"0";
                self.txtTienDaUngTruoc.text=@"0";
                self.txtTongMuaKhopTrongNgay.text=@"0";
                //2
                self.txtLaiTienGui.text=@"0";
                self.txtTienLaiKyQuy.text=@"0";
                self.txtDuNoKyQuy.text=@"0";
                self.txtDuNoCamCo.text=@"0";
                self.txtChuaThanhToan.text=@"0";
                //3
                self.txtTongTienBanChungKhoan.text=@"0";
                self.txtGiaTriNgay_T.text=@"0";
                self.txtGiaTriNgay_T_1.text=@"0";
                self.txtGiaTriNgay_T_2.text=@"0";
                //4
                self.txtTongGiaTriTaiKhoan.text=@"0";
                self.txtGiaTriTien.text=@"0";
                self.txtGiaTriCK.text=@"0";
                self.txtTongTaiSan.text=@"0";
                self.txtTongGiaTriTaiKhoan.text=@"0";
                
                [self LoadMap];
                
            }
        }
        else if(request.tag==200)
        {
            double TongGiaTriTienChungKhoan=0;
            
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                
                [array_ObjectStockBaklance_root removeAllObjects];
                [array_ObjectStockStatus_root removeAllObjects];
                self.TongTienGiaTriChungKhoan=0;
                self.TongTienKhaNangNhanNo=0;
                VDSCObjectStockBalance *stock = nil;
                VDSCObjectStockBalance *stock_status = nil;
                if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
                    for (NSDictionary *item in [allDataDictionary objectForKey:@"list"]) {
                    
                    
                    TongGiaTriTienChungKhoan=TongGiaTriTienChungKhoan+(
                                                                       +[[item objectForKey:@"SETTLED"] doubleValue]
                                                                       + [[item objectForKey:@"DUEBUY"]doubleValue]
                                                                       + [[item objectForKey:@"TT2UNSETTLEBUY"]doubleValue]
                                                                       + [[item objectForKey:@"TT1UNSETTLEBUY"]doubleValue]
                                                                       +[[item objectForKey:@"TTODAYCONFIRMBUY"]doubleValue]
                                                                       -([[item objectForKey:@"TT1UNSETTLESELL"]doubleValue]+[[item objectForKey:@"TT2UNSETTLESELL"]doubleValue]+[[item objectForKey:@"TTODAYCONFIRMSELL"]doubleValue]))*[[item objectForKey:@"CURRENTPRICE"] doubleValue];
                    
                    stock = [[VDSCObjectStockBalance alloc] init];
                    stock.MaCK = [item objectForKey:@"INSTRUMENTID"];
                    stock.TongSoLuong=[[item objectForKey:@"SETTLED"] doubleValue];
                    stock.GiaoDich=[[item objectForKey:@"USABLE"]doubleValue];
                    stock.CKMuaChoKhop=[[item objectForKey:@"TODAYBUY"]doubleValue]-[[item objectForKey:@"TTODAYCONFIRMBUY"]doubleValue];
                    stock.MuaChoVe_T=[[item objectForKey:@"DUEBUY"]doubleValue];
                    stock.MuaChoVe_T1=[[item objectForKey:@"TT2UNSETTLEBUY"]doubleValue];
                    stock.MuaChoVe_T2=[[item objectForKey:@"TT1UNSETTLEBUY"]doubleValue];
                    stock.MuaChoVe_T3=[[item objectForKey:@"TTODAYCONFIRMBUY"]doubleValue];
                    stock.BanChoThanhToan=[[item objectForKey:@"TT1UNSETTLESELL"]doubleValue]+[[item objectForKey:@"TT2UNSETTLESELL"]doubleValue]+[[item objectForKey:@"TTODAYCONFIRMSELL"]doubleValue];
                    stock.TyLeVay=[[item objectForKey:@"STOCKMARGINPERCENTAGE"]doubleValue];
                    stock.GiaThiTruong = [[item objectForKey:@"CURRENTPRICE"] doubleValue];
                    stock.GiaTriThiTruong=(stock.TongSoLuong
                                           +stock.MuaChoVe_T
                                           +stock.MuaChoVe_T1
                                           +stock.MuaChoVe_T2
                                           +stock.MuaChoVe_T3-stock.BanChoThanhToan )
                    *stock.GiaThiTruong;
                    
                    stock.KhaNangNhanNo=(stock.GiaoDich
                                         + stock.CKMuaChoKhop
                                         +stock.MuaChoVe_T
                                         +stock.MuaChoVe_T1
                                         +stock.MuaChoVe_T2
                                         +stock.MuaChoVe_T3
                                         )*stock.TyLeVay/100*stock.GiaThiTruong;
                    
                    
                    if(!(stock.TongSoLuong<=0 && stock.GiaoDich<=0 && stock.CKMuaChoKhop<=0 && stock.MuaChoVe_T<=0 && stock.MuaChoVe_T1<=0&& stock.MuaChoVe_T2<=0 && stock.MuaChoVe_T3<=0 &&stock.BanChoThanhToan<=0))
                    {
                        
                        [array_ObjectStockBaklance_root  addObject:stock];
                    }
                    self.TongTienGiaTriChungKhoan=self.TongTienGiaTriChungKhoan+stock.GiaTriThiTruong;
                    self.TongTienKhaNangNhanNo=self.TongTienKhaNangNhanNo+stock.KhaNangNhanNo;
                    
                    stock_status = [[VDSCObjectStockBalance alloc] init];
                    stock_status.MaCK = [item objectForKey:@"INSTRUMENTID"];
                    stock_status.TongSoLuong=[[item objectForKey:@"SETTLED"] doubleValue];
                    stock_status.GiaoDich=[[item objectForKey:@"USABLE"] doubleValue];
                    
                    stock_status.TongMuaChoVe=[[item objectForKey:@"DUEBUY"] doubleValue]
                    +[[item objectForKey:@"TT2UNSETTLEBUY"] doubleValue]
                    +[[item objectForKey:@"TT1UNSETTLEBUY"] doubleValue]
                    +[[item objectForKey:@"TTODAYCONFIRMBUY"] doubleValue];
                    
                    stock_status.BanChoThanhToan=[[item objectForKey:@"TT1UNSETTLESELL"] doubleValue]+
                    +[[item objectForKey:@"TT2UNSETTLESELL"] doubleValue]
                    +[[item objectForKey:@"TTODAYCONFIRMSELL"] doubleValue];
                    
                    stock_status.BanChoKhop=[[item objectForKey:@"TODAYSELL"] doubleValue]
                    -[[item objectForKey:@"TTODAYCONFIRMSELL"] doubleValue];
                    
                    stock_status.HanCheChuyenNhuong=[[item objectForKey:@"TCONDITIONALHOLDQTY"] doubleValue];
                    stock_status.CamCo=[[item objectForKey:@"TMORTGAGEQTY"] doubleValue];
                    stock_status.PhongToa=[[item objectForKey:@"TNORMALHOLDQTY"] doubleValue];
                    stock_status.ChoGiaoDich=[[item objectForKey:@"TAWAITINGTRADECERT"] doubleValue];
                    stock_status.QuyenChoPhanBo=[[item objectForKey:@"TPENDINGENTITLEMENTQTY"] doubleValue];
                    stock_status.LK_Gui=[[item objectForKey:@"TAWAITINGDEPOSITCERT"] doubleValue];
                    stock_status.LK_Rut=[[item objectForKey:@"TAWAITINGWITHDRAWALCERT"] doubleValue];
                    if(!(stock_status.TongSoLuong<=0 && stock_status.GiaoDich<=0&&stock_status.TongMuaChoVe<=0 && stock_status.BanChoThanhToan<=0&& stock_status.BanChoKhop<=0 && stock_status.HanCheChuyenNhuong<=0&& stock_status.CamCo<=0&& stock_status.PhongToa<=0&& stock_status.ChoGiaoDich<=0 && stock_status.QuyenChoPhanBo<=0))
                    {
                        [array_ObjectStockStatus_root  addObject:stock_status];
                    }
                    
                    [stock release];
                    [stock_status release];
                }
            }
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"MaCK" ascending:YES];
            //[yourArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            self.array_ObjectStockStatus=[array_ObjectStockStatus_root sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            self.array_ObjectStockBaklance=[array_ObjectStockBaklance_root sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            GTChungKhoan=self.TongTienGiaTriChungKhoan;
            if(StockStatus!=nil)
            {
                [StockStatus LoadStockStatus];
            }
            if(StockBalance!=nil)
            {
                [StockBalance LoadStockBalancce];
            }
            [self LoadMap];
        }
        else{
            if(![allDataDictionary isEqual:[NSNull null]])
            {
                DepositoryFree=[[allDataDictionary objectForKey:@"feeLK"] doubleValue];
                fixedLoan=[[allDataDictionary objectForKey:@"fixedLoan"] doubleValue];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
    
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}

static int mySortFunc(NSDictionary *dico1, NSDictionary *dico2, void *context)
{
    NSString *studentName1 = [dico1 objectForKey:@"MaCK"];
    NSString *studentName2 = [dico2 objectForKey:@"MaCK"];
    return [studentName1 compare:studentName2];
}
-(void)LoadMap{
    @try{
    
    double GTTongTaiSan=GTTien+GTChungKhoan;
    double ChieuCaoToiDa_Duong=270;
    double Y=436;
    double GTTien_d=0;if(GTTien<0)GTTien_d=GTTien*-1;else GTTien_d=GTTien;
    double GTChungKhoan_d=0;if(GTChungKhoan<0)GTChungKhoan_d=GTChungKhoan*-1;else GTChungKhoan_d=GTChungKhoan;
    double GTTongTaiSan_d=0;if(GTTongTaiSan<0)GTTongTaiSan_d=GTTongTaiSan*-1;else GTTongTaiSan_d=GTTongTaiSan;
    
    double GiaTriTien_MotPicel=0;
    GiaTriTien_MotPicel=MAX(GTTongTaiSan_d,GTChungKhoan_d);
    GiaTriTien_MotPicel=MAX(GiaTriTien_MotPicel,GTTien_d)/(ChieuCaoToiDa_Duong+10);
    
    if(GiaTriTien_MotPicel<=0){
        return;
    }
    //tren design luon luon de X=535,W=75, Y va H tuy y
    [lbColorGiaTriTien setFrame:CGRectMake(535, (Y-1-(GTTien/GiaTriTien_MotPicel)/2), 75,(GTTien/GiaTriTien_MotPicel)/2 )];
    
    if(GTTien>0 ){
        [txtGiaTriTien setFrame:CGRectMake(535, (Y-1-(GTTien/GiaTriTien_MotPicel)/2)-(GTTien/GTTien_d)*20, 75,20)];
    }
    else {
        if(GTTien_d!=0)
        {        [txtGiaTriTien setFrame:CGRectMake(535, (Y-1-(GTTien/GiaTriTien_MotPicel)/2)-(GTTien/GTTien_d)*-5, 75,20)];
        }
    }
    
    
    txtGiaTriTien.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:GTTien]];
    
    //tren design luon luon de X=612,W=75, Y va H tuy y
    [lbColorGiaTriCK setFrame:CGRectMake(612, (Y-1-(GTChungKhoan/GiaTriTien_MotPicel)/2), 75,(GTChungKhoan/GiaTriTien_MotPicel)/2)];
    
    if(GTChungKhoan>0 ){
        
        [txtGiaTriCK setFrame:CGRectMake(612, (Y-1-(GTChungKhoan/GiaTriTien_MotPicel)/2)-(GTChungKhoan/GTChungKhoan_d)*20, 75,20)];
    }
    else
    {
        if(GTChungKhoan_d!=0)
        {
            [txtGiaTriCK setFrame:CGRectMake(612, (Y-1-(GTChungKhoan/GiaTriTien_MotPicel)/2)-(GTChungKhoan/GTChungKhoan_d)*-5, 75,20)];
        }
    }
    txtGiaTriCK.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:GTChungKhoan]];
    
    
    //tren design luon luon de X=689,W=75, Y va H tuy y
    [lbColorTongTaiSan setFrame:CGRectMake(689, (Y-1-(GTTongTaiSan/GiaTriTien_MotPicel)/2), 75,(GTTongTaiSan/GiaTriTien_MotPicel)/2)];
    if(GTTongTaiSan>0){
        [txtTongTaiSan setFrame:CGRectMake(689, (Y-1-(GTTongTaiSan/GiaTriTien_MotPicel)/2)-(GTTongTaiSan/GTTongTaiSan_d)*20, 75,20)];    }
    else {
        [txtTongTaiSan setFrame:CGRectMake(689, (Y-1-(GTTongTaiSan/GiaTriTien_MotPicel)/2)-(GTTongTaiSan/GTTongTaiSan_d)*-5, 75,20)];
    }
    
    txtTongTaiSan.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:GTTongTaiSan]];
    
    self.txtTongGiaTriTaiKhoan.text=[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:GTTongTaiSan]];
    }
    @catch (NSException *ex) {
        NSLog(ex.description);
    }
    @finally {
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
}

// -- su kien sau khi thay doi cac tab con cua tab cha
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    CGFloat width = self.frame.size.width;
    //CGFloat height = self.frame.size.height;
    switch (segmentedControl.selectedIndex) {
        case 1:
            if(StockBalance==nil)
            {
                
                StockBalance = [[[NSBundle mainBundle] loadNibNamed:@"VDSCStockBalance" owner:self options:nil] objectAtIndex:0];
                StockBalance.frame = CGRectMake(0, 33, width, 612);
                StockBalance.backgroundColor=[UIColor blackColor];
                StockBalance.delegate=self;
                [self addSubview:StockBalance];
            }
            //[StockBalance LoadStockBalancce];
            [self bringSubviewToFront:StockBalance];
            break;
            
        case 2:
            if(StockStatus==nil)
            {
                StockStatus = [[[NSBundle mainBundle] loadNibNamed:@"VDSCStockStatus" owner:self options:nil] objectAtIndex:0];
                StockStatus.frame = CGRectMake(0, 33, width, 612);
                StockStatus.backgroundColor=[UIColor blackColor];
                StockStatus.delegate=self;
                [self addSubview:StockStatus];
            }
            //[StockStatus LoadStockStatus];
            [self bringSubviewToFront:StockStatus];
            
            
            break;
        default:
            
            /*
             if(backgroundView !=nil){
             [backgroundView removeFromSuperview];
             [backgroundView release];backgroundView = nil;}
             */
            
            if(StockBalance!=nil)
                [self sendSubviewToBack: StockBalance];
            if(StockStatus!=nil)
                [self sendSubviewToBack: StockStatus];
            // cho nay xem lai release 2 cai view de giai phong vung nho
            [self performSelectorInBackground:@selector(LoadBalance) withObject:nil];
            break;
            
    }
	
}
- (void)dealloc {
    [array_ObjectStockBaklance_root release];
    [array_ObjectStockStatus_root release];
    [_array_ObjectStockBaklance release];
    [_array_ObjectStockStatus release];
    [tabbBalance release];
    [txtTienCoTheRut release];
    [txtTienMatThucCo release];
    [txtTienCoTheUngTruoc release];
    [txtTienDaUngTruoc release];
    [txtTongMuaKhopTrongNgay release];
    [txtLaiTienGui release];
    [txtTienLaiKyQuy release];
    [txtDuNoKyQuy release];
    [txtDuNoCamCo release];
    [txtChuaThanhToan release];
    [txtTongGiaTriTaiKhoan release];
    [txtTongTienBanChungKhoan release];
    [txtGiaTriNgay_T release];
    [txtGiaTriNgay_T_1 release];
    [txtGiaTriNgay_T_2 release];
    [txtGiaTriTien release];
    [lbColorGiaTriTien release];
    [txtGiaTriCK release];
    [lbColorGiaTriCK release];
    [txtTongTaiSan release];
    [lbColorTongTaiSan release];
    //[timer invalidate];
    timer = nil;
    [queue cancelAllOperations];
    [super dealloc];
}
@end

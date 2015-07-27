//
//  SearchViewController.m
//  weilvTest1
//
//  Created by lx on 15/7/8.
//  Copyright (c) 2015年 WeiLvTechnology. All rights reserved.
//

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define navHeight self.navigationController.navigationBar.frame.size.height
//历史搜索记录的文件路径
#define TraveHisPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"travehisDatas.data"]

#define ShipHisPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shiphisDatas.data"]

#define VisaHisPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"visahisDatas.data"]

#define KeeperHisPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"keeperhisDatas.data"]

#import "SearchViewController.h"
#import "SearchViewTopView.h"
#import "SearchViewBottomView.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()
{
   // NSArray *_placeStrArray;
    NSArray *_searchTypeStrArray;
}

@property (nonatomic,strong) NSArray *placeStrArray;
@property (nonatomic,strong) NSMutableArray *historyDataArray;

@property (nonatomic,strong)SearchViewTopView *topVc;
@property (nonatomic,strong)SearchViewBottomView *bottomVc;
@property (nonatomic,strong)SearchResultViewController *searchResultVc;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self getHistoryDataArray];
    /**
     1 旅游
     2 邮轮
     3 签证
     */
    _placeStrArray=@[@"请搜旅游",@"请搜邮轮",@"请搜签证"];
    _searchTypeStrArray=@[@"旅游",@"邮轮",@"签证"];
    
    _topVc=[[SearchViewTopView alloc] initWithFrame:CGRectMake(50, 10, self.view.frame.size.width-100, 25) placeholderStr:[_placeStrArray objectAtIndex:self.searchType-1] searchType:[_searchTypeStrArray objectAtIndex:self.searchType-1]];
    self.navigationItem.titleView=_topVc;
    
    /**
     *  切换搜索类型
     */
    __block SearchViewController *searchVc=self;
    _topVc.typeBlock = ^(NSInteger type){
        NSLog(@"切换搜索类型---%ld",(long)type);
        searchVc.searchType=type;
        
        [searchVc getHistoryDataArray];
        [searchVc.bottomVc updateSearchTab:searchVc.historyDataArray searchType:type];
        searchVc.topVc.searchTF.placeholder=[searchVc.placeStrArray objectAtIndex:type-1];
    };
    
    /**
     *  点击搜索按钮时返回的值
     */
    _topVc.keywordsBlock = ^(NSString *keywords){
        if (keywords.length>0) {
            
            [searchVc saveKeywords:keywords];
           
            [searchVc getHistoryDataArray];
            [searchVc.bottomVc updateSearchTab:searchVc.historyDataArray searchType:searchVc.searchType];
            searchVc.searchResultVc=[[SearchResultViewController alloc] init];
            [searchVc.navigationController pushViewController:searchVc.searchResultVc animated:YES];
        }else{
            NSLog(@"没有搜索内容");
        }
    };

    _bottomVc = [[SearchViewBottomView alloc] initWithFrame:CGRectMake(0, navHeight+40, ScreenWidth, ScreenHeight-navHeight-40) searchType:self.searchType];
    [_bottomVc updateSearchTab:self.historyDataArray searchType:self.searchType];
    [self.view addSubview:_bottomVc];
    
    _bottomVc.hiskewordsBlock = ^(NSString *hiskewords){
        searchVc.searchResultVc=[[SearchResultViewController alloc] init];
        [searchVc.navigationController pushViewController:searchVc.searchResultVc animated:YES];
    };
    
    _bottomVc.searchTypeBlock = ^(NSInteger type){
        [searchVc deleteHisData:type];
    };
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_topVc deleteMask];
    [_topVc.searchTF resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_topVc.searchTF resignFirstResponder];
}

/**
 *  保存搜索记录
 */
-(void)saveKeywords:(NSString *)keywords
{
    
    if (![self.historyDataArray containsObject:keywords]) {
        
        [self.historyDataArray insertObject:keywords atIndex:0];
        NSLog(@"保存了搜索数据--%@",self.historyDataArray);
        switch (self.searchType) {
            case 1:
            {
                [self.historyDataArray writeToFile:TraveHisPath atomically:YES];
            }
                break;
                
            case 2:
            {
                [self.historyDataArray writeToFile:ShipHisPath atomically:YES];
            }
                break;
                
            case 3:
            {
                [self.historyDataArray writeToFile:VisaHisPath atomically:YES];
            }
                break;
                
            case 4:
            {
                [self.historyDataArray writeToFile:KeeperHisPath atomically:YES];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
}

/**
 *  获取搜索记录
 */
-(void)getHistoryDataArray
{
    switch (self.searchType) {
        case 1:
        {
            self.historyDataArray = [NSMutableArray arrayWithContentsOfFile:TraveHisPath];
        }
            break;
            
        case 2:
        {
            self.historyDataArray = [NSMutableArray arrayWithContentsOfFile:ShipHisPath];
        }
            break;
            
        case 3:
        {
            self.historyDataArray = [NSMutableArray arrayWithContentsOfFile:VisaHisPath];
        }
            break;
            
        case 4:
        {
            self.historyDataArray = [NSMutableArray arrayWithContentsOfFile:KeeperHisPath];
        }
            break;
            
        default:
            break;
    }
    
    
    if (self.historyDataArray==nil) {
        self.historyDataArray=[NSMutableArray arrayWithCapacity:0];
    }
    NSLog(@"搜索历史--%@--%@",self.historyDataArray,TraveHisPath);
    
}

/**
 *  删除当前页面搜索历史记录
 */
-(void)deleteHisData:(NSInteger)searchType
{
    [self.historyDataArray removeAllObjects];
    switch (searchType) {
        case 1:
        {
            [self.historyDataArray writeToFile:TraveHisPath atomically:YES];
        }
            break;
            
        case 2:
        {
            [self.historyDataArray writeToFile:ShipHisPath atomically:YES];
        }
            break;
            
        case 3:
        {
            [self.historyDataArray writeToFile:VisaHisPath atomically:YES];
        }
            break;
            
        case 4:
        {
            [self.historyDataArray writeToFile:KeeperHisPath atomically:YES];
        }
            break;
            
        default:
            break;
    }
}

@end

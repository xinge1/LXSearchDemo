//
//  SearchViewBottomView.h
//  weilvTest1
//
//  Created by lx on 15/7/9.
//  Copyright (c) 2015年 WeiLvTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^hisBlock)(NSString *hiskewords);
typedef void (^deleteHisDataBlock)(NSInteger deletetype);
@interface SearchViewBottomView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_hotSearchBtn;
   
    NSMutableArray *_hisArray;
    
}

@property (nonatomic ,strong)UITableView *hisTableView;

/**
 *  点击搜索历史block回调
 */
@property (nonatomic ,strong) hisBlock hiskewordsBlock;

@property (nonatomic ,strong) deleteHisDataBlock searchTypeBlock;

@property (nonatomic ,assign) NSInteger searchType;


/**
 *  搜索后更新搜索记录列表
 */
-(void)updateSearchTab:(NSMutableArray *)array searchType:(NSInteger)type;



-(id)initWithFrame:(CGRect)frame searchType:(NSInteger)type;

@end

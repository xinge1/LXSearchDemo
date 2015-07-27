//
//  SearchViewBottomView.m
//  weilvTest1
//
//  Created by lx on 15/7/9.
//  Copyright (c) 2015年 WeiLvTechnology. All rights reserved.
//

#define cellHeight 35

#import "SearchViewBottomView.h"

@implementation SearchViewBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame searchType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initData];
        [self initView];
    }
    return self;
}
-(void)initData
{
    self.backgroundColor=[UIColor greenColor];
    
    
    
}

-(void)initView
{
    
    _hisTableView=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _hisTableView.delegate=self;
    _hisTableView.dataSource=self;
    _hisTableView.tableFooterView=[[UIView alloc] init];
    [self addSubview:_hisTableView];
   
    
}


-(void)updateSearchTab:(NSMutableArray *)array searchType:(NSInteger)type
{
   
    self.searchType=type;
    _hisArray=[NSMutableArray arrayWithArray:array];
    if (_hisArray.count>0) {
        [_hisArray insertObject:@"清空搜索记录" atIndex:_hisArray.count];
    }else{
        [_hisArray insertObject:@"暂无搜索记录" atIndex:_hisArray.count];
    }
    [_hisTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hisArray.count>0) {
        return _hisArray.count;
    }else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier1 = @"cellIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (_hisArray.count>0) {
        cell.textLabel.text=[_hisArray objectAtIndex:indexPath.row];
        
        if (indexPath.row==_hisArray.count-1) {
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
        }else{
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.textAlignment=NSTextAlignmentLeft;
        }
        
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==_hisArray.count-1) {

        [_hisArray removeAllObjects];
        _hisArray=[[NSMutableArray alloc] initWithObjects:@"暂无搜索记录", nil];
        [_hisTableView reloadData];
        NSLog(@"清空记录");
        if (self.searchTypeBlock) {
            self.searchTypeBlock(self.searchType);
        }
    }else{
        if (self.hiskewordsBlock) {
            self.hiskewordsBlock([_hisArray objectAtIndex:indexPath.row]);
        }
    }
}

@end

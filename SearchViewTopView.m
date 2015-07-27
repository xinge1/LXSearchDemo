//
//  SearchViewTopView.m
//  weilvTest1
//
//  Created by lx on 15/7/9.
//  Copyright (c) 2015年 WeiLvTechnology. All rights reserved.
//
#define cellHeight 40


#import "SearchViewTopView.h"

@implementation SearchViewTopView

+ (SearchViewTopView *)sharedSearchTopView
{
    static SearchViewTopView *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}


-(id)initWithFrame:(CGRect)frame placeholderStr:(NSString *)placeholder searchType:(NSString*)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=5;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[[UIColor grayColor] CGColor];
        _isShow=NO;
        _typeArray=@[@"旅游",@"邮轮",@"签证"];
        [self initViewplaceholderStr:placeholder searchType:type];
    }
    return self;
}

-(void)initViewplaceholderStr:(NSString *)placeholder searchType:(NSString*)type
{
    if (!_searchTF) {
        
        _typeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.frame=CGRectMake(0, 0, 60, self.frame.size.height);
        [_typeBtn setTitle:type forState:UIControlStateNormal];
        [_typeBtn addTarget:self action:@selector(changeTypeClick) forControlEvents:UIControlEventTouchUpInside];
        [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_typeBtn];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(_typeBtn.frame.origin.x+_typeBtn.frame.size.width+10, 3, 0.5, self.frame.size.height-6)];
        line.backgroundColor=[UIColor grayColor];
        [self addSubview:line];
        
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, self.frame.size.width-100, self.frame.size.height)];
        [_searchTF setPlaceholder:placeholder];
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.borderStyle=UITextBorderStyleNone;
        _searchTF.delegate=self;
        [self addSubview:_searchTF];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        _maskView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, window.frame.size.width, window.frame.size.height)];
        _maskView.alpha=0.7;
        _maskView.backgroundColor=[UIColor blackColor];
        _maskView.hidden=YES;
        _maskView.userInteractionEnabled=YES;
        [window addSubview:_maskView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMask)];
        [_maskView addGestureRecognizer:tap];
        
        _typeTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, _maskView.frame.origin.y,  window.frame.size.width, _typeArray.count*cellHeight)];
        _typeTabView.delegate=self;
        _typeTabView.dataSource=self;
        _typeTabView.tableFooterView=[[UIView alloc] init];
        _typeTabView.hidden=YES;
        [window addSubview:_typeTabView];
        
    }
    
}

-(void)changeTypeClick
{
    if (_isShow==NO) {
        _isShow=YES;
        _maskView.hidden=NO;
        _typeTabView.hidden=NO;
    }else{
        _isShow=NO;
        _maskView.hidden=YES;
        _typeTabView.hidden=YES;
    }
}

-(void)deleteMask
{
    _isShow=NO;
    _maskView.hidden=YES;
    _typeTabView.hidden=YES;
   
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier1 = @"cellIdentifier1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=[_typeArray objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_typeBtn setTitle:[_typeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self deleteMask];
    
    if (self.typeBlock) {
        self.typeBlock(indexPath.row+1);
    }
}

#pragma mark -
#pragma mark 点击键盘上的搜索按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    if (self.keywordsBlock) {
        self.keywordsBlock(textField.text);
    }
    
    textField.text = @"";
    
    return YES;
}


@end

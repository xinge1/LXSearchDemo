//
//  ViewController.m
//  LXSearchDemo
//
//  Created by lx on 15/7/27.
//  Copyright (c) 2015年 WeiLvTechnology. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSArray *nameArray=@[@"旅游",@"邮轮",@"签证"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(100, 100+50*i, 100, 50);
        [btn setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        [self.view addSubview:btn];
    }
    
}

-(void)btnClick:(UIButton *)btn
{
    //    UIStoryboard * st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    //1代表sb里面拖拽的viewcontrol的storyboard id
    //    [self.navigationController pushViewController:[st instantiateViewControllerWithIdentifier:@"1"] animated:YES];
    
    SearchViewController *vc=[[SearchViewController alloc] init];
    vc.searchType=btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

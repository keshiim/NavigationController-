//
//  aViewController.m
//  MutiThreadDemo
//
//  Created by Jason on 15/8/12.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "aViewController.h"
#import "bViewController.h"

@interface aViewController ()

@end

@implementation aViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 40, 100, 60);
    [self.view addSubview:button];
    [button setTitle:@"点选" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)pushVC:(UIButton *)sender {
    [self.navigationController pushViewController:[[bViewController alloc] init] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

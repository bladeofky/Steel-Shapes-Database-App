//
//  AW_AboutViewController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 6/14/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_AboutViewController.h"

@interface AW_AboutViewController ()

@end

@implementation AW_AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.barTintColor = [UIColor blackColor];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.tabBarController.tabBar.barTintColor = nil;
//    self.tabBarController.tabBar.tintColor = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerTap)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleFingerTap
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

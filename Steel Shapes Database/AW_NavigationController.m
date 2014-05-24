//
//  AW_NavigationController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_NavigationController.h"

@interface AW_NavigationController ()


@end

@implementation AW_NavigationController

@synthesize unitSystem = _unitSystem;

#pragma mark - Custom accessors

-(UISegmentedControl *)unitSystem
{
    if (!_unitSystem) {
        _unitSystem = [[UISegmentedControl alloc]initWithItems:@[@"in.",@"mm"]];
        
        // Default to imperial units
        _unitSystem.selectedSegmentIndex = 0;
    }
    
    return _unitSystem;
}


#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

-(BOOL)isMetric
{
    BOOL isMetric;
    
    if (self.unitSystem.selectedSegmentIndex == 0) {
        // This is imperial units
        isMetric = NO;
    }
    else if (self.unitSystem.selectedSegmentIndex == 1) {
        isMetric = YES;
    }
    else {
        [NSException raise:@"Unknown selected index" format:@"unitSystem segemented controller is returning a selected index that is netiher 0 nor 1"];
    }
    
    return isMetric;
}

@end

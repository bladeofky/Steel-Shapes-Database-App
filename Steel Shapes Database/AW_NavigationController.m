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

#pragma mark - Initializers


#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.barTintColor = self.navigationBar.barTintColor;
    self.tabBarController.tabBar.tintColor = self.navigationBar.tintColor;
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

// This code might be used if I ever decide to convert the color name to a UIColor in this app rather than store it as
// a UIColor in CoreData

//- (void)changeBarTintColorTo: (NSString *)barTintColorName andTintColorTo: (NSString *)tintColorName
//{
//    self.navigationBar.barTintColor = [self getColorForName:barTintColorName];
//    self.navigationBar.tintColor = [self getColorForName:tintColorName];
//}
//
//-(UIColor *)getColorForName: (NSString *)colorName
//{
//    UIColor *color;
//    
//    if ([colorName isEqualToString:@"Maroon"]) {
//        color = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1.0];
//    }
//    else if ([colorName isEqualToString:@"Dark Blue"]) {
//        color = [UIColor colorWithRed:0/255.0f green:58/255.0f blue:169/255.0f alpha:1.0f];
//    }
//    else if ([colorName isEqualToString:@"Black"]) {
//        color = [UIColor blackColor];
//    }
//    else if ([colorName isEqualToString:@"White"]) {
//        color = [UIColor whiteColor];
//    }
//    else if ([colorName isEqualToString:@"Gold"]) {
//        color = [UIColor colorWithRed:1 green:1 blue:0 alpha:1.0];
//    } // end else if
//    else {
//        color = nil;
//    }
//    
//    return color;
//}


@end

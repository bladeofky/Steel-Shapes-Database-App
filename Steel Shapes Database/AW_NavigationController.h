//
//  AW_NavigationController.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_NavigationController : UINavigationController

@property (nonatomic, strong, readonly) UISegmentedControl *unitSystem;

- (BOOL)isMetric;

// See note on .m file
//- (void)changeBarTintColorTo: (NSString *)barTintColorName andTintColorTo: (NSString *)tintColorName;

@end

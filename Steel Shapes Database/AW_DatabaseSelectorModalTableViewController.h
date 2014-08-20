//
//  AW_DatabaseSelectorModalTableViewController.h
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_SearchCriteriaTableViewController;

@protocol DatabaseSelectorDelegate <NSObject>

-(void)databaseSelectorDidChangeDatabase;

@end

@interface AW_DatabaseSelectorModalTableViewController : UITableViewController

@property (nonatomic, weak) AW_SearchCriteriaTableViewController *searchCriteriaVC;

@end

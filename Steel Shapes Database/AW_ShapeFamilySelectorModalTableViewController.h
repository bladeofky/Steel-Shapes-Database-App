//
//  AW_ShapeFamilySelectorModalTableViewController.h
//  Shape DB
//
//  Created by Alan Wang on 7/23/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//


#import <UIKit/UIKit.h>

@class AW_SearchCriteriaTableViewController;

@protocol ShapeFamilySelectorDelegate <NSObject>

-(void)shapeFamilySelectorDidRemoveShapeFamily;

@end

@interface AW_ShapeFamilySelectorModalTableViewController : UITableViewController

@property (nonatomic, weak) AW_SearchCriteriaTableViewController *searchCriteriaVC;

@end

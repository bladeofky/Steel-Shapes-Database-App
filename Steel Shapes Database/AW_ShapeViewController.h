//
//  AW_ShapeTableViewController.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/24/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_ShapeFamily, AW_InfoBar;

@interface AW_ShapeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AW_ShapeFamily *shapeFamily;
@property (nonatomic, weak) IBOutlet AW_InfoBar *infoBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end

//
//  AW_DatabaseTableViewController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_AboutViewController.h"
#import "AW_NavigationController.h"
#import "AW_DatabaseTableViewController.h"
#import "AW_ShapeFamilyTableViewController.h"
#import "AW_CoreDataStore.h"
#import "AW_Database.h"

@interface AW_DatabaseTableViewController ()

@property (nonatomic, readonly) NSArray *databaseList;

@end

@implementation AW_DatabaseTableViewController

@synthesize databaseList = _databaseList;

#pragma mark - Custom Accessors
- (NSArray *)databaseList
{
    if (!_databaseList) {
        _databaseList = [[AW_CoreDataStore sharedStore] fetchAW_DatabaseObjects];
    }
    
    return _databaseList;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Configure nav bar title
    self.navigationItem.title = @"Select Database";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reset navigation and tab bar colors to default
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.tabBarController.tabBar.barTintColor = nil;
    self.tabBarController.tabBar.tintColor = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Return all managed objects to faults
    for (AW_Database *database in self.databaseList)
    {
        [[AW_CoreDataStore sharedStore]returnObjectToFault:database];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.databaseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AW_Database *database = self.databaseList[indexPath.row];
    cell.textLabel.text = database.longName;
    
    // Not sure whether to make cells match colors of the source books
    //cell.backgroundColor = database.backgroundColor;
    //cell.textLabel.textColor = database.textColor;
    
    return cell;
}

#pragma mark - Table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_Database *database = self.databaseList[indexPath.row];
    
    NSLog(@"Did select %@",database.key);
    
    AW_ShapeFamilyTableViewController *shapeFamilyVC = [[AW_ShapeFamilyTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    shapeFamilyVC.database = database;
    
    [self.navigationController pushViewController:shapeFamilyVC animated:YES];
}

@end

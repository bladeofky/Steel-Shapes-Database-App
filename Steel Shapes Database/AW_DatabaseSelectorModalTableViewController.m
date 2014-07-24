//
//  AW_DatabaseSelectorModalTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_SearchCriteriaTableViewController.h"
#import "AW_DatabaseSelectorModalTableViewController.h"
#import "AW_CoreDataStore.h"
#import "AW_Database.h"

@interface AW_DatabaseSelectorModalTableViewController ()

@property (nonatomic, strong) NSArray *databaseList;

@end

@implementation AW_DatabaseSelectorModalTableViewController

#pragma mark - Custom Accessors
- (NSArray *)databaseList
{
    if (!_databaseList) {
        _databaseList = [[AW_CoreDataStore sharedStore]fetchAW_DatabaseObjects];
    }
    
    return _databaseList;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up nav bar stuff
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf)];
    self.navigationItem.title = @"Select Database";
    
    // Set up table view stuff
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.databaseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AW_Database *databse = self.databaseList[indexPath.row];
    cell.textLabel.text = databse.longName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchCriteriaVC.databaseCriteria = self.databaseList[indexPath.row];
    [self.searchCriteriaVC.tableView reloadData];
    [self dismissSelf];
}


#pragma mark - Navigation

- (void)dismissSelf
{
    [self.searchCriteriaVC dismissViewControllerAnimated:YES
                                              completion:nil];
}

@end

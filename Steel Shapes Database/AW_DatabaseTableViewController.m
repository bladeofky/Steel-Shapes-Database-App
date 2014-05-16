//
//  AW_DatabaseTableViewController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_DatabaseTableViewController.h"
#import "AW_CoreDataStore.h"
#import "AW_Database.h"

@interface AW_DatabaseTableViewController ()

@property (nonatomic, readonly) NSArray *databaseList;

@end

@implementation AW_DatabaseTableViewController

@synthesize databaseList = _databaseList;

- (NSArray *)databaseList
{
    if (!_databaseList) {
        _databaseList = [[AW_CoreDataStore sharedStore] fetchAW_DatabaseObjects];
    }
    
    return _databaseList;
}

#pragma mark - Custom Accessors

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@th Edition", database.organization, database.edition];
    
    return cell;
}


@end

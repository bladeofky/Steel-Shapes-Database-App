//
//  AW_ShapeFamilySelectorModalTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 7/23/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_SearchCriteriaTableViewController.h"
#import "AW_ShapeFamilySelectorModalTableViewController.h"
#import "AW_ShapeFamily.h"

@interface AW_ShapeFamilySelectorModalTableViewController ()

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSMutableArray *selectedShapeFamilies;

@end

@implementation AW_ShapeFamilySelectorModalTableViewController

#pragma mark - Custom accessors

- (NSMutableArray *)selectedShapeFamilies
{
    if (!_selectedShapeFamilies) {
        _selectedShapeFamilies = [[NSMutableArray alloc]init];
    }
    
    return _selectedShapeFamilies;
}

-(NSArray *)tableData
{
    if (!_tableData) {
        // Get list of shape families from database
        NSArray *shapeFamilyList = [self.searchCriteriaVC.databaseCriteria.shapeFamilies allObjects];
        NSSortDescriptor *sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:YES];
        shapeFamilyList = [shapeFamilyList sortedArrayUsingDescriptors:@[sortByOrder]];
        
        // Organize shape families into groups
        NSMutableArray *tableDataTemp = [[NSMutableArray alloc]init];
        
        NSMutableDictionary *groupIndex = [[NSMutableDictionary alloc]init];
        
        for (AW_ShapeFamily *family in shapeFamilyList) {
            
            NSString *groupName = family.group;
            NSMutableArray *groupStore;
            
            if (!groupIndex[groupName]) {
                // This is a new group. Create an NSMutableArray for it and add it to the dictionary and tableData array
                groupStore = [[NSMutableArray alloc]init];
                [groupIndex setObject:groupStore forKey:groupName];
                [tableDataTemp addObject:groupStore];
            }
            else {
                groupStore = groupIndex[groupName];
            }
            
            [groupStore addObject:family];
        }
        
        
        _tableData = [tableDataTemp copy];
    }
    
    return _tableData;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Set up nav bar stuff
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelfAndPassSelectedFamilies)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.tintColor = self.searchCriteriaVC.databaseCriteria.textColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Select Shape(s)";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // Set up tableView stuff
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.allowsMultipleSelection = YES;
    self.selectedShapeFamilies = [self.searchCriteriaVC.shapeFamilyCriteria mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Change colors
    self.navigationController.navigationBar.barTintColor = self.searchCriteriaVC.databaseCriteria.backgroundColor;
    self.navigationController.navigationBar.tintColor = self.searchCriteriaVC.databaseCriteria.textColor;
    ((UILabel *)self.navigationItem.titleView).textColor = self.searchCriteriaVC.databaseCriteria.textColor;
    self.tabBarController.tabBar.barTintColor = self.searchCriteriaVC.databaseCriteria.backgroundColor;
    self.tabBarController.tabBar.tintColor = self.searchCriteriaVC.databaseCriteria.textColor;
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
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableData[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    AW_ShapeFamily *family = self.tableData[indexPath.section][indexPath.row];
    
    cell.textLabel.text = family.displayName;
    cell.imageView.image = family.image;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if ([self.selectedShapeFamilies containsObject:family]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.highlighted = YES;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.highlighted = NO;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_ShapeFamily *family = self.tableData[indexPath.section][indexPath.row];
    
    [self.selectedShapeFamilies addObject:family];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"%@", self.selectedShapeFamilies);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_ShapeFamily *family = self.tableData[indexPath.section][indexPath.row];
    
    [self.selectedShapeFamilies removeObject:family];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"%@", self.selectedShapeFamilies);
}

#pragma mark - Navigation
- (void)dismissSelfAndPassSelectedFamilies
{
    NSSet *oldSelectedShapeFamilies = [NSSet setWithArray:self.searchCriteriaVC.shapeFamilyCriteria];
    NSSet *newSelectedShapeFamilies = [NSSet setWithArray:self.selectedShapeFamilies];
    
    // Pass back new shape families
    if ([self.selectedShapeFamilies count] == 0) {
        self.searchCriteriaVC.shapeFamilyCriteria = nil;
    }
    else {
        // Pass back selected shape families
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:YES];
        self.searchCriteriaVC.shapeFamilyCriteria = [self.selectedShapeFamilies sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    
    // Check if any shape families were removed (so that property criteria can be adjusted)
    if (![oldSelectedShapeFamilies isSubsetOfSet:newSelectedShapeFamilies]) {
        [self.searchCriteriaVC shapeFamilySelectorDidRemoveShapeFamily];
    }
    
    [self dismissSelf];
}

- (void)dismissSelf
{
    [self.searchCriteriaVC dismissViewControllerAnimated:YES
                                              completion:nil];
}

@end

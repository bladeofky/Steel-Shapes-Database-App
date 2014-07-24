//
//  AW_SearchCriteriaTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_SearchCriteriaTableViewController.h"
#import "AW_ShapeFamily.h"
#import "AW_PropertyCriteriaObject.h"
#import "AW_DatabaseSelectorModalTableViewController.h"
#import "AW_ShapeFamilySelectorModalTableViewController.h"

@interface AW_SearchCriteriaTableViewController ()

@end

@implementation AW_SearchCriteriaTableViewController

- (NSArray *)shapeFamilyCriteria
{
    if (_shapeFamilyCriteria) {
        // If the shape families do not match the databaseCriteria, remove the shapeFamilyCriteria
        AW_ShapeFamily *family = _shapeFamilyCriteria[0];   // If _shapeFamilyCriteria exists, it must contain at least one object
        if (![self.databaseCriteria.key isEqual:family.database.key]) {
            _shapeFamilyCriteria = nil;
        }
    }
    
    return _shapeFamilyCriteria;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up navigation bar stuff
    // Set database title for navigation bar
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];   //Matches Apple's default nav bar title font
    titleLabel.textColor = self.navigationController.navigationBar.tintColor;
    titleLabel.text = @"Search By Property";
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllCriteria)];
    
    // Set up table view stuff
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Change colors
    self.navigationController.navigationBar.barTintColor = self.databaseCriteria.backgroundColor;
    self.navigationController.navigationBar.tintColor = self.databaseCriteria.textColor;
    ((UILabel *)self.navigationItem.titleView).textColor = self.databaseCriteria.textColor;
    self.tabBarController.tabBar.barTintColor = self.databaseCriteria.backgroundColor;
    self.tabBarController.tabBar.tintColor = self.databaseCriteria.textColor;
        
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.databaseCriteria) {
        return 1;   // Return only the database criteria section
    }
    else if (!self.shapeFamilyCriteria) {
        return 2;   // Return database criteria section and shape family section
    }
    else if (!self.propertyCriteria) {
        return 3;   // Return database criteria, shape family criteria, and property criteria sections
    }
    else {
        return 4;   // All criteria have been filled. Final section contains the Search button.
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // DATABASE SECTION
    if (section == 0) {
        // Database section
        return 1;
    }
    
    // SHAPE FAMILY SECTION
    else if (section == 1)
    {
        // Shape family section
        if (!self.shapeFamilyCriteria) {
            return 1;   // Return a cell allowing selection of shape families
        }
        else {
            return [self.shapeFamilyCriteria count];
        }
        
    }
    
    // PROPERTY CRITERIA SECTION
    else if (section == 2)
    {
        if (!self.propertyCriteria) {
            return 1;   // Return a cell allowing addition of property criteria
        }
        else {
            return [self.propertyCriteria count];
        }
    }
    
    // SEARCH BUTTON
    else if (section == 3) {
        return 1;   //Search button cell
    }
    
    else {
        // Unrecognized section
        [NSException raise:@"Unrecognized section number" format:@"Unrecognized section number sent ot numberOfRowsInSection"];
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSUInteger section = indexPath.section;
    
    // DATABASE CRITERIA
    // Note: We need to set the image every time, because cells are not removed from memory when the Clear button is pressed.
    if (section == 0) {
        if (!self.databaseCriteria) {
            cell.textLabel.text = @"Select Database";
            cell.imageView.image = nil;
        }
        else {
            cell.textLabel.text = self.databaseCriteria.longName;
            cell.imageView.image = nil;
        }
    }
    
    // SHAPE FAMILY CRITERIA
    else if (section == 1) {
        if (!self.shapeFamilyCriteria) {
            // If no shape families selected, present cell to select them
            cell.textLabel.text = @"Select Shape(s)";
            cell.imageView.image = nil;
        }
        else {
            // Display the titles and images of each shape family selected
            AW_ShapeFamily *shapeFamily = self.shapeFamilyCriteria[indexPath.row];
            cell.textLabel.text = shapeFamily.displayName;
            cell.imageView.image = shapeFamily.image;
        }
    }
    
    // PROPERTY CRITERIA
    else if (section == 2) {
        if (!self.propertyCriteria) {
            // If no property criteria are present, present cell to select them
            cell.textLabel.text = @"Add Search Criteria";
            cell.imageView.image = nil;
        }
        else {
            // Display property criteria
            AW_PropertyCriteriaObject *propertyCriteriaObject = self.propertyCriteria[indexPath.row];
            cell.textLabel.attributedText = [propertyCriteriaObject summary];
            cell.imageView.image = nil;
        }
    }
    
    // SEARCH BUTTON
    else if (section == 3) {
        cell.textLabel.text = @"Search...";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Database";
    }
    else if (section == 1) {
        return @"Shape(s)";
    }
    else if (section == 2) {
        return @"Property";
    }
    else {
        return nil;
    }
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    // DATABASE CRITERIA
    if (section == 0) {
        AW_DatabaseSelectorModalTableViewController *modalVC = [[AW_DatabaseSelectorModalTableViewController alloc]initWithStyle:UITableViewStylePlain];
        modalVC.searchCriteriaVC = self;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:modalVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
    // SHAPE FAMILY CRITERIA
    else if (section == 1) {
        // Present Shape Family Modal Selector
        AW_ShapeFamilySelectorModalTableViewController *modalVC = [[AW_ShapeFamilySelectorModalTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        modalVC.searchCriteriaVC = self;
        
        // Embed a navigation controller for the nav bar
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:modalVC];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
    
    // PROPERTY CRITERIA
    else if (section == 2) {
        if (!self.propertyCriteria) {
            // Present Add Search Criteria modal vc
        }
        else {
            // Present Edit Search Criteria modal vc
        }
    }
    
    // SEARCH BUTTON
    else if (section == 3) {
    }
}

#pragma mark - Helper methods
- (void)clearAllCriteria
{
    self.databaseCriteria = nil;
    self.shapeFamilyCriteria = nil;
    self.propertyCriteria = nil;

#warning TODO - find a way to soften the transition
    [self.tableView reloadData];
    [self viewWillAppear:YES];  // Reset nav bar colors
 
}


@end

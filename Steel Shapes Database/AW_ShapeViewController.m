//
//  AW_ShapeTableViewController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/24/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_NavigationController.h"
#import "AW_ShapeViewController.h"
#import "AW_PropertyViewController.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"
#import "AW_InfoBar.h"

@interface AW_ShapeViewController ()

@property (nonatomic, strong) NSArray *tableData;

@end

@implementation AW_ShapeViewController

#pragma mark - Custom Accessors
-(NSArray *)tableData
{
    if (!_tableData) {
        // Get list of shapes from the shapeFamily
        NSArray *shapeList = [self.shapeFamily.shapes allObjects];
        NSSortDescriptor *sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:NO];
        shapeList = [shapeList sortedArrayUsingDescriptors:@[sortByOrder]];
        
        // Organize shapes into groups
        NSMutableArray *tableDataTemp = [[NSMutableArray alloc]init];
        
        NSMutableDictionary *groupIndex = [[NSMutableDictionary alloc]init];
        
        
        for (AW_Shape *shape in shapeList) {
            
            NSString *groupName;
            if ([(AW_NavigationController *)self.navigationController isMetric]) {
                groupName = shape.met_group;
            }
            else {
                groupName = shape.imp_group;
            }
            
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
            
            [groupStore addObject:shape];
        }
        
        _tableData = [tableDataTemp copy];
    }
    
    return _tableData;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup navigation bar
    if ([self.navigationController isKindOfClass:[AW_NavigationController class]]) {
        AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navController.unitSystem];
        [navController.unitSystem addTarget:self
                                     action:@selector(switchImperialMetric)
                           forControlEvents:UIControlEventValueChanged];
        
        // Set database title for navigation bar
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];   //Matches Apple's default nav bar title font
        titleLabel.textColor = self.navigationController.navigationBar.tintColor;
        titleLabel.text = self.shapeFamily.database.shortName;
        [titleLabel sizeToFit];
        
        self.navigationItem.titleView = titleLabel;
    }
    
    // Setup info bar
    self.infoBar.textLabel.text = self.shapeFamily.displayName;
    
    // Setup table view
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    // Remove target-actions from the nav bar's unitSystem segmented control
    if ([self.navigationController isKindOfClass:[AW_NavigationController class]]) {
        AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;

        [navController.unitSystem removeTarget:self
                                        action:@selector(switchImperialMetric)
                              forControlEvents:UIControlEventValueChanged];
    }
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
    
    // Configure the cell...
    AW_Shape *shape = self.tableData[indexPath.section][indexPath.row];
    
    cell.textLabel.text = [shape formattedDisplayNameForUnitSystem:[(AW_NavigationController *)self.navigationController isMetric]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    AW_Shape *temp = self.tableData[section][0]; // Used to access the group name for this group
    
    sectionName = [temp formattedGroupNameForUnitSystem:[(AW_NavigationController *)self.navigationController isMetric]];
    
    return sectionName;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_PropertyViewController *nextVC = [[AW_PropertyViewController alloc]initWithNibName:@"AW_PropertyViewController" bundle:[NSBundle mainBundle]];
    
    nextVC.shape = self.tableData[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - Custom methods

// Shows a flip horizontal animation for the view currently at the top of the navigation stack
-(void)switchImperialMetric
{
    UIViewAnimationOptions flipDirection;
    
    if ([(AW_NavigationController *)self.navigationController isMetric]) {
        // Switched imperial to metric. Flip from left.
        flipDirection = UIViewAnimationOptionTransitionFlipFromLeft;
    }
    else {
        // Switched metric to imperial. Flip from right.
        flipDirection = UIViewAnimationOptionTransitionFlipFromRight;
    }
    
    // Reload view
    [UIView transitionWithView:self.view duration:0.6 options:flipDirection animations:
     ^{
         [self.tableView reloadData];
     } completion:nil];
}

@end

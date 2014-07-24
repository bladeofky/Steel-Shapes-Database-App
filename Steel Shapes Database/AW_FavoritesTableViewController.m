//
//  AW_FavoritesTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 6/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_NavigationController.h"
#import "AW_FavoritesTableViewController.h"
#import "AW_PropertyViewController.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"
#import "AW_FavoritedShape.h"
#import "AW_CoreDataStore.h"
#import "AW_FavoritesStore.h"
#import "AW_FavoritesTableViewCell.h"

@interface AW_FavoritesTableViewController ()

@property (nonatomic, strong) NSArray *tableData;

@end

@implementation AW_FavoritesTableViewController

#pragma mark - Custom Accessors
-(NSArray *)tableData
{
    return [[AW_FavoritesStore sharedStore]allItems];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Favorites";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[AW_FavoritesTableViewCell class] forCellReuseIdentifier:@"AW_FavoritesTableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Reset navigation and tab bar colors to default
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.tabBarController.tabBar.barTintColor = nil;
    self.tabBarController.tabBar.tintColor = nil;
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    // This seems redundant, but viewWillAppear is not called upon switching tabs, so it is necessary to reloadData again. If reloadData is NOT included in viewWillAppear, then it will awkwardly pop in after the view has already appeared.
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_FavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AW_FavoritesTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AW_FavoritedShape *favShape = self.tableData[indexPath.row];
    
    cell.textLabel.text = [[favShape shape] formattedDisplayNameForUnitSystem:favShape.defaultUnitSystem];
    cell.detailTextLabel.text = favShape.databaseLongName;
    cell.imageView.image = [favShape shape].shapeFamily.image;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_FavoritedShape *favShape = self.tableData[indexPath.row];
    AW_PropertyViewController *propertyVC = [[AW_PropertyViewController alloc]initWithFavoritedShape:favShape];
    ((AW_NavigationController *)self.navigationController).unitSystem.selectedSegmentIndex = favShape.defaultUnitSystem;
    
    [self.navigationController pushViewController:propertyVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[AW_FavoritesStore sharedStore]removeShapeFromList:self.tableData[indexPath.row]];
        
        // Delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        // Currently unused
    }   
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end

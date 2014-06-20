//
//  AW_FavoritesTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 6/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_FavoritesTableViewController.h"
#import "AW_PropertyViewController.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"
#import "AW_FavoritedShape.h"
#import "AW_CoreDataStore.h"

@interface AW_FavoritesTableViewController ()

@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation AW_FavoritesTableViewController

-(NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc]init];
    }
    
    return _tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // for testing: grab a random item from CoreData and add it to the array
    NSArray *databases = [[AW_CoreDataStore sharedStore]fetchAW_DatabaseObjects];
    AW_Database *database = databases[0];
    AW_ShapeFamily *randomFamily = database.shapeFamilies.allObjects[0];
    AW_Shape *randomShape = randomFamily.shapes.allObjects[0];
    
    AW_FavoritedShape *favShape = [[AW_FavoritedShape alloc]initWithShape:randomShape
                                                                withOrder:[self.tableData count]
                                                           withUnitSystem:0];
    
    [[AW_CoreDataStore sharedStore]returnObjectToFault:randomShape];
    [[AW_CoreDataStore sharedStore]returnObjectToFault:randomFamily];
    [[AW_CoreDataStore sharedStore]returnObjectToFault:database];
    
    [self.tableData insertObject:favShape atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Reset navigation and tab bar colors to default
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.tabBarController.tabBar.barTintColor = nil;
    self.tabBarController.tabBar.tintColor = nil;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AW_FavoritedShape *favShape = self.tableData[indexPath.row];
    
    cell.textLabel.text = [favShape.shape formattedDisplayNameForUnitSystem:favShape.defaultUnitSystem];
    cell.detailTextLabel.text = favShape.databaseShortName;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_PropertyViewController *propertyVC = [[AW_PropertyViewController alloc]initWithFavoritedShape:self.tableData[indexPath.row]];
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

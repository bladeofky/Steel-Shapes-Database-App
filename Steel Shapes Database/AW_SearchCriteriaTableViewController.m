//
//  AW_SearchCriteriaTableViewController.m
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_SearchCriteriaTableViewController.h"
#import "AW_SearchResultsViewController.h"
#import "AW_ShapeFamily.h"
#import "AW_PropertyCriteriaObject.h"
#import "AW_PropertyDescription.h"
#import "AW_AddPropertyCriteriaViewController.h"
#import "AW_PropertyCriteriaTableViewCell.h"
#import "AW_NavigationController.h"
#import "AW_CoreDataStore.h"
#import "AW_Shape.h"
#import "AW_Property.h"
#import "AW_MatchingShape.h"

@interface AW_SearchCriteriaTableViewController ()

@end

@implementation AW_SearchCriteriaTableViewController

#pragma mark - Custom accessors


#pragma mark

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
    [self.tableView registerNib:[UINib nibWithNibName:@"AW_PropertyCriteriaTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AW_PropertyCriteriaTableViewCell"];
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
    
    NSIndexPath *bottomRow;
    if (!self.databaseCriteria) {
        bottomRow = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if (!self.shapeFamilyCriteria) {
        bottomRow = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else if (!self.propertyCriteria) {
        bottomRow = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else {
        bottomRow = [NSIndexPath indexPathForRow:0 inSection:3];
    }
    [self.tableView scrollToRowAtIndexPath:bottomRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    UITableViewCell *cell;
    NSUInteger section = indexPath.section;
    
    // DATABASE CRITERIA
    // Note: We need to set the image every time, because cells are not removed from memory when the Clear button is pressed.
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        if (!self.databaseCriteria) {
            cell.textLabel.text = @"Select Database";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]; // Match default button tint blue
            cell.imageView.image = nil;
        }
        else {
            cell.textLabel.text = self.databaseCriteria.longName;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.image = nil;
        }
    }
    
    // SHAPE FAMILY CRITERIA
    else if (section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        if (!self.shapeFamilyCriteria) {
            // If no shape families selected, present cell to select them
            cell.textLabel.text = @"Select Shape(s)";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]; // Match default button tint blue
            cell.imageView.image = nil;
        }
        else {
            // Display the titles and images of each shape family selected
            AW_ShapeFamily *shapeFamily = self.shapeFamilyCriteria[indexPath.row];
            cell.textLabel.text = shapeFamily.displayName;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.image = shapeFamily.image;
        }
    }
    
    // PROPERTY CRITERIA
    else if (section == 2) {
        
        if (!self.propertyCriteria) {
            // If no property criteria are present, present cell to select them
            cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"Add Search Criteria";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]; // Match default button tint blue
            cell.imageView.image = nil;
        }
        else {
            // Display property criteria
            cell = [tableView dequeueReusableCellWithIdentifier:@"AW_PropertyCriteriaTableViewCell" forIndexPath:indexPath];
            
            cell.textLabel.text = nil;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.image = nil;
            AW_PropertyCriteriaObject *propertyCriteriaObject = self.propertyCriteria[indexPath.row];
            AW_PropertyCriteriaTableViewCell *propertyCriteriaCell = (AW_PropertyCriteriaTableViewCell *)cell;
            propertyCriteriaCell.symbolLabel.attributedText = [propertyCriteriaObject symbol];
            propertyCriteriaCell.relationshipLabel.text = [propertyCriteriaObject relationshipSymbol];
            propertyCriteriaCell.valueLabel.text = [NSString stringWithFormat:@"%@", propertyCriteriaObject.value];
            propertyCriteriaCell.unitsLabel.text = [propertyCriteriaObject units];
        }
    }
    
    // SEARCH BUTTON
    else if (section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"Perform Search";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]; // Match default button tint blue
        cell.imageView.image = nil;
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

        AW_AddPropertyCriteriaViewController *modalVC = [[AW_AddPropertyCriteriaViewController alloc]initWithNibName:@"AW_AddPropertyCriteriaViewController" bundle:[NSBundle mainBundle]];
        
        modalVC.searchCriteriaVC = self;
        
        if (self.propertyCriteria) {
            modalVC.criteria = self.propertyCriteria[indexPath.row];
        }
        
        AW_NavigationController *navController = [[AW_NavigationController alloc]initWithRootViewController:modalVC];
        
        [self presentViewController:navController animated:YES completion:nil];

    }
    
    // SEARCH BUTTON
    else if (section == 3) {
        AW_PropertyCriteriaObject *propertyCriteriaObject = self.propertyCriteria[0];
        
        NSArray *filteredShapes = [self performSearchWithShapeFamilies:self.shapeFamilyCriteria forPropertyCriteria:propertyCriteriaObject];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"imp_value" ascending:YES];
        filteredShapes = [filteredShapes sortedArrayUsingDescriptors:@[sortDescriptor]];
    
        AW_SearchResultsViewController *searchResultsVC = [[AW_SearchResultsViewController alloc]initWithNibName:@"AW_SearchResultsViewController" bundle:[NSBundle mainBundle]];
        searchResultsVC.data = filteredShapes;
        searchResultsVC.symbol = [propertyCriteriaObject.propertyDescription formattedSymbol];
        
        ((AW_NavigationController *)self.navigationController).unitSystem.selectedSegmentIndex = propertyCriteriaObject.isMetric;
        [self.navigationController pushViewController:searchResultsVC animated:YES];
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

-(NSArray *)performSearchWithShapeFamilies:(NSArray *)selectedShapeFamilies
                       forPropertyCriteria:(AW_PropertyCriteriaObject *)propertyCriteria
{
    /*
     Find AW_Shapes whose:
     - Shape Family is in the set of selected shape families
     - Have a property key matching the property criteria description's key
     - Property's value matches the property criteria
     
     1) Create a set of all shapes from the selected shape families
     2) Retrieve the property with matching key and test its value
     */
    
    
    // Collect all shapes from shape families
    NSMutableSet *allShapes = [[NSMutableSet alloc]init];
    for (AW_ShapeFamily *shapeFamily in selectedShapeFamilies) {
        [allShapes addObjectsFromArray:shapeFamily.shapes.allObjects];
    }
    
    // Filter based on criteria
    NSMutableSet *filteredShapes = [[NSMutableSet alloc]init];
    
    for (AW_Shape *shape in allShapes) {

        for (AW_Property *property in shape.properties) {
            
            if ([property.propertyDescription.key isEqual:propertyCriteria.propertyDescription.key]) {  //Matching property
                
                // Computer necessary comparison values
                NSDecimalNumber *criteriaImpValue;
                if (propertyCriteria.isMetric) {
                    //self.value is a metric value and must be converted
                    criteriaImpValue = [propertyCriteria.value decimalNumberByDividingBy:propertyCriteria.propertyDescription.impToMetFactor];
                }
                else {
                    criteriaImpValue = propertyCriteria.value;
                }
                NSDecimalNumber *criteriaImpValuePlusThreshold = [criteriaImpValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1.03"]];
                NSDecimalNumber *criteriaImpValueMinusThreshold = [criteriaImpValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.97"]];
                
                // Test property criteria

                if ( (propertyCriteria.relationship == GREATER_THAN && property.imp_value.doubleValue > criteriaImpValue.doubleValue) ||
                     (propertyCriteria.relationship == GREATER_THAN_OR_EQUAL_TO && property.imp_value.doubleValue >= criteriaImpValue.doubleValue) ||
                     (propertyCriteria.relationship == EQUAL_TO && property.imp_value.doubleValue >= criteriaImpValueMinusThreshold.doubleValue && property.imp_value.doubleValue <= criteriaImpValuePlusThreshold.doubleValue) ||
                     (propertyCriteria.relationship == LESS_THAN_OR_EQUAL_TO && property.imp_value.doubleValue <= criteriaImpValue.doubleValue) ||
                     (propertyCriteria.relationship == LESS_THAN && property.imp_value.doubleValue < criteriaImpValue.doubleValue)
                    ) {
                    // Criteria met: Add shape
                    AW_MatchingShape *matchingShape = [[AW_MatchingShape alloc]init];
                    matchingShape.property = property;
                    matchingShape.imp_value = property.imp_value;
                    matchingShape.shape = shape;
                    [filteredShapes addObject:matchingShape];
                }
                else {
                    // Do nothing
                }
                
                break; // Matching property was found and actions taken. Move on to next shape.
                
            } //end if matching property
            
            else {
                [[AW_CoreDataStore sharedStore]returnObjectToFault:property];
            }
            
        } // end for each property
        
        [[AW_CoreDataStore sharedStore]returnObjectToFault:shape];
        
    } //end for each shape
    
    return filteredShapes.allObjects;
}

#pragma mark - Delegate methods
-(void)databaseSelectorDidChangeDatabase
{
    self.shapeFamilyCriteria = nil;
    self.propertyCriteria = nil;
    
    [self.tableView reloadData];
}

-(void)shapeFamilySelectorDidRemoveShapeFamily
{
    NSMutableArray *propertyCriteriaCollection = [self.propertyCriteria mutableCopy];
    
    NSSet *selectedShapeFamilies = [NSSet setWithArray:self.shapeFamilyCriteria];

    // For each property criteria object
    for (AW_PropertyCriteriaObject *propertyCriteria in propertyCriteriaCollection) {
        
        // If none of the selected shape families contain this property, then remove it from the property criteria colelction
        if (![propertyCriteria.propertyDescription.shapeFamilies intersectsSet:selectedShapeFamilies]) {
            [propertyCriteriaCollection removeObject:propertyCriteria];
        }
    }
    
    if ([propertyCriteriaCollection count] == 0) {
        self.propertyCriteria = nil;
    }
    else {
        self.propertyCriteria = [propertyCriteriaCollection copy];
    }
}


@end

//
//  AW_SearchResultsViewController.m
//  Shape DB
//
//  Created by Alan Wang on 8/22/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_NavigationController.h"
#import "AW_SearchResultsViewController.h"
#import "AW_PropertyViewController.h"
#import "AW_DetailStyleTableViewCell.h"
#import "AW_MatchingShape.h"
#import "AW_Property.h"
#import "AW_Shape.h"

@interface AW_SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *symbolLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *previousSelectionIndexPath;

@end

@implementation AW_SearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[AW_DetailStyleTableViewCell class] forCellReuseIdentifier:@"AW_DetailStyleTableViewCell"];
    
    // Setup navigation bar
    if ([self.navigationController isKindOfClass:[AW_NavigationController class]]) {
        AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navController.unitSystem];
        [navController.unitSystem addTarget:self action:@selector(switchImperialMetric) forControlEvents:UIControlEventValueChanged];
        
        // Set title for navigation bar
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];   //Matches Apple's default nav bar title font
        titleLabel.textColor = self.navigationController.navigationBar.tintColor;
        titleLabel.text = [NSString stringWithFormat:@"%i Results", [self.data count]];;
        [titleLabel sizeToFit];
        
        self.navigationItem.titleView = titleLabel;
    }
    
    self.symbolLabel.attributedText = self.symbol;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload tableView
    [self.tableView reloadData];
    
    // Change colors
    ((UILabel *)self.navigationItem.titleView).textColor = self.navigationController.navigationBar.tintColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set target-action for unitSystem segmented control
    AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
    [navController.unitSystem addTarget:self
                                 action:@selector(switchImperialMetric)
                       forControlEvents:UIControlEventValueChanged];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove target-actions from the nav bar's unitSystem segmented control
    if ([self.navigationController isKindOfClass:[AW_NavigationController class]]) {
        AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
        
        [navController.unitSystem removeTarget:self
                                        action:@selector(switchImperialMetric)
                              forControlEvents:UIControlEventValueChanged];
    }
    
    // Return nav bar title color to default
    ((UILabel *)self.navigationItem.titleView).textColor = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_DetailStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AW_DetailStyleTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AW_MatchingShape *matchingShape = self.data[indexPath.row];
    cell.detailTextLabel.text = [matchingShape.shape formattedDisplayNameForUnitSystem:((AW_NavigationController *)self.navigationController).isMetric];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesSignificantDigits = YES;
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    numberFormatter.minimumSignificantDigits = 3;
    numberFormatter.maximumSignificantDigits = 3;
    
    NSDecimalNumber *value;
    
    if (((AW_NavigationController *)self.navigationController).isMetric) {
        value = [matchingShape.imp_value decimalNumberByMultiplyingBy:matchingShape.property.impToMetFactor];
    }
    else {
        value = matchingShape.imp_value;
    }
    
    if (value.doubleValue > 1000000) {
        numberFormatter.numberStyle = NSNumberFormatterScientificStyle;
    }
    
    cell.textLabel.text = [numberFormatter stringFromNumber:value];
    
    if ([self.previousSelectionIndexPath isEqual:indexPath]) {
        [self.tableView selectRowAtIndexPath:self.previousSelectionIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}


#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.previousSelectionIndexPath = indexPath;
    
    AW_MatchingShape *matchingShape = self.data[indexPath.row];
    AW_PropertyViewController *propertyVC = [[AW_PropertyViewController alloc]initWithShape:matchingShape.shape];
    
    [self.navigationController pushViewController:propertyVC animated:YES];
}

@end

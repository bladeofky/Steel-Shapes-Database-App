//
//  AW_PropertyViewController.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/27/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <iAd/iAd.h>
#import "AW_InfoBar.h"
#import "AW_CoreDataStore.h"
#import "AW_NavigationController.h"
#import "AW_PropertyViewController.h"
#import "AW_PropertyTableViewCell.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"
#import "AW_FavoritedShape.h"
#import "AW_Property.h"

@interface AW_PropertyViewController () <ADBannerViewDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSIndexPath *selectedRow;
@property BOOL bannerViewIsVisible;

@property (nonatomic, strong) AW_Shape *shape;
@property (nonatomic, copy) NSString *navTitleText; // Title text for navigation bar
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *tintColor;

@end

@implementation AW_PropertyViewController

#pragma mark - Custom Accessors
-(NSArray *)tableData
{
    if (!_tableData) {
        // Get list of properties from the shape
        NSArray *propertyList = [self.shape.properties allObjects];
        NSSortDescriptor *sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:YES];
        propertyList = [propertyList sortedArrayUsingDescriptors:@[sortByOrder]];
        
        // Organize shapes into groups
        NSMutableArray *tableDataTemp = [[NSMutableArray alloc]init];
        
        NSMutableDictionary *groupIndex = [[NSMutableDictionary alloc]init];
        
        for (AW_Property *property in propertyList) {
            
            NSString *groupName = property.group;
            
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
            
            [groupStore addObject:property];
        }
        
        _tableData = [tableDataTemp copy];

    }
    
    return _tableData;
}

#pragma mark - Custom Initializer
-(instancetype) initWithShape:(AW_Shape *)shape
{
    self = [super initWithNibName:@"AW_PropertyViewController" bundle:[NSBundle mainBundle]];
    
    if (self) {
        _shape = shape;
        _navTitleText = shape.shapeFamily.database.shortName;
        _barTintColor = shape.shapeFamily.database.backgroundColor;
        _tintColor = shape.shapeFamily.database.textColor;
    }
    
    return self;
}

-(instancetype) initWithFavoritedShape:(AW_FavoritedShape *)favShape
{
    self = [super initWithNibName:@"AW_PropertyViewController" bundle:[NSBundle mainBundle]];
    
    if (self) {
        _shape = favShape.shape;
        _navTitleText = favShape.databaseShortName;
        _barTintColor = favShape.barTintColor;
        _tintColor = favShape.tintColor;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setup navigation bar
    if ([self.navigationController isKindOfClass:[AW_NavigationController class]]) {
        AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navController.unitSystem];
        
        // Set database title for navigation bar
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];   //Matches Apple's default nav bar title font
        titleLabel.textColor = self.navigationController.navigationBar.tintColor;
        titleLabel.text = self.navTitleText;
        [titleLabel sizeToFit];
        
        self.navigationItem.titleView = titleLabel;
    }

    // Set up info bar
    self.infoBar.textLabel.text = [self.shape formattedDisplayNameForUnitSystem:[(AW_NavigationController *)self.navigationController isMetric]];
    self.infoBar.imageView.image = self.shape.shapeFamily.image;
    
    // Set up tableView
    UINib *nib = [UINib nibWithNibName:@"AW_PropertyTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AW_PropertyTableViewCell"];
    
    // Set up iAd banner view
    ADBannerView *adView = [[ADBannerView alloc]initWithAdType:ADAdTypeBanner];
    
    // Puts the adView right beneath the tableView
    adView.frame = CGRectMake(self.tableView.frame.origin.x,
                              self.tabBarController.tabBar.frame.origin.y,
                              self.tableView.frame.size.width,
                              adView.bounds.size.height);
    
    /*
     It would be nice to not have to use the tab bar to position the ad view, but unfortunately the
     tableView origin.y + height does not equal to the bottom position of the tableView when running on a 3.5"
     screen. Possibly this is an issue with autoresizing masks.
     
     NSLog(@"TableView Origin Y = %f", self.tableView.frame.origin.y);
     NSLog(@"TableView Height = %f", self.tableView.frame.size.height);
     NSLog(@"TabBar Origin Y = %f", self.tabBarController.tabBar.frame.origin.y);
     */
    
    adView.delegate = self;
    [self.view addSubview:adView];
    
    NSLayoutConstraint *constraintWithTableView = [NSLayoutConstraint constraintWithItem:adView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.tableView
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.0
                                                                                constant:0.0];
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[adView]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"adView": adView}];
    
    [self.view addConstraints:horizontalConstraint];
    [self.view addConstraint:constraintWithTableView];
    
    self.bannerViewIsVisible = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Reload tableView
    [self.tableView reloadData];
    
    // Change colors
    self.navigationController.navigationBar.barTintColor = self.barTintColor;
    self.navigationController.navigationBar.tintColor = self.tintColor;
    ((UILabel *)self.navigationItem.titleView).textColor = self.tintColor;
    self.tabBarController.tabBar.barTintColor = self.barTintColor;
    self.tabBarController.tabBar.tintColor = self.tintColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    // Set target-action for unitSystem segmented control
    AW_NavigationController *navController = (AW_NavigationController *)self.navigationController;
    [navController.unitSystem addTarget:self
                                 action:@selector(switchImperialMetric)
                       forControlEvents:UIControlEventValueChanged];
    
    // Change colors
//    self.navigationController.navigationBar.barTintColor = self.barTintColor;
//    self.navigationController.navigationBar.tintColor = self.tintColor;
    ((UILabel *)self.navigationItem.titleView).textColor = self.tintColor;
    self.tabBarController.tabBar.barTintColor = self.barTintColor;
    self.tabBarController.tabBar.tintColor = self.tintColor;
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
    
    // Return nav bar title color to default
    ((UILabel *)self.navigationItem.titleView).textColor = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Return all managed objects to faults
    for (AW_Property *property in self.shape.properties)
    {
        [[AW_CoreDataStore sharedStore]returnObjectToFault:property];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isMetric = [(AW_NavigationController *)self.navigationController isMetric];
    
    AW_Property *property = self.tableData[indexPath.section][indexPath.row];
    AW_PropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AW_PropertyTableViewCell" forIndexPath:indexPath];

    cell.symbolLabel.attributedText = [property formattedSymbol];
    cell.valueLabel.text = [property formattedValueForUnitSystem:isMetric];
    cell.unitLabel.text = [property formattedUnitsForUnitSystem:isMetric];
    cell.descriptionTextView.text = [property longDescription];
    cell.descriptionTextView.font = [UIFont systemFontOfSize:15.0];
    //NSLog(@"%@", [property longDescription]);
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    AW_Property *property = self.tableData[section][0];
    
    return property.group;
}

#pragma mark - Table View delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath;
    
    // Animated the change in row height (see code in tableView: heightForRowAtIndexPath
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectedRow]) {
        // Manually deselect row
        [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        
        return nil;
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = nil;
    
    // Animated the change in row height (see code in tableView: heightForRowAtIndexPath
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TO-DO: Figure out how to make this work by using a property from the cell
    // Currently, using cellForRowAtIndexPath results in a bad access error
    // We will need to use a property for the individual cell, since the required height may
    // change depending on if an image is included.
    
    CGFloat rowHeight;
    
    if ([indexPath isEqual:self.selectedRow]) {
        // For the selected row, display the full height of the cell
        rowHeight = 100;    // This is the bounds height for AW_PropertyTableViewCell
    }
    else {
        // Otherwise, only show the top 44 points (default size for tableView)
        rowHeight = 44;
    }
    
    return rowHeight;
}

#pragma mark - Custom methods

// Shows a flip horizontal animation for the view currently at the top of the navigation stack
-(void)switchImperialMetric
{
    BOOL isMetric = [(AW_NavigationController *)self.navigationController isMetric];
    UIViewAnimationOptions flipDirection;
    
    if (isMetric) {
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
         self.infoBar.textLabel.text = [self.shape formattedDisplayNameForUnitSystem:isMetric];
         [self.tableView reloadData];
     } completion:nil];
}

#pragma mark - iAd methods
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    if (!self.bannerViewIsVisible) {
        NSLog(@"Banner view did load ad");
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        CGFloat bannerHeight = banner.bounds.size.height;
        banner.frame = CGRectOffset(banner.frame, 0, -bannerHeight);    //tableView will automatically readjust because of the constraint we made in viewDidLoad
        [UIView commitAnimations];
        self.bannerViewIsVisible = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerViewIsVisible) {
        NSLog(@"bannerView:didFailToReceiveAdWithError");
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        CGFloat bannerHeight = banner.bounds.size.height;
        banner.frame = CGRectOffset(banner.frame, 0, bannerHeight); //tableView will automatically readjust because of the constraint we made in viewDidLoad
        [UIView commitAnimations];
        self.bannerViewIsVisible = NO;
    }
}


@end

//
//  AW_AddPropertyCriteriaViewController.m
//  Shape DB
//
//  Created by Alan Wang on 8/2/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_ShapeFamily.h"
#import "AW_SearchCriteriaTableViewController.h"
#import "AW_AddPropertyCriteriaViewController.h"
#import "AW_PropertyCriteriaObject.h"
#import "AW_PropertyDescription.h"
#import "AW_DetailStyleTableViewCell.h"
#import "AW_TriangleView.h"

@interface AW_AddPropertyCriteriaViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) AW_PropertyCriteriaTableViewCell *propertyCriteriaView;
@property (weak, nonatomic) IBOutlet UIScrollView *editorScrollView;

@property (nonatomic, weak) AW_TriangleView *arrow;
@property (nonatomic, weak) UILabel *propertyDescriptionLabel;
@property (nonatomic, weak) UITableView *propertyTableView;
@property (nonatomic, weak) UIView *relationshipPickerView;
@property (nonatomic, weak) UIPickerView *relationshipPicker;
@property (nonatomic, weak) IBOutlet UIView *valueEntryView;
@property (nonatomic, weak) IBOutlet UITextField *valueEntryTextField;
@property (nonatomic, weak) IBOutlet UILabel *valueEntryUnitLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *unitSystemControl;

@property (nonatomic, strong) NSArray *allProperties;

@end

@implementation AW_AddPropertyCriteriaViewController

#pragma mark - Custom Accessors

-(AW_PropertyCriteriaObject *)criteria
{
    if (!_criteria) {
        // Create some default values
        _criteria = [[AW_PropertyCriteriaObject alloc]init];
        
        _criteria.propertyDescription = self.allProperties[0];
        _criteria.relationship = 2;
        _criteria.value = [NSDecimalNumber decimalNumberWithString:@"0"];
        _criteria.isMetric = 0;
    }
    
    return _criteria;
}

-(NSArray *)allProperties
{
    if (!_allProperties) {
        NSArray *shapeFamilies = [self.searchCriteriaVC shapeFamilyCriteria];
        
        NSMutableSet *propertyDescriptions = [[NSMutableSet alloc]init];
        
        for (AW_ShapeFamily *family in shapeFamilies) {
            [propertyDescriptions addObjectsFromArray:[family.propertyDescriptions allObjects]];
        }
        
        _allProperties = [propertyDescriptions allObjects];
        NSSortDescriptor *sortByDefaultOrder = [[NSSortDescriptor alloc]initWithKey:@"defaultOrder" ascending:YES];
        _allProperties = [_allProperties sortedArrayUsingDescriptors:@[sortByDefaultOrder]];
    }

    return _allProperties;
}

-(CGPoint)symbolArrowLocation
{
    CGPoint origin = self.displayView.frame.origin;
    CGFloat symbolMidpointX = origin.x + self.propertyCriteriaView.symbolLabel.frame.origin.x + self.propertyCriteriaView.symbolLabel.frame.size.width/2;
    CGFloat symbolBottom = origin.y + self.displayView.frame.size.height;
    
    return CGPointMake(symbolMidpointX, symbolBottom);
}

-(CGPoint)relationshipArrowLocation
{
    CGPoint origin = self.displayView.frame.origin;
    CGFloat relationshipMidpointX = origin.x + self.propertyCriteriaView.relationshipLabel.frame.origin.x + self.propertyCriteriaView.relationshipLabel.frame.size.width/2;
    CGFloat relationshipBottom = origin.y + self.displayView.frame.size.height;
    
    return CGPointMake(relationshipMidpointX, relationshipBottom);
}

-(CGPoint)valueArrowLocation
{
    CGPoint origin = self.displayView.frame.origin;
    CGFloat valueEndpointX = origin.x + self.propertyCriteriaView.valueLabel.frame.origin.x + self.propertyCriteriaView.valueLabel.frame.size.width;
    CGFloat valueBottom = origin.y + self.displayView.frame.size.height;
    
    return CGPointMake(valueEndpointX, valueBottom);
}

#pragma mark - Auto Layout
-(void)viewDidLayoutSubviews
{
    // Set content size
    int numberOfPages = 3;
    CGFloat scrollViewWidth = self.editorScrollView.bounds.size.width;
    CGFloat scrollViewHeight = self.editorScrollView.bounds.size.height;
    self.editorScrollView.contentSize = CGSizeMake(scrollViewWidth * numberOfPages, scrollViewHeight);
    
    self.propertyDescriptionLabel.frame = CGRectMake(20, 8, scrollViewWidth - 40, 44);
    self.propertyTableView.frame = CGRectMake(0, self.propertyDescriptionLabel.frame.origin.y + self.propertyDescriptionLabel.frame.size.height + 8, scrollViewWidth, scrollViewHeight - (self.propertyDescriptionLabel.frame.size.height + 8));
    
    self.relationshipPickerView.frame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.relationshipPicker.frame = CGRectMake(20, 44, scrollViewWidth - 40, scrollViewHeight);
    
    self.valueEntryView.frame = CGRectMake(scrollViewWidth * 2, 0, scrollViewWidth, scrollViewHeight);
    
    [self.view layoutSubviews];
    
    [self moveArrowToPointAt:[self symbolArrowLocation]];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Populate the editorScrollView with editing views
    // Arrow
    AW_TriangleView *triangleView = [[AW_TriangleView alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
    [triangleView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:triangleView];
    self.arrow = triangleView;
    
    // Initialize the display
    NSArray *temp = [[NSBundle mainBundle]loadNibNamed:@"AW_PropertyCriteriaTableViewCell" owner:self options:nil];
    self.propertyCriteriaView = [temp firstObject];
    [self.displayView addSubview:self.propertyCriteriaView];
    [self updatePropertyCriteriaDisplay];
    self.propertyCriteriaView.symbolLabel.userInteractionEnabled = YES;
    self.propertyCriteriaView.relationshipLabel.userInteractionEnabled = YES;
    self.propertyCriteriaView.valueLabel.userInteractionEnabled = YES;
    self.propertyCriteriaView.unitsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnSymbol = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToPropertyInput)];
    UITapGestureRecognizer *tapOnRelationship = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToRelationshipInput)];
    UITapGestureRecognizer *tapOnValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToValueInput)];
    UITapGestureRecognizer *tapOnUnits = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToValueInput)];
    [self.propertyCriteriaView.symbolLabel addGestureRecognizer:tapOnSymbol];
    [self.propertyCriteriaView.relationshipLabel addGestureRecognizer:tapOnRelationship];
    [self.propertyCriteriaView.valueLabel addGestureRecognizer:tapOnValue];
    [self.propertyCriteriaView.unitsLabel addGestureRecognizer:tapOnUnits];
    
    // Create criteria editing subviews
    // Property selector
    UILabel *propertyDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    propertyDescriptionLabel.font = [UIFont systemFontOfSize:15.0];
    propertyDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    propertyDescriptionLabel.numberOfLines = 0;
    [self.editorScrollView addSubview:propertyDescriptionLabel];
    self.propertyDescriptionLabel = propertyDescriptionLabel;
    
    UITableView *propertySelector = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [propertySelector registerClass:[AW_DetailStyleTableViewCell class] forCellReuseIdentifier:@"AW_DetailStyleTableViewCell"];
    propertySelector.dataSource = self;
    propertySelector.delegate = self;
    [self.editorScrollView addSubview:propertySelector];    //editorScrollView has strong ownership of propertySelector
    self.propertyTableView = propertySelector;              //self.propertyTableView has weak ownership of propertySelector
    
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[propertyDescription]-[propertySelector]|"
//                                            options:0
//                                            metrics:nil
//                                              views:@{@"propertyDescription": propertyDescriptionLabel,
//                                                      @"propertySelector"   : propertySelector}];
//    [self.editorScrollView addConstraints:constraints];
//    [propertySelector setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
//    [propertySelector setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    [propertyDescriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    [propertyDescriptionLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
//    [propertyDescriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // Relationship picker
    UIView *relationshipPickerView = [[UIView alloc]initWithFrame:CGRectZero];
    UIPickerView *relationshipPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [relationshipPickerView addSubview:relationshipPicker];
    
    relationshipPicker.dataSource = self;
    relationshipPicker.delegate = self;
    [self.editorScrollView addSubview:relationshipPickerView];
    self.relationshipPicker = relationshipPicker;
    self.relationshipPickerView = relationshipPickerView;
    
    // Value entry
    UIView *valueEditorView = [[[NSBundle mainBundle]loadNibNamed:@"ValueEntryView" owner:self options:nil] firstObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self.valueEntryTextField action:@selector(resignFirstResponder)];
    [valueEditorView addGestureRecognizer:tap];
    [self.editorScrollView addSubview:valueEditorView];
    self.valueEntryUnitLabel.text = @"in.";
    [self.valueEntryTextField addTarget:self action:@selector(valueWasEdited) forControlEvents:UIControlEventEditingChanged];
    self.unitSystemControl.selectedSegmentIndex = 0;
    [self.unitSystemControl addTarget:self action:@selector(unitsDidChange) forControlEvents:UIControlEventValueChanged];
    
    
    
    // Set up views for initial criteria
    NSInteger initialPropertyDescriptionIndex = [self.allProperties indexOfObject:self.criteria.propertyDescription];
    NSIndexPath *initialPropertyDescriptionIndexPath = [NSIndexPath indexPathForRow:initialPropertyDescriptionIndex inSection:0];
    // Select the row
    [self tableView:propertySelector willSelectRowAtIndexPath:initialPropertyDescriptionIndexPath];
    [propertySelector selectRowAtIndexPath:initialPropertyDescriptionIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:propertySelector didSelectRowAtIndexPath:initialPropertyDescriptionIndexPath];
    
    [self.relationshipPicker selectRow:self.criteria.relationship inComponent:0 animated:NO];
    
    self.valueEntryTextField.text = [NSString stringWithFormat:@"%@",self.criteria.value];
    self.valueEntryUnitLabel.text = [self.criteria.propertyDescription formattedUnitsForUnitSystem:self.criteria.isMetric];
    
    self.unitSystemControl.selectedSegmentIndex = self.criteria.isMetric;
    
    
    // Set up Nav Bar stuff
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelfAndPassPropertyCriteria)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.tintColor = self.searchCriteriaVC.databaseCriteria.textColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Edit Property Criteria";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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

#pragma mark - Navigation
- (void)dismissSelfAndPassPropertyCriteria
{
    // Temporary implementation for single property search
    self.searchCriteriaVC.propertyCriteria = @[self.criteria];
    [self.searchCriteriaVC dismissViewControllerAnimated:YES completion:nil];
    
    // THIS IMPLEMENTATION FOR MULTIPLE PROPERTY CRITERIA. USE IN FUTURE
//    NSMutableArray *propertyCriteriaCollection;
//    
//    if (!self.searchCriteriaVC.propertyCriteria) {
//        // If there are currently no property criteria, then the collection is nil so we need to create it
//        propertyCriteriaCollection = [[NSMutableArray alloc]init];
//    }
//    else {
//        propertyCriteriaCollection = [self.searchCriteriaVC.propertyCriteria mutableCopy];
//    }
//    
//    [propertyCriteriaCollection addObject:self.criteria];
//    self.searchCriteriaVC.propertyCriteria = [propertyCriteriaCollection copy];
//    [self.searchCriteriaVC dismissViewControllerAnimated:YES
//                                              completion:nil];
}

- (void)dismissSelf
{
    [self.searchCriteriaVC dismissViewControllerAnimated:YES
                                              completion:nil];
}

#pragma mark - Table View Delegate/Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allProperties count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AW_DetailStyleTableViewCell"];
    
    AW_PropertyDescription *propertyDescription = self.allProperties[indexPath.row];
    
    cell.textLabel.attributedText = [propertyDescription formattedSymbol];
    cell.detailTextLabel.text = propertyDescription.longDescription;
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_PropertyDescription *propertyDescription = self.allProperties[indexPath.row];
    
    self.propertyDescriptionLabel.text = propertyDescription.longDescription;
    
    // Resize label
    CGPoint oldTableViewOffset = [self.propertyTableView contentOffset];
    CGSize labelSize = [self.propertyDescriptionLabel.text sizeWithFont:self.propertyDescriptionLabel.font
                                                 constrainedToSize:CGSizeMake(self.propertyDescriptionLabel.frame.size.width, MAXFLOAT)
                                                     lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat newLabelHeight = MAX(labelSize.height, 44);
    CGFloat currentLabelHeight = self.propertyDescriptionLabel.frame.size.height;
    CGFloat verticalOffset = newLabelHeight - currentLabelHeight;
    
    self.propertyDescriptionLabel.frame = CGRectMake(self.propertyDescriptionLabel.frame.origin.x,
                                                     self.propertyDescriptionLabel.frame.origin.y,
                                                     self.propertyDescriptionLabel.frame.size.width,
                                                     newLabelHeight);
    
    CGFloat scrollViewHeight = self.editorScrollView.bounds.size.height;
    CGFloat tableViewOriginY = self.propertyTableView.frame.origin.y + verticalOffset;
    CGFloat tableViewHeight = scrollViewHeight - tableViewOriginY;
    self.propertyTableView.frame = CGRectMake(self.propertyTableView.frame.origin.x,
                                              tableViewOriginY,
                                              self.propertyTableView.frame.size.width,
                                              tableViewHeight);
    
    [self.propertyTableView setContentOffset:CGPointMake(oldTableViewOffset.x, oldTableViewOffset.y + verticalOffset)];
    
    // If selection is different from existing propertyDescription, change criteria.propertyDescription to the selected propertyDescription
    if (![propertyDescription isEqual:self.criteria.propertyDescription]) {
        self.criteria.propertyDescription = propertyDescription;
        [self unitsDidChange];
    }
    
    [self.propertyDescriptionLabel setNeedsDisplay];
    [self.propertyTableView setNeedsDisplay];
    [self updatePropertyCriteriaDisplay];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select Property";
}

#pragma mark - Relationship Picker Delegate/Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:24.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        switch (row) {
            case GREATER_THAN:
                label.text = @">";
                break;
            case GREATER_THAN_OR_EQUAL_TO:
                label.text = @"\u2265";
                break;
            case EQUAL_TO:
                label.text = @"=";
                break;
            case LESS_THAN_OR_EQUAL_TO:
                label.text = @"\u2264";
                break;
            case LESS_THAN:
                label.text = @"<";
                break;
                
            default:
                label.text = @"UNKN";
                break;
        } // end switch
        
        return label;
    }
    else {
        return view;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.criteria.relationship = row;
    [self updatePropertyCriteriaDisplay];
}

#pragma mark - Scroll View Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.editorScrollView.bounds.size.width;
    CGFloat arrowNewX;
    CGFloat arrowNewY;
    
    if (scrollView.contentOffset.x < pageWidth) {
        CGPoint symbolArrowLocation = [self symbolArrowLocation];
        CGPoint relationshipArrowLocation = [self relationshipArrowLocation];
        CGFloat arrowDistanceBetweenSymbolAndRelationship = relationshipArrowLocation.x - symbolArrowLocation.x;
        arrowNewX = (scrollView.contentOffset.x / pageWidth) * arrowDistanceBetweenSymbolAndRelationship + symbolArrowLocation.x;
        arrowNewY = (symbolArrowLocation.y + relationshipArrowLocation.y)/2;
        
        [self moveArrowToPointAt:CGPointMake(arrowNewX, arrowNewY)];
    }
    else if (scrollView.contentOffset.x >= pageWidth)
    {
        CGPoint valueArrowLocation = [self valueArrowLocation];
        CGPoint relationshipArrowLocation = [self relationshipArrowLocation];
        CGFloat arrowDistanceBetweenRelationshipAndValue = valueArrowLocation.x - relationshipArrowLocation.x;
        arrowNewX = ((scrollView.contentOffset.x - pageWidth) / pageWidth) * arrowDistanceBetweenRelationshipAndValue + relationshipArrowLocation.x;
        arrowNewY = (relationshipArrowLocation.y + valueArrowLocation.y)/2;
        
        [self moveArrowToPointAt:CGPointMake(arrowNewX, arrowNewY)];
    }
    
    if (scrollView.contentOffset.x == 2*pageWidth) {
        [self.valueEntryTextField becomeFirstResponder];
    }
    else {
        [self.valueEntryTextField resignFirstResponder];
    }
}

#pragma mark - Value Editor
-(void)unitsDidChange
{
    self.criteria.isMetric = self.unitSystemControl.selectedSegmentIndex;
    self.valueEntryUnitLabel.text = [self.criteria.propertyDescription formattedUnitsForUnitSystem:self.criteria.isMetric];
    [self updatePropertyCriteriaDisplay];
}

-(void)valueWasEdited
{
    if ([self.valueEntryTextField.text isEqualToString:@""]) {
        self.criteria.value = [NSDecimalNumber zero];
    }
    else {
        self.criteria.value = [NSDecimalNumber decimalNumberWithString:self.valueEntryTextField.text];
    }
    
    [self updatePropertyCriteriaDisplay];
}

#pragma mark - Helper Methods
-(void)updatePropertyCriteriaDisplay
{
    self.propertyCriteriaView.symbolLabel.attributedText = [self.criteria.propertyDescription formattedSymbol];
    
    switch (self.criteria.relationship) {
        case GREATER_THAN:
            self.propertyCriteriaView.relationshipLabel.text = @">";
            break;
        case GREATER_THAN_OR_EQUAL_TO:
            self.propertyCriteriaView.relationshipLabel.text = @"\u2265";
            break;
        case EQUAL_TO:
            self.propertyCriteriaView.relationshipLabel.text = @"=";
            break;
        case LESS_THAN_OR_EQUAL_TO:
            self.propertyCriteriaView.relationshipLabel.text = @"\u2264";
            break;
        case LESS_THAN:
            self.propertyCriteriaView.relationshipLabel.text = @"<";
            break;
        default:
            self.propertyCriteriaView.relationshipLabel.text = @"UNKN";
            break;
    } // end switch
    
    self.propertyCriteriaView.valueLabel.text = [NSString stringWithFormat:@"%@",self.criteria.value];
    self.propertyCriteriaView.unitsLabel.text = [self.criteria.propertyDescription formattedUnitsForUnitSystem:self.criteria.isMetric];
    
    [self.propertyCriteriaView setNeedsDisplay];
}

-(void)moveArrowToPointAt:(CGPoint)point
{
    CGFloat newOriginX = point.x - self.arrow.frame.size.width/2;
    CGFloat newOriginY = point.y;
    
    self.arrow.frame = CGRectMake(newOriginX, newOriginY, self.arrow.frame.size.width, self.arrow.frame.size.height);
    [self.arrow setNeedsDisplay];
}

-(void)scrollToPropertyInput
{
    [self.editorScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollToRelationshipInput
{
    [self.editorScrollView setContentOffset:CGPointMake(self.editorScrollView.frame.size.width, 0) animated:YES];
}

-(void)scrollToValueInput
{
    [self.editorScrollView setContentOffset:CGPointMake(self.editorScrollView.frame.size.width * 2, 0) animated:YES];
}

@end

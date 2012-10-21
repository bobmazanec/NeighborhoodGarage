//
//  NGFuelingViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/28/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling+CoreDataOps.h"
#import "NGFuelingViewController.h"

static NSNumber *NumberFromTextField( UITextField *textField) {
    return [NSNumber numberWithDouble:[textField.text doubleValue]];
}

@interface NGFuelingViewController ()
@property (weak, nonatomic) IBOutlet UITextField        *costTextField;
@property (weak, nonatomic) IBOutlet UITextField        *dateField;
@property (weak, nonatomic) IBOutlet UIButton           *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *saveButton;
@property (weak, nonatomic) IBOutlet UITextField        *fuelVolumeTextField;
@property (weak, nonatomic) IBOutlet UITextField        *odometerTextField;

@property (strong, nonatomic) NSDate        *date;
@property (strong, nonatomic) UIDatePicker  *datePicker;
@end

@implementation NGFuelingViewController
@synthesize costTextField       = _costTextField;
@synthesize date                = _date;
@synthesize dateField           = _dateField;
@synthesize datePicker          = _datePicker;
@synthesize deleteButton        = _deleteButton;
@synthesize saveButton          = _saveButton;
@synthesize fueling             = _fueling;
@synthesize fuelVolumeTextField = _fuelVolumeTextField;
@synthesize managedObjectContext= _managedObjectContext;
@synthesize odometerTextField   = _odometerTextField;


- (NSManagedObjectContext *)managedObjectContext {
    if ( ! _managedObjectContext && self.fueling != nil ) {
        _managedObjectContext = self.fueling.managedObjectContext;
    }
    
    return _managedObjectContext;
}

- (IBAction)deleteFueling:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Really delete this Fueling?"
                                                       delegate:self
                                              cancelButtonTitle:@"No - do not delete"
                                         destructiveButtonTitle:@"Yes - delete"
                                              otherButtonTitles:nil
                            ];
    
    [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (void) saveChanges {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (IBAction)saveFueling:(id)sender {
    NGFueling *fueling;
    
    if (( fueling = self.fueling ) == nil ) {
        // Not editing an existing Fueling -- make a new one
        fueling = [NSEntityDescription insertNewObjectForEntityForName:@"Fueling"inManagedObjectContext:self.managedObjectContext];
    }
    
    fueling.timeStamp    = self.date;
    fueling.odometer     = NumberFromTextField( self.odometerTextField );
    fueling.fuelCost     = NumberFromTextField( self.costTextField );
    fueling.fuelVolume   = NumberFromTextField( self.fuelVolumeTextField );
    
    [self saveChanges];
    
    // Dismiss/hide any keyboard/inputView visible
    [self hideCostKeyboard];
    [self hideFuelVolumeKeyboard];
    [self hideOdometerKeyboard];
    [self dismissDatePicker];
    
    if ( self.fueling ) {
        // Back to the "parent"
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NGFueling *previousFueling;
        
        if (( previousFueling = fueling.previousFueling )) {
            double      milesSince      = [fueling.odometer doubleValue] - [previousFueling.odometer doubleValue];
            NSInteger   daysSince       = [fueling.timeStamp timeIntervalSinceDate:previousFueling.timeStamp] / ( 60 * 60 * 24 );
            double      milesPerGallon  = milesSince / [fueling.fuelVolume doubleValue];
            
            // Really want to compute & display stats for that last "tank" of gas, but for now...
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Since Last Fueling..."
                                                            message:[NSString stringWithFormat:@"Miles = %02lf\nDays = %d\nMPG = %02lf", milesSince, daysSince, milesPerGallon]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
        // Clear the entries - ready for next entry
        [self clearCost];
        [self clearFuelVolume];
        [self setSaveButtonState];
    }
}

- (BOOL)textFieldHasData:(UITextField *)textField {
    return [textField.text length] > 0;
}

- (BOOL)costHasData {
    return [self textFieldHasData:self.costTextField];
}

- (BOOL)fuelHasData {
    return [self textFieldHasData:self.fuelVolumeTextField];
}

- (BOOL)odometerHasData {
    return [self textFieldHasData:self.odometerTextField];
}

- (void)setSaveButtonState {
    self.saveButton.enabled = [self costHasData]
    && [self fuelHasData]
    && [self odometerHasData];
}

- (void)textFieldChanaged:(id)object {
    [self setSaveButtonState];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( self.fueling ) {
        self.costTextField      .text   = [self.fueling.fuelCost   stringValue];
        self.date                       =  self.fueling.timeStamp;
        self.fuelVolumeTextField.text   = [self.fueling.fuelVolume stringValue];
        self.odometerTextField  .text   = [self.fueling.odometer   stringValue];
        
        self.title                  = @"Edit Fueling Info";
        
        self.deleteButton.hidden    = NO;
    } else {
        self.date                   = [NSDate date];
        self.deleteButton.hidden    = YES;
    }
    
    self.costTextField.keyboardType         = UIKeyboardTypeNumberPad;
    self.costTextField.inputAccessoryView   = [self accessoryViewCallsClearSelector:@selector(clearCost) callsDoneSelector:@selector(hideCostKeyboard)];
    self.costTextField.delegate             = self;
    
    [self initDecimalEntryTextField:self.fuelVolumeTextField withClearSelector:@selector(clearFuelVolume) withDoneSelector:@selector(hideFuelVolumeKeyboard)];
    
    [self initDecimalEntryTextField:self.odometerTextField withClearSelector:@selector(clearOdometer) withDoneSelector:@selector(hideOdometerKeyboard)];
    
    self.dateField.inputView            = self.datePicker;
    self.dateField.inputAccessoryView   = [self dateFieldAccessoryView];    // self.date must be set!
    
    [self showDate];

    [self setSaveButtonState];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)initDecimalEntryTextField:(UITextField *)textField withClearSelector:(SEL)clearSelector withDoneSelector:(SEL)doneSelector {
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.inputAccessoryView = [self accessoryViewCallsClearSelector:clearSelector callsDoneSelector:doneSelector];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanaged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField
     ];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self setSaveButton:nil];
    [self setOdometerTextField:nil];
    [self setFuelVolumeTextField:nil];
    [self setCostTextField:nil];
    [self setDateField:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate


#pragma mark - inputAccessoryView

#define BARBUTTON( TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define SYSBARBUTTON( ITEM, SELECTOR) [[ UIBarButtonItem alloc] \
initWithBarButtonSystemItem:ITEM \
target:self action:SELECTOR]

- (UIToolbar *) accessoryViewCallsClearSelector:(SEL)clearSelector callsDoneSelector:(SEL)doneSelector {
    // Return an accessory toolbar with two buttons: Clear and Done
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    tb.tintColor = [UIColor darkGrayColor];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:BARBUTTON(@" Clear", clearSelector)];
    [items addObject:SYSBARBUTTON( UIBarButtonSystemItemFlexibleSpace, nil)];
    [items addObject:BARBUTTON(@" Done", doneSelector)];
    tb.items = items;
    return tb;
}

- (UIToolbar *)dateFieldAccessoryView {
    // Return an accessory toolbar with two buttons: Clear and Done
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    tb.tintColor = [UIColor darkGrayColor];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:BARBUTTON(@"Today", @selector(selectToday))];
    [items addObject:SYSBARBUTTON( UIBarButtonSystemItemFlexibleSpace, nil)];
    [items addObject:BARBUTTON(@"Done", @selector(dismissDatePicker))];
    tb.items = items;
    return tb;
}

- (void)selectToday {
    self.datePicker.date = [NSDate date];
}

- (void)dismissDatePicker {
    self.date = self.datePicker.date;
    [self showDate];
    [self.dateField resignFirstResponder];
}

#pragma mark - Text Field functions

- (void)clearCost {
    self.costTextField.text = @"";
    [self setSaveButtonState];
}

- (void)hideCostKeyboard {
    [self.costTextField resignFirstResponder];
}

- (void)clearFuelVolume {
    self.fuelVolumeTextField.text = @"";
}

- (void)hideFuelVolumeKeyboard {
    [self.fuelVolumeTextField resignFirstResponder];
}

- (void)clearOdometer {
    self.odometerTextField.text = @"";
}

- (void)hideOdometerKeyboard {
    [self.odometerTextField resignFirstResponder];
}

- (void)showDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    self.dateField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.date]];
}

#pragma mark - Date picker

- (void)dateChanged:(id)sender {
    self.date = self.datePicker.date;
    [self showDate];
}

- (UIDatePicker *)datePicker {
    if ( ! _datePicker ) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode  = UIDatePickerModeDate;
        
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.date = self.date;
        _datePicker.maximumDate = [NSDate date];    // no later than today
    }
    
    return _datePicker;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ( textField == self.costTextField ) {
        NSMutableString *newString = [textField.text mutableCopy];
        [newString replaceCharactersInRange:range withString:string];
        [newString replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, [newString length])];
        NSInteger intValue = [newString integerValue];
        textField.text = [NSString stringWithFormat:@"%0.2f", intValue / 100.0];
        [self setSaveButtonState];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate

static const NSInteger ConfirmButtonIndex = 0;

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == ConfirmButtonIndex ) {
        [self.managedObjectContext deleteObject:self.fueling];
        [self saveChanges];
    
        // Pop view past the 'detail' view back to the list
        NSArray             *viewControllers                = self.navigationController.viewControllers;
        NSUInteger           numViewControllers             = [viewControllers count];
        NSUInteger           viewControllerBeforeLastIndex  = numViewControllers - 3;   // -1 is this; -2 is previous; -3 before that one
        UIViewController    *viewControllerBeforeLast       = [viewControllers objectAtIndex:viewControllerBeforeLastIndex];
        [self.navigationController popToViewController:viewControllerBeforeLast animated:YES];
    }
}

@end

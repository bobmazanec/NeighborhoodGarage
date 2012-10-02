//
//  NGFuelingViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/28/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling.h"
#import "NGFuelingViewController.h"

static NSNumber *NumberFromTextField( UITextField *textField) {
    return [NSNumber numberWithDouble:[textField.text doubleValue]];
}

@interface NGFuelingViewController ()
@property (weak, nonatomic) IBOutlet UITextField        *costTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *doneButton;
@property (weak, nonatomic) IBOutlet UITextField        *fuelVolumeTextField;
@property (weak, nonatomic) IBOutlet UITextField        *odometerTextField;
@end

@implementation NGFuelingViewController
@synthesize costTextField       = _costTextField;
@synthesize doneButton          = _doneButton;
@synthesize fuelVolumeTextField = _fuelVolumeTextField;
@synthesize managedObjectContext= _managedObjectContext;
@synthesize odometerTextField   = _odometerTextField;

- (IBAction)saveFueling:(id)sender {
    NGFueling *newFueling = [NSEntityDescription insertNewObjectForEntityForName:@"Fueling"inManagedObjectContext:self.managedObjectContext];
    
    newFueling.timeStamp    = [NSDate date];
    newFueling.odometer     = NumberFromTextField( self.odometerTextField );
    newFueling.fuelCost     = NumberFromTextField( self.costTextField );
    newFueling.fuelVolume   = NumberFromTextField( self.fuelVolumeTextField );
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Clear the entries & tell the user all is well
    [self clearCost];
    [self clearFuelVolume];
    [self setDoneButtonState];
    
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Saved the Fueling" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    */
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

- (void)setDoneButtonState {
    self.doneButton.enabled = [self costHasData]
    && [self fuelHasData]
    && [self odometerHasData];
}

- (void)textFieldChanaged:(id)object {
    [self setDoneButtonState];
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
    
    [self initDecimalEntryTextField:self.costTextField withClearSelector:@selector(clearCost) withDoneSelector:@selector(hideCostKeyboard)];
    
    [self initDecimalEntryTextField:self.fuelVolumeTextField withClearSelector:@selector(clearFuelVolume) withDoneSelector:@selector(hideFuelVolumeKeyboard)];
    
    [self initDecimalEntryTextField:self.odometerTextField withClearSelector:@selector(clearOdometer) withDoneSelector:@selector(hideOdometerKeyboard)];
    
    [self setDoneButtonState];

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

    [self setDoneButton:nil];
    [self setOdometerTextField:nil];
    [self setFuelVolumeTextField:nil];
    [self setCostTextField:nil];
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

#pragma mark - Text Field functions

- (void)clearCost {
    self.costTextField.text = @"";
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
@end

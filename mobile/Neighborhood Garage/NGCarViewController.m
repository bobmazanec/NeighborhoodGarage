//
//  NGCarViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/3/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGCarViewController.h"

@interface NGCarViewController ()
@property (weak, nonatomic) IBOutlet UITextField *makeTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@end

@implementation NGCarViewController
@synthesize car                 = _car;
@synthesize makeTextField       = _makeTextField;
@synthesize managedObjectContext= _managedObjectContext;
@synthesize modelTextField      = _modelTextField;
@synthesize nameTextField       = _nameTextField;
@synthesize yearTextField       = _yearTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.car ) {
        self.makeTextField.text = self.car.make;
        self.modelTextField.text= self.car.model;
        self.nameTextField.text = self.car.name;
        self.yearTextField.text = [self.car.year stringValue];
    }
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setMakeTextField:nil];
    [self setModelTextField:nil];
    [self setYearTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSManagedObjectContext *)managedObjectContext {
    if ( ! _managedObjectContext  ) {
        _managedObjectContext = self.car.managedObjectContext;
    }
    
    return _managedObjectContext;
}

#pragma mark - Save button
- (IBAction)saveCar:(UIBarButtonItem *)sender {
    NSString *name = self.nameTextField.text;
    
    if ( [name length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot save Car" message:@"Will fix the UI later; for now, can't save without a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NGCar *car = self.car;
    
    if ( ! car) {
        car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.managedObjectContext];
    }
    car.make    = self.makeTextField.text;
    car.model   = self.modelTextField.text;
    car.name    = name;
    car.year    = [NSNumber numberWithInteger:[self.yearTextField.text integerValue]];
    
    NSError *error = nil;
    if ( ! [self.managedObjectContext save:&error] ) {
        NSString *message = [NSString stringWithFormat:@"%@\n%@", error, [error userInfo]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    textField.returnKeyType = UIReturnKeyDone;
}
@end

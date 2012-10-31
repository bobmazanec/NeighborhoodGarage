//
//  NGFueling2ViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 10/29/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling2ViewController.h"

@interface NGFueling2ViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation NGFueling2ViewController
@synthesize picker          = _picker;
@synthesize deleteButton    = _deleteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.picker.delegate = self;
    self.picker.dataSource   = self;

    self.deleteButton.hidden    = NO;
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Car Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch ( row ) {
        case 0: return @"2001 Mazda Miata";     break;
        case 1: return @"1999 Toyota Tacoma";   break;
        case 2: return @"Manage...";            break;
    }
    
    return @"";
}

@end

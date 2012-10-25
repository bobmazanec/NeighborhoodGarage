//
//  NGDetailViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/27/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFuelingDetailViewController.h"

@interface NGFuelingDetailViewController ()
- (void)populateView;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *odometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@end

@implementation NGFuelingDetailViewController
@synthesize costLabel       = _costLabel;
@synthesize dateLabel       = _dateLabel;
@synthesize fueling         = _fueling;
@synthesize odometerLabel   = _odometerLabel;
@synthesize volumeLabel     = _volumeLabel;


#pragma mark - Managing the detail item

- (void)setFueling:(id)newFueling
{
    if (_fueling != newFueling) {
        _fueling = newFueling;
        
        // Update the view.
        [self populateView];
    }
}

- (void)populateView
{
    // Update the user interface for the detail item.

    if (self.fueling) {
        self.dateLabel    .text =  self.fueling.dateString;
        self.odometerLabel.text = [self.fueling.odometer   stringValue];
        self.volumeLabel  .text = [self.fueling.fuelVolume stringValue];
        self.costLabel    .text =  self.fueling.costString;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self populateView];
}

- (void)viewDidUnload
{
    [self setOdometerLabel:nil];
    [self setVolumeLabel:nil];
    [self setCostLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setFueling:self.fueling];
}

@end

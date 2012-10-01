//
//  NGDetailViewController.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/27/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFuelingDetailViewController.h"

@interface NGFuelingDetailViewController ()
- (void)configureView;
@end

@implementation NGFuelingDetailViewController
@synthesize odometerLabel = _odometerLabel;
@synthesize volumeLabel = _volumeLabel;
@synthesize costLabel = _costLabel;

@synthesize fueling = _fueling;


#pragma mark - Managing the detail item

- (void)setFueling:(id)newFueling
{
    if (_fueling != newFueling) {
        _fueling = newFueling;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.fueling) {
        self.dateLabel    .text = [self.fueling.timeStamp  description];
        self.odometerLabel.text = [self.fueling.odometer   stringValue];
        self.volumeLabel  .text = [self.fueling.fuelVolume stringValue];
        self.costLabel    .text = [self.fueling.fuelCost   stringValue];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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

@end

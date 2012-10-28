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
@property (weak, nonatomic) IBOutlet UILabel *daysTilLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesTilLabel;
@property (weak, nonatomic) IBOutlet UILabel *odometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *tankMpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateMpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@end

@implementation NGFuelingDetailViewController
@synthesize costLabel       = _costLabel;
@synthesize dateLabel       = _dateLabel;
@synthesize daysTilLabel    = _daysLabel;
@synthesize fueling         = _fueling;
@synthesize milesTilLabel   = _milesTilLabel;
@synthesize odometerLabel   = _odometerLabel;
@synthesize tankMpgLabel    = _tankMpgLabel;
@synthesize volumeLabel     = _volumeLabel;
@synthesize toDateMpgLabel = _toDateMpgLabel;


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
        
        NGFueling *nextFueling = self.fueling.nextFueling;
        
        if ( nextFueling ) {
            double      milesTil        = [nextFueling.odometer doubleValue] - [self.fueling.odometer doubleValue];
            NSInteger   daysTil         = [nextFueling.timeStamp timeIntervalSinceDate:self.fueling.timeStamp] / ( 60 * 60 * 24 );
            double      milesPerGallon  = milesTil / [nextFueling.fuelVolume doubleValue];
            
            self.daysTilLabel .text = [NSString stringWithFormat:@"%d",     daysTil];
            self.milesTilLabel.text = [NSString stringWithFormat:@"%0.3lf", milesTil];
            self.tankMpgLabel .text = [NSString stringWithFormat:@"%0.3lf", milesPerGallon];
            
            NSArray *fuelingsToDate = self.fueling.fuelingsToDate;
            if ( fuelingsToDate && [fuelingsToDate count] > 1 ) {
                __block double toDateFuelVolume    = 0.0;
                [fuelingsToDate enumerateObjectsUsingBlock:^(NGFueling *prevFueling, NSUInteger idx, BOOL *stop) {
                    toDateFuelVolume += [prevFueling.fuelVolume doubleValue];
                }];
                
                NGFueling *firstFueling = [fuelingsToDate objectAtIndex:0];
                
                // First Fueling's volume 'replaces' prior burn -- subtract it out
                toDateFuelVolume -= [firstFueling.fuelVolume doubleValue];
                
                // Add next Fueling's volume -- i.e., how much of this tank will be burned & replaced
                toDateFuelVolume += [nextFueling.fuelVolume doubleValue];
                
                // Miles from initial Fueling to next one
                double toDateMiles = [nextFueling.odometer doubleValue] - [firstFueling.odometer doubleValue];
                
                self.toDateMpgLabel.text = [NSString stringWithFormat:@"%0.3lf", toDateMiles / toDateFuelVolume];
            }
        } else {
            self.tankMpgLabel.text  =
            self.daysTilLabel.text  =
            self.milesTilLabel.text =
            self.toDateMpgLabel.text= @"TBD";
        }
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
    [self setDaysTilLabel:nil];
    [self setMilesTilLabel:nil];
    [self setTankMpgLabel:nil];
    [self setToDateMpgLabel:nil];
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

//
//  NGDetailViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/27/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGFueling.h"

@interface NGFuelingDetailViewController : UIViewController

@property (strong, nonatomic) NGFueling *fueling;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *odometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@end

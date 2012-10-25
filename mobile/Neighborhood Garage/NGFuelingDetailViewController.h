//
//  NGDetailViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/27/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGFueling+CoreDataOps.h"

@interface NGFuelingDetailViewController : UITableViewController

@property (strong, nonatomic) NGFueling *fueling;
@end

//
//  NGCarViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/3/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGCar.h"

@interface NGCarViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) NGCar                     *car;
@end

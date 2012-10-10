//
//  NGFuelingViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/28/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGFuelingViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) NGFueling                 *fueling;
@end

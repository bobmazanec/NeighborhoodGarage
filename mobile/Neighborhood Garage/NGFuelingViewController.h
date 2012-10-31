//
//  NGFuelingViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/28/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGFueling.h"

@interface NGFuelingViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) NGFueling                 *fueling;
@end

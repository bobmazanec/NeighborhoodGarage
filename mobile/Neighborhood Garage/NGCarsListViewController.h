//
//  NGCarsListViewController.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/3/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGCarsListViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

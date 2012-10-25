//
//  NGFueling+CoreDataOps.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 10/17/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling+CoreDataOps.h"

@implementation NGFueling (CoreDataOps)
- (NGFueling *)previousFueling {
    NSFetchRequest *fetchRequest = [NSFetchRequest alloc];
    
    fetchRequest.entity             = self.entity;
    fetchRequest.sortDescriptors    = @[[[NSSortDescriptor alloc] initWithKey:@"odometer" ascending:NO]];   // descending by odometer
    fetchRequest.predicate          = [NSPredicate predicateWithFormat:@"odometer < %@", self.odometer];    // less than this fueling's mileage
    fetchRequest.fetchBatchSize     = 1;                                                                    // just the first -- so the previous fueling
    
    NSError *fetchError     = nil;
    NSArray *fetchResults   = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if ( fetchResults && [fetchResults count] ) {
        return [fetchResults objectAtIndex:0];
    }
    
    return nil;
}

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return [dateFormatter stringFromDate:self.timeStamp];
}

- (NSString *)costString {
    return [NSString stringWithFormat:@"%0.2f", [self.fuelCost doubleValue]];
}
@end

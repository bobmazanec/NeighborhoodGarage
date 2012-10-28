//
//  NGFueling+CoreDataOps.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 10/17/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling+CoreDataOps.h"

@implementation NGFueling (CoreDataOps)
- (NGFueling *)fetchNearestFueling:(BOOL)following {
    NSString       *predicateFormat = [NSString stringWithFormat:@"odometer %@ %%@", following ? @">" : @"<"];
    NSFetchRequest *fetchRequest = [NSFetchRequest alloc];
    
    fetchRequest.entity             = self.entity;
    fetchRequest.sortDescriptors    = @[[[NSSortDescriptor alloc] initWithKey:@"odometer" ascending:following]];
    fetchRequest.predicate          = [NSPredicate predicateWithFormat:predicateFormat, self.odometer];
    fetchRequest.fetchBatchSize     = 1;
    
    NSError *fetchError     = nil;
    NSArray *fetchResults   = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if ( fetchResults && [fetchResults count] ) {
        return [fetchResults objectAtIndex:0];
    }
    
    return nil;
}

- (NGFueling *)previousFueling {
    return [self fetchNearestFueling:NO];   // not following, so previous
}

- (NGFueling *)nextFueling {
    return [self fetchNearestFueling:YES];   // not following, so previous
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

- (NSArray *)fuelingsToDate {
    NSFetchRequest *fetchRequest = [NSFetchRequest alloc];
    
    fetchRequest.entity             = self.entity;
    fetchRequest.sortDescriptors    = @[[[NSSortDescriptor alloc] initWithKey:@"odometer" ascending:YES]];
    fetchRequest.predicate          = [NSPredicate predicateWithFormat:@"odometer <= %@", self.odometer];
    
    NSError *fetchError     = nil;
    return  [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
}
@end

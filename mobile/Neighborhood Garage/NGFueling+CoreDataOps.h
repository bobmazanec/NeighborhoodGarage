//
//  NGFueling+CoreDataOps.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 10/17/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGFueling.h"

@interface NGFueling (CoreDataOps)
@property (strong, readonly) NGFueling  *previousFueling;

// Formatted strings
@property (strong, readonly) NSString   *dateString;  // "MM/DD/YYYY"
@property (strong, readonly) NSString   *costString;  // "ddd.cc"
@end

//
//  NGFueling.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/29/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NGFueling : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * fuelVolume;
@property (nonatomic, retain) NSNumber * fuelCost;

@end

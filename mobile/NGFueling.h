//
//  NGFueling.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 10/1/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NGFueling : NSManagedObject

@property (nonatomic, retain) NSNumber * fuelCost;
@property (nonatomic, retain) NSNumber * fuelVolume;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSDate * timeStamp;

@end

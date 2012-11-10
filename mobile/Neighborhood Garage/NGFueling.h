//
//  NGFueling.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/3/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NGCar;

@interface NGFueling : NSManagedObject

@property (nonatomic, retain) NSNumber * fuelCost;
@property (nonatomic, retain) NSNumber * fuelVolume;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NGCar *car;

@end

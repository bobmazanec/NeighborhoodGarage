//
//  NGCar.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/4/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NGFueling;

@interface NGCar : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *fuelings;
@end

@interface NGCar (CoreDataGeneratedAccessors)

- (void)addFuelingsObject:(NGFueling *)value;
- (void)removeFuelingsObject:(NGFueling *)value;
- (void)addFuelings:(NSSet *)values;
- (void)removeFuelings:(NSSet *)values;

@end

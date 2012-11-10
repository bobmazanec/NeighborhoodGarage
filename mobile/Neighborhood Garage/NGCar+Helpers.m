//
//  NGCar+Helpers.m
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 11/4/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import "NGCar+Helpers.h"

@implementation NGCar (Helpers)
- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%@ %@ %@", self.year, self.make, self.model];
    
    return [desc stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0 "]];
}
@end

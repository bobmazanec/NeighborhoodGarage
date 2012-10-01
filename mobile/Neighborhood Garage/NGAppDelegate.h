//
//  NGAppDelegate.h
//  Neighborhood Garage
//
//  Created by Bob Mazanec on 9/27/12.
//  Copyright (c) 2012 Bob Mazanec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

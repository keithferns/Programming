//
//  WriteNowAppDelegate.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"

@class MyDataObject;


@interface WriteNowAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, AppDelegateProtocol> {
    
        UIWindow *window;
        UITabBarController *tabBarController;
        MyDataObject* myDataObject;

    }
    
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) MyDataObject* myDataObject;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

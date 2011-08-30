//
//  WriteNowAppDelegate.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WriteNowAppDelegate.h"
#import "MainViewController.h"

@implementation WriteNowAppDelegate


@synthesize window;
@synthesize tabBarController;


@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    //CGRect frame = CGRectMake(0, 20, 320, 460);
    //[rootViewController.view setFrame:frame];
    //rootViewController.managedObjectContext = self.managedObjectContext;
    
	tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    CGRect frame = CGRectMake(0, 20, 320, 460);

    //frame = CGRectMake(0, 245, 320, 215);
    [tabBarController.view setFrame:frame];
    	
    // Create instances of the MainViewController for the 4 TabBar buttons
	MainViewController *viewController1 = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewController1.managedObjectContext = self.managedObjectContext;
	viewController1.tabBarItem.title = @"Today";
    UIImage *dayCalendarImage = [UIImage imageNamed:@"calendar.png"];
	[viewController1.tabBarItem setImage:dayCalendarImage];
    viewController1.tabBarItem.tag = 1;

    
    MainViewController *viewController2 = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewController2.managedObjectContext = self.managedObjectContext;
	viewController2.tabBarItem.title = @"Calendar";
    UIImage *calendarImage = [UIImage imageNamed:@"83-calendar.png"];	
	[viewController2.tabBarItem setImage:calendarImage];
    viewController2.tabBarItem.tag = 2;

    MainViewController *viewController3 = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewController3.managedObjectContext = self.managedObjectContext;
	viewController3.tabBarItem.title = @"Archive";
    UIImage *archiveImage = [UIImage imageNamed:@"33-cabinet.png"];	
	[viewController3.tabBarItem setImage:archiveImage];
    viewController3.tabBarItem.tag = 3;
    
    MainViewController *viewController4 = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewController4.managedObjectContext = self.managedObjectContext;
	viewController4.tabBarItem.title = @"Documents";
    UIImage *documentImage = [UIImage imageNamed:@"179-notepad.png"];	
	[viewController4.tabBarItem setImage:documentImage];
    viewController4.tabBarItem.tag = 4;
    
    MainViewController *viewController5 = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewController5.tabBarItem.title = @"Settings";
    UIImage *settingsImage = [UIImage imageNamed:@"push-pin.png"];	
	[viewController5.tabBarItem setImage:settingsImage];
    viewController5.tabBarItem.tag = 5;
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, viewController4, viewController5, nil];	
    
    
	// Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    //[window addSubview:rootViewController.view];
	//[rootViewController.view addSubview:tabBarController.view];
    // Override point for customization after application launch
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    NSLog(@"AppDelegate MOC:%@", __managedObjectContext);
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WriteNow" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WriteNow.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

//
//  AddEntityTableViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppointmentsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UILabel *tableLabel;
@property (nonatomic, retain) NSDate *selectedDate;

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

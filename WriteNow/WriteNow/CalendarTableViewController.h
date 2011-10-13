//
//  CalendarTableViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppointmentCustomCell.h"
    
    @interface CalendarTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
        
        NSManagedObjectContext *managedObjectContext;
        NSFetchedResultsController *_fetchedResultsController;
        AppointmentCustomCell *myCell;
        BOOL tableIsDown;
        
    }
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) UILabel *tableLabel;
    @property (nonatomic, retain) NSDate *selectedDate;
    @property (nonatomic, retain) AppointmentCustomCell *myCell;
    
    
    - (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 
    
    - (void) configureCell: (UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath;
    
    @end
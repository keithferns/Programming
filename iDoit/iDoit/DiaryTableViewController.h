//
//  DiaryTableViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate> {
        
        NSFetchedResultsController *_fetchedResultsController;
        NSManagedObjectContext *managedObjectContext;
        
    }
    
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) NSDate *selectedDate;
    
    //- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 
    
    
    - (void) getSelectedCalendarDate: (NSNotification *) notification;
    
    
    @end
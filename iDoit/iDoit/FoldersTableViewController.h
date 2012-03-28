//
//  FoldersTableViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemOrEvent.h"
@interface FoldersTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    UISearchBar *searchBar;
    BOOL saving;
    NewItemOrEvent *theItem;
    
    
}
@property (nonatomic,retain) NewItemOrEvent *theItem;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, readwrite) BOOL saving;

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

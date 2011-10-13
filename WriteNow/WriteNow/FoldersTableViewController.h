//
//  FoldersTableViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoldersTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    UISearchBar *searchBar;
    //BOOL isFolderView;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UISearchBar *searchBar;

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

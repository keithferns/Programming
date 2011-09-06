//
//  FilesTableViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiaryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;

}
//@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;



- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 


@end

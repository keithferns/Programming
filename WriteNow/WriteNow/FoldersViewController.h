//
//  FoldersViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoldersViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *_fetchedResultsController;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

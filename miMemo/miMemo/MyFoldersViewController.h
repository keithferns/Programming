//
//  MyFoldersViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "Tag.h"

@interface MyFoldersViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
	UIActionSheet *goActionSheet, *saveActionSheet;
    UIToolbar *toolbar;
    UISearchBar *searchBar;
    NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *_fetchedResultsController;
}
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;
- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

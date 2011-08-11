//
//  AddFileViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "MemoText.h"

@interface AddFileViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate,  NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
    NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
    BOOL swappingViews, isSelected;
    NSString *newTextInput;
    NSFetchedResultsController *_fetchedResultsController;
    
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain)  File *newFile;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *fileTextField, *tagTextField;
@property (nonatomic, retain) NSString *newTextInput;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void) swapViews;
- (void) backAction;
- (void) makeFile;
- (void) makeToolbar;

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end

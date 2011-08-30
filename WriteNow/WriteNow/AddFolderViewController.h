//
//  AddFolderViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
#import <UIKit/UIKit.h>
#import "Folder.h"
#import "Memo.h"

@interface AddFolderViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate,  NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
        NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
        BOOL swappingViews, isSelected;
        NSString *newTextInput;
        NSFetchedResultsController *_fetchedResultsController;
    }
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
    @property (nonatomic, retain) Memo *newMemo;
    @property (nonatomic, retain) Folder *newFolder;
    @property (nonatomic, retain) UIActionSheet *goActionSheet;
    @property (nonatomic, retain) UIToolbar *toolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *fileTextField, *folderTextField, *tagTextField;
    @property (nonatomic, retain) NSString *newTextInput;
    @property (nonatomic, retain) IBOutlet UITableView *tableView;
    @property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

    - (void) swapViews;
    - (void) backAction;
    - (void) makeFolder;
    - (void) makeToolbar;
        
    - (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

    @end

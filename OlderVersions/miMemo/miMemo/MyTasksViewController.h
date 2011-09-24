//
//  MyTasksViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//FIXME: Set predicate to filter out minimum date to current date. 

#import <UIKit/UIKit.h>
#import "MemoText.h"
#import "ToDo.h"

@interface MyTasksViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, NSFetchedResultsControllerDelegate>{
    
    UITextView *textView;
    NSManagedObjectContext *managedObjectContext;    
    MemoText *selectedMemoText;
    NSFetchedResultsController *_fetchedResultsController;
	UITableView *tableView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField; 
@property (nonatomic, retain) MemoText *selectedMemoText;

- (void) saveSelectedMemo;
- (void) startNew;
- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end

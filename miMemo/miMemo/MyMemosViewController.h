//
//  MyMemosViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Memo.h"
#import "MemoText.h"
    
@interface MyMemosViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>  {
        
        MemoText *selectedMemoText;
        UITextView *textView;

        NSManagedObjectContext *managedObjectContext;
        NSFetchedResultsController *_fetchedResultsController;
        UITableView *tableView;
    }
    
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) IBOutlet UITableView *tableView;
    @property (nonatomic, retain) MemoText *selectedMemoText;
    @property (nonatomic, retain) UITextField *dateTextField; 
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
    @property (nonatomic, retain) UIToolbar *toolbar;

    - (void) saveSelectedMemo;
    - (void) startNew;
    - (void) makeToolbar;
    - (IBAction) navigationAction:(id)sender;
    
    @end

//
//  MyTasksViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MemoText.h"
#import "ToDo.h"

@interface MyTasksViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    
    UITextView *textView;
    NSManagedObjectContext *managedObjectContext;    
    UITableViewController *tableViewController;
    MemoText *selectedMemoText;
    
    
}


@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField; 
@property (nonatomic, retain) MemoText *selectedMemoText;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;

- (void) saveSelectedMemo;
- (void) startNew;
- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end

/*
 */
//
//  RootViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"
#import "File.h"
#import "MemoText.h"

@interface RootViewController : UIViewController <UITextViewDelegate> {

	NSManagedObjectContext *managedObjectContext;
	UITextView *newText;
	UITableViewController *tableViewController;
	UIBarButtonItem *add_doneButton;
}


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITextView *newText;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *add_doneButton;

- (IBAction) insertNewMemo;



@end

/*
*/
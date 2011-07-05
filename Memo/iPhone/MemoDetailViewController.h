//
//  MemoDetailViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"
#import "MemoText.h"
#import "AppDelegate_Shared.h"

@interface MemoDetailViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>{

	UILabel *creationDateView;
	UITextView *memoTextView;
	NSManagedObjectContext *managedObjectContext;
	Memo *selectedMemo;
	UITextField *memoREView;
	
}

@property (nonatomic, retain) IBOutlet UILabel *creationDateView;
@property (nonatomic, retain) IBOutlet UITextView *memoTextView;
@property (nonatomic, retain) IBOutlet UITextField *memoREView;
@property (nonatomic, retain) Memo *selectedMemo;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


-(IBAction) backToTable;

-(IBAction) saveSelectedMemo;

@end

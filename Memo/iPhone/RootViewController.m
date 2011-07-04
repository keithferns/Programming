//
//  RootViewController.m
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate_Shared.h"

@implementation RootViewController

@synthesize managedObjectContext, newText, tableViewController;
@synthesize add_doneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:newText];
	[self.view addSubview:tableViewController.tableView];
	
	//Point the new instance of managedObjectContext to the managedObjectContext for the app.
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
}

- (void) addNewMemo{
		MemoText *newMemoText =[MemoText insertNewMemoText:managedObjectContext];
		[newMemoText setMemoText:newText.text];
	
		Memo *newMemo = [Memo insertNewMemo:managedObjectContext];
		//[newMemo setIsEditing:YES];
		[newMemo setCreationDate:[NSDate date]];
		newMemo.memoText = newMemoText;
		NSLog(@"The Date of the new memo is '%@'", newMemo.creationDate);

		NSLog(@"The Text of the new memo is '%@'", newMemo.memoText.memoText);
	
		NSError *error;
		if(![managedObjectContext save:&error]){ 
				//
		}
		[self.view endEditing:YES];
}

- (IBAction) insertNewMemo{
	
	if (![newText hasText]) {
		[self.view endEditing:YES];
		return;
	}
	[self addNewMemo];
	newText.text = @"";

}

- (void) textViewDidBeginEditing:(UITextView *)textView{
		//@ Input --> Put Done button in Toolbar.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[tableViewController release];
	[newText release];
}


@end

//
//  RootViewController.m
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate_Shared.h"
#import "AppointmentsViewController.h"

@implementation RootViewController

@synthesize managedObjectContext, newText, tableViewController;
@synthesize doneButton, newMemoButton;
@synthesize previousTextInput;
@synthesize goActionSheet, saveActionSheet;


#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
			if ([newText hasText]) {
				[self addNewMemo];
			}

			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			
			[goActionSheet showInView:self.view];
			
			[goActionSheet release];
			
			NSLog(@"The Go To Action was Shown");
			break;
		case 1:
			if ([newText hasText]) {
				[self addNewMemo];
				newText.text = @"";
				}
			
			else if (![newText hasText]) {
				[self.view endEditing:YES];
				return;
				}
				//TODO: ADD Condition where the text in view is same as text in memoText for the last saved memo. Add Button to toggle between DONE and NEW. DONE will save the input text but retain it in view. The button will change to New. If the user taps on the newText view then the button changes back to DONE. Only if the user click on NEW, will the newText clear for new input and the table will update. Perhaps use two different managedObjectContexts here. Only NEW will merge the input text MOC with the tableView MOC. DONE will just save it to the inputView MOC. 
			/*
			MyMemosViewController *viewController = [[[MyMemosViewController alloc] initWithNibName:@"MyMemosViewController" bundle:nil] autorelease];
			editmemoTextView.text = @"";
			[self presentModalViewController:viewController animated:YES];	
			 */
			break;
			
		case 2:
			if ([newText hasText]) {
				[self addNewMemo];
			}

			saveActionSheet = [[UIActionSheet alloc] 
									initWithTitle:@"What do you want to do with this Memo?" delegate:self
									cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Name, Tag and Save", @"Append to Existing File", @"Appointment or Task Reminder", nil];
			
			[saveActionSheet showInView:self.view];
			
			[saveActionSheet release]; 
			
			break;
		default:
			break;
	}
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet	== saveActionSheet){
		switch (buttonIndex) {
			case 4:
				NSLog(@"Cancel Button Clicked on saveAlert");
				break;
			case 3:
				NSLog(@"1st Button Clicked on saveAlert");
			{AppointmentsViewController *gotoView = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES];}
				break;
			case 2:
				NSLog(@"2nd Button Clicked on saveAlert");
			{AppointmentsViewController *gotoView = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES];}
				break;
			case 1:
				NSLog(@"3rd Button Clicked on saveAlert");
			{AppointmentsViewController *gotoView = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES]; }
				break;
			case 0:
				NSLog(@"4th Button Clicked on saveAlert");
			{AppointmentsViewController *gotoView = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES];}
				break;
			default:
				break;
		}
	}
	else if (actionSheet == goActionSheet){
		switch (buttonIndex){
			case 3:
				NSLog(@"1st Button Clicked on WallAlert");
			{AppointmentsViewController *viewController = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 2:
				NSLog(@"2nd Button Clicked on WallAlert");
			{AppointmentsViewController *viewController = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];			
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 1:
				NSLog(@"3rd Button Clicked on WallAlert");
			{AppointmentsViewController *viewController = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 0:
				NSLog(@"4th Button Clicked on WallAlert");
			{AppointmentsViewController *viewController = [[[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil] autorelease];		
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 4:
				NSLog(@"Cancel Button Clicked on wallAlert");
			default:
				break;
		}
	}
}



- (void) addNewMemo{
	
	NSString *newTextInput = [NSString stringWithFormat: @"%@", newText.text];//copy contents of textView to newTextInput
	
	if ([newTextInput isEqualToString:previousTextInput]) {
		return;
	}
	
	MemoText *newMemoText = [MemoText insertNewMemoText:managedObjectContext];
	[newMemoText setMemoText:newTextInput];
	
	Memo *newMemo = [Memo insertNewMemo:managedObjectContext];
		//[newMemo setIsEditing:YES];
	[newMemo setCreationDate:[NSDate date]];
	newMemo.memoText = newMemoText;
	newMemo.memoRE = @"";
	NSLog(@"The Date of the new memo is '%@'", newMemo.creationDate);
	
	NSLog(@"The Text of the new memo is '%@'", newMemo.memoText.memoText);
	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
			//
	}
	previousTextInput = newTextInput;
	[self.view endEditing:YES];
	
}


#pragma mark -

#pragma mark ViewLifeCycle

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
	self.managedObjectContext = nil;
}

- (void)dealloc {
    [super dealloc];
	[tableViewController release];
	[newText release];
	[managedObjectContext release];
	[newMemoButton release];
	[doneButton release];
}


@end

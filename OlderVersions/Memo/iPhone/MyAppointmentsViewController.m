//
//  MyAppointmentsViewController.m
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppointmentsViewController.h"
#import "AppDelegate_Shared.h"
#import "AppointmentsViewController.h"
#import "NSManagedObjectContext-insert.h"

@implementation MyAppointmentsViewController

@synthesize managedObjectContext, tableViewController;
@synthesize doneButton, newMemoButton;
@synthesize previousTextInput;
@synthesize goActionSheet, saveActionSheet;

#pragma mark -

#pragma mark ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:tableViewController.tableView];
    
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:[UIColor blueColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE AS" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"NEW" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    [saveAsButton setWidth:90];
    [saveAsButton setEnabled:YES];
    [newButton setWidth:90];
    [newButton setEnabled:YES];
    [gotoButton setWidth:90];
    [gotoButton setEnabled:YES];
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [toolbar setItems:items];
    [self.view addSubview:toolbar];
	
		//Point the new instance of managedObjectContext to the managedObjectContext for the app.
	
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
}
- (void) textViewDidEndEditing:(UITextView *)textView{
		//Change the Done Button to a New button. 
}


#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			
			[goActionSheet showInView:self.view];
			
			[goActionSheet release];
			
			NSLog(@"The Go To Action was Shown");
			break;
		case 1:
            [self dismissModalViewControllerAnimated:YES];

			break;
			
		case 0:
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
				
			case 3:
				NSLog(@"Cancel Button Clicked on saveAlert");
				break;
			case 2:
				NSLog(@"3nd Button Clicked on saveAlert");
				break;
			case 1:
				NSLog(@"2nd Button Clicked on saveAlert");
				break;
			case 0:
				NSLog(@"1st Button Clicked on saveAlert");
				break;
			default:
				break;
		}
	}
	else if (actionSheet == goActionSheet){
		switch (buttonIndex){
			case 3:
				NSLog(@"Cancel Button Clicked on wallAlert");
			default:
				break;
			case 2:
				NSLog(@"Task Button Clicked on WallAlert");
			
				break;
			case 1:
				NSLog(@"Appointments Button Clicked on WallAlert");
			{MyAppointmentsViewController *viewController = [[[MyAppointmentsViewController alloc] initWithNibName:@"MyAppointmentsViewController" bundle:nil] autorelease];			
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 0:
				NSLog(@" Folder and Files Button Clicked on WallAlert");
				break;				
		}
	}
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
	[managedObjectContext release];
	[newMemoButton release];
	[doneButton release];
}


@end

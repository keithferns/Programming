//
//  MyMemosViewController.m
//  miMemo
//
//  Created by Keith Fernandes on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMemosViewController.h"
#import "MemoTableViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"


@implementation MyMemosViewController

@synthesize tableViewController;
@synthesize selectedMemoText;
@synthesize managedObjectContext;
@synthesize goActionSheet, saveActionSheet;
@synthesize toolbar;
@synthesize textView, dateTextField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:tableViewController.tableView];
    [self makeToolbar];
    [self.view addSubview:toolbar];    
    
    self.view.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //The Text View
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 160)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", selectedMemoText.memoText]];
    [self.view addSubview:textView];
	//[textView becomeFirstResponder];
    [textView setDelegate:self];
    
    //The Date Label and Date Field
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EE, dd MMMM h:mm a"];
    }	
    dateTextField = [[UITextField alloc] init];
    
    [dateTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateTextField setFont:[UIFont systemFontOfSize:17]];
    
        [dateTextField setFrame:CGRectMake(12, 20, 293, 31)];    
		[dateTextField setPlaceholder:@"Add a tag or two"];
        [self.view addSubview:dateTextField];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [super dealloc];
    [toolbar release];
    [saveActionSheet release];
    [goActionSheet release];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning at MyMemosViewController");

    // Release any cached data, images, etc that aren't in use.
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"Try to change New botton to Done");
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:1];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1){
            [toolbarItems release];
            [doneButton release];
            return;
        }
        else if (barButtonItem.tag == 3) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
    [toolbarItems release];
    [doneButton release];
}


-(void) saveSelectedMemo{
	[self.view endEditing:YES];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"NEW" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:3];
    [newButton setWidth:90];
    NSUInteger myButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            myButton = i;
            break;
        }
    }
    
    [toolbarItems replaceObjectAtIndex:myButton withObject:newButton];
    toolbar.items = toolbarItems;
	[newButton release];
    [toolbarItems release];
    /*--Save the edited text--*/
	selectedMemoText.memoText = textView.text;
    
    /*--Save to the managedObjectContext]--*/
	NSError *error;
	if(![managedObjectContext save:&error]){
	}
}
- (void) startNew {
    /*--Send notification that changes saved to the MOC--*/
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:managedObjectContextSavedNotification object:nil];
    
    /*--dimiss the modalView--*/
    [self dismissModalViewControllerAnimated:YES];
}

#pragma -
#pragma Navigation Controls and Actions

- (void) makeToolbar{
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 210, 320, 40);
    toolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE AS" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    [saveAsButton setWidth:90];
    [doneButton setWidth:90];
    [gotoButton setWidth:90];
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, doneButton, flexSpace, gotoButton, flexSpace,nil];
    [toolbar setItems:items];
    [doneButton release];
    [saveAsButton release];
    [gotoButton release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}


-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Folders" @"Appointments", @"Tasks", nil];
			
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
				break;
			case 0:
				NSLog(@" Folder and Files Button Clicked on WallAlert");
				break;				
		}
	}
}
#pragma -

@end


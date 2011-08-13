//  MemoDetailViewController.m
//  Memo
//  Created by Keith Fernandes on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "miMemoAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MemoDetailViewController.h"
#import "MemoTableViewController.h"

@implementation MemoDetailViewController

@synthesize selectedMemoText;
@synthesize managedObjectContext;
@synthesize goActionSheet, saveActionSheet;
@synthesize toolbar;
@synthesize textView, dateTextField;

#pragma mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeToolbar];
    
    /*Setting Up the Views*/
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
	[textView becomeFirstResponder];
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
    
	if ([selectedMemoText.noteType intValue] == 0){
        [dateTextField setFrame:CGRectMake(12, 20, 293, 31)];    
		[dateTextField setPlaceholder:@"Add a tag or two"];
        [self.view addSubview:dateTextField];

    }
    else if ([selectedMemoText.noteType intValue] == 1){
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 23, 90, 21)];
        [dateLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self.view addSubview:dateLabel];
        [dateTextField setFrame:CGRectMake(105, 20, 200, 31)];
        
        [dateLabel setText:@"Scheduled:"];
        [dateTextField setText:selectedMemoText.savedAppointment.doDate];
        [self.view addSubview:dateTextField];
        [dateLabel release];
    }
    else{
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 23, 90, 21)];
        [dateLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self.view addSubview:dateLabel];
        [dateTextField setFrame:CGRectMake(105, 20, 200, 31)];
        [dateLabel setText:@"Due:"];
        [dateTextField setText:selectedMemoText.savedTask.doDate];
        [self.view addSubview:dateTextField];
        [dateLabel release];
        
    }
    /*--End Setting Up the Views--*/
    
    
    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext =[(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@", managedObjectContext);
        }
    /*--End Initializing the managedObjectContext--*/
}

#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
        case 3:
            [self startNew];
            break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			
			[goActionSheet showInView:self.view];
			
			NSLog(@"The Go To Action was Shown");
			break;
		case 1:
		
            [self saveSelectedMemo];
            //TODO: ADD Condition where the text in view is same as text in memoText for the last saved memo. Add Button to toggle between DONE and NEW. DONE will save the input text but retain it in view. The button will change to New. If the user taps on the newText view then the button changes back to DONE. Only if the user click on NEW, will the newText clear for new input and the table will update. Perhaps use two different managedObjectContexts here. Only NEW will merge the input text MOC with the tableView MOC. DONE will just save it to the inputView MOC. 
			break;
			
		case 0:
			saveActionSheet = [[UIActionSheet alloc] 
                               initWithTitle:@"What do you want to do with this Memo?" delegate:self
                               cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Name, Tag and Save", @"Append to Existing File", @"Appointment or Task Reminder", nil];
			
			[saveActionSheet showInView:self.view];
            
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[textView release];
	[dateTextField release];
    [saveActionSheet release];
    [goActionSheet release];
}

- (void) makeToolbar{
    /*--Setting up the Toolbar--*/
    CGRect buttonBarFrame = CGRectMake(0, 210, 320, 40);
    toolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE AS" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    [saveAsButton setWidth:90];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:1];
    [doneButton setWidth:90];
    
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    [gotoButton setWidth:90];
    
    /* UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     //Possible to use this with the initWithCustomView method of  UIBarButtonItems */
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, doneButton, flexSpace, gotoButton, flexSpace,nil];
    [toolbar setItems:items];
    [self.view addSubview:toolbar];
    [saveAsButton release];
    [doneButton release];
    [gotoButton release];
    [flexSpace release];
    /*--End Setting up the Toolbar--*/
}

@end
/*
 CGRect topViewFrame = CGRectMake(0, 0, 320, 204);
 UIView *topView = [[[UIView	alloc] initWithFrame:topViewFrame] autorelease];
 [self.view addSubview:topView];
 
 CGRect labelFrame1 = CGRectMake(5, 10, 30, 40);
 UILabel *reLabel = [[UILabel alloc] initWithFrame:labelFrame1];
 [reLabel setFont:[UIFont systemFontOfSize:12]];
 
 CGRect reFrame = CGRectMake(45, 15, 70, 30);
 textFieldRE	= [[UITextField alloc] initWithFrame: reFrame];
 [textFieldRE setBorderStyle:UITextBorderStyleRoundedRect];
 [textFieldRE setFont:[UIFont systemFontOfSize:12]];
 [textFieldRE setBounds:CGRectMake(45, 20, 70, 25)];


 CGRect textFieldFrame = CGRectMake(20, 70, 280, 120);
 textFieldText = [[UITextField alloc] initWithFrame:textFieldFrame];
 [textFieldText setBackground:[UIImage imageNamed:@"lined_paper_320x200.png"]];
 [textFieldText setDelegate:self];
 [textFieldText drawTextInRect:textFieldFrame];
 [topView addSubview:textFieldText];
 */

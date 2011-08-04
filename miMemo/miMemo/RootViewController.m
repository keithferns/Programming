//  RootViewController.m  CURRENT
//  Memo
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"

#import "RootViewController.h"
#import "MemoTableViewController.h"

#import "AppointmentsViewController.h"
#import "AddTaskViewController.h"
#import "AddFolderViewController.h"

#import "MyAppointmentsViewController.h"
#import "MyTasksViewController.h"
#import "MyFoldersViewController.h"
#import "MyMemosViewController.h"

@implementation RootViewController

@synthesize managedObjectContext, newText;
@synthesize previousTextInput;
@synthesize goActionSheet, saveActionSheet;
@synthesize toolbar;
@synthesize newMemoText;
@synthesize tableViewController;

//TODO: Recognize input numbers as telephone numbers  save to contacts. Obviously, an obvious thing to do, so has to be part of core functionality. 
//TODO: Related to above. Recognize and Add input names to an appropriate place. 
//TODO: add LOCATION entity. use as basis for creating categories and Location Folders.
//TOTHINK: ADD PERSON entity. Key relational entity in the real world. Needs a place here. 

#pragma mark -

#pragma mark ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In RootViewController");
    
    //Add the tableViewController
    [self.view addSubview:tableViewController.tableView];
    
    if (managedObjectContext == nil) { 
		managedObjectContext = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"In RootViewController");
        
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
    [self makeToolbar];
    [self.view addSubview:toolbar];
    
    self.view.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    newText = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 305, 170)];
    [newText setFont:[UIFont systemFontOfSize:18]];
    newText.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    newText.layer.cornerRadius = 7.0;
    newText.layer.frame = CGRectInset(newText.layer.frame, 5, 10);
    newText.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;
    newText.delegate = self;
    [self.view addSubview:newText];
    
    UILabel *topLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    [topLabel setText:@"My Memo"];
    [topLabel setTextAlignment:UITextAlignmentCenter];
    [topLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:topLabel];
    
    /*    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(handleDidSaveNotification:)
     name:NSManagedObjectContextObjectsDidChangeNotification 
     object:nil];*/
    [self.view addSubview:tableViewController.tableView];
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    /*--Add the DONE button to the textView once editing begins.--*/
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:1];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1){
            return;
        }
        else if (barButtonItem.tag == 3) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
    /*--DONE button added--*/    
}

- (void) textViewDidEndEditing:(UITextView *)textView{
}

#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
        case 3:    
            if ([newText hasText]) {
				[self addNewMemo];
            }
            break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos", @"Folders", @"Appointments", @"Tasks", nil];
			[goActionSheet showFromRect:CGRectMake(20, 350, 280, 300) inView:self.view animated:YES];
            break;
		case 1:
			if ([newText hasText]) {
				[self addNewMemoText];
            }
			else if (![newText hasText]) {
				[self.view endEditing:YES];
				return;
            }
            //TODO: ADD Condition where the text in view is same as text in memoText for the last saved memo. Add Button to toggle between DONE and NEW. DONE will save the input text but retain it in view. The button will change to New. If the user taps on the newText view then the button changes back to DONE. Only if the user click on NEW, will the newText clear for new input and the table will update. Perhaps use two different managedObjectContexts here. Only NEW will merge the input text MOC with the tableView MOC. DONE will just save it to the inputView MOC. 
			break;
		case 0:
			saveActionSheet = [[UIActionSheet alloc] 
                               initWithTitle:@"What do you want to do with this Memo?" delegate:self
                               cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to a Folder", @"Append to a File", @"Appointment", @"Task Reminder", nil];
			[saveActionSheet showFromToolbar:toolbar];						
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
                NSLog(@"4nd Button Clicked on saveAlert");
                /*--Adds a new Appointment.--*/
				if ([newText hasText]) {
					[self addNewTask];
				}	
				break;
			case 2:
				NSLog(@"3nd Button Clicked on saveAlert");
                /*--Adds a new Appointment.--*/
				if ([newText hasText]) {
					[self addNewAppointment];
				}	
				break;
			case 1:
				NSLog(@"2nd Button Clicked on saveAlert");
				break;
			case 0:
				NSLog(@"1st Button Clicked on saveAlert");
                if ([newText hasText]) {
					[self addNewFolder];
				}
				break;
			default:
				break;
		}
	}
	else if (actionSheet == goActionSheet){
		switch (buttonIndex){
			case 4:
			default:
				break;
			case 3:
			{MyTasksViewController *viewController = [[[MyTasksViewController	alloc] initWithNibName:nil bundle:nil] autorelease];	
                [self presentModalViewController:viewController animated:YES];}
				break;
			case 2:
				NSLog(@"Appointments Button Clicked on GoToAction");
			{MyAppointmentsViewController *viewController = [[[MyAppointmentsViewController alloc] initWithNibName:nil bundle:nil] autorelease];	
				[self presentModalViewController:viewController animated:YES];
            }
				break;
			case 1:
				NSLog(@" Folders Button Clicked on GoToAction");
            {MyFoldersViewController *viewController = [[[MyFoldersViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                [self presentModalViewController:viewController animated:YES];}
				break;		
            case 0:
				NSLog(@" Memos Button Clicked on GoToAction");
                MyMemosViewController *viewController = [[[MyMemosViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                [self presentModalViewController:viewController animated:YES];
				break;	    
		}
	}
}

- (void) viewWillAppear{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning");
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.managedObjectContext = nil;
}

- (void)dealloc {
    [super dealloc];
	[newText release];
	//[managedObjectContext release];
    [goActionSheet release];
    [saveActionSheet release];
    [toolbar release];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self 
     name:NSManagedObjectContextDidSaveNotification 
     object:nil];
    /*[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NSManagedObjectContextObjectsDidChangeNotification object:nil];*/
}

- (void) addNewMemoText{
	/*Called BY: Done Button and.....*/
    [self.view endEditing:YES];
	NSString *newTextInput = [NSString stringWithFormat: @"%@", newText.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    
    /*--the text is NOT the same as previous call of method --> insert a new instance of MemoText in the MOC and copy new text to this instance--
     CASE: When the user has added and saved text, then returns to editing but does not add any text ---*/
    // NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	//self.managedObjectContext = addingContext;	
	//[self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    //[addingContext release];
    
	if (![newTextInput isEqualToString:previousTextInput]) {
        newMemoText = [self.managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
        [newMemoText setMemoText:newTextInput];
        [newMemoText setCreationDate:[NSDate date]]; 
    }
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        //
	}
    /*-- If newMemoText has been added to the MOC in some call of the present method -> Change the Done button to the new Button.--*/ 
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
    
	previousTextInput = newTextInput;
    NSLog(@"%@", previousTextInput);
    
}

- (void) addNewMemo{
    /*CALLED BY:  New button --*/
    Memo *newMemo = [self.managedObjectContext insertNewObjectForEntityForName:@"Memo"];
    //[newMemo setIsEditing:YES];
    newMemo.doDate = newMemoText.creationDate;
    newMemo.memoText = newMemoText;
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        //
	}
    //FIXME: CASE> if the User hits the done button but rather than hitting the new button, select a cell in the displayed table. Should newMemoText be saved as a newMemo?
    
    [newText setText:@""];
}

- (void) addNewAppointment{	
	/*CALLED BY:   SaveAs-Appointment --*/
	NSString *newTextInput = [NSString stringWithFormat: @"%@", newText.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);	
    // Pass the selected object to the new view controller.
	AppointmentsViewController *appointmentViewController = [[AppointmentsViewController alloc] initWithNibName:@"AppointmentsViewController" bundle:nil];
	// Create a new managed object context for the new appointment -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	appointmentViewController.managedObjectContext = addingContext;
	[addingContext release];
	[appointmentViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    /*-Save changes to the MOC. NOTE: no changes made in this function as it is --*/
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        //
	}
	appointmentViewController.newTextInput = newTextInput;	
	[self presentModalViewController:appointmentViewController animated:YES];	
    [newText setText:@""];
	[self.view endEditing:YES];
}

- (void) addNewTask{
    /*--CALLED BY:   SaveAs-Task --*/    
	NSString *newTextInput = [NSString stringWithFormat: @"%@", newText.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);	
    // Init NewTaskViewContrsoller & Pass the textinput to this view controller.
	AddTaskViewController *taskViewController = [[AddTaskViewController alloc] initWithNibName:nil bundle:nil];
	// Create a new managed object context for the new task -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	taskViewController.managedObjectContext = addingContext;
	[addingContext release];
	[taskViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        //
	}
	taskViewController.newTextInput = newTextInput;	
	[self presentModalViewController:taskViewController animated:YES];	
    [newText setText:@""];
	[self.view endEditing:YES];
}

- (void) addNewFolder{
    /*--CALLED BY:   SaveAs-Task --*/    
	NSString *newTextInput = [NSString stringWithFormat: @"%@", newText.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    if (![newTextInput isEqualToString:previousTextInput]) 
        
    {
        // Initialize an instance of NewTaskViewCOntroller and Pass the text input to this view controller.
        AddFolderViewController *addViewController = [[AddFolderViewController alloc] initWithNibName:nil bundle:nil];
        // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that from the fetched results controller's context.
        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
        addViewController.managedObjectContext = addingContext;
        [addingContext release];	
        [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
        NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
        
        
        addViewController.newTextInput = newTextInput;	
        addViewController.newMemoText = newMemoText;
        [self presentModalViewController:addViewController animated:YES];	
        [newText setText:@""];
        [self.view endEditing:YES];
    }
}

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
    /*--End Setting up the Toolbar */
}

@end


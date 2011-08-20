//
//  MainViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WriteNowAppDelegate.h"
#import "MainViewController.h"

#import "CurrentViewController.h"
#import "CalendarViewController.h"
#import "FoldersViewController.h"
#import "FilesViewController.h"
#import "SettingsViewController.h"

#import "AppointmentsViewController.h"
#import "TasksViewController.h"

@implementation MainViewController

@synthesize navigationController;
@synthesize managedObjectContext;
@synthesize textView, previousTextInput, myToolBar;

- (void)dealloc
{
    [super dealloc];
    [navigationController release];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];    
}
#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    NSLog(@"MainViewController MOC: %@", managedObjectContext);

    //self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setOpacity:0.8];
    
    [self.view addSubview:containerView];

    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 300,100)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
    textView.showsVerticalScrollIndicator = YES;
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    [textView setFont:[UIFont boldSystemFontOfSize:15]];
    [textView setDelegate:self];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"Write Now";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
    
    [containerView addSubview:textView];
    [containerView addSubview:label];
    
    previousTextInput = @"";
    
    FoldersViewController *foldersViewController = [[FoldersViewController alloc] init];

    NSLog(@"Main View Did Load: %@", self.tabBarItem.title);
    if(self.tabBarItem.title == @"Today") {
    NSLog(@"viewController1");
    CurrentViewController *currentViewController = [[CurrentViewController alloc] init];
    [self pushViewController:currentViewController animated:YES];
    [currentViewController release];
    }
    else if (self.tabBarItem.title == @"Calendar") {	
    NSLog(@"viewController2");
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
    [self pushViewController:calendarViewController animated:YES];
    [calendarViewController release];
    } 
    else if (self.tabBarItem.title == @"Archive") {	
    NSLog(@"viewController3");
    //FoldersViewController *foldersViewController = [[FoldersViewController alloc] init];
    [self pushViewController:foldersViewController animated:YES];
    [foldersViewController release];
    } 
    else if (self.tabBarItem.title == @"Documents") {	
    NSLog(@"viewController4");
    FilesViewController  *filesViewController = [[FilesViewController alloc] init];
    [self pushViewController:filesViewController animated:YES];
    [filesViewController release];
    } 
    else if (self.tabBarItem.title == @"Settings") {	
    NSLog(@"viewController5");
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
    }
    [navigationController.navigationBar setHidden:YES];
    [self.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(keyboardWasShown)
                                        name:UIKeyboardDidShowNotification
                                        object:foldersViewController.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(keyboardWillHide)
                                        name:UIKeyboardWillHideNotification
                                        object:nil];
}

- (void)keyboardWasShown{
    NSLog(@"Keyboard Was Shown");
    if ([textView isFirstResponder]) {
        return;
    }
        else {
         
            [containerView setHidden:YES];    
        }
}

- (void) keyboardWillHide{
    NSLog(@"Keyboard will Hide");
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) textViewDidBeginEditing:(UITextView *)textView{    
    NSLog(@"EDITING BEGAN");
    
    CGRect buttonBarFrame = CGRectMake(0, 200, 320, 45);
    myToolBar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [myToolBar setBarStyle:UIBarStyleDefault];
    [myToolBar setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
    //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithTitle:@"Folder" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMemo)];
    
    UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addNewFolder)];
    [folderButton setTitle:@"Folder"];
    [folderButton setTag:0];
    [folderButton setWidth:50.0];

    UIBarButtonItem *appendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"179-notepad.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewFile)];
    [appendButton setTag:1];
    [appendButton setWidth:50.0];
    
    UIBarButtonItem *appointmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"11-clock.png"]style:UIBarButtonItemStylePlain target:self action:@selector(addNewAppointment)];
    [appointmentButton setTag:2];
    
    UIBarButtonItem *taskButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"117-todo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewTask)];
    [taskButton setTag:3];
    
    //UIBarButtonItem *memoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"180-stickynote.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewMemo)];
    //[memoButton setTag:4];

    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(makeActionSheet:)];
    
    [actionButton setTag:4];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, folderButton, flexSpace, appendButton, flexSpace, appointmentButton, flexSpace, taskButton,flexSpace, actionButton, flexSpace, nil];
    [myToolBar setItems:items];
    [self.view addSubview:myToolBar];
    
    [folderButton release];
    [appendButton release];
    [appointmentButton release];
    [taskButton release];
    [flexSpace release];
    
}

- (void) makeActionSheet:(id) sender{
    UIBarButtonItem *actionButton = sender;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DO" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to Folder", @"Append to File", @"Send as Email", @"Send as Message", nil];
    
    actionSheet.layer.backgroundColor = [UIColor blueColor].CGColor;
    
    
    
    //UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(50, 260, 220, 150)];
    
    //[actionSheet showInView:myView];
    [actionSheet showFromBarButtonItem:actionButton animated:YES];
    }

- (void) textViewDidEndEditing:(UITextView *)textView{
    [myToolBar setHidden:YES];
    [self.view endEditing:YES];
    [self.textView resignFirstResponder];
}

- (void) addNewFolder{
    [self.textView resignFirstResponder];
    //[containerView setHidden:YES];
}

- (void) addNewMemo {
    
    [self.view endEditing:YES];
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){
    NSLog(@"Trying to Create a newMemo");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Memo"
                                   inManagedObjectContext:managedObjectContext];
    
    Memo *newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    //Memo *newMemo = [self.managedObjectContext insertNewObjectForEntityForName:@"Memo"];
    [newMemo setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newMemo setCreationDate:[NSDate date]];
    [newMemo setType:0];
    [newMemo setEditDate:[NSDate date]];
    
    //   }
    /*--the text is NOT the same as previous call of method --> insert a new instance of MemoText in the MOC and copy new text to this instance--
     CASE: When the user has added and saved text, then returns to editing but does not add any text ---*/
    /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    NSLog(@"newMemo.text = %@", newMemo.text);
    NSLog(@"newMemo.creationDate = %@", newMemo.creationDate);
    NSLog(@"newMemo.type = %d", [newMemo.type intValue]);
    NSLog(@"newMemo.editDate = %@", newMemo.editDate);
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
    }
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    
    /*-- If newMemoText has been added to the MOC in some call of the present method -> Change the Done button to the new Button.
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
     previousTextInput = newTextInput;
     NSLog(@"%@", previousTextInput);
     --*/ 
}

- (void) addNewAppointment {
    
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){
    NSLog(@"Trying to Create a newAppointment");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Appointment"
                                   inManagedObjectContext:managedObjectContext];
    
    Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newAppointment setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newAppointment setCreationDate:[NSDate date]];
    [newAppointment setType:[NSNumber numberWithInt:1]];
        
    //   }
    /*--the text is NOT the same as previous call of method --> insert a new instance of MemoText in the MOC and copy new text to this instance--
     CASE: When the user has added and saved text, then returns to editing but does not add any text ---*/
    /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    NSLog(@"newAppointment.text = %@", newAppointment.text);
    NSLog(@"newAppointment.creationDate = %@", newAppointment.creationDate);
    NSLog(@"newAppointment.type = %d", [newAppointment.type intValue]);
    
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
        
    }
    
    AppointmentsViewController *viewController = [[AppointmentsViewController alloc] initWithNibName:nil bundle:nil];
    viewController.managedObjectContext = self.managedObjectContext;

    viewController.newAppointment = newAppointment;
    
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];

    /*-- If newMemoText has been added to the MOC in some call of the present method -> Change the Done button to the new Button.
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
     previousTextInput = newTextInput;
     NSLog(@"%@", previousTextInput);
     --*/ 
}

- (void) addNewTask {
    
    [self.view endEditing:YES];
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){
    NSLog(@"Trying to Create a newTask");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Task"
                                   inManagedObjectContext:managedObjectContext];
    
    Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newTask setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newTask setCreationDate:[NSDate date]];
    [newTask setType:[NSNumber numberWithInt:2]];
    [newTask setDoDate:[NSDate date]];
    
    //   }
    /*--the text is NOT the same as previous call of method --> insert a new instance of MemoText in the MOC and copy new text to this instance--
     CASE: When the user has added and saved text, then returns to editing but does not add any text ---*/
    /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    TasksViewController *viewController = [[TasksViewController alloc] initWithNibName:nil bundle:nil];
    viewController.managedObjectContext = self.managedObjectContext;
    
    viewController.newTask = newTask;
    
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
    

    
    NSLog(@"newTask.text = %@", newTask.text);
    NSLog(@"newTask.creationDate = %@", newTask.creationDate);
    NSLog(@"newTask.type = %d", [newTask.type intValue]);
    NSLog(@"newTask.doDate = %@", newTask.doDate);
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
    }
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    
    /*-- If newMemoText has been added to the MOC in some call of the present method -> Change the Done button to the new Button.
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
     previousTextInput = newTextInput;
     NSLog(@"%@", previousTextInput);
     --*/ 
}

@end

/* SEGMENTED CONTROL
 NSArray * segControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"documents_folder_white.png"], [UIImage imageNamed:@"documents_white_small.png"], [UIImage imageNamed:@"documents.png"], nil];
 UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:segControlItems];
 segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
 [segmentControl setTintColor:[UIColor blueColor]];
 [segmentControl setBackgroundColor:[UIColor blueColor]];
 segmentControl.momentary = NO;
 segmentControl.frame = CGRectMake (0, 225, 320, 40);
 [self.view addSubview:segmentControl];
*/
/*
 UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
 UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
 UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
 entryImageView.frame = CGRectMake(12, 0, 300, 130);
 entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 
 UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
 UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
 UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
 imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
 imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 */


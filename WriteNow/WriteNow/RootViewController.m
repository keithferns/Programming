//
//  RootViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController

@synthesize managedObjectContext;
@synthesize textView, previousTextInput;
@synthesize myToolBar;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    //self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];

    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300,120)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [textView.layer setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor];

    [textView.layer setBorderWidth:3.0];
    [textView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    [textView setFont:[UIFont boldSystemFontOfSize:15]];
    [textView setDelegate:self];

    [self.view addSubview:containerView];

    
    /*
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(12, 0, 300, 130);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    */
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

  
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"Write Now";
    [label setFont:[UIFont boldSystemFontOfSize:16]];

    
    
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
   // [containerView addSubview:entryImageView];

    [containerView addSubview:label];

    previousTextInput = @"";

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    
    NSLog(@"EDITING BEGAN");
    
    CGRect buttonBarFrame = CGRectMake(0, 205, 320, 45);
    myToolBar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [myToolBar setBarStyle:UIBarStyleDefault];
    [myToolBar setTintColor:[UIColor grayColor]];
   // UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithTitle:@"Folder" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMemo)];
    
    UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addNewFolder)];
    [folderButton setTitle:@"Folder"];
    
    
    [folderButton setTag:0];
    [folderButton setWidth:50.0];
    UIBarButtonItem *appendButton = [[UIBarButtonItem alloc] initWithTitle:@"Document" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewAppointment)];
    [appendButton setTag:1];
    [appendButton setWidth:50.0];
    
    UIBarButtonItem *appointmentButton = [[UIBarButtonItem alloc] initWithTitle:@"Appointment" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewAppointment)];
    [appointmentButton setTag:2];
    [appointmentButton setWidth:50.0];
    
    UIBarButtonItem *taskButton = [[UIBarButtonItem alloc] initWithTitle:@"Task" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewTask)];

    [taskButton setTag:3];
    [taskButton setWidth:50.0];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    
    
    UIBarButtonItem *saveMemo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"note_accept.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewMemo)];
                    
    [saveMemo setTag:4];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, folderButton, flexSpace, appendButton, flexSpace, appointmentButton, flexSpace, taskButton,flexSpace, saveMemo, nil];
    [myToolBar setItems:items];
    [self.view addSubview:myToolBar];
    
    [folderButton release];
    [appendButton release];
    [appointmentButton release];
    [taskButton release];
    [flexSpace release];
    
    /*
     
     */
}

- (void) textViewDidEndEditing:(UITextView *)textView{
    [myToolBar setHidden:YES];
    [self.textView resignFirstResponder];
}

- (void) addNewFolder{
    [self.textView resignFirstResponder];
    [containerView setHidden:YES];
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
    
    [self.view endEditing:YES];
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){
    NSLog(@"Trying to Create a newAppointment");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Appointment"
                                   inManagedObjectContext:managedObjectContext];
    
    Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    //Memo *newMemo = [self.managedObjectContext insertNewObjectForEntityForName:@"Memo"];
    [newAppointment setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newAppointment setCreationDate:[NSDate date]];
    [newAppointment setType:[NSNumber numberWithInt:1]];
    [newAppointment setDoDate:[NSDate date]];
    
    
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
    NSLog(@"newAppointment.doDate = %@", newAppointment.doDate);
    
    
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

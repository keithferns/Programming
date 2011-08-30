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
#import "FilesTableViewController.h"
#import "SettingsViewController.h"

#import "AppointmentsViewController.h"
#import "TasksViewController.h"
#import "AddFolderViewController.h"
#import "AddEntityViewController.h"

@implementation MainViewController

@synthesize newMemo;
@synthesize navigationController;
@synthesize managedObjectContext;
@synthesize textView, previousTextInput, myToolBar;

#pragma mark - MEMORY MANAGEMENT
- (void)dealloc
{
    [super dealloc];
    [navigationController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [myToolBar release];
    [newMemo release];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.navigationBar setHidden:YES];
      
    NSLog(@"MainViewController MOC: %@", managedObjectContext);

    //self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    //[containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1].CGColor];
    [containerView.layer setOpacity:1.0];
    
    [self.view addSubview:containerView];

    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 35, 310,135)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    //textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
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
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:20]];
    [label setTextColor:[UIColor whiteColor]];

    
    [containerView addSubview:textView];
    [containerView addSubview:label];
    [label release];
    
    previousTextInput = @"";
    CGRect bottomFrame = CGRectMake(0, 245, 320, 215);
    
    NSLog(@"Main View Did Load: %@", self.tabBarItem.title);
    if(self.tabBarItem.title == @"Today") {
    CurrentViewController *viewController = [[CurrentViewController alloc] init];
    [viewController.view setFrame:bottomFrame];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    }
    else if (self.tabBarItem.title == @"Calendar") {	
    CalendarViewController *viewController = [[CalendarViewController alloc] init];
    [viewController.view setFrame:bottomFrame];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Archive") {	
    FoldersViewController *viewController = [[FoldersViewController alloc] init];
    [viewController.view setFrame:bottomFrame];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Documents") {	
    FilesTableViewController  *viewController = [[FilesTableViewController alloc] init];
    [viewController.view setFrame:bottomFrame];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Settings") {	
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    [viewController.view setFrame:bottomFrame];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    }
    
    /*--NOTIFICATIONS: register --*/
    
    /* Search Bar Notification sent from FolderTable View to the Main view to accommodate the moving TableView 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(keyboardWasShown)
                                        name:UIKeyboardDidShowNotification
                                        object:foldersViewController.searchBar];
    */

    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    /*
     You can create the accessory view programmatically (in code), in the same nib file as the view controller's main view, or from a separate nib file. This example illustrates the latter; it means the accessory view is loaded lazily -- only if it is required.
     */
    
    if (textView.inputAccessoryView == nil) {
        //[[NSBundle mainBundle] loadNibNamed:@"AccessoryView" owner:self options:nil];
        // Loading the AccessoryView nib file sets the accessoryView outlet.
        
        CGRect buttonBarFrame = CGRectMake(0, 195, 320, 50);
        myToolBar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
        [myToolBar setBarStyle:UIBarStyleDefault];
        [myToolBar setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(makeActionSheet:)];
        [actionButton setWidth:50.0];
        [actionButton setTag:0];
        actionButton.title = @"Do";
        
        UIBarButtonItem *saveMemo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save_document.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveMemo)];
        [saveMemo setTitle:@"Note"];
        [saveMemo setWidth:50.0];
        [saveMemo setTag:1];
        
        UIBarButtonItem *appointmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"]style:UIBarButtonItemStylePlain target:self action:@selector(addEntity:)];
        [appointmentButton setTitle:@"Appointment"];
        [appointmentButton setTag:2];
        [appointmentButton setWidth:50.0];
        
        UIBarButtonItem *taskButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"document_todo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addEntity:)];
        [taskButton setTitle:@"To Do"];
        [taskButton setWidth:50.0];
        [taskButton setTag:3];
        
        UIBarButtonItem *dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
        [dismissKeyboard setTitle:@"Down Input"];

        [taskButton setWidth:50.0];
        [taskButton setTag:4];
        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithTitle:@"Folder" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMemo)];
        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addNewFolder)];
        //[folderButton setTitle:@"Folder"];
        //[folderButton setTag:0];
        //[folderButton setWidth:50.0];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flexSpace, actionButton, flexSpace, saveMemo, flexSpace, appointmentButton, flexSpace, taskButton,flexSpace, dismissKeyboard, flexSpace, nil];
        [myToolBar setItems:items];
        
        
        textView.inputAccessoryView = myToolBar;
        [dismissKeyboard release];
        [saveMemo release];
        [appointmentButton release];
        [actionButton release];
        [taskButton release];
        [flexSpace release];    
        
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        //self.myToolBar = nil; //kjf NOTE: this line actually causes a crash.
    }
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [aTextView resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    /*
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    if (textView.frame.origin.y+textView.frame.size.height  > keyboardTop){
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    }
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    textView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
     */
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    /*
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    textView.frame = self.view.bounds;
    
    [UIView commitAnimations];
    */
}

/*
#pragma mark -
#pragma mark Accessory view action

- (IBAction)tappedMe:(id)sender {
    
    // When the accessory view button is tapped, add a suitable string to the text view.
    NSMutableString *text = [textView.text mutableCopy];
    NSRange selectedRange = textView.selectedRange;
    
    [text replaceCharactersInRange:selectedRange withString:@"You tapped me.\n"];
    textView.text = text;
    [text release];
}

*/

#pragma mark - NOTIFICATIONS

- (void)keyboardWasShown{
    NSLog(@"Keyboard Was Shown");
    if ([textView isFirstResponder]) {
        return;
    }
        else {
         
            [containerView setHidden:YES];    
        }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - EVENTS & ACTIONS

- (void) textViewDidBeginEditing:(UITextView *)textView{    
    NSLog(@"EDITING BEGAN");
}

- (void) makeActionSheet:(id) sender{
    UIBarButtonItem *actionButton = sender;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DO" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to Folder", @"Append to File", @"Send as Email", @"Send as Message", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    actionSheet.layer.backgroundColor = [UIColor blueColor].CGColor;
    [actionSheet showFromBarButtonItem:actionButton animated:YES];
    /*
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(50, 340, 220, 65)];
    CGRect myframe = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.frame.size.width, myView.frame.size.height);
    CALayer *mylayer = [[CALayer alloc] init];
    [mylayer setFrame:myframe];
    [mylayer setCornerRadius:10.0];
    [myView.layer addSublayer:mylayer];
    [myView.layer setMask:mylayer];
    [actionSheet showInView:myView];
    [actionSheet setAlpha:0.8];
     */
    [actionSheet release];
    
    }

- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
    //[containerView setHidden:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
		switch (buttonIndex) {
			case 4:
				NSLog(@"Cancel Button Clicked on Main View action sheet");
				break;
            case 3:   
                NSLog(@"4nd Button Clicked on action sheet");
              
				break;
			case 2:
				NSLog(@"3nd Button Clicked on action sheet");
				break;
			case 1:
				NSLog(@"2nd Button Clicked on action sheet");
                //[self addEntity];
				break;
			case 0:
				NSLog(@"1st Button Clicked on action sheet");
                if ([textView hasText]) {
					[self addNewFolder];
				}
				break;
			default:
				break;
        }
}

- (void) addNewFolder{
   
        AddFolderViewController *addViewController = [[AddFolderViewController alloc] initWithNibName:nil bundle:nil];
        // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that from the fetched results controller's context.
        /*
        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
        addViewController.managedObjectContext = addingContext;
        [addingContext release];	
        [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
        NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
        */
    if (newMemo.text == nil) {
        if (![textView hasText]){
            return;
        }
        NSLog(@"Trying to Create a newMemo");
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Memo"
                                       inManagedObjectContext:managedObjectContext];
        newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newMemo setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newMemo setCreationDate:[NSDate date]];
        [newMemo setType:0];
        [newMemo setEditDate:[NSDate date]];
        }
        addViewController.newMemo = newMemo;	
        [self presentModalViewController:addViewController animated:YES];	
        previousTextInput = textView.text;
        NSLog(@"Previous Text: %@", previousTextInput);
        [textView setText:@""];
        [textView resignFirstResponder];
        [addViewController release];
        
}

- (void) saveMemo {
    if (![textView hasText]){
        return;
    }
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    NSLog(@"Trying to Create a newMemo");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Memo"
                                   inManagedObjectContext:managedObjectContext];
    
    newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newMemo setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newMemo setCreationDate:[NSDate date]];
    [newMemo setType:0];
    [newMemo setEditDate:[NSDate date]];

    /*--TODO:   SAVE(MEMO/NOTE) option. When the user has added and saved text, then returns to editing but does not add any text. 
     // if (![newTextInput isEqualToString:previousTextInput]){

     -*/
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
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    [textView resignFirstResponder];
    
}

- (void) addNewAppointment {
    if (![textView hasText]){
        return;
    }
    [self.view endEditing:YES];

    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
      /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    AppointmentsViewController *viewController = [[AppointmentsViewController alloc] initWithNibName:nil bundle:nil];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.newText = textView.text;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
    [textView resignFirstResponder];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
}

- (void) addNewTask {
    if (![textView hasText]){
        return;
    }
    [self.view endEditing:YES];
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){

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
    
    viewController.newText = textView.text;
    
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
    
    [textView resignFirstResponder];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
}

- (void) addEntity:(id)sender {

    NSLog(@"Adding Entity");
    AddEntityViewController *viewController = [[AddEntityViewController alloc] initWithNibName:nil bundle:nil];
    viewController.sender = [sender title];
    viewController.newText = [textView text];
    
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

@end

//[(UITabBarController *)self.parentViewController setSelectedIndex:0];



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


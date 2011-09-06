//
//  CurrentViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentViewController.h"
#import "WriteNowAppDelegate.h"


#import "CustomTextView.h"
#import "CustomToolBarMainView.h"

#import "CurrentTableViewController.h"
#import "AddEntityViewController.h"
#import "TasksViewController.h"

#import "FoldersViewController.h"
#import "TasksTableViewController.h"



@implementation CurrentViewController

@synthesize managedObjectContext;
@synthesize tableViewController;
@synthesize textView;
@synthesize newMemo;
@synthesize previousTextInput;


- (void)dealloc {
    [super dealloc];
    [textView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];    

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    
    self.title = @"Write Now";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    previousTextInput = @"";
      
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 100)];
    textView.delegate = self;

    [self.view addSubview:textView];
    
    tableViewController = [[CurrentTableViewController alloc] init];
    [tableViewController.tableView setFrame:CGRectMake(0, 205, 320, 205)];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 48.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    
}


- (void) viewWillAppear:(BOOL)animated{    
    if (tableViewController.tableView.superview == nil) {
    [self.view addSubview:tableViewController.tableView];
    }
    CGRect startFrame = CGRectMake(320, 205, 320, 204);
    CGRect endFrame = CGRectMake(0, 205, 320, 204);
    [self animateViews:tableViewController.tableView startFrom:startFrame endAt:endFrame];
    
}


#pragma mark -
#pragma mark Text view delegate methods
 - (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
 
 if (textView.inputAccessoryView == nil) {
     //[[NSBundle mainBundle] loadNibNamed:@"AccessoryView" owner:self options:nil];
     // Loading the AccessoryView nib file sets the accessoryView outlet.
 
     CustomToolBarMainView *toolbar = [[CustomToolBarMainView alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
     [toolbar.actionButton setTarget:self];
     [toolbar.actionButton setAction:@selector(makeActionSheet:)];
     [toolbar.memoButton setTarget:self];
     [toolbar.memoButton setAction:@selector(saveMemo)];
     [toolbar.appointmentButton setTarget:self];
     [toolbar.appointmentButton setAction: @selector(addEntity:)];
     [toolbar.taskButton setTarget:self];
     [toolbar.taskButton setAction:@selector(addEntity:)];
     [toolbar.dismissKeyboard setTarget:self];
     [toolbar.dismissKeyboard setAction:@selector(dismissKeyboard)];
     textView.inputAccessoryView = toolbar;
 
 // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
 //self.myToolBar = nil; //kjf NOTE: this line actually causes a crash.
 }
 
 return YES;
}
 
 
 - (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
 [aTextView resignFirstResponder];
 return YES;
 }

#pragma mark - EVENTS & ACTIONS

- (void) textViewDidBeginEditing:(UITextView *)textView{    
   // NSLog(@"EDITING BEGAN");
}

- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
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
    
    //FoldersViewController *addViewController = [[FoldersViewController alloc] initWithNibName:nil bundle:nil];
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
            //[addViewController release];
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
    //addViewController.newMemo = newMemo;	
    //[self presentModalViewController:addViewController animated:YES];	
    previousTextInput = textView.text;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    [textView resignFirstResponder];
   // [addViewController release];
    
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
    
    AddEntityViewController *viewController =[[AddEntityViewController alloc] initWithNibName:nil bundle:nil];
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

- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame{
    view.frame = fromFrame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    view.frame = toFrame;
    [UIView commitAnimations];    
}


@end

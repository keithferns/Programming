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



@implementation CurrentViewController

@synthesize managedObjectContext;
@synthesize tableViewController;
@synthesize textView;
@synthesize newNote;
@synthesize previousTextInput;
@synthesize toolBar;
@synthesize bottomView;


#define screenRect [[UIScreen mainScreen] applicationFrame]
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewHeight 100.0
#define bottomViewRect CGRectMake(0, navBarHeight+160, screenRect.size.width, 260)


- (void)dealloc {
    [super dealloc];
    [textView release];
    [tableViewController release];
    [managedObjectContext release];
    [newNote release];
    [toolBar release];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       
    swappingViews = NO;     
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    self.title = @"Write Now";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    previousTextInput = @"";
    
    //TOOLBAR: setup    
    toolBar = [[CustomToolBarMainView alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(makeActionSheet:)];
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(saveMemo)];
    [toolBar.thirdButton setTarget:self];
    [toolBar.thirdButton setAction: @selector(addNewAppointment)];
    [toolBar.fourthButton setTarget:self];
    [toolBar.fourthButton setAction:@selector(addEntity:)];
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];

    //TEXTVIEW: setup and add to self.view
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, navBarHeight, 320, textViewHeight)];
    textView.delegate = self;    
    textView.inputAccessoryView = toolBar;
    [self.view addSubview:textView];
    
    //BOTTOMVIEW: setup and add the datePicker and dateToolBar
    bottomView = [[UIView alloc] initWithFrame:bottomViewRect];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    
    tableViewController = [[CurrentTableViewController alloc] init];
    [tableViewController.tableView setFrame:CGRectMake(0, 0, screenRect.size.width, bottomView.frame.size.height)];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 48.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    
}

- (void) viewWillAppear:(BOOL)animated{    
    
    [bottomView addSubview:tableViewController.tableView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.4];    
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height);
   
    [UIView commitAnimations]; 
}

#pragma mark -
#pragma mark MAINTOOLBAR ACTIONS

- (void) addEntity:(id)sender {
    
    [self createNewNote];
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"ScheduleSomethingNotification" object:nil];
    
    NSLog(@"Adding Entity");
    AddEntityViewController *viewController = [[AddEntityViewController alloc] initWithNibName:nil bundle:nil];
    viewController.sender = [sender title];
    viewController.newText = textView.text;
    viewController.textView.text = self.textView.text;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

- (void)keyboardWillShow:(NSNotification *)notification {

    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    
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
    
        CGRect endFrame = bottomView.frame;
        endFrame.origin.y  = keyboardTop;
        bottomView.frame = endFrame;
        [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.*/
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
  
    
    tableViewController.tableView.frame = CGRectMake(0, 205, 320, 200);
    
    
    [UIView commitAnimations];
}



- (void) dismissKeyboard{
    //Check if textView is firstResponder. If yes, dismiss the keyboard by calling resignFirstResponder;
    if ([textView isFirstResponder]){
        [textView resignFirstResponder];
    }
           [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        
          
        
        bottomView.frame = bottomViewRect;
        if (textView.frame.size.height <100){
            CGRect frame = textView.frame;
            frame.size.height = textViewHeight;
            textView.frame = frame;
        
        }
        
        [UIView commitAnimations];
        [self.navigationController.navigationBar setHidden:NO];
}



- (void) makeActionSheet:(id) sender{
   // UIBarButtonItem *actionButton = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DO" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to Folder", @"Append to File", @"Send as Email", @"Send as Message", nil];
    //[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    actionSheet.layer.backgroundColor = [UIColor blueColor].CGColor;
    //[actionSheet showFromBarButtonItem:actionButton animated:YES];
    //[actionSheet showInView:self.view];
     UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(50, 340, 220, 65)];
     CGRect myframe = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.frame.size.width, myView.frame.size.height);
     CALayer *mylayer = [[CALayer alloc] init];
     [mylayer setFrame:myframe];
     [mylayer setCornerRadius:10.0];
     [myView.layer addSublayer:mylayer];
     [myView.layer setMask:mylayer];
     [actionSheet showInView:myView];
     [actionSheet setAlpha:0.6];
     [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    [myView release];
    [mylayer release];
    [textView becomeFirstResponder];
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
          //  if ([textView hasText] || rightLabel.superview == nil) {
          //  [self.view addSubview:rightLabel];
            //[rightLabel setPlaceholder:@"New File"];
          //  CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //[self animateViews:rightLabel startFrom:startFrame endAt:endFrame]; 
            //}
                break;
        case 0:
            //if ([textView hasText]) {
            //    [self.view addSubview:rightLabel];
            //    //[rightLabel setPlaceholder:@"New Folder:"];
            //    CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
              //  CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
             //   [self animateViews:rightLabel startFrom:startFrame endAt:endFrame];
           // }
            break;
        default:
            break;
    }
}

- (void) createNewNote{

if (newNote.text == nil) {
    if (![textView hasText]){
        return;
        }
    NSLog(@"Trying to Create a newNote");
    
   // NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput

    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note"
                                   inManagedObjectContext:managedObjectContext];
    newNote = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newNote setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newNote setCreationDate:[NSDate date]];
    [newNote setType:0];
    }
    previousTextInput = textView.text;

}

- (void) addNewFolder{
    [self createNewNote];
    //FoldersViewController *addViewController = [[FoldersViewController alloc] initWithNibName:nil bundle:nil];
    // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that from the fetched results controller's context.
    /*
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     addViewController.managedObjectContext = addingContext;
     [addingContext release];	
     [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
     */
    //addViewController.newMemo = newMemo;	
    //[self presentModalViewController:addViewController animated:YES];	
    previousTextInput = textView.text;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    [textView resignFirstResponder];
   // [addViewController release];
    
}

- (void) saveMemo {
    [self createNewNote];
    if (![textView hasText]){
        return;
    }

    Memo *newMemo = [[Memo alloc] init];
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
    
    [textView setText:@""];
    [textView resignFirstResponder];    
    [newMemo release];
}

- (void) addNewAppointment {
    
    [self createNewNote];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScheduleSomethingNotification" object:nil];
     /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    AddEntityViewController *viewController =[[AddEntityViewController alloc] initWithNibName:@"AddEntityViewController" bundle:[NSBundle mainBundle]];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.newText = textView.text;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
    [textView resignFirstResponder];
    
    previousTextInput = textView.text;
    
    [textView setText:@""];
    
    [self.view endEditing:YES];

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
    //TasksViewController *viewController = [[TasksViewController alloc] initWithNibName:nil bundle:nil];
    //viewController.managedObjectContext = self.managedObjectContext;
    
    //viewController.newText = textView.text;
    
    //[self presentModalViewController:viewController animated:YES];
    
    //[viewController release];
    
    //[textView resignFirstResponder];
    
   // previousTextInput = newTextInput;
    //NSLog(@"Previous Text: %@", previousTextInput);
    //[textView setText:@""];
}

- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame{
    view.frame = fromFrame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    view.frame = toFrame;
    [UIView commitAnimations];    
}

- (void) swapViews {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [transition setType:@"kCATransitionPush"];	
    [transition setSubtype:@"kCATransitionFromLeft"];
    
    swappingViews = YES;
    transition.delegate = self;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
}


@end

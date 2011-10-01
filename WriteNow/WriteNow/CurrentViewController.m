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

#import "CalendarViewController.h"
#import "FoldersViewController.h"

#import "MyDataObject.h"
#import "AppDelegateProtocol.h"

@implementation CurrentViewController

@synthesize managedObjectContext;
@synthesize tableViewController;
@synthesize textView;
@synthesize previousTextInput;
@synthesize toolBar;
@synthesize navPopover;

#define screenRect [[UIScreen mainScreen] applicationFrame]
//CGRect screenBounds = [UIScreen mainScreen].bounds;
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+10, screenRect.size.width-10, 140)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height-textViewRect.origin.y-textViewRect.size.height-10)

- (MyDataObject *) myDataObject {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}

- (void)dealloc {
    [super dealloc];
    [textView release];
    [tableViewController release];
    [managedObjectContext release];
    [toolBar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CURRENTVIEWCONTROLLER: MEMORY WARNING");
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
       
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    self.title = @"Write Now";
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    
    previousTextInput = @"";
    
    //TEXTVIEW: setup and add to self.view
    textView = [[CustomTextView alloc] initWithFrame:textViewRect];
    textView.delegate = self;    
   // UIImage *patternImage = [UIImage imageNamed:@"54700.png"];
    //self.textView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self.view addSubview:textView];
}

- (void) viewWillAppear:(BOOL)animated{
    if (self.navigationController.navigationBarHidden == YES){
        self.navigationController.navigationBarHidden = NO;
    }
    //TOOLBAR: setup    
    toolBar = [[CustomToolBarMainView alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(saveMemo)];
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(saveTo:)];
    [toolBar.thirdButton setTarget:self];
    [toolBar.thirdButton setAction: @selector(schedule:)];
    [toolBar.fourthButton setTarget:self];
    [toolBar.fourthButton setAction:@selector(send:)];
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];

    textView.inputAccessoryView = toolBar;
    
    if (tableViewController == nil) {
        tableViewController = [[CurrentTableViewController alloc]init];
    }
    
    if (tableViewController.tableView.superview == nil) {
        [self.view addSubview:tableViewController.tableView];
        }
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 48.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];

    CGRect startFrame = CGRectMake(-screenRect.size.width, bottomViewRect.origin.y, bottomViewRect.size.width, bottomViewRect.size.height);
    tableViewController.tableView.frame = startFrame;   
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = bottomViewRect;
   
    [UIView commitAnimations]; 
    
    NSIndexPath *tableSelection = [tableViewController.tableView indexPathForSelectedRow];
	[tableViewController.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated{

    [tableViewController.tableView removeFromSuperview];
    [navPopover setDelegate:nil];
    [navPopover autorelease];
    navPopover = nil;
    tableViewController.tableView = nil;
    [tableViewController release];
    tableViewController = nil;
    [toolBar release];
}

#pragma mark -
#pragma mark Responding to keyboard notifications

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
    //Put endframes for views that are to be resized here.
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];

    tableViewController.tableView.frame = bottomViewRect;    
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

    if (textView.frame.size.height <100){
        textView.frame = textViewRect;        
    }
    [UIView commitAnimations];
    [self.navigationController.navigationBar setHidden:NO];
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    }
}

- (void) createNewNote{
    if (![textView hasText]){
        return;
        }
        MyDataObject *myDataObject = [self myDataObject];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext];
        Note *newNote = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newNote setText:textView.text];
        [newNote setCreationDate:[NSDate date]];
        //[newNote setLocation:<#(Place *)#>];
        myDataObject.myNote = newNote;
        [newNote release];
    //TODO: Add condition for reedit = if creationDate != nil then break

    //[newNote setType:[NSNumber numberWithInt:0]];
}


- (void) saveMemo {
    if (![textView hasText]){
        return;
    }
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
    Memo *newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newMemo setText:textView.text];
    [newMemo setCreationDate:[NSDate date]];
    [newMemo setType:0];
    [newMemo setEditDate:[NSDate date]];

    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
    }
    // [[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];
    
    [textView setText:@""];
    [textView resignFirstResponder];    
    [newMemo release];
    
    /*--TODO:   SAVE(MEMO/NOTE) option. When the user has added and saved text, then returns to editing but does not add any text. 
     // if (![newTextInput isEqualToString:previousTextInput]){
     --*/
}

- (void) addNewAppointment {
    MyDataObject *myData = [self myDataObject];
    [myData setMyText:textView.text];
    [myData setNoteType:[NSNumber numberWithInt:1]];
    
    [self.tabBarController setSelectedIndex:1];
    
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];
}

- (void) addNewTask {
    MyDataObject *myData = [self myDataObject];    
    [myData setMyText:textView.text];
    [myData setNoteType:[NSNumber numberWithInt:2]];
    
    [self.tabBarController setSelectedIndex:1];
    
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];

}

- (void) saveToFile{
    [self.tabBarController setSelectedIndex:2];
    
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];    
}

- (void) saveToFolder{
    [self.tabBarController setSelectedIndex:2];
    
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];
}

#pragma -
#pragma mark TOOLBAR AND NAVPOPOVER ACTIONS


- (void)popoverButtonPressed:(id)sender {
    if ([sender tag] == 1) {
        NSLog(@"Popover Button 1 pressed");
    } else {    
        NSLog(@"Popover Button 2 pressed");
    }
}

- (void)saveTo:(id)sender {
	NSLog(@"Save-> Button Pressed");
    
    if(!navPopover) {
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
        [button1 setImage:[UIImage imageNamed:@"folder_button.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(saveToFolder) forControlEvents:UIControlEventTouchUpInside];
        UILabel *folderLabel = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
        [folderLabel setBackgroundColor:[UIColor clearColor]];
        [folderLabel setTextAlignment:UITextAlignmentCenter];
        [folderLabel setTextColor:[UIColor whiteColor]];
        [folderLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [folderLabel setText:@"To Folder"];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
        [button2 setImage:[UIImage imageNamed:@"files_button.png.png"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(saveToFile) forControlEvents:UIControlEventTouchUpInside];
        UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x, button2.frame.size.height+5, button2.frame.size.width, 30)];
        [fileLabel setBackgroundColor:[UIColor clearColor]];
        [fileLabel setTextAlignment:UITextAlignmentCenter];
        [fileLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [fileLabel setTextColor:[UIColor whiteColor]];
        [fileLabel setText:@"To File"];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(150, button1.frame.size.height+folderLabel.frame.size.height);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:button2];
        [viewCon.view addSubview:folderLabel];
        [viewCon.view addSubview:fileLabel];
        
        [button1 release];
        [button2 release];
        [folderLabel release];
        [fileLabel release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        [navPopover presentPopoverFromRect:CGRectMake(90, 205, 50, 40)
                                    inView:self.view    
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}

- (void)schedule:(id)sender {
	NSLog(@"Bookmarks Button Pressed");
    
    if(!navPopover) {
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
        [button1 setImage:[UIImage imageNamed:@"task_button.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(addNewTask) forControlEvents:UIControlEventTouchUpInside];
        UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
        [appLabel setBackgroundColor:[UIColor clearColor]];
        [appLabel setTextAlignment:UITextAlignmentCenter];
        [appLabel setTextColor:[UIColor whiteColor]];
        [appLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [appLabel setText:@"Task"];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
        [button2 setImage:[UIImage imageNamed:@"appointment_button.png.png"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(addNewAppointment) forControlEvents:UIControlEventTouchUpInside];
        UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x-10, button2.frame.size.height+5, button2.frame.size.width+20, 30)];
        [taskLabel setBackgroundColor:[UIColor clearColor]];
        [taskLabel setTextAlignment:UITextAlignmentCenter];
        [taskLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [taskLabel setTextColor:[UIColor whiteColor]];
        [taskLabel setText:@"Appointment"];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(150, button1.frame.size.height+appLabel.frame.size.height);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:button2];
        [viewCon.view addSubview:appLabel];
        [viewCon.view addSubview:taskLabel];
        
        [button1 release];
        [button2 release];
        [appLabel release];
        [taskLabel release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
        
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        
        [navPopover presentPopoverFromRect:CGRectMake(145, 205, 50, 40)
                                    inView:self.view
                  permittedArrowDirections: UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}

- (void)send:(id)sender {
	NSLog(@"Bookmarks Button Pressed");
    
    if(!navPopover) {
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
        [button1 setImage:[UIImage imageNamed:@"email_button.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(addNewTask) forControlEvents:UIControlEventTouchUpInside];
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
        [emailLabel setBackgroundColor:[UIColor clearColor]];
        [emailLabel setTextAlignment:UITextAlignmentCenter];
        [emailLabel setTextColor:[UIColor whiteColor]];
        [emailLabel setFont:[UIFont systemFontOfSize:12]];
        [emailLabel setText:@"Email"];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
        [button2 setImage:[UIImage imageNamed:@"message_button.png"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(addNewAppointment) forControlEvents:UIControlEventTouchUpInside];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x-10, button2.frame.size.height+5, button2.frame.size.width+20, 30)];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextAlignment:UITextAlignmentCenter];
        [messageLabel setFont:[UIFont systemFontOfSize:12]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setText:@"Message"];
        
        //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 130, 30)];
        //  [label setTextAlignment:UITextAlignmentCenter];
        //  [label setBackgroundColor:[UIColor clearColor]];
        //  [label setTextColor:[UIColor whiteColor]];
        //  [label setText:@"Schedule:"];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(150, button1.frame.size.height+emailLabel.frame.size.height);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:button2];
        // [viewCon.view addSubview:label];
        [viewCon.view addSubview:emailLabel];
        [viewCon.view addSubview:messageLabel];
        
        [button1 release];
        [button2 release];
        //  [label release];
        [emailLabel release];
        [messageLabel release];
        
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        [navPopover presentPopoverFromRect:CGRectMake(205, 205, 50, 50)
                                    inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}


@end

/*
 // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that for the fetched results controller's context.
 NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
 addViewController.managedObjectContext = addingContext;
 [addingContext release];	
 [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
 NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
 [addViewController release];
 */
/*

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
*/


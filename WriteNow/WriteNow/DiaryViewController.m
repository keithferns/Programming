//
//  FilesViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiaryViewController.h"
#import "DiaryTableViewController.h"
#import "WriteNowAppDelegate.h"
#import "CustomToolBarMainView.h"
#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DiaryViewController

@synthesize managedObjectContext, tableViewController;
@synthesize textView, diaryView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [textView release];
    [diaryView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After MOC in Folders: %@",  managedObjectContext);
	}
    
    
    [self setTitle:@"Diary"];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    //previousTextInput = @"";
    
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 100)];
    textView.delegate = self;
    
    [self.view addSubview:textView];
    diaryView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y+textView.frame.size.height+15, 320, 225)];
    [diaryView setEditable:NO];
    [self.view addSubview:diaryView];
    
    
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
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    /* Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard. */
  
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The top of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    //CGFloat keyboardTop = keyboardRect.origin.y;
    //CGRect newTextViewFrame = self.view.bounds;
    //if (diaryView.frame.origin.y > keyboardTop){
    //   newTextViewFrame.origin.y = keyboardTop;
    // }
    
    CGRect newTextViewFrame = keyboardRect;

    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [diaryView setFrame:newTextViewFrame];
    
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
    
      
    diaryView.frame = CGRectMake(0, textView.frame.origin.y+textView.frame.size.height+15, 320, 225);
    
    [UIView commitAnimations];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
}

@end

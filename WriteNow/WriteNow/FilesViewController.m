//
//  FilesViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController.h"
#import "FilesTableViewController.h"
#import "WriteNowAppDelegate.h"
#import "ContainerView.h"
#import "CustomToolBarMainView.h"
#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FilesViewController

@synthesize managedObjectContext, tableViewController;
@synthesize textView;

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
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After MOC in Folders: %@",  managedObjectContext);
	}
    
    tableViewController = [[FilesTableViewController alloc] init];
    
    ContainerView *topView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 205)];
    [self.view  addSubview:topView];
    
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(5, 25, 310, 135)];
    [topView addSubview:textView];
    
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
    
    [topView.label setText:@"Documents"];
    [topView release];
    
    
    ContainerView *bottomView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 205, 320, 260)];
    [self.view addSubview:bottomView];
    [tableViewController.tableView setFrame:CGRectMake(0, 0, 320, 260)];    
    [tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [bottomView addSubview:tableViewController.tableView];
    [bottomView release];
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


- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
}

@end

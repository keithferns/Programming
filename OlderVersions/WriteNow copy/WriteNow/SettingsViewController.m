//
//  SettingsViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "WriteNowAppDelegate.h"
#import "NotesTableViewController.h"

@implementation SettingsViewController

@synthesize tableViewController, managedObjectContext;

- (void)dealloc {
    [tableViewController release];
    [managedObjectContext release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Settings View Controller - Memory Worning Received");
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidDisappear:(BOOL)animated {
    managedObjectContext = nil;
    tableViewController = nil;
    [tableViewController release];
    [managedObjectContext release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"In SettingsViewController");

    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];    
    self.title = @"Settings";
 }

- (void) viewWillAppear:(BOOL)animated{
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}        
    tableViewController = [[NotesTableViewController alloc] init];
    tableViewController.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, 320, 400);
    [self.view addSubview:tableViewController.tableView];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 36.0;
    NSIndexPath *tableSelection = [tableViewController.tableView indexPathForSelectedRow];
	[tableViewController.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

@end

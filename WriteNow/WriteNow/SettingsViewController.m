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
    NSLog(@"In SettingsViewController");
    
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}        
    
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    
    self.title = @"Settings";
    /*
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];

    CGRect bgRect = CGRectMake(0, 0, 160, 180);
    UIImage *theImage = [UIImage imageNamed:@"popoverBg.png"];
    UIImage *bgImage = [[theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0] retain];
    [bgImage drawInRect:bgRect blendMode:kCGBlendModeNormal alpha:0.8];//KJF CHANGED ALPHA FROM 1.0
    UIView *popoverViewForTable = [[UIView alloc] initWithFrame:CGRectMake(160, 5, 160, 180)];
    popoverViewForTable.layer.contents = (id)bgImage.CGImage;   
    [self.view addSubview:popoverViewForTable];
     */
}

- (void) viewWillAppear:(BOOL)animated{
    tableViewController = [[NotesTableViewController alloc] init];
    tableViewController.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, 400, 320);
    [self.view addSubview:tableViewController.tableView];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 36.0;
    NSIndexPath *tableSelection = [tableViewController.tableView indexPathForSelectedRow];
	[tableViewController.tableView deselectRowAtIndexPath:tableSelection animated:NO];
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

@end

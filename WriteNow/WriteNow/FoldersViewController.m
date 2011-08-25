//
//  FoldersViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoldersViewController.h"
#import "WriteNowAppDelegate.h"

@implementation FoldersViewController

@synthesize managedObjectContext;

#pragma mark - View lifecycle

//FIXME: Add ability to change/edit the name of a folder. 


-(id)init {
	[super init];
	//----- SETUP TAB BAR -----
	UITabBarItem *tabBarItem = [self tabBarItem];
	[tabBarItem setTitle:@"Archive"];									
	UIImage *archiveImage = [UIImage imageNamed:@"33-cabinet.png"];	
	[tabBarItem setImage:archiveImage];
    
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
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

- (void)dealloc{
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning at MyFoldersViewController");
    // Release any cached data, images, etc that aren't in use.
}

#pragma -
#pragma Navigation Controls and Actions


#pragma -

@end


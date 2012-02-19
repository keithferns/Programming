//
//  FoldersDetailViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoldersDetailViewController.h"
#import "FoldersTableViewController.h"
#import "UINavigationController+NavControllerCategory.h"

@implementation FoldersDetailViewController

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // get navBar title from item at the selected row.
    
    self.navigationItem.rightBarButtonItem = [self.navigationController addOrganizeButton];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

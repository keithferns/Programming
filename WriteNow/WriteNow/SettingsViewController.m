//
//  SettingsViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (void)dealloc
{
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
    
    
    self.title = @"Settings";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    UITableView *tempTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 320, 180) style:UITableViewStylePlain];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 30)];
    [headerLabel setBackgroundColor:[UIColor lightGrayColor]];
    [headerLabel setText:@"MY STUFF"];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [headerView addSubview:headerLabel];
    [tempTableView setTableHeaderView:headerView];
    //[tableView setSectionFooterHeight:0.0];
    //[tableView setSectionHeaderHeight:15.0];
    [tempTableView setRowHeight:40];
    //[tempTableView setDelegate:self];
    //[tempTableView setDataSource:self];
    [self.view addSubview:tempTableView];
    
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

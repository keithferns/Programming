//
//  MainViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WriteNowAppDelegate.h"

#import "MainViewController.h"

#import "CurrentViewController.h"
#import "CalendarViewController.h"
#import "FoldersViewController.h"
#import "FilesViewController.h"
#import "SettingsViewController.h"


@implementation MainViewController

@synthesize navigationController;
@synthesize managedObjectContext;

- (void)dealloc
{
    [super dealloc];
    [navigationController release];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];

    
}
#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    NSLog(@"MainViewController MOC: %@", managedObjectContext);

    
                        NSLog(@"Main View Did Load: %@", self.tabBarItem.title);
                        if(self.tabBarItem.title == @"Today") {
                            NSLog(@"viewController1");
                CurrentViewController *currentViewController = [[CurrentViewController alloc] init];
                            [self pushViewController:currentViewController animated:YES];
                            [currentViewController release];
                        
                        } else if (self.tabBarItem.title == @"Calendar") {	
                            NSLog(@"viewController2");
                            CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
                            [self pushViewController:calendarViewController animated:YES];
                            [calendarViewController release];
                        } else if (self.tabBarItem.title == @"Archive") {	
                            NSLog(@"viewController3");
                            FoldersViewController *foldersViewController = [[FoldersViewController alloc] init];
                            [self pushViewController:foldersViewController animated:YES];
                            [foldersViewController release];
                        } else if (self.tabBarItem.title == @"Documents") {	
                            NSLog(@"viewController4");
                            FilesViewController  *filesViewController = [[FilesViewController alloc] init];
                            [self pushViewController:filesViewController animated:YES];
                            [filesViewController release];
                        } else if (self.tabBarItem.title == @"Settings") {	
                            NSLog(@"viewController5");
                            SettingsViewController  *settingsViewController = [[SettingsViewController alloc] init];
                            [self pushViewController:settingsViewController animated:YES];
                            [settingsViewController release];
                        }
    [navigationController.navigationBar setHidden:YES];
    [self.navigationBar setHidden:YES];
    
   /* 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    */
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end



/* SEGMENTED CONTROL
 NSArray * segControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"documents_folder_white.png"], [UIImage imageNamed:@"documents_white_small.png"], [UIImage imageNamed:@"documents.png"], nil];
 UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:segControlItems];
 segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
 [segmentControl setTintColor:[UIColor blueColor]];
 [segmentControl setBackgroundColor:[UIColor blueColor]];
 segmentControl.momentary = NO;
 segmentControl.frame = CGRectMake (0, 225, 320, 40);
 
 [self.view addSubview:segmentControl];
 */


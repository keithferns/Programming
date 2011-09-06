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
#import "DiaryViewController.h"
#import "SettingsViewController.h"

@implementation MainViewController

@synthesize navigationController;
@synthesize managedObjectContext;

#pragma mark - MEMORY MANAGEMENT
- (void)dealloc
{
    [super dealloc];
    [navigationController release];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.navigationBar setHidden:NO];
    [self.navigationBar setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];

    [self.navigationBar setTranslucent:YES];
    
    NSLog(@"MainViewController MOC: %@", managedObjectContext);
    
    NSLog(@"Main View Did Load: %@", self.tabBarItem.title);
    if(self.tabBarItem.title == @"Today") {
    CurrentViewController *viewController = [[CurrentViewController alloc] init];

    [self pushViewController:viewController animated:YES];
    [viewController release];
    }
    else if (self.tabBarItem.title == @"Calendar") {	
    CalendarViewController *viewController = [[CalendarViewController alloc] init];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Archive") {	
    FoldersViewController *viewController = [[FoldersViewController alloc] init];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Diary") {	
    DiaryViewController  *viewController = [[DiaryViewController alloc] init];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    } 
    else if (self.tabBarItem.title == @"Settings") {	
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    [self pushViewController:viewController animated:YES];
    [viewController release];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end

//[(UITabBarController *)self.parentViewController setSelectedIndex:0];

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
/*
 UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
 UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
 UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
 entryImageView.frame = CGRectMake(12, 0, 300, 130);
 entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 
 UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
 UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
 UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
 imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
 imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 */


//
//  TestViewController.m
//  TestCustomTextView
//
//  Created by Keith Fernandes on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"
	//#import "EditTextView.h"

@implementation TestViewController

@synthesize newTV;

- (IBAction)changeBkColor{

	}


- (void)viewDidLoad {
	
		//		[newTV setBackgroundColor:[UIColor blueColor]];
		//	if (/*[newTV hasText])*/[newTV isFirstResponder]) {
		//	[newTV setBackgroundColor:[UIColor whiteColor]];}
	
		//SaveMemoViewController *savememoView = [[[SaveMemoViewController alloc] initWithNibName:@"SaveMemoViewController" bundle:nil] autorelease];
	
		//	[self.view addSubview:newTV];
	
    [super viewDidLoad]; 
	 
	 
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[newTV release];
    [super dealloc];
}


@end

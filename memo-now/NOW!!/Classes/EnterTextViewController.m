//
//  EnterTextViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnterTextViewController.h"
#import	"SaveMemoViewController.h"

@implementation EnterTextViewController

@synthesize savememoButton;
@synthesize gotowallButton;
@synthesize newmemoButton;
@synthesize memotitleLabel;
@synthesize editmemoTextView;

- (IBAction)savememoAction:(id)sender{
	SaveMemoViewController *savememoView = [[[SaveMemoViewController alloc] initWithNibName:@"SaveMemoViewController" bundle:nil] autorelease];
	[self presentModalViewController:savememoView animated:YES];
	
}

- (IBAction)gotowallAction:(id)sender{
}

- (IBAction)newmemoAction:(id)sender{
}


/* 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	 return YES; 
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	[savememoButton release];
	[newmemoButton release];
	[gotowallButton release];
	[memotitleLabel release];
	[editmemoTextView release]; 
    [super dealloc];
}


@end

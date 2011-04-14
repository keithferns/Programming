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

	//@synthesize saveButton;
	//@synthesize wallButton;
	//@synthesize newButton;
	//@synthesize memotitleLabel;
@synthesize editmemoTextView;
@synthesize reeditmemoTextView;


- (IBAction)savememoAction:(id)sender{
	
	SaveMemoViewController *savememoView = [[[SaveMemoViewController alloc] initWithNibName:@"SaveMemoViewController" bundle:nil] autorelease];
	[self presentModalViewController:savememoView animated:YES];
	
}

- (IBAction)gotowallAction:(id)sender{
}

- (IBAction)newmemoAction:(id)sender{
}

- (IBAction)movebottomTextView:(id)sender{

	
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

- (void)viewDidLoad {
/*	
	saveButton = [NavButton buttonWithType:UIButtonTypeCustom];
	[saveButton addTarget:self 
			 action:@selector(aMethod:)
	forControlEvents:UIControlEventTouchDown];
	saveButton.frame = CGRectMake(220, 229, 100, 10);
	[saveButton setUserInteractionEnabled:YES];
	[saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[saveButton setHighlighted:YES];
	[saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
	[self.view addSubview:saveButton];
*/			
	
	editmemoTextView = [[EditTextView alloc] initWithFrame:CGRectMake	(0, 0, 320, 205)];
		[editmemoTextView setBackgroundColor:[UIColor blueColor]];
		[editmemoTextView setEditable:YES];
		[reeditmemoTextView setText:@"Start Typing Here..."];

	reeditmemoTextView = [[EditTextView alloc] initWithFrame:CGRectMake	(0, 245, 320, 215)];
		[reeditmemoTextView setBackgroundColor:[UIColor greenColor]];
		[reeditmemoTextView setEditable:YES];
		[reeditmemoTextView setText:@"This is my last memo. "];
		[reeditmemoTextView setUserInteractionEnabled:YES];
		//		[reeditmemoTextView setInputView:reeditmemoTextView];
		//[reeditmemoTextView.inputView addTarget:self
		//					   action:@selector(touchesForView:)
		//				forControlEvents:UIControlEventAllEvents];
		
	
NSLog(@"adding editmemoTextView to view");
		[self.view	addSubview:editmemoTextView];	
NSLog(@"adding reeditmemoTextView to view");
		[self.view	addSubview:reeditmemoTextView];

	
		//NSLog(@"topframe_start - %@", NSStringFromRect([editmemoTextView frame]));
		//NSLog(@"bottonframe_start - %@", NSStringFromRect([reeditmemoTextView frame]));
	

	
	if ([reeditmemoTextView.inputView  isUserInteractionEnabled]) {
		NSLog(@"I am inside while loop");

		[reeditmemoTextView becomeFirstResponder];
			//		if([editmemoTextView isFirstResponder]) {
		
		editmemoTextView.text = reeditmemoTextView.text; 
		[editmemoTextView setBackgroundColor:[UIColor lightGrayColor]];
		[reeditmemoTextView setFont:[UIFont boldSystemFontOfSize:30.0]];
		[reeditmemoTextView setEditable:YES];
			//[self.view addSubview:reeditmemoTextView];
		
	}
	
	
			

				
	
	[super viewDidLoad];
	
		//NSLog(@"topframe_finish - %@", NSStringFromRect([editmemoTextView frame]));
		//NSLog(@"bottomframe_finish - %@", NSStringFromRect([reeditmemoTextView frame]));
	
	
}
			//[reeditmemoTextView [setFrame:(CGRectMake(0, 0, 320, 215)]];
			
			//editmemoTextView.frame = CGRectOffset(editmemoTextView.frame, 222, 107);

							

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
	[saveButton release];
	[newButton release];
	[wallButton release];
		//	[memotitleLabel release];
	[editmemoTextView release]; 
	[reeditmemoTextView release]; 

    [super dealloc];
}


@end

    //
//  MemoDetailViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoDetailViewController.h"
#import "MemoTableViewController.h"

@implementation MemoDetailViewController

@synthesize memoTextView, creationDateView;
@synthesize selectedMemo;
@synthesize managedObjectContext;

- (IBAction) backToTable{
	
[self dismissModalViewControllerAnimated:YES];	
	
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:managedObjectContextSavedNotification object:nil];
	selectedMemo.memoText.memoText = memoTextView.text;
	NSLog(@"After Editing the text is %@", selectedMemo.memoText.memoText);
	
	NSError *error;
	if(![managedObjectContext save:&error]){
	}
	
}

-(IBAction) saveSelectedMemo{
	
	[self.view endEditing:YES];
			
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (managedObjectContext == nil) 
	{ 
		managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy h:mm a"];
	}	
	[creationDateView setText: [dateFormatter stringFromDate:[selectedMemo creationDate]]];		
	[memoTextView setText:[NSString stringWithFormat:@"%@", selectedMemo.memoText.memoText]];	
	NSLog(@"Heh.");
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
	[creationDateView release];
	[memoTextView release];
}


@end

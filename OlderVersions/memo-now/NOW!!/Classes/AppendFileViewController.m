    //
//  AppendFileViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppendFileViewController.h"
#import "NOW__AppDelegate.h"


@implementation AppendFileViewController


@synthesize topView, bottomView, searchBar, tableViewController;
@synthesize fileArray, managedObjectContext;


#pragma mark -
#pragma mark Navigation


-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
/*FIX: the BACK button should return the user to the current memo; the NEW button should return the user to a blank memo page; the GOTO button should raise the GOTO action sheet */			
		case 1:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 2:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 3:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		default:
			break;
	}
}
	

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"added an instance of topView and bottomView to view");
	[self.bottomView addSubview:tableViewController.tableView];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(NOW__AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	[self fetchFileRecords];	
}

-(void) fetchFileRecords{NSLog(@"Going to fetch Memo records now");
	NSEntityDescription *aFile = [NSEntityDescription entityForName:@"File" inManagedObjectContext:managedObjectContext];
		//setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:aFile];
		//defines how to sort the records
	NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"fileName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];//note: if adding other sortdescriptors, then use method -arraywithObjects. If the fetch request must meet some conditions, then use the NSPredicate class 
	[request setSortDescriptors:sortDescriptors];
	[sortByName release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
			//
	}
	[self setFileArray:mutableFetchResults];//save fetched data to an array
	[mutableFetchResults release];
	[request release];	
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
		//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
		//When the user taps inside the search bar, the new subview is set to blue background and the tableView is added to it. 
	[myNewView setBackgroundColor:[UIColor blueColor]];
	[self.view addSubview:myNewView];
	[myNewView addSubview:tableViewController.tableView];	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
	[tableViewController release];
	[fileArray release];
	[searchBar release];
	[topView release];
	[bottomView release];
    [super dealloc];
}


@end

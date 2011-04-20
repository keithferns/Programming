//
//  MyMemosTableViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMemosTableViewController.h"
#import "NOW__AppDelegate.h"


@implementation MyMemosTableViewController

@synthesize managedObjectContext;
@synthesize memoArray;
	//@synthesize	mymemoView;
	//@synthesize memoTable;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
		if (managedObjectContext == nil) 
		{ 
		managedObjectContext = [(NOW__AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
		}
	self.title = @"All Memos";

	
	[self fetchMemoRecords];
	
		//[self.tableView reloadData];  
		// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) fetchMemoRecords{
	
		//defining table to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
	
		//setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
		//defines how to sort the records
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];//note: if adding other sortdescriptors, then use  method -arraywithObjects. If the fetch request must meet some conditions, then use the NSPredicate class 
															
	[request setSortDescriptors:sortDescriptors];
	[sortByDate release];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

	if (!mutableFetchResults) {
		
	}
	
		//save fetched data to an array
	[self setMemoArray:mutableFetchResults];
	
	[mutableFetchResults release];
	[request release];
	
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	 return YES;
 }



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [memoArray count];
	
}

// Customizes the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm.ss a"];
	}
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	Memo *newMemo = [memoArray objectAtIndex:[indexPath row]];
		//Memo *previousMemo = nil;
	
	if ([memoArray count] > ([indexPath row] + 1)) {
			//previousMemo = [memoArray objectAtIndex:([indexPath row] + 1)];
	}
	[cell.textLabel setText: [dateFormatter stringFromDate:[newMemo timeStamp]]];
	[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@,", newMemo.Text]];
		//if (previousMemo) {
		//NSTimeInterval timeDifference = [[newMemo timeStamp] timeIntervalSinceDate: [previousMemo timeStamp]];
		//[cell.detailTextLabel setText: [NSString stringWithFormat:@"+%.02f sec", timeDifference]];
		

		//} else{
		

		//[cell.detailTextLabel setText:@"---"];
		//}
	
    // Configure the cell...    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[managedObjectContext release];
	[memoArray release];
    [super dealloc];
}


@end


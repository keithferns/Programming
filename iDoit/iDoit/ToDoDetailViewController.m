//
//  ToDoDetailViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToDoDetailViewController.h"
#import "CustomTextView.h"


@interface ToDoDetailViewController ()

@end

@implementation ToDoDetailViewController

@synthesize theItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog (@"ToDoDetailViewController:viewDidLoad -> loading");
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    
    UITextField *headerText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 140, 24)];
    // headerText.delegate = self;
    headerText.borderStyle = UITextBorderStyleNone;
    headerText.backgroundColor = [UIColor clearColor];
    headerText.placeholder = @"Title";
    [headerText setFont:[UIFont systemFontOfSize:20]];
    headerText.textColor = [UIColor whiteColor];
    headerText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    headerText.textAlignment = UITextAlignmentCenter;
    headerText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.navigationItem.titleView = headerText;
    [headerText release];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0://Date
            rows = 1;
            break;
        case 1: //Recurring
            rows = 1;
            break;
        case 2: //Alarms
            rows = 4;
            break;
        case 3: //Tags
            rows = 1;
        default:
            break;
    }
    
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result;
    switch (indexPath.section)
    {
        case 0:
            result = 40;
            break;
        case 1:
            result = 100;
            break;
        case 2: 
            result = 22;
            break;
        case 3:
            result = 22;
            break;
        default:
            break;
    }
    return result;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat hHeight;
    
    if (section == 1) {
        hHeight = 0.0;
    }
    else {
        hHeight = 0.0;
    }
    return hHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat fHeight;
    
    fHeight = 0.0;
    
    return fHeight;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {   
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        
        UILabel *labeldate = [[UILabel alloc] initWithFrame:CGRectMake (5,0,50,18)];
        labeldate.text = @"Date";
        labeldate.enabled = NO;
        [cell.contentView addSubview:labeldate];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame: CGRectMake (60,0,220,18)];
        dateLabel.text = [dateFormatter stringFromDate:theItem.theToDo.aDate];
        [cell.contentView addSubview:dateLabel];
        
        [labeldate release];
        [dateLabel release];
        [dateFormatter setDateFormat: @"h:mm a"];
     
        UILabel *labelplace = [[UILabel alloc] initWithFrame:CGRectMake (5,20,50,18)];
        labelplace.text = @"Place:";
        labelplace.enabled = NO;
        [cell.contentView addSubview:labelplace];
        
        UILabel *placeLabel = [[UILabel alloc] initWithFrame: CGRectMake (60,20,80,18)];
        //placeLabel.text = [dateFormatter stringFromDate:theItem.theToDo.aPlace];
        [cell.contentView addSubview:placeLabel];
        
        [labelplace release];
        [placeLabel release];
        
        UILabel *labelrepeat = [[UILabel alloc] initWithFrame:CGRectMake (140,20,50,18)];
        labelrepeat.text = @"Repeats:";
        labelrepeat.enabled = NO;
        [cell.contentView addSubview:labelrepeat];
        
        UILabel *repeatLabel = [[UILabel alloc] initWithFrame: CGRectMake (195,20,80,18)];
        //repeatLabel.text = [dateFormatter stringFromDate:theItem.theToDo.recur];
        [cell.contentView addSubview:repeatLabel];
        [labelrepeat release];
        [repeatLabel release];
        
        
        
        [dateFormatter release];
        
        
    }
    else if (indexPath.section == 1){
        CustomTextView *theTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(0,0,300,105)];
        theTextView.editable = NO;
        
        [theTextView setText:[[theItem.theToDo.rNote anyObject] text]];
        theTextView.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(14.0)];
        
        [cell.contentView addSubview: theTextView];
        
        [theTextView release];
        
    }
    else if (indexPath.section == 2){
        UILabel *labelalarm = [[UILabel alloc] initWithFrame:CGRectMake (5,0,50,18)];
        labelalarm.text = @"Alarm";
        labelalarm.enabled = NO;
        [cell.contentView addSubview:labelalarm];
        
        UILabel *alarmLabel = [[UILabel alloc] initWithFrame: CGRectMake (60,0,220,18)];
        //NSString *temp = [NSString stringWithFormat:@"%@, %@, %@, %@", theItem.theMemo.rTag etc
        [cell.contentView addSubview:alarmLabel];
        
        [labelalarm release];
        [alarmLabel release];
        
    }
    else if (indexPath.section == 3){
        UILabel *labeltag = [[UILabel alloc] initWithFrame:CGRectMake (5,0,50,18)];
        labeltag.text = @"Tags";
        labeltag.enabled = NO;
        [cell.contentView addSubview:labeltag];
        
        UILabel *tagLabel = [[UILabel alloc] initWithFrame: CGRectMake (60,0,220,18)];
        //NSString *temp = [NSString stringWithFormat:@"%@, %@, %@, %@", theItem.theMemo.rTag etc
        [cell.contentView addSubview:tagLabel];
        
        [labeltag release];
        [tagLabel release];
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end

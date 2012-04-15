//
//  MemoDetailViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemoDetailViewController.h"
#import "CustomTextView.h"

@interface MemoDetailViewController ()

@end

@implementation MemoDetailViewController

@synthesize theItem;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog (@"MemoDetailViewController:viewDidLoad -> loading");
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    [tableHeaderView setBackgroundColor:[UIColor blackColor]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY h::mm a"];   
    
        UILabel *dateplaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,2,280,18)];
        dateplaceLabel.backgroundColor = [UIColor blackColor];
        dateplaceLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(12.0)];
        dateplaceLabel.textColor = [UIColor whiteColor];
        NSString *date = [dateFormatter stringFromDate:theItem.theMemo.creationDate];
        dateplaceLabel.textAlignment = UITextAlignmentRight;
        NSString *temp = [NSString stringWithFormat:@"%@ at Some Place", date];
        dateplaceLabel.text = temp;
        //FIXME: add the key theItem.theMemo.aPlace
        [tableHeaderView addSubview: dateplaceLabel];
    
    [dateplaceLabel release];
    [dateFormatter release];
    
        
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];        
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //MEMO SECTION: Text and Time/Place
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    //Memo has 3 sections
    switch (section) {
        case 0:// Text
            rows = 1;
            break;
        case 1://Folder/File
            rows = 1;
            break;
        case 2: //tags
            rows = 1;
            break;

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
            result = 100;
            break;
        case 1:
            result = 22;
            break;
        case 2: 
            result = 22;
            break;

        default:
            break;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat hHeight;
    
    if (section == 3) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    

     if (indexPath.section == 0){
        CustomTextView *theTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(0,0,300,105)];
        theTextView.editable = NO;
        
        [theTextView setText:[[theItem.theMemo.rNote anyObject] text]];
        theTextView.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:(14.0)];
        
        [cell.contentView addSubview: theTextView];
        
        [theTextView release];
        
    }
    else if (indexPath.section == 1){
        UILabel *labelfolder = [[UILabel alloc] initWithFrame:CGRectMake (5,0,50,18)];
        labelfolder.text = @"Folder";
        labelfolder.enabled = NO;
        [cell.contentView addSubview:labelfolder];
        
        UILabel *folderLabel = [[UILabel alloc] initWithFrame: CGRectMake (60,0,220,18)];
        //NSString *temp = [NSString stringWithFormat:@"%@", theItem.theMemo.rFolder etc
        [cell.contentView addSubview:folderLabel];

        folderLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];

        
        [labelfolder release];
        [folderLabel release];        
        
    }
    else if (indexPath.section == 2){
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

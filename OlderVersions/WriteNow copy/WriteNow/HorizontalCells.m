//
//  HorizontalCells.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HorizontalCells.h"
#import "CustomTextLabel.h"
#import "ControlVariables.h"
#import "EventsCell.h"
#import "WriteNowAppDelegate.h"
#import "TasksTableViewController.h"
#import "AppointmentsTableViewController.h"
#import "StartScreenCustomCell.h"

@implementation HorizontalCells

@synthesize hTableView = _hTableView;
@synthesize myObjects;


- (void) dealloc{
    self.hTableView = nil;
    myObjects = nil;
    [self.hTableView release];
    [myObjects release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {

   if ((self = [super initWithFrame:frame])){
        self.hTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kScreenWidth)] autorelease];
        self.hTableView.showsVerticalScrollIndicator = NO;
        self.hTableView.showsHorizontalScrollIndicator = NO;
        self.hTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.hTableView setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kScreenWidth - kRowHorizontalPadding, kCellHeight)];
        self.hTableView.rowHeight = kCellWidth;
        self.hTableView.backgroundColor = [UIColor blackColor];        
        self.hTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.hTableView.separatorColor = [UIColor clearColor];
        self.hTableView.dataSource = self;
        self.hTableView.delegate = self;
        [self addSubview:self.hTableView];
     }
    return self;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows;
    numberOfRows = [myObjects count];
    return numberOfRows;
}

- (NSString *) reuseIdentifier{
    return @"HorizontalCell";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"EventsCell";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    EventsCell *cell = (EventsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[EventsCell alloc] init]autorelease];
    }
    if ([[myObjects objectAtIndex:0] isKindOfClass:[Appointment class]]) {
        Appointment *currentAppointment = [myObjects objectAtIndex:indexPath.row];
        CGSize itemSize=CGSizeMake(kCellWidth,kCellHeight-20);
        UIGraphicsBeginImageContext(itemSize);
        [currentAppointment.text drawInRect:CGRectMake(0, 0, itemSize.width, itemSize.height) withFont:[UIFont boldSystemFontOfSize:10]];
        UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.myTextView.image = theImage;
       // cell.myTextLabel.text = currentAppointment.text;
        cell.dateLabel.text = [dateFormatter stringFromDate:currentAppointment.doDate];
    }
    else if ([[myObjects objectAtIndex:0] isKindOfClass:[Task class]]) {
        Task *currentTask = [myObjects objectAtIndex:indexPath.row];
        CGSize itemSize=CGSizeMake(kCellWidth-4, kCellHeight-17);
        UIGraphicsBeginImageContext(itemSize);
        [currentTask.text drawInRect:CGRectMake(0, 0, itemSize.width, itemSize.height) withFont:[UIFont boldSystemFontOfSize:10]];
        UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.myTextView.image = theImage;
        //cell.myTextLabel.text = currentTask.text;
        cell.dateLabel.text = [dateFormatter stringFromDate:currentTask.doDate];
    }
    else if ([[myObjects objectAtIndex:0] isKindOfClass:[Memo class]]){
        Memo *currentMemo = [myObjects objectAtIndex:indexPath.row];
        CGSize itemSize=CGSizeMake(kCellWidth-4, kCellHeight-25);
        UIGraphicsBeginImageContext(itemSize);
        [currentMemo.text drawInRect:CGRectMake(0, 0, itemSize.width, itemSize.height) withFont:[UIFont boldSystemFontOfSize:10]];
        UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.myTextView.image = theImage;
        //cell.myTextLabel.text = currentMemo.text;
        cell.dateLabel.text = [dateFormatter stringFromDate:currentMemo.doDate];
    }
    [dateFormatter release];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *myIndexPath = [tableView indexPathForSelectedRow];
    NSLog(@"Selected Row is %i", [myIndexPath row]);
    NSLog(@"Selected Section is %i", [myIndexPath section]);
    
    id *selectedObject = (id *) [myObjects objectAtIndex:indexPath.row];
    if ([(id)selectedObject isKindOfClass:[Appointment class]]) {
        NSLog(@"HUZZAH");
    }    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:(id)selectedObject];

    if ([[myObjects objectAtIndex:indexPath.row] isKindOfClass:[Appointment class]]) {
        NSLog(@"Object is Appointment");
        Appointment *tempAppointment  =  [myObjects objectAtIndex:indexPath.row];
        NSLog(@"My Appointment Text is %@", tempAppointment.text);
    }
    else if ([[myObjects objectAtIndex:indexPath.row] isKindOfClass:[Task class]]){
        NSLog(@"Object is Task");
        //Task *tempTask = [myObjects objectAtIndex:indexPath.row];
        
    }
    else{
        NSLog(@"Object is Memo");
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:[self.fetchedResultsController objectAtIndexPath:indexPath ]];   
    }
    
    
}

@end
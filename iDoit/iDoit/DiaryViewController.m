//
//  DiaryViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//NOTE: IN FUTURE UPDATE THIS WILL HAVE A PAGING SCROLL VIEW TO MOVE BETWEEN PAGES OF THE DIARY. CURRENT VERSION HAS ALL SCROLLVIEW RELATED CODE COMMENTED OUT

#import "DiaryViewController.h"
#import "Contants.h"
#import "DiaryTableViewController.h"
#import "UINavigationController+NavControllerCategory.h"


@interface DiaryViewController ()

@property (nonatomic, retain) DiaryTableViewController *currentTableViewController;
//@property (nonatomic, retain) DiaryTableViewController  *nextTableViewController;


- (void) loadCurrentDate;

@end

@implementation DiaryViewController


//@synthesize scrollView;
//@synthesize pageControl;
//@synthesize nextTableViewController;

@synthesize currentTableViewController;
@synthesize dateCounter;
@synthesize datelabel;
@synthesize calendarView;

- (void) loadCurrentDate{
    return;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    //scrollView = nil;
    //pageControl = nil;
    //nextTableViewController = nil;
    
    currentTableViewController  = nil;
    datelabel = nil;
    calendarView = nil;
}

- (void) dealloc{
    [super dealloc];
    [currentTableViewController release];
    [calendarView release];
    
    //[scrollView release];
    //[pageControl release];
    //[nextTableViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    dateCounter = 0;
    [super viewDidLoad];
    
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE, MMMM dd"];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    dateLabel.text = [dateformatter stringFromDate:[NSDate date]];
    [dateformatter release];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = dateLabel;
    
    //Navigation Bar SetUP    
    
    NSArray *items = [NSArray arrayWithObjects:@"Today", [UIImage imageNamed:@"Calendar-Month-30x30.png"], nil];
    UISegmentedControl *diaryControl = [[UISegmentedControl alloc] initWithItems:items];
    [diaryControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [diaryControl setWidth:90 forSegmentAtIndex:0];
    [diaryControl setWidth:90 forSegmentAtIndex:1];
    [diaryControl setSelectedSegmentIndex:0];
    [diaryControl addTarget:self
                         action:@selector(toggleTodayCalendarView:)
               forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = diaryControl;
    [diaryControl release];
    
    self.navigationItem.leftBarButtonItem = [self.navigationController addLeftArrowButton];
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.tag = 1;

    self.navigationItem.rightBarButtonItem = [self.navigationController addRightArrowButton];
    self.navigationItem.rightBarButtonItem.tag = 2;
    self.navigationItem.rightBarButtonItem.target = self;
    /*
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight)];
    scrollView.contentSize = CGSizeMake( scrollView.frame.size.width * 3,scrollView.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, 0);    
    [scrollView setDelegate:self];
    //[scrollView setPagingEnabled:YES];
    [self.view addSubview:scrollView];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:1];
     // nextTableViewController = [[DiaryTableViewController alloc] init];     
     //[self.scrollView addSubview:nextTableViewController.tableView];
    */
    
    currentTableViewController = [[DiaryTableViewController alloc] init];
    currentTableViewController.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight);

    [self.view addSubview:currentTableViewController.tableView];
}

- (void) toggleTodayCalendarView:(id) sender{
    
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    NSLog(@"DiaryViewController:toggleTodayCalendarView -> Segment %d touched", segControl.selectedSegmentIndex);
    
	
	switch (segControl.selectedSegmentIndex) {
		case 0:
            NSLog(@"DiaryViewController:toggleTodayCalendarView -> Switching to Today View");
            dateCounter = 0;
            [self postSelectedDateNotification:nil];
            
            [self moveCalendarDown];
            
			break;
        case 1:
            NSLog(@"DiaryViewController:toggleTodayCalendarView  -> Switching to Calendar View");	            
            if (calendarView == nil) {
                
                calendarView = 	[[TKCalendarMonthView alloc] init];        
                calendarView.delegate = self;
                [self.view addSubview:calendarView];
                [calendarView reload];
                calendarView.frame = CGRectMake(0, -calendarView.frame.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
                //calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelegate:self];
                
                calendarView.frame = CGRectMake(0, kNavBarHeight, calendarView.frame.size.width, calendarView.frame.size.height);
                
                [UIView commitAnimations];
            }
            break;
	}
}

- (void) moveCalendarDown{
    
    if (calendarView.superview != nil) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(finishedMovingCalendar)];
        
        calendarView.frame = CGRectMake(0, -calendarView.frame.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void) finishedMovingCalendar{
    
    if (calendarView !=nil) {
        
        calendarView = nil;
    }
}


#pragma mark - TKCalendarMonthViewDelegate methods
- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"calendarMonthView didSelectDate: %@", d);
    
    [self moveCalendarDown];
    
}
- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");	
//
}

- (void) postSelectedDateNotification:(id) sender{
    
    NSLog(@"DiaryViewController:postDateNotification -> posting dateNotification");
    // if nil then post current date. 
    //if left arrow selected add
    if ([sender tag] ==2 && dateCounter >= 0){
        //right arrow does nothing
        return;
    } else if ([sender tag] == 1){
        NSLog(@"decrement dateCounter by 1");
        
            --dateCounter;
        }else if ([sender tag] == 2){
        NSLog(@"increment dateCounter by 1");
            ++dateCounter;
        }
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    [gregorian setLocale:[NSLocale currentLocale]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //FIXME: Better way of setting the current timezone as the default and not as xx hours from GMT
    NSDateComponents *addDay = [[[NSDateComponents alloc] init] autorelease];
    addDay.day = dateCounter;
    NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];    
    [timeComponents setYear:[timeComponents year]];
    [timeComponents setMonth:[timeComponents month]];
    [timeComponents setDay:[timeComponents day]];
    
    NSDate *currentDate= [gregorian dateFromComponents:timeComponents];
    
    NSDate *selectedDate = [gregorian dateByAddingComponents:addDay toDate:currentDate options:0];
    NSLog(@"Current Date is %@", currentDate);
    NSLog(@"Selected Date is %@",selectedDate);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetSelectedDateNotification" object:selectedDate userInfo:nil];   
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE, MMMM dd"];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    dateLabel.text = [dateformatter stringFromDate:selectedDate];
    [dateformatter release];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = UITextAlignmentCenter;
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

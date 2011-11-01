//
//  HorizontalCells.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HorizontalCells.h"
#import "ControlVariables.h"
#import "EventsCell.h"

@implementation HorizontalCells

@synthesize horizontalTableView = _horizontalTableView;


- (void) dealloc{
    self.horizontalTableView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
   if ((self = [super initWithFrame:frame]))
        {

        //self.horizontalTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kScreenWidth)] autorelease];
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.horizontalTableView setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kScreenWidth - kRowHorizontalPadding, kCellHeight)];
        
        self.horizontalTableView.rowHeight = kCellWidth;
        self.horizontalTableView.backgroundColor = kHorizontalTableBackgroundColor;
        
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.horizontalTableView.separatorColor = [UIColor clearColor];
        
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
        [self addSubview:self.horizontalTableView];
     }
    
    return self;
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    return numberOfRows;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    static NSString * cellIdentifier = @"EventsCell";
    EventsCell *cell = (EventsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if ([myObject isKindOfClass:[Appointment class]]) {
        Appointment *currentAppointment = [[Appointment alloc]init];
        currentAppointment = (Appointment *) myObject;
        cell.textLabel.text = currentAppointment.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        cell.dateLabel.text = [dateFormatter stringFromDate:currentAppointment.doDate];
    }
    
    
    return cell;
}

- (NSString *) reuseIdentifier{
    return @"HorizontalCells";
}



@end

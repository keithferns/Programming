//
//  EventsCell.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsCell.h"
#import "ControlVariables.h"


@implementation EventsCell

@synthesize dateLabel;
//@synthesize myTextLabel = _myTextLabel;
@synthesize myTextView = _myTextView;
- (void)dealloc {    
    self.myTextView = nil;
    self.dateLabel = nil;
    [self.myTextView release];
    [self.dateLabel release];
    [super dealloc];
}

- (NSString *)reuseIdentifier{
    return @"EventsCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_line_page_background.png"]];
        backgroundImage.frame = CGRectMake(1, 1, kCellWidth-2, kCellHeight-2);
        self.backgroundView = backgroundImage;
        self.backgroundView.backgroundColor = [UIColor blackColor];
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCellWidth-2, 20)] autorelease];
        dateLabel.backgroundColor = [UIColor clearColor];
        //dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.textColor = [UIColor blueColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:9];
        dateLabel.numberOfLines = 1;
        dateLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:dateLabel];
        /*
        self.myTextLabel= [[CustomTextLabel alloc]initWithFrame:CGRectMake(0, 15, kCellWidth, 60)];
        [self.myTextLabel setFont:[UIFont systemFontOfSize:12]];
        //[self.myTextLabel setAdjustsFontSizeToFitWidth:YES];
        //self.bounds = CGRectMake(0, -5, kCellHeight, 70);
        [self.myTextLabel setTextAlignment:UITextAlignmentLeft];
        self.myTextLabel.backgroundColor = [UIColor clearColor];
        self.myTextLabel.textColor = [UIColor blackColor];
        self.myTextLabel.numberOfLines = 4;
        [self.contentView addSubview:self.myTextLabel];
        */
        self.myTextView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 15, kCellWidth-4, kCellHeight-17)];
        [self.contentView addSubview:self.myTextView];
        self.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }
    return self;    
}

@end


/*
 - (id)initWithFrame:(CGRect)frame
 {
 
 self = [super initWithFrame:frame];
 
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
 label.backgroundColor = [UIColor greenColor];
 [self.contentView addSubview:label];
 
 myTextLabel = [[[UILabel alloc] init] autorelease];
 myTextLabel.opaque = YES;
 myTextLabel.backgroundColor = [UIColor colorWithRed:0.5 green:0.4745098 blue:0.29019808 alpha:0.9];
 myTextLabel.textColor = [UIColor blackColor];
 myTextLabel.font = [UIFont boldSystemFontOfSize:9];
 myTextLabel.numberOfLines = 4;
 
 myTextLabel.text = myTextLabel;
 
 UILabel *dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 48, 54, 10)] autorelease];
 dateLabel.opaque = YES;
 dateLabel.backgroundColor = [UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9];
 dateLabel.textColor = [UIColor whiteColor];
 dateLabel.font = [UIFont boldSystemFontOfSize:9];
 dateLabel.numberOfLines = 1;
 dateLabel.text = self.date;
 [self.contentView addSubview:dateLabel];
 
 //self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
 //self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
 
 self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
 
 
 return self;
 }
 */


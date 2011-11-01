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

@synthesize textLabel, dateLabel;

- (void)dealloc {
    
    self.textLabel = nil;
    self.dateLabel = nil;
    
    [super dealloc];
}

- (NSString *)reuseIdentifier{
    return @"EventsCell";
}

- (id)initWithFrame:(CGRect)frame
{
    [super initWithFrame:frame];
    
    self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2)] autorelease];
    self.textLabel.opaque = YES;
	self.textLabel.backgroundColor = [UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:9];
    self.textLabel.numberOfLines = 4;
    
    [self.contentView addSubview:self.textLabel];
    
    self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.textLabel.frame.size.height, self.textLabel.frame.size.width, self.textLabel.frame.size.height * 0.37)] autorelease];
    self.dateLabel.opaque = YES;
	self.dateLabel.backgroundColor = [UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:9];
    self.dateLabel.numberOfLines = 1;
    [self.contentView addSubview:self.dateLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
    self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    return self;
}


@end

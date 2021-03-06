//
//  AppointmentCustomCell.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentCustomCell.h"


@implementation AppointmentCustomCell

@synthesize textLabel, startTimeLabel, endTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //[self setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 200, 40)];
        [textLabel setMinimumFontSize:10.0];
        [textLabel setAdjustsFontSizeToFitWidth:YES];
        [textLabel setTextAlignment:UITextAlignmentLeft];
        [textLabel setBounds:CGRectMake(5, 0, textLabel.frame.size.width, textLabel.frame.size.height)];//???
        
        startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        [startTimeLabel setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.2]];
        [startTimeLabel setMinimumFontSize:10.0];
        [startTimeLabel setAdjustsFontSizeToFitWidth:YES];
       
        endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
        [endTimeLabel setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.2]];
        [endTimeLabel setMinimumFontSize:10.0];
        [endTimeLabel setAdjustsFontSizeToFitWidth:YES];

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:startTimeLabel];
        [self.contentView addSubview:endTimeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{   
    textLabel = nil;
    startTimeLabel = nil;
    endTimeLabel = nil;
    [super dealloc];
}

@end

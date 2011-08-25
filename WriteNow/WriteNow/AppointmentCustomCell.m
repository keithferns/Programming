//
//  AppointmentCustomCell.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentCustomCell.h"


@implementation AppointmentCustomCell

@synthesize textLabel, timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
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
    [super dealloc];
}

@end

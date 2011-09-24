//
//  TaskCustomCell.m
//  miMemo
//
//  Created by Keith Fernandes on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskCustomCell.h"


@implementation TaskCustomCell

@synthesize memoTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
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
    //[memoTextLabel release];
    //[doDateLabel release];
}

@end

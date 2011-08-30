//
//  ContainerView.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
        
        //[containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
           }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end

//
//  CustomTextView.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.showsVerticalScrollIndicator = YES;
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [self.layer setCornerRadius:10.0];
        [self setFont:[UIFont boldSystemFontOfSize:15]];
        //textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
        //textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
        //textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage; 
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

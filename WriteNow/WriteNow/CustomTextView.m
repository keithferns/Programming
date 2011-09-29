//  CustomTextView.m
//  WriteNow
//  Created by Keith Fernandes on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //UIImage *patternImage = [UIImage imageNamed:@"54700.png"];
        UIImage *patternImage = [UIImage imageNamed:@"underPageBackground.png"];

        self.backgroundColor = [UIColor colorWithPatternImage:patternImage];

        self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.showsVerticalScrollIndicator = YES;
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [self.layer setCornerRadius:5.0];
        [self setFont:[UIFont boldSystemFontOfSize:15]];
        //textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
        //textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
        //textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage; 
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

/*--setup the textView for the input text--
 textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 22, 300, 40)];
 textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
 //textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
 [textView.layer setBorderWidth:1.0];
 [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
 [textView.layer setCornerRadius:10.0];
 
 CALayer *shadowSublayer = [CALayer layer];
 [shadowSublayer setShadowOffset:CGSizeMake(0, 3)];
 [shadowSublayer setShadowRadius:5.0];
 [shadowSublayer setShadowColor:[UIColor blackColor].CGColor];
 [shadowSublayer setShadowOpacity:0.8];
 [shadowSublayer setCornerRadius:10.0];
 [shadowSublayer setFrame:CGRectMake(textView.layer.frame.origin.x+5, textView.layer.frame.origin.y+5, textView.frame.size.width-10, textView.frame.size.height-10)];
 [textView.layer addSublayer:shadowSublayer];
 [textView setFont:[UIFont boldSystemFontOfSize:14]];
 [textView setDelegate:self];
 [textView setAlpha:1.0];
 */
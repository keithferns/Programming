//
//  CustomTextField.m
//  WriteNow
//
//  Created by Keith Fernandes on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField.h"


@implementation CustomTextField

- (id)init
{
    self = [super init];
    if (self) {
        //UIImage *patternImage = [UIImage imageNamed:@"underPageBackground.png"];

        UIImage *patternImage = [UIImage imageNamed:@"54700.png"];

        [self setAdjustsFontSizeToFitWidth:YES];
        [self setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
        //[self setBorderStyle:UITextBorderStyleRoundedRect];
        //[self setBackgroundColor:[UIColor clearColor]];
        [self  setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.layer setCornerRadius:5.0];

        [self setDelegate:nil];
        [self setEnabled:YES];
        [self setHidden:NO];

        [self setInputAccessoryView:nil];
        [self setInputView:nil];
        [self setMinimumFontSize:14.0];

        [self setPlaceholder:@"Tap to Type:"];
        [self setTag:0];
        [self setTextColor:[UIColor blackColor]];
        [self setTextAlignment:UITextAlignmentCenter];
        [self setUserInteractionEnabled:YES];
        //[self setBounds:CGRectMake(self.frame.origin.x+2, self.frame.origin.y+2, self.frame.size.width-4,self.frame.size.height-4)];
    }
    return self;

}

- (void)dealloc
{
    [super dealloc];
}

@end


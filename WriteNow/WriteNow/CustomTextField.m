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
        
        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setPlaceholder:@"Tap to Type:"];
        [self setInputView:nil];
        [self setInputAccessoryView:nil];
        [self setDelegate:nil];
        [self setFont:[UIFont systemFontOfSize:13.0]];
        [self setTag:0];
        [self setTextAlignment:UITextAlignmentCenter];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self setEnabled:YES];
        [self setHidden:NO];
        //[self setBounds:CGRectMake(self.frame.origin.x+2, self.frame.origin.y+2, self.frame.size.width-4,self.frame.size.height-4)];
    }
    return self;

}

- (void)dealloc
{
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

//
//  CustomTextLabel.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTextLabel.h"


@implementation CustomTextLabel

- (void) drawTextInRect:(CGRect)rect{
    
    CGFloat textRectWidth = rect.size.width - 4;
    CGFloat textRectHeight = rect.size.height - 4;
    CGRect textRect = CGRectMake(2, 2, textRectWidth, textRectHeight);
    [super drawTextInRect:textRect];
}



@end

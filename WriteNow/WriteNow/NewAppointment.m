//
//  NewAppointment.m
//  WriteNow
//
//  Created by Keith Fernandes on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewAppointment.h"


@implementation NewAppointment

@synthesize delegate;
@synthesize newAppointment;
@synthesize addingContext;//note this MOC is an adding MOC passed from the parent.

- (void) dealloc{
    addingContext = nil;
    newAppointment = nil;
    delegate = nil;
    [addingContext release];
    [newAppointment release];
    [delegate release];
    [super dealloc];
}

- (void) createNewAppointment:(NSString *)text{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
    newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
    newAppointment.creationDate =  [NSDate date];
    newAppointment.type = [NSNumber numberWithInt:1];
    newAppointment.text = text;
    
    NSLog(@"New Appointment Created with Text: %@", newAppointment.text);
    return;
}


- (void) addDateField{
    
    return;
}

- (void) setDoDate{

    return;
}

- (void) updateText:(NSString *) text{
    //if the text is changed since creation of the appointment
    if (text == @"") {
        //put up an alert view.
        return;
    }
    else if (![newAppointment.text isEqualToString:text]){
        newAppointment.text = text;
    }
    return;
}

- (void) saveNewAppointment{
    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"Calendar/Appointments VIEWCONTROLLER MOC: DID NOT SAVE");
    } 
    
}

@end

//
//  NewMemo.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewItemOrEvent.h"


@implementation NewItemOrEvent

@synthesize recurring;
@synthesize delegate;
@synthesize theNote, theAppointment, theMemo, theTask;
@synthesize addingContext;//note this MOC is an adding MOC passed from the parent.

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:addingContext];
    
    theNote = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    theNote.doDate = selectedDate;
    
    [dateComponents setYear:0];
    [dateComponents setMonth:0];
    [dateComponents setDay:0];
    [dateComponents setHour:[dateComponents hour]];
    [dateComponents setMinute:[dateComponents minute]];
    [dateComponents setSecond:[dateComponents second]];
    selectedDate = [calendar dateFromComponents:dateComponents];
    theNote.doTime = selectedDate;
    theNote.endTime = selectedDate;
    
    theNote.text = text;
    theNote.type = type;
    theNote.creationDate = [NSDate date];
    theNote.doTime = [NSDate date];
    theNote.endTime = [NSDate date];    
}

- (void) addDateField{
    
    return;
}

- (void) updateSelectedDate:(NSDate *)date{
    theNote.doDate = date;
    NSLog(@"newNote.doDate is %@", theNote.doDate);
    return;
}

- (void) updateText:(NSString *) text{
    //if the text is changed since creation of the appointment
    if (text == @"") {
        //put up an alert view.
        return;
    }
    else if (![theNote.text isEqualToString:text]){
        theNote.text = text;
    }
    return;
}

- (void) saveNewItem {
    
    if ([theNote.type intValue] == 0) {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:addingContext];
        
        theMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
        theMemo.creationDate =  [NSDate date];
        theMemo.type = theNote.type;
        theMemo.text = theNote.text;
        theMemo.creationDate = theNote.creationDate;
        theMemo.doDate = theNote.doDate;
        theMemo.doTime = theNote.doTime;
        theMemo.endTime = theNote.endTime;
        NSLog(@"NEW MEMO TEXT IS %@", theMemo.text);
        NSLog(@"NEW MEMO Type IS %d", [theMemo.type intValue]);
        NSLog(@"NEW MEMO doDate IS %@", theMemo.doDate);
        NSLog(@"NEW MEMO doTime IS %@", theMemo.doTime);
        NSLog(@"NEW MEMO endTime IS %@", theMemo.endTime);
    }
    
    else if([theNote.type intValue] == 1){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
        theAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];        
        theAppointment.creationDate = theNote.creationDate;
        theAppointment.doDate = theNote.doDate;
        theAppointment.doTime = theNote.doTime;
        theAppointment.endTime = theNote.endTime;
        theAppointment.type = theNote.type;
        theAppointment.text = theNote.text;
        theAppointment.recurring = recurring;
        NSLog(@"NEW APPOINTMENT TEXT IS %@", theAppointment.text);
        NSLog(@"NEW APPOINTMENT Type IS %d", [theAppointment.type intValue]);
        NSLog(@"NEW APPOINTMENT doDate IS %@", theAppointment.doDate);
        NSLog(@"NEW APPOINTMENT doTime IS %@", theAppointment.doTime);
        NSLog(@"NEW APPOINTMENT endTime IS %@", theAppointment.endTime);
        NSLog(@"NEW APPOINTMENT recurring IS %@", theAppointment.recurring);
    }
    
    else {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:addingContext];        
        theTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
       // myTask = (Task *)theNote;
        theTask.creationDate = theNote.creationDate;
        theTask.doDate = theNote.doDate;
        theTask.doTime = theNote.doTime;
        theTask.endTime = theNote.endTime;
        theTask.type = theNote.type;
        theTask.text = theNote.text;
        theTask.recurring = recurring;
        NSLog(@"NEW TASK TEXT IS %@", theTask.text);
        NSLog(@"NEW TASK Type IS %d", [theTask.type intValue]);
        NSLog(@"NEW TASK doDate IS %@", theTask.doDate);
        NSLog(@"NEW TASK doTime IS %@", theTask.doTime);
        NSLog(@"NEW TASK endTime IS %@", theTask.endTime);
        NSLog(@"the TASK recurring IS %@", theTask.recurring);
    }
    [addingContext deleteObject:theNote];
     
    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"NEWITEMOREVENT ADDING MOC: DID NOT SAVE");
    } 
}

- (void) deleteItem:(id)sender{
    [addingContext deleteObject:theNote];
    
}

@end

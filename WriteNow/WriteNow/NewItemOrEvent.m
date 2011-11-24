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
@synthesize newNote, newAppointment, newMemo, newTask;
@synthesize addingContext;//note this MOC is an adding MOC passed from the parent.

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:addingContext];
    
    newNote = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    newNote.doDate = selectedDate;
    
    [dateComponents setYear:0];
    [dateComponents setMonth:0];
    [dateComponents setDay:0];
    [dateComponents setHour:[dateComponents hour]];
    [dateComponents setMinute:[dateComponents minute]];
    [dateComponents setSecond:[dateComponents second]];
    selectedDate = [calendar dateFromComponents:dateComponents];
    newNote.doTime = selectedDate;
    newNote.endTime = selectedDate;
    
    newNote.text = text;
    newNote.type = type;
    newNote.creationDate = [NSDate date];
    newNote.doTime = [NSDate date];
    newNote.endTime = [NSDate date];    
}

- (void) addDateField{
    
    return;
}

- (void) updateSelectedDate:(NSDate *)date{
    newNote.doDate = date;
    NSLog(@"newNote.doDate is %@", newNote.doDate);
    return;
}

- (void) updateText:(NSString *) text{
    //if the text is changed since creation of the appointment
    if (text == @"") {
        //put up an alert view.
        return;
    }
    else if (![newNote.text isEqualToString:text]){
        newNote.text = text;
    }
    return;
}

- (void) saveNewItem {
    
    if ([newNote.type intValue] == 0) {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:addingContext];
        
        newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
        newMemo.creationDate =  [NSDate date];
        newMemo.type = newNote.type;
        newMemo.text = newNote.text;
        newMemo.creationDate = newNote.creationDate;
        newMemo.doDate = newNote.doDate;
        newMemo.doTime = newNote.doTime;
        newMemo.endTime = newNote.endTime;
        NSLog(@"NEW MEMO TEXT IS %@", newMemo.text);
        NSLog(@"NEW MEMO Type IS %d", [newMemo.type intValue]);
        NSLog(@"NEW MEMO doDate IS %@", newMemo.doDate);
        NSLog(@"NEW MEMO doTime IS %@", newMemo.doTime);
        NSLog(@"NEW MEMO endTime IS %@", newMemo.endTime);
    }
    
    else if([newNote.type intValue] == 1){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
        newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];        
        newAppointment.creationDate = newNote.creationDate;
        newAppointment.doDate = newNote.doDate;
        newAppointment.doTime = newNote.doTime;
        newAppointment.endTime = newNote.endTime;
        newAppointment.type = newNote.type;
        newAppointment.text = newNote.text;
        newAppointment.recurring = recurring;
        NSLog(@"NEW APPOINTMENT TEXT IS %@", newAppointment.text);
        NSLog(@"NEW APPOINTMENT Type IS %d", [newAppointment.type intValue]);
        NSLog(@"NEW APPOINTMENT doDate IS %@", newAppointment.doDate);
        NSLog(@"NEW APPOINTMENT doTime IS %@", newAppointment.doTime);
        NSLog(@"NEW APPOINTMENT endTime IS %@", newAppointment.endTime);
        NSLog(@"NEW APPOINTMENT recurring IS %@", newAppointment.recurring);
    }
    
    else {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:addingContext];        
        newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
       // myTask = (Task *)newNote;
        newTask.creationDate = newNote.creationDate;
        newTask.doDate = newNote.doDate;
        newTask.doTime = newNote.doTime;
        newTask.endTime = newNote.endTime;
        newTask.type = newNote.type;
        newTask.text = newNote.text;
        newTask.recurring = recurring;
        NSLog(@"NEW TASK TEXT IS %@", newTask.text);
        NSLog(@"NEW TASK Type IS %d", [newTask.type intValue]);
        NSLog(@"NEW TASK doDate IS %@", newTask.doDate);
        NSLog(@"NEW TASK doTime IS %@", newTask.doTime);
        NSLog(@"NEW TASK endTime IS %@", newTask.endTime);
        NSLog(@"NEW TASK recurring IS %@", newTask.recurring);
    }
    [addingContext deleteObject:newNote];
     
    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"NEWITEMOREVENT ADDING MOC: DID NOT SAVE");
    } 
}

- (void) deleteItem:(id)sender{
    [addingContext deleteObject:newNote];
    
}

@end

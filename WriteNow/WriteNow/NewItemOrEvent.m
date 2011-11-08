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
@synthesize newNote;
@synthesize addingContext;//note this MOC is an adding MOC passed from the parent.

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:addingContext];
    
    newNote = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
    
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

- (void) setDoDate{
    
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
        
        Memo *myMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
        myMemo.creationDate =  [NSDate date];
        myMemo.type = newNote.type;
        myMemo.text = newNote.text;
        myMemo.creationDate = newNote.creationDate;
        myMemo.doDate = newNote.doDate;
        myMemo.doTime = newNote.doTime;
        myMemo.endTime = newNote.endTime;
        
        [myMemo release];
        return;
    }
    
    else if([newNote.type intValue] == 1){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
        
        Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
        
        newAppointment.creationDate = newNote.creationDate;
        newAppointment.doDate = newNote.doDate;
        newAppointment.doTime = newNote.doTime;
        newAppointment.endTime = newNote.endTime;
        newAppointment.type = newNote.type;
        newAppointment.text = newNote.text;
        
        [newAppointment release];
        return;
    }
    
    else {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:addingContext];
        
        Task  *myTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
        
       // myTask = (Task *)newNote;
        myTask.creationDate = newNote.creationDate;
        myTask.doDate = newNote.doDate;
        myTask.doTime = newNote.doTime;
        myTask.endTime = newNote.endTime;
        myTask.type = newNote.type;
        myTask.text = newNote.text;
        NSString *recur = @"Never";
        myTask.recurring = recur;
        NSLog(@"NEW TASK TEXT IS %@", myTask.text);
        NSLog(@"NEW TASK Type IS %d", [myTask.type intValue]);
        NSLog(@"NEW TASK doDate IS %@", myTask.doDate);
        NSLog(@"NEW TASK doTime IS %@", myTask.doTime);
        NSLog(@"NEW TASK endTime IS %@", myTask.endTime);
        NSLog(@"NEW TASK recurring IS %@", myTask.recurring);
        [myTask release];
    }
    [addingContext deleteObject:newNote];
     
    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"NEWITEMOREVENT ADDING MOC: DID NOT SAVE");
    } 
    
}

@end

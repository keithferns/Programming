//
//  NewMemo.m
//  WriteNow
//
//  Created by Keith Fernandes on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewItemOrEvent.h"
#import "NSCalendar+CalendarCalculations.h"

@implementation NewItemOrEvent

@synthesize recurring;
@synthesize delegate;
@synthesize theMemo, theNote,theToDo,theAppointment, theProject, theFolder, theDocument;
@synthesize addingContext;//note this MOC is an adding MOC passed from the parent.
@synthesize eventType;

- (void) createNewItem:(NSString *)text ofType:(NSNumber *)type {
    
    NSLog(@"NewItemOrEvent: Creating New Item: Type is %d", [type intValue]);
    //Always check to see if there is a Note object. If not, create a Note object before proceeding.
    
    
    if (theNote == nil){
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:addingContext];
        
        theNote = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
        
        theNote.text = text;
        theNote.editDate = [NSDate date];
        if (theNote != nil){
        NSLog(@"NewItemOrEvent:createNewItem - Created New Note");
        }
    }
    //link this note to an event depending on the sender. 
    
    switch ([type intValue]) {
   
        case 1://insert a Memo object into the managedObjectContext
            if (theMemo == nil && theNote != nil){
                type = [NSNumber numberWithInt:0];
                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new Memo Object");
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:addingContext];
            
            theMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
            
            [theMemo addRNoteObject: theNote];
            [theMemo setAType:[NSNumber numberWithInt:0]];
            
            }
            
            if (theMemo != nil){
                NSLog(@"NewItemOrEvent:createNewItem - Created New Memo");
            
            break;
            
        case 2://:insert an Appointment object into the MOC
            if (theAppointment == nil && theNote != nil){
                type = [NSNumber numberWithInt:1];

                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new Appointment Object");

                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
                
                theAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
                
                [theAppointment addRNoteObject:theNote];
                [theAppointment setAType:[NSNumber numberWithInt:1]];

                if (theAppointment != nil){
                    NSLog(@"NewItemOrEvent:createNewItem - Created New Appointment");
                }
            }
            break;
        case 3://insert a ToDo object into the MOC
            
            if (theToDo == nil && theNote != nil){
                type = [NSNumber numberWithInt:3];

                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new ToDo Object");

                NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:addingContext];
                
                theToDo = [[ToDo alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
                
                [theToDo addRNoteObject:theNote];
                [theToDo setAType:[NSNumber numberWithInt:2]];

                if (theToDo != nil){
                    NSLog(@"NewItemOrEvent:createNewItem - Created New To Do");
                }
            }
            break;
                
        case 4://insert a Project object into the MOC
            if (theProject == nil && theNote != nil){
                type = [NSNumber numberWithInt:4];

                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new Project Object");

                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:addingContext];
                
                theProject = [[Project alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
                
                [theProject addRNoteObject:theNote];
                [theProject setAType:[NSNumber numberWithInt:3]];
            }
            break;
            
        case 5://insert a Folder object into the MOC
            NSLog(@"NewItemOrEvent:createNewItem -  going to Folders");

            /*
            if (theFolder == nil && theNote != nil){
                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new Folder Object");

                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Folder" inManagedObjectContext:addingContext];
                
                theFolder = [[Folder alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
            
                [theFolder addNotesObject:theNote];
                
            }
             */
            break;
            
        case 6://insert a Document object intot the MOC:
                 type = [NSNumber numberWithInt:6];

            if (theDocument == nil && theNote != nil){
                NSLog(@"NewItemOrEvent:createNewItem - Trying to create new document Object");

                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Folder" inManagedObjectContext:addingContext];
                
                theDocument = [[Document alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];    
                [theDocument addRNoteObject:theNote];
                [theDocument setAType:[NSNumber numberWithInt:5]];
            
            }
            break;
            
        default:
            break;
        }
    
    }
}

- (void) addDateField{
    
    return;
}

- (void) updateSelectedDate:(NSDate *)date{
//
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
    NSLog(@"NewItemOrEvent: Saving New Item");

    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"NEWITEMOREVENT ADDING MOC: DID NOT SAVE");
        
    } 
    if (theAppointment != nil){
        NSLog(@"the SYSTEMDATE is %@", [NSDate date]);
        NSLog(@"the note creationDate is %@", theNote.creationDate);
        
        NSDateFormatter *datef = [[NSDateFormatter alloc] init];
        [datef setDateFormat:@"MM d, hh:mm a"];
        NSString *string = [datef stringFromDate:theNote.creationDate];
        NSLog(@"The note creation date is is %@", string);
        
        NSLog(@"the appointment creationDate is %@", theAppointment.creationDate);
        NSLog(@"the appointment creationDateDay is %@", theAppointment.creationDateDay);
        NSLog(@"the appointment aDate is %@", theAppointment.aDate);     
    }
}

- (void) deleteItem:(id)sender{
    [addingContext deleteObject:theNote];
    
}

#pragma mark - Get Values From Event Objects

- (NSArray *) dateTimeArrayfromObject: (id)theObject{
    
    
    NSArray *theArray = [theObject allObjects];
    
    return theArray;
}

-(NSArray *) alarmArrayFromEventObject:(id)theObject{
        
    
    NSArray *theArray = [theObject allObjects];
    
    return theArray;
}


@end

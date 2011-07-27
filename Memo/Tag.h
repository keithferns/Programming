//
//  Tag.h
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Folder, Memo;

@interface Tag : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * myTag;
@property (nonatomic, retain) NSSet* taggedFile;
@property (nonatomic, retain) NSSet* taggedFolder;
@property (nonatomic, retain) NSSet* taggedMemo;

@end

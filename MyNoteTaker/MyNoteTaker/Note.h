//
//  Note.h
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Note : NSObject <NSCoding>

// The Note object, the data model used in my project: the text of the note
// is represented using a NSString, note; the date when the note was last modified
// is represented using a NSDate object, called lastModifiedDate; and the image
// associated with the note is represented by a UIImage object, image.
@property NSString *note;

@property NSDate *lastModifiedDate;

@property UIImage *image;

@end

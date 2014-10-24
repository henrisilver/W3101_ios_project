//
//  Note.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import "Note.h"

@implementation Note

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.note = [[decoder decodeObjectForKey:@"note"] copy];
    self.lastModifiedDate = [[decoder decodeObjectForKey:@"lastModifiedDate"] copy];
    self.image = [[decoder decodeObjectForKey:@"image"] copy];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.note forKey:@"note"];
    [encoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
    [encoder encodeObject:self.image forKey:@"image"];
}


@end

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

@property NSString *note;

@property NSDate *lastModifiedDate;

@property UIImage *image;

@end

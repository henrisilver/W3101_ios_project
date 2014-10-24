//
//  AddNoteViewController.h
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"

@interface AddNoteViewController : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property Note *note;
@property (weak, nonatomic) NSString *rowNote;
@property (weak, nonatomic) NSDate *rowDate;
@property (weak, nonatomic) UIImage *rowImage;
@property AppDelegate *delegate;

@end

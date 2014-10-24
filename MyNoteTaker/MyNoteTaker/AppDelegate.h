//
//  AppDelegate.h
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<UIApplicationDelegate>delagete;

// globalMailComposer used to work around the issue Apple has with the
// MFMailComposeViewController
@property (strong, nonatomic) MFMailComposeViewController *globalMailComposer;

// Array used to store the array of loaded notes from memory
@property NSArray *loadedNotes;

- (void) cycleTheGlobalMailComposer;

@end


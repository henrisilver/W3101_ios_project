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
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property NSArray *loadedNotes;

- (void) cycleTheGlobalMailComposer;

@end


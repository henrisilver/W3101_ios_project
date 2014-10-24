//
//  ChoosePictureViewController.h
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/16/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePictureViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImagePickerController *imagePicker;
@property UIPopoverController *popover;
@property UIImage *picture;

@end

//
//  ChoosePictureViewController.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/16/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import "ChoosePictureViewController.h"

@interface ChoosePictureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureViewer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *choosePicture;

@end

@implementation ChoosePictureViewController

// IBAction that launches the UIImagePickerController when the choosePicture button is clicked
- (IBAction)choosePictureClicked:(id)sender
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // For iPhone, just show the UIImagePickerController
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    // For iPad, a UIPopoverController has to be used
    else
    {
        UIButton *buttonGallery = (UIButton *) self.choosePicture;
        self.popover=[[UIPopoverController alloc]initWithContentViewController:self.imagePicker];
        [self.popover presentPopoverFromRect:buttonGallery.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - ImagePickerController Delegate

// When the user selects a picture, the viewController (in the case of a phone) is dismissed or
// the popoverController (in the case of an iPad) is dismissed. Then, the image in the pictureViewer
// is updated with the new picture.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.popover dismissPopoverAnimated:YES];
    }
    self.pictureViewer.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

// If the user cancels picking an image, the viewController is dismissed
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// When the view loads, if the picture passed from the preview viewController is not nil,
// it is displayed in the pictureViewer.
- (void)viewDidLoad {
    [super viewDidLoad];

    if(self.picture != nil){
        self.pictureViewer.image = self.picture;
    }
    
    // Sets the right navigation bar button to execute choosePictureClicked when it is clicked.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Choose Picture..." style:UIBarButtonItemStylePlain target:self action: @selector(choosePictureClicked:)];
    self.navigationItem.rightBarButtonItem = barButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// Sets the picture attribute as the image from the pictureViewer
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.picture = self.pictureViewer.image;
    
}

@end


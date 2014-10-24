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

- (IBAction)choosePictureClicked:(id)sender
{
    self.ipc= [[UIImagePickerController alloc] init];
    self.ipc.delegate = self;
    self.ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [self presentViewController:self.ipc animated:YES completion:nil];
    else
    {
        UIButton *btnGallery = (UIButton *) self.choosePicture;
        self.popover=[[UIPopoverController alloc]initWithContentViewController:self.ipc];
        [self.popover presentPopoverFromRect:btnGallery.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.popover dismissPopoverAnimated:YES];
    }
    self.pictureViewer.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.picture != nil){
        self.pictureViewer.image = self.picture;
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Picture" style:UIBarButtonItemStylePlain target:self action: @selector(choosePictureClicked:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.picture = self.pictureViewer.image;
    
}
@end


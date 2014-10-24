//
//  AddNoteViewController.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

// ADD CODE FOR IMAGE

#import "AddNoteViewController.h"
#import "MyNoteTakerTableViewController.h"
#import "ChoosePictureViewController.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteNoteButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AddNoteViewController

- (IBAction)sendEmailButtonClicked:(id)sender {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSString *date = [dateFormat stringFromDate:[NSDate date]];
    NSString *subject = [NSString stringWithFormat:@"%@ %@", @"My Note from", date];
    
    self.delegate.globalMailComposer.mailComposeDelegate = self;
    [self.delegate.globalMailComposer setSubject:subject];
    [self.delegate.globalMailComposer addAttachmentData:UIImageJPEGRepresentation(self.rowImage, 1) mimeType:@"image/png" fileName:@"note_picture.jpeg"];
    [self.delegate.globalMailComposer setMessageBody:self.textView.text isHTML:NO];
    self.delegate.globalMailComposer.delegate = self;
    [self presentViewController:self.delegate.globalMailComposer animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^
     { [self.delegate cycleTheGlobalMailComposer]; }];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
    ChoosePictureViewController *source = [segue sourceViewController];
    self.rowImage = source.picture;
    self.note.image = source.picture;
    [self viewDidAppear:YES];
}

-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

//remember to set your text view delegate
//but if you only have 1 text view in your view controller
//you can simply change currentTextField to the name of your text view
//and ignore this textViewDidBeginEditing delegate method

-(void)doneButtonClickedDismissKeyboard
{
    [self.textView resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    UIButton *cameraButton;
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.rowImage == nil)
    {
        UIImage *camera = [UIImage imageNamed:@"selectPhoto"];
        cameraButton.bounds = CGRectMake( 0, 0, camera.size.width, camera.size.height );
        [cameraButton setImage:camera forState:UIControlStateNormal];
    }
    else
    {
        cameraButton.bounds = CGRectMake( 0, 0, 35, 35 );
        [cameraButton setImage:self.rowImage forState:UIControlStateNormal];
    }
    [cameraButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *selectPhoto;
    selectPhoto = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    
    self.navigationItem.rightBarButtonItem = selectPhoto;
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDoneToolBarToKeyboard:self.textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.note = [[Note alloc] init];
    if(self.rowNote != nil)
    {
        self.note.note = self.rowNote;
        self.note.image = self.rowImage;
        self.note.lastModifiedDate = self.rowDate;
        self.textView.text = self.rowNote;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.textView.scrollIndicatorInsets = self.textView.contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (IBAction)buttonPressed
{
    [self performSegueWithIdentifier:@"ViewPicture" sender:self];
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if((UIButton *) sender == self.deleteNoteButton) {
        self.note.note = nil;
    }
    else if(![self.note.note isEqualToString:self.textView.text] && ![[segue identifier] isEqualToString:@"ViewPicture"]) {
        self.note.note = self.textView.text;
        self.note.image = self.rowImage;
        self.note.lastModifiedDate = [NSDate date];
    }
    
    else if([[segue identifier] isEqualToString:@"ViewPicture"] && self.rowImage != nil) {
        ChoosePictureViewController *destination = segue.destinationViewController;
        destination.picture = self.rowImage;
    }

}

@end

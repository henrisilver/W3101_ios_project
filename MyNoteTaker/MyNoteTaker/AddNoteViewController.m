//
//  AddNoteViewController.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import "AddNoteViewController.h"
#import "MyNoteTakerTableViewController.h"
#import "ChoosePictureViewController.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteNoteButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AddNoteViewController

// Prepares the email and presents the MFMailComposViewController
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

// When the email is sent, dismisses viewController and cycles the MFMailComposeViewController object
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^
     { [self.delegate cycleTheGlobalMailComposer]; }];
}

// Gets the picture from the previous segue (segue from viewController to select the picture).
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
    ChoosePictureViewController *source = [segue sourceViewController];
    self.rowImage = source.picture;
    self.note.image = source.picture;
    [self viewDidAppear:YES];
}

// Adds toolbar with Done button to the keyboard to dismiss it.
-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.textView resignFirstResponder];
}

// Sets up navigation bar buttons, personalizing the right button. If the note has a picture,
// a small thumbnail of the picture is displayed. If that is not the case, a small camera icon
// is displayed to indicate to the user that a picture can be selected.
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
    
    // Used to prevent that the text of the textView be displayed with an offset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.note = [[Note alloc] init];
    
    // If this is a not a new Note,rowNote has been initialized with the content from the Note
    // specified by the row selected in the TableView.
    if(self.rowNote != nil)
    {
        self.note.note = self.rowNote;
        self.note.image = self.rowImage;
        self.note.lastModifiedDate = self.rowDate;
        self.textView.text = self.rowNote;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Used to resize the textView when the keyboard is shown
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.textView.scrollIndicatorInsets = self.textView.contentInset;
}

// Used to resize the textView when the keyboard is dismissed.
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

// Performs segue that goes to the viewController that displays pictures in case the picture/camera
// button is pressed
- (IBAction)buttonPressed
{
    [self performSegueWithIdentifier:@"ViewPicture" sender:self];
}

// Evaluates whether or not the segue should be performed. Used to prevent the segue when the back button
// is pressed and the note has a picture but has no text.
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if((UIBarButtonItem *) sender == self.backButton && [self.textView.text length] == 0 && self.rowImage != nil )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your note has a picture but has no text. Please enter text or tap Delete." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
        
    }
    else
        return YES;
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If sender is the delete button, sets the text fiel of the note as nil, so when the
    // note is evaluated in the tableView controller it is not added to the Note array and
    // is discarded
    if((UIButton *) sender == self.deleteNoteButton) {
        self.note.note = nil;
    }
    
    // If the note is different than it was and the segue does not lead to the ChoosePictureViewController,
    // then the note's attributes are updated
    else if(![self.note.note isEqualToString:self.textView.text] && ![[segue identifier] isEqualToString:@"ViewPicture"]) {
        self.note.note = self.textView.text;
        self.note.image = self.rowImage;
        self.note.lastModifiedDate = [NSDate date];
    }
    
    // If the segue leads to the ChoosePictureViewController, that displays the Note picture
    // and lets the user choose a new picture, and the current image is not nil, meaning
    // an image has already been selected, then we set the picture field of the destination
    // view controller as the rowImage, so that the Note's current picture is displayed
    else if([[segue identifier] isEqualToString:@"ViewPicture"] && self.rowImage != nil) {
        ChoosePictureViewController *destination = segue.destinationViewController;
        destination.picture = self.rowImage;
    }

}

@end

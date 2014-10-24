//
//  TextNote.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/14/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import "TextNote.h"

@implementation TextNote

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - TextView Delegate methods


UITextView itsTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, itsTextView.frame.size.width, itsTextView.frame.size.height)];
[itsTextView setDelegate:self];
[itsTextView setReturnKeyType:UIReturnKeyDone];
[itsTextView setText:@"List words or terms separated by commas"];
[itsTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
[itsTextView setTextColor:[UIColor lightGrayColor]];

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (itsTextView.textColor == [UIColor lightGrayColor]) {
        itsTextView.text = @"";
        itsTextView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(itsTextView.text.length == 0){
        itsTextView.textColor = [UIColor lightGrayColor];
        itsTextView.text = @"List words or terms separated by commas";
        [itsTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(itsTextView.text.length == 0){
            itsTextView.textColor = [UIColor lightGrayColor];
            itsTextView.text = @"List words or terms separated by commas";
            [itsTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}



@end

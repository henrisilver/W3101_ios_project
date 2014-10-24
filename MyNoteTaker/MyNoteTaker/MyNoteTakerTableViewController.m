//
//  MyNoteTakerTableViewController.m
//  MyNoteTaker
//
//  Created by Henrique de Almeida Machado da Silveira on 10/11/14.
//  Copyright (c) 2014 Henrique de Almeida Machado da Silveira. All rights reserved.
//

#import "MyNoteTakerTableViewController.h"
#import "AddNoteViewController.h"

@interface MyNoteTakerTableViewController ()

@property (strong, nonatomic) IBOutlet UITableViewCell *selectRow;
@property Note *currentNote;
@property AppDelegate *delegate;
@property NSMutableArray *userNotes;

@end

@implementation MyNoteTakerTableViewController


- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    // Sets editting to NO to deal with the case when the user is editing/deleting Notes in the
    // TableView and then taps a Note or the + sign, to create/edit a note, and then goes back.
    // In this case, the Editing mode should be reset as NO.
    [self setEditing:NO animated:NO];
    
    // Gets note from previous incoming segue
    AddNoteViewController *source = [segue sourceViewController];
    Note *newNote = source.note;
    // If it is not an empty note, the note is inserted in the array of notes and is displayed
    // in the tableview
    if ([newNote.note length] != 0) {
        [self.userNotes addObject:newNote];
        [self.userNotes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1 = [(Note *)obj1 lastModifiedDate];
            NSDate *date2 = [(Note *)obj2 lastModifiedDate];
            return [date2 compare:date1];
        }];
    }
    // Also, the array of notes is coped to the loadNotes array in the delegate, so when
    // the app gos to an inactive state the data is saved
    self.delegate.loadedNotes = [self.userNotes copy];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    self.currentNote = [[Note alloc] init];
    
    [self loadInitialData];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void) loadInitialData {
    if(self.delegate.loadedNotes != nil)
        self.userNotes = [self.delegate.loadedNotes mutableCopy];
    else
        self.userNotes = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.userNotes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // creates cell using UITableViewCellStyleSubtitle
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    // Configures the cell, selecting the corresponding Note in the array of Notes and
    // setting the cell's attributes equal to the selected Note
    Note *note = [self.userNotes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.note;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy, hh:mm:ss "];
    cell.detailTextLabel.text = [dateFormat stringFromDate:note.lastModifiedDate];
    cell.imageView.image = note.image;
    
    // Sets the size of the UIImageView of the cell, presenting all images using the same size
    // of UIImageView
    CGSize itemSize = CGSizeMake(75, 75);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deletes Note entry from TableVIew, array and the array from the delegate is updated.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.userNotes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([self.userNotes count] == 0)
            [self setEditing:NO animated:YES];
        self.delegate.loadedNotes = [self.userNotes copy];
    }  
}

// If a row is selected, performs segue that goes to the view of editing and viewing notes,
// calling the segue. Removes Note from the array, so the updated Note will be added to the array
// when this view is displayed again.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentNote = [self.userNotes objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.userNotes removeObjectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditNote" sender:self];

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // In case the segue is to Edit and display notes, gets the new view controller
    // using [segue destinationViewController] and passes the selected note's attributes
    // to the destination, setting the viewController's variables.
    if([segue.identifier isEqualToString:@"EditNote"])
    {
        AddNoteViewController *transferViewController = segue.destinationViewController;
        transferViewController.rowNote = self.currentNote.note;
        transferViewController.rowImage = self.currentNote.image;
        transferViewController.rowDate = self.currentNote.lastModifiedDate;
        
    }

}


@end

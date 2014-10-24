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

@property NSMutableArray *userNotes;

@end

@implementation MyNoteTakerTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self setEditing:NO animated:NO];
    AddNoteViewController *source = [segue sourceViewController];
    Note *newNote = source.note;
    if ([newNote.note length] != 0) {
        [self.userNotes addObject:newNote];
        [self.userNotes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1 = [(Note *)obj1 lastModifiedDate];
            NSDate *date2 = [(Note *)obj2 lastModifiedDate];
            return [date2 compare:date1];
        }];
    }
    self.delegate.loadedNotes = [self.userNotes copy];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    self.currentNote = [[Note alloc] init];
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
    
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }

    
    // Configure the cell...
    Note *note = [self.userNotes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.note;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy, hh:mm:ss "];

    
    cell.detailTextLabel.text = [dateFormat stringFromDate:note.lastModifiedDate];
    cell.imageView.image = note.image;
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.userNotes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([self.userNotes count] == 0)
            [self setEditing:NO animated:YES];
        self.delegate.loadedNotes = [self.userNotes copy];
    }  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentNote = [self.userNotes objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.userNotes removeObjectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditNote" sender:self];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"EditNote"])
    {
        AddNoteViewController *transferViewController = segue.destinationViewController;
        transferViewController.rowNote = self.currentNote.note;
        transferViewController.rowImage = self.currentNote.image;
        transferViewController.rowDate = self.currentNote.lastModifiedDate;
        
    }

}


@end

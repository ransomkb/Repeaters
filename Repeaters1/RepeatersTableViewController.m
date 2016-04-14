//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "RepeatersTableViewController.h"
#import "Repeater.h"
#import "Deadline+Settings.h"
#import "DetailsViewController.h"
#import "AddRepeaterViewController.h"

@interface RepeatersTableViewController ()
- (NSString *)formatDay:(Deadline *)deadline;
@end

@implementation RepeatersTableViewController
@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize settingsInfo = _settingsInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpFetchedResultsController
{
    // self.fetchedResultsController = ...?
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    // request.predicate - no predicate means get all. need sortDescriptors
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    
    //initializing frc seems to cause a fetch
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.repeaterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];

}

//IMPORTANT: maybe this method should be placed in EditorViewController/AddRepeater and called when returned
//Not used to create deadline here
/*
- (void)fetchRepeaterDataIntoDocument:(UIManagedDocument *)document
{
    // will use it to get data from nsnotification
    //set up as delegate for editor and addrepeater
    [Deadline deadlineWithSettingsInfo:self.settingsInfo inManagedObjectContext:document.managedObjectContext];
}
*/

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.repeaterDatabase.fileURL path]]) {
        [self.repeaterDatabase saveToURL:self.repeaterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
            //IMPORTANT: THIS SHOULD BE CALLED WHEN DONE WITH EDITOR OR ADDREPEATER [self fetchRepeaterDataIntoDocument:self.repeaterDatabase];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateClosed) {
        [self.repeaterDatabase openWithCompletionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateNormal) {
        [self setUpFetchedResultsController];
    }
}

- (void)setRepeaterDatabase:(UIManagedDocument *)repeaterDatabase
{
    if (_repeaterDatabase != repeaterDatabase) {
        _repeaterDatabase = repeaterDatabase;
        [self useDocument];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.repeaterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Repeater Database"];
        self.repeaterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString *)formatDay:(Deadline *)deadline
{
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ ", deadline.ordinal];
    if (deadline.day) {
        label = [label stringByAppendingString:deadline.day];
    }
    label = [label stringByAppendingString:@" in a month"];
    if (deadline.time) {
        label = [label stringByAppendingString:[NSString stringWithFormat:@" at %@.", deadline.time]];
    }
    
    return label;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Repeater Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (deadline) {
        cell.textLabel.text = deadline.whichReminder.name;
        cell.detailTextLabel.text = [self formatDay:deadline];
    }
        
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([segue.identifier hasPrefix:@"Details"]) {
        DetailsViewController *dvc = (DetailsViewController *)segue.destinationViewController;
        dvc.repeaterDatabase = self.repeaterDatabase;
        dvc.deadline = deadline;
        //dvc.delegate = self; use if need a delegate
    } else if ([segue.identifier hasPrefix:@"Add Repeater"]) {
        AddRepeaterViewController *avc = (AddRepeaterViewController *)segue.destinationViewController;
        // will not use a deadline here because creating a new one; avc.deadline = deadline;
        avc.repeaterDatabase = self.repeaterDatabase;
        avc.name = @"Enter a name";
        //avc.delegate = self; use if need a delegate
    }
}

@end

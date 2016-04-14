//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Barber Ransom on 7/23/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DetailsViewController.h"
#import "EditorViewController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) NSString *name;
@end

@implementation DetailsViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize nameLabel = _nameLabel;
@synthesize dayLabel = _dayLabel;
@synthesize nextLabel = _nextLabel;
@synthesize name = _name;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.name = self.deadline.whichReminder.name;
    self.nameLabel.text = self.name;
    self.dayLabel.text = [self formatDay:self.deadline];
    self.nextLabel.text = @"Need to set this";
    //[Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[Repeater removeLastRepeater:@"feed frog" inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDayLabel:nil];
    [self setNextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.nameLabel.text = self.deadline.whichReminder.name;
    self.dayLabel.text = [self formatDay:self.deadline];
    self.nextLabel.text = @"Need to set Next Deadline";
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
}

- (IBAction)deleteRepeater:(id)sender
{
    //set up a way to delete the deadline from the database, and the repeater too if it is the last one
    [Deadline removeDeadline:self.deadline inManagedObjectContext:self.deadline.managedObjectContext];
    [Repeater removeLastRepeater:self.name inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Editor Modal"]) {
        EditorViewController *evc = (EditorViewController *)segue.destinationViewController;
        evc.deadline = self.deadline;
        //evc.name = @"Enter a name"; IMPORTANT: make this so that it changes to repeater.name if editing existing one
        //dvc.delegate = self; maybe used but probably not.
    }
}

@end

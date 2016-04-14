//
//  EditorViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "EditorViewController.h"
//#import "DayViewController.h"
//#import "DeadlineViewController.h"
//#import "NotifyTableViewController.h"

@interface EditorViewController ()
//<UITextFieldDelegate, DayViewControllerDelegate, DeadlineViewControllerDelegate, NotifyTableViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
//- (void)formatOrdinalandDay;
//- (void)formatSettings;
//- (NSDate *)calculateNextDeadline;
//- (NSDate *)lastDeadline;
//- (NSDictionary *)updateSettingsInfo;
@end

@implementation EditorViewController

//@synthesize deadline = _deadline;
//@synthesize name = _name;
//@synthesize nameTextField = _nameTextField;
//@synthesize settingsLabel = _settingsLabel;
//@synthesize settingsInfo = _settingsInfo;
//@synthesize ordinalSetting = _ordinalSetting;
//@synthesize daySetting = _daySetting;
//@synthesize deadlineSetting = _deadlineSetting;
//@synthesize notifierSetting = _notifierSetting;
//@synthesize ordinalAndDay = _ordinalAndDay;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDate *)calculateNextDeadline
{
    NSDate *next = [[NSDate alloc] init];
    // Add present time plus one hour for now
    return next;
}

- (NSDate *)lastDeadline
{
    if (self.deadline.last) {
        return self.deadline.last;
    } else {
        return [self calculateNextDeadline];
    }
}

- (NSDictionary *)updateSettingsInfo
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [mutDict setObject:self.ordinalSetting forKey:@"ordinal"];
    [mutDict setObject:self.daySetting forKey:@"day"];
    [mutDict setObject:self.deadlineSetting forKey:@"time"];
    [mutDict setObject:self.notifierSetting forKey:@"notify"];
    [mutDict setObject:[self calculateNextDeadline] forKey:@"next"];
    [mutDict setObject:[self lastDeadline] forKey:@"last"];
    [mutDict setObject:self.name forKey:@"name"];
    
    return mutDict;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text length]) {
        // for returning to Details; no good here [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        // for resigning keyboard, see below
        [textField resignFirstResponder];
    } else {
        self.name = textField.text;
        //IMPORTANT: check whether this name is already in Repeaters database
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
    // the below is no good if wish to quit editing without setting repeater
    */
    /*
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
    */
/*
}


- (void)dayViewController:(DayViewController *)sender
                didGetDay:(NSString*)daySetting
{
    //add daySetting to settingsInfo dictionary
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.daySetting = self.deadline.day;
    self.ordinalSetting = self.deadline.ordinal;
    self.deadlineSetting = self.deadline.time;
    self.notifierSetting = self.deadline.notify;
    self.name = self.deadline.whichReminder.name;
    self.nameTextField.text = self.name;
    //self.nameTextField.placeholder = self.name;
    // set a default ghost title
    // prepare for segue does not set outlets and stuff
    [self formatOrdinalandDay];
    [self formatSettings];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSettingsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.nameTextField becomeFirstResponder];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
*/

/*
- (void)formatSettings
{
    NSString *label = self.ordinalAndDay;
    if (self.deadlineSetting) {
        [label stringByAppendingString:[NSString stringWithFormat:@" at %@.", self.deadlineSetting]];
    }
    label = [label stringByAppendingString:[NSString stringWithFormat:@"Notify me: %@.", self.notifierSetting]];
    NSLog(@"formatSettings: label = %@", label);
    self.settingsLabel.text = label;
}

- (void)formatOrdinalandDay
{
    NSLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", self.ordinalSetting, self.daySetting);
    
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ ", self.ordinalSetting];
    label = [label stringByAppendingString:self.daySetting];
    label = [label stringByAppendingString:@" in a month"];
    
    NSLog(@"EditorSettings: Day set to: %@ ", label);
    
    self.ordinalAndDay = label;
}

- (void)dayViewController:(DayViewController *)sender
            didGetOrdinal:(NSString *)ordinal
             andDidGetDay:(NSString *)dayOfWeek
{
    self.ordinalSetting = ordinal;
    self.daySetting = dayOfWeek;
    
    [self formatOrdinalandDay];
    [self formatSettings];
}

- (void)deadlineViewController:(DeadlineViewController *)sender
                didGetDeadline:(NSDate *)deadline
{
    NSLog(@"EditorSettings: doneTime: self.deadline = %@", deadline);
    self.deadlineSetting = deadline;
    [self formatSettings];
}

- (void)NotifyTableViewController:(NotifyTableViewController *)sender
                   didGetNotifier:(NSString *)notifier
{
    NSLog(@"EditorSettings: doneNotifier: self.notifier = %@", notifier);
    self.notifierSetting = notifier;
    [self formatSettings];
}
*/

- (IBAction)cancelEditor:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneEditor:(id)sender
{
    self.settingsInfo = [self updateSettingsInfo];
    //Update CoreData Repeater and Deadline
    // if the below context doesn't work, get it by creating a MOC here and passing the repeaterTableView one to it in the prepareforsegue
    NSLog(@"Editor doneEditor: settingsInfo = %@", self.settingsInfo);
    //Update CoreData Repeater and Deadline
    // create a method to update a deadline
    if (self.deadline) {
        self.deadline.day = [self.settingsInfo objectForKey:@"day"];
        self.deadline.time = [self.settingsInfo objectForKey:@"time"];
        self.deadline.next = [self.settingsInfo objectForKey:@"next"];
        self.deadline.last = [self.settingsInfo objectForKey:@"last"];
        self.deadline.notify = [self.settingsInfo objectForKey:@"notify"];
        self.deadline.ordinal = [self.settingsInfo objectForKey:@"ordinal"];
        self.deadline.whichReminder.name = [self.settingsInfo objectForKey:@"name"];
        //self.deadline.whichReminder = [Repeater repeaterWithName:[self.settingsInfo objectForKey:@"name"] inManagedObjectContext:self.deadline.managedObjectContext];
        
        NSLog(@"Deadline Settings are: day = %@, time = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", self.deadline.day, self.deadline.time, self.deadline.next, self.deadline.last, self.deadline.notify, self.deadline.ordinal, self.deadline.whichReminder);

        //[Deadline updateDeadline:self.deadline withSettingsInfo:self.settingsInfo inManagedObjectContext:self.deadline.managedObjectContext];
    } else {
        // handle error of now deadline
    }
    
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Day Setter"]) {
        DayViewController *dayvc = (DayViewController *)segue.destinationViewController;
        dayvc.delegate = self;
    } else if ([segue.identifier hasPrefix:@"Deadline Setter"]) {
        DeadlineViewController *deadvc = (DeadlineViewController *)segue.destinationViewController;
        deadvc.delegate = self;
    } else if ([segue.identifier hasPrefix:@"Notifier Setter"]) {
        NotifyTableViewController *notvc = (NotifyTableViewController *)segue.destinationViewController;
        notvc.delegate = self;
    }
}
@end

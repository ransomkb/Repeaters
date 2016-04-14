//
//  AddRepeaterViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/2/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "AddRepeaterViewController.h"

@interface AddRepeaterViewController ()
@end

@implementation AddRepeaterViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize name = _name;
@synthesize nameTextField = _nameTextField;
@synthesize settingsLabel = _settingsLabel;
@synthesize deadLabel = _deadLabel;
@synthesize notifyLabel = _notifyLabel;
@synthesize settingsInfo = _settingsInfo;
@synthesize ordinalSetting = _ordinalSetting;
@synthesize daySetting = _daySetting;
@synthesize timeString = _timeString;
@synthesize deadlineSetting = _deadlineSetting;
@synthesize notifierSetting = _notifierSetting;
@synthesize ordinalAndDay = _ordinalAndDay;
@synthesize hour = _hour;
@synthesize minute = _minute;

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
    [mutDict setObject:self.timeString forKey:@"time"];
    [mutDict setObject:self.hour forKey:@"hour"];
    [mutDict setObject:self.minute forKey:@"minute"];
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
    /*
     if ([textField.text length]) {
     [textField resignFirstResponder];
     return YES;
     } else {
     return NO;
     }
     */
}

- (void)dayViewController:(DayViewController *)sender
                didGetDay:(NSString*)daySetting
{
    //add daySetting to settingsInfo dictionary
    [self dismissModalViewControllerAnimated:YES];
}

- (void)defaultSettings
{
    self.ordinalAndDay = @"Repeat every day in a month";
    self.daySetting = @"day";
    self.ordinalSetting = @"";
    self.timeString = @"17:00";
    self.hour = [[NSNumber alloc] initWithInt:5];
    self.minute = [[NSNumber alloc] initWithInt:0];
    self.deadlineSetting = [self formatDefaultTime];
    self.notifierSetting = @"No Notifier";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.settingsLabel.text = @"Default: Repeat every day";
    self.deadLabel.text = @"Default: 5:00 PM";
    self.notifyLabel.text = @"Default: No Notifier";
    self.nameTextField.placeholder = self.name; //@"Enter a name";
    [self defaultSettings];
    // prepare for segue does not set outlets and stuff
    //[self formatSettings];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSettingsLabel:nil];
    [self setDeadLabel:nil];
    [self setNotifyLabel:nil];
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

// maybe don't need
- (void)formatSettings
{
    NSString *label = self.ordinalAndDay;
    if (self.deadlineSetting) {
        [label stringByAppendingString:[NSString stringWithFormat:@" at %@. ", self.deadlineSetting]];
    }
    label = [label stringByAppendingString:[NSString stringWithFormat:@"Notify me: %@.", self.notifierSetting]];
    NSLog(@"formatSettings: label = %@", label);
    self.settingsLabel.text = label;
}

- (NSDate *)formatDefaultTime
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setHour:[self.hour integerValue]];
    [comps setMinute:[self.minute integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    NSLog(@"formatDefaultTime: deadlineSetting will be set to date = %@", date);
    return date;
}

/*
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 [comps setDay:6];
 [comps setMonth:5];
 [comps setYear:2004];
 NSCalendar *gregorian = [[NSCalendar alloc]
 initWithCalendarIdentifier:NSGregorianCalendar];
 NSDate *date = [gregorian dateFromComponents:comps];
 [comps release];
 NSDateComponents *weekdayComponents =
 [gregorian components:NSWeekdayCalendarUnit fromDate:date];
 int weekday = [weekdayComponents weekday]; 
 
 separate stuff: nsnumber to nsinteger
 NSInteger myInteger = [myNumber integerValue];
 */

- (NSString *)formatTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    NSLog(@"formatTime: deadline = %@", [formatter stringFromDate:self.deadlineSetting]);
    
    return [formatter stringFromDate:self.deadlineSetting];
}

- (void)formatHour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh"];
    NSString *formattedDeadline = [formatter stringFromDate:self.deadlineSetting];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    self.hour = [f numberFromString:formattedDeadline];
    
    NSLog(@"formatHour: self.hour = %@", self.hour);
}

- (void)formatMinute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *formattedDeadline = [formatter stringFromDate:self.deadlineSetting];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    self.minute = [f numberFromString:formattedDeadline];
    
    NSLog(@"formatMinute: self.minute = %@", self.minute);
}


- (void)dayViewController:(DayViewController *)sender
            didGetOrdinal:(NSString *)ordinal
             andDidGetDay:(NSString *)dayOfWeek
{
    self.ordinalSetting = ordinal;
    self.daySetting = dayOfWeek;
    
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ ", self.ordinalSetting];
    label = [label stringByAppendingString:self.daySetting];
    label = [label stringByAppendingString:@" in a month"];
    
    NSLog(@"AppRep: Day set to: %@", label);
    
    self.ordinalAndDay = label;
    NSLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", ordinal, dayOfWeek);
    self.settingsLabel.text = self.ordinalAndDay;

    //[self formatSettings];
}

- (void)deadlineViewController:(DeadlineViewController *)sender
                didGetDeadline:(NSDate *)deadline
{
    NSLog(@"AppRep: doneTime: self.deadline = %@", deadline);
    self.deadlineSetting = deadline;
    //[self formatSettings];
    self.timeString = [self formatTime];
    [self formatHour];
    [self formatMinute];
    self.deadLabel.text = self.timeString;
}

- (void)NotifyTableViewController:(NotifyTableViewController *)sender
                   didGetNotifier:(NSString *)notifier
{
    NSLog(@"AppRep: doneNotifier: self.notifier = %@", notifier);
    self.notifierSetting = notifier;
    //[self formatSettings];
    self.notifyLabel.text = self.notifierSetting;
}

- (IBAction)cancelAddRepeater:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneEditor:(id)sender
{
    self.settingsInfo = [self updateSettingsInfo];
    //Update CoreData Repeater and Deadline
    // if the below context doesn't work, get it by creating a MOC here and passing the repeaterTableView one to it in the prepareforsegue
    NSLog(@"AddRep doneEditor: settingsInfo = %@", self.settingsInfo);
    [Deadline deadlineWithSettingsInfo:self.settingsInfo inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Add Day"]) {
        DayViewController *dayvc = (DayViewController *)segue.destinationViewController;
        dayvc.delegate = self;
    } else if ([segue.identifier hasPrefix:@"Add Deadline"]) {
        DeadlineViewController *deadvc = (DeadlineViewController *)segue.destinationViewController;
        deadvc.delegate = self;
    } else if ([segue.identifier hasPrefix:@"Add Notifier"]) {
        NotifyTableViewController *notvc = (NotifyTableViewController *)segue.destinationViewController;
        notvc.delegate = self;
    }
}
@end

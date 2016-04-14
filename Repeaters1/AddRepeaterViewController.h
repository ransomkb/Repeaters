//
//  AddRepeaterViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 8/2/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayViewController.h"
#import "DeadlineViewController.h"
#import "NotifyTableViewController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@interface AddRepeaterViewController : UIViewController <UITextFieldDelegate, DayViewControllerDelegate, DeadlineViewControllerDelegate, NotifyTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;

@property (nonatomic, strong) UIManagedDocument *repeaterDatabase;
@property (strong, nonatomic) Deadline *deadline;
@property (strong, nonatomic) NSDictionary *settingsInfo;
@property (strong, nonatomic) NSDate *deadlineSetting;
@property (strong, nonatomic) NSNumber *hour;
@property (strong, nonatomic) NSNumber *minute;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *ordinalSetting;
@property (strong, nonatomic) NSString *daySetting;
@property (strong, nonatomic) NSString *notifierSetting;
@property (strong, nonatomic) NSString *ordinalAndDay;
@property (strong, nonatomic) NSString *name;

- (void)defaultSettings;
- (void)formatSettings;
- (NSDate *)calculateNextDeadline;
- (NSDate *)lastDeadline;
- (NSDictionary *)updateSettingsInfo;
@end

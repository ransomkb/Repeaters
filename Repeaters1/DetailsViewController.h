//
//  RepeatersViewController.h
//  Repeaters1
//
//  Created by Barber Ransom on 7/23/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *repeaterDatabase;
@property (strong, nonatomic) Deadline *deadline;

@end

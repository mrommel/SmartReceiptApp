//
//  DetailViewController.h
//  SmartReceipt
//
//  Created by Michael Rommel on 17.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface DetailViewController : UITableViewController

- (void)setReceiptItem:(Receipt *)newReceipt;

@end


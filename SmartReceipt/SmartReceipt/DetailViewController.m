//
//  DetailViewController.m
//  SmartReceipt
//
//  Created by Michael Rommel on 17.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "DetailViewController.h"

#import <UIKit/UIKit.h>

#import "Receipt.h"
#import "Receipt+Extended.h"
#import "UIConstants.h"
#import "CoreDataReceiptManager.h"
#import "DetailMenuEntry.h"
#import "UIConstants.h"

#define LABEL_WIDTH             90

#define IMAGE           0
#define TITLE           1
#define DESCRIPTION     2

#define MENU_ITEMS      [NSArray arrayWithObjects:  \
    [DetailMenuEntry entryWithLabelText:@"Image" andTag:IMAGE],  \
    [DetailMenuEntry entryWithLabelText:@"Title" andTag:TITLE],  \
    [DetailMenuEntry entryWithLabelText:@"Description" andTag:DESCRIPTION],nil]

@interface DetailViewController () {
    Receipt *_receipt;
    
    BOOL _editMode;
    UIBarButtonItem *_editButton;
    NSMutableArray *_textFields;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setReceiptItem:(Receipt *)newReceipt
{
    if (_receipt != newReceipt) {
        _receipt = newReceipt;
        
        [self.tableView reloadData];
    }
}

/*- (void)addRow
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textFields = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editOrSaveReceipt:)];
    self.navigationItem.rightBarButtonItem = _editButton;
}

- (id)cellTextForMenuTag:(NSInteger)tag
{
    if (_receipt) {
        switch (tag) {
            case IMAGE:
                return [_receipt getImage];
            case TITLE:
                return _receipt.title;
                break;
            case DESCRIPTION:
                return _receipt.desc;
            default:
                break;
        }
    }
    
    return @"";
}

- (void)updateReceiptWithText:(NSString *)text forTag:(NSInteger)tag
{
    if (_receipt) {
        switch (tag) {
            case TITLE:
                _receipt.title = text;
                break;
            case DESCRIPTION:
                _receipt.desc = text;
            default:
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MENU_ITEMS.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    DetailMenuEntry *item = [MENU_ITEMS objectAtIndex:row];
    return item.tag == IMAGE ? 240 + 32 : BU4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReceiptDetailViewCell";
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    } else {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    
    DetailMenuEntry *item = [MENU_ITEMS objectAtIndex:row];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(BU1, BU1, LABEL_WIDTH, BU2)];
    textLabel.text = item.labelText;
    textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [cell addSubview:textLabel];
    
    if (item.tag == IMAGE) {
        UIImageView *labelBox = [[UIImageView alloc] initWithFrame:CGRectMake(LABEL_WIDTH + BU2, BU1, DEVICE_WIDTH - LABEL_WIDTH - BU2 - BU1, DEVICE_WIDTH - LABEL_WIDTH - BU2 - BU1)];
        labelBox.image = [self cellTextForMenuTag:item.tag];
        [cell addSubview:labelBox];
    } else {
        if (_editMode) {
            UITextField *inputBox = [[UITextField alloc] initWithFrame:CGRectMake(LABEL_WIDTH + BU2, BU1, DEVICE_WIDTH - LABEL_WIDTH - BU2 - BU1, BU2)];
            inputBox.text = [self cellTextForMenuTag:item.tag];
            inputBox.borderStyle = UITextBorderStyleRoundedRect;
            inputBox.tag = item.tag;
            
            [_textFields addObject:inputBox];
            
            [cell addSubview:inputBox];
        } else {
            UILabel *labelBox = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_WIDTH + BU2, BU1, DEVICE_WIDTH - LABEL_WIDTH - BU2 - BU1, BU2)];
            labelBox.text = [self cellTextForMenuTag:item.tag];
            [cell addSubview:labelBox];
        }
    }
        
    return cell;
}

- (IBAction)editOrSaveReceipt:(id)sender
{
    _editMode = !_editMode;
    
    if (_editMode) {
        _editButton.title = @"Save";
    } else {
        _editButton.title = @"Edit";
        
        // store the changes
        for (UITextField *field in _textFields) {
            [self updateReceiptWithText:field.text forTag:field.tag];
        }
        
        if (_receipt) {
            [[CoreDataReceiptManager sharedInstance] saveReceipt];
        }
        
        [_textFields removeAllObjects];
    }
    
    [self.tableView reloadData];
}

@end

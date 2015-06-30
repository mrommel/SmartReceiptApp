//
//  TableViewCell.h
//  SmartReceipt
//
//  Created by Michael Rommel on 25.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReceiptViewCellClickedBlock)(void);


@interface ReceiptViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

- (void)setClickCallback:(ReceiptViewCellClickedBlock)receiptViewCellClickedBlock;

@end

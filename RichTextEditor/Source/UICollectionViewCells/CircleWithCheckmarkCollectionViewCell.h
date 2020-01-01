//
//  CircleWithCheckmarkCollectionViewCell.h
//  RichTextEditor
//
//  Created by Michael Babienco on 12/31/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleWithCheckmarkCollectionViewCell : UICollectionViewCell

@property UIColor *color;
@property BOOL useWhiteCheckmark; // defaults to NO

@end

NS_ASSUME_NONNULL_END

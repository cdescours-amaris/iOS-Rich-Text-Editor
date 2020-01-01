//
//  RichTextEditorSingleColorPickerViewController.h
//  RichTextEditor
//
//  Created by Michael Babienco on 12/31/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextEditorColorPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface RichTextEditorSingleColorPickerViewController : UIViewController <RichTextEditorColorPicker>

@property (nonatomic, weak) id<RichTextEditorColorPickerViewControllerDelegate> delegate;
@property (nonatomic, weak) id<RichTextEditorColorPickerViewControllerDataSource> dataSource;
@property (nonatomic, assign) RichTextEditorColorPickerAction action;

@property NSArray<UIColor*> *colors;
@property UIColor *selectedColor;
@property BOOL useWhiteCheckmark; // defaults to NO

@end

NS_ASSUME_NONNULL_END

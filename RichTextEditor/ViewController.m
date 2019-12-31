//
//  ViewController.m
//  RichTextEdtor
//
//  Created by Aryan Gh on 7/21/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "ViewController.h"
#import <RichTextEditor/RichTextEditor.h>
#import <RichTextEditor/RichTextEditorSingleColorPickerViewController.h>

@interface ViewController () <RichTextEditorDataSource, RichTextEditorDelegate, UITextViewDelegate, RichTextEditorColorPickerViewControllerDataSource>

@property (assign) IBOutlet RichTextEditor *richTextEditor;

@property UIColor *latestTextColor;
@property UIColor *latestBackgroundColor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.richTextEditor.delegate = self;
    self.richTextEditor.rteDelegate = self;
    self.richTextEditor.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

/*- (NSArray *)fontSizeSelectionForRichTextEditor:(RichTextEditor *)richTextEditor {
	// pass an array of NSNumbers
	return @[@5, @20, @30];
}

- (RichTextEditorToolbarPresentationStyle)presentarionStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
	return RichTextEditorToolbarPresentationStyleModal;
}

- (UIModalPresentationStyle)modalPresentationStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
	return UIModalPresentationFormSheet;
}

- (UIModalTransitionStyle)modalTransitionStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
	return UIModalTransitionStyleFlipHorizontal;
}*/

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"View controller -- text view did change selection");
}

- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor {
	return RichTextEditorFeatureFontSize | RichTextEditorFeatureFont | RichTextEditorFeatureAll;
}

- (UIViewController <RichTextEditorColorPicker> *)colorPickerForRichTextEditor:(RichTextEditor *)richTextEditor withAction:(RichTextEditorColorPickerAction)action {
    RichTextEditorSingleColorPickerViewController *picker = [[RichTextEditorSingleColorPickerViewController alloc] init];
    picker.dataSource = self;
    picker.action = action;
    if (action == RichTextEditorColorPickerActionTextBackgroundColor) {
        picker.colors = @[UIColor.orangeColor, UIColor.yellowColor];
        picker.selectedColor = self.latestBackgroundColor;
    } else {
        picker.selectedColor = self.latestTextColor;
    }
    return picker;
}

- (BOOL)richTextEditorColorPickerViewControllerShouldDisplayToolbar {
    return YES;
}

- (BOOL)richTextEditorColorPickerViewControllerShouldDisplayAllColors { // return NO to only display a select # of colors {
    return NO;
}

-(void)selectionForEditor:(RichTextEditor*)editor changedTo:(NSRange)range isBold:(BOOL)isBold isItalic:(BOOL)isItalic isUnderline:(BOOL)isUnderline isInBulletedList:(BOOL)isInBulletedList textBackgroundColor:(UIColor*)textBackgroundColor textColor:(UIColor*)textColor {
    self.latestTextColor = textColor;
    self.latestBackgroundColor = textBackgroundColor;
}

@end

//
//  RichTextEditor.h
//  RichTextEdtor
//
//  Created by Aryan Gh on 7/21/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
//  Modified heavily by Deadpikle
//  https://github.com/Deadpikle/iOS-Rich-Text-Editor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "RichTextEditorColorPicker.h"
#import "RichTextEditorFontPicker.h"
#import "RichTextEditorFontSizePicker.h"

typedef NS_ENUM(NSUInteger, RichTextEditorToolbarPresentationStyle) {
	RichTextEditorToolbarPresentationStyleModal,
	RichTextEditorToolbarPresentationStylePopover
};

typedef NS_OPTIONS(NSUInteger, RichTextEditorFeature) {
	RichTextEditorFeatureNone							= 1 << 0,
	RichTextEditorFeatureFont							= 1 << 1,
	RichTextEditorFeatureFontSize						= 1 << 2,
	RichTextEditorFeatureBold							= 1 << 3,
	RichTextEditorFeatureItalic							= 1 << 4,
	RichTextEditorFeatureUnderline						= 1 << 5,
	RichTextEditorFeatureStrikeThrough					= 1 << 6,
	RichTextEditorFeatureTextAlignmentLeft				= 1 << 7,
	RichTextEditorFeatureTextAlignmentCenter			= 1 << 8,
	RichTextEditorFeatureTextAlignmentRight				= 1 << 9,
	RichTextEditorFeatureTextAlignmentJustified			= 1 << 10,
	RichTextEditorFeatureTextBackgroundColor			= 1 << 11,
	RichTextEditorFeatureTextForegroundColor			= 1 << 12,
	RichTextEditorFeatureParagraphIndentation			= 1 << 13, // RichTextEditorFeatureParagraphIndentation includes increase and decrease
	RichTextEditorFeatureParagraphFirstLineIndentation	= 1 << 14, // also included in RichTextEditorFeatureParagraphIndentation
	RichTextEditorFeatureBulletList						= 1 << 15,
	RichTextEditorTextAttachment						= 1 << 16,
	RichTextEditorFeatureUndoRedo						= 1 << 17,
	RichTextEditorFeatureDismissKeyboard				= 1 << 18,
	RichTextEditorFeatureAll							= 1 << 19,
    RichTextEditorFeatureParagraphIndentationDecrease   = 1 << 20, // RichTextEditorFeatureParagraphIndentation includes increase and decrease
    RichTextEditorFeatureParagraphIndentationIncrease   = 1 << 21, // RichTextEditorFeatureParagraphIndentation includes increase and decrease
};

@class RichTextEditor;

@protocol RichTextEditorDataSource <NSObject>

@optional

- (NSArray *)fontSizeSelectionForRichTextEditor:(RichTextEditor *)richTextEditor;
- (NSArray *)fontFamilySelectionForRichTextEditor:(RichTextEditor *)richTextEditor;
- (RichTextEditorToolbarPresentationStyle)presentationStyleForRichTextEditor:(RichTextEditor *)richTextEditor;
- (UIModalPresentationStyle)modalPresentationStyleForRichTextEditor:(RichTextEditor *)richTextEditor;
- (UIModalTransitionStyle)modalTransitionStyleForRichTextEditor:(RichTextEditor *)richTextEditor;
- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor;
- (BOOL)shouldDisplayToolbarForRichTextEditor:(RichTextEditor *)richTextEditor;
- (BOOL)shouldDisplayRichTextOptionsInMenuControllerForRichTextEditor:(RichTextEditor *)richTextEditor;
- (UIViewController <RichTextEditorColorPicker> *)colorPickerForRichTextEditor:(RichTextEditor *)richTextEditor withAction:(RichTextEditorColorPickerAction)action;
- (UIViewController <RichTextEditorFontPicker> *)fontPickerForRichTextEditor:(RichTextEditor *)richTextEditor;
- (UIViewController <RichTextEditorFontSizePicker> *)fontSizePickerForRichTextEditor:(RichTextEditor *)richTextEditor;

// images should be 24x24 for @1x, 48x48 for @2x, and 72x72 for @3x
// return nil in imageForToolbarInRichTextEditor:forFeature: if you do not have a custom image for that feature.
// note that RichTextEditorFeatureParagraphIndentation is not used here: it uses the more specific RichTextEditorFeature
// items of RichTextEditorFeatureParagraphFirstLineIndentation, RichTextEditorFeatureParagraphIndentationDecrease,
// and RichTextEditorFeatureParagraphIndentationIncrease.
- (UIImage *)imageForToolbarInRichTextEditor:(RichTextEditor *)richTextEditor forFeature:(RichTextEditorFeature)feature;

@end

typedef NS_ENUM(NSInteger, RichTextEditorPreviewChange) {
	RichTextEditorPreviewChangeBold,
	RichTextEditorPreviewChangeItalic,
	RichTextEditorPreviewChangeUnderline,
	RichTextEditorPreviewChangeStrikethrough,
	RichTextEditorPreviewChangeFontResize,
	RichTextEditorPreviewChangeHighlight,
	RichTextEditorPreviewChangeFontSize,
	RichTextEditorPreviewChangeFontName,
	RichTextEditorPreviewChangeFontColor,
	RichTextEditorPreviewChangeIndentIncrease,
	RichTextEditorPreviewChangeIndentDecrease,
	RichTextEditorPreviewChangeParagraphFirstLineHeadIndent,
	RichTextEditorPreviewChangeTextAlignment,
	RichTextEditorPreviewChangeCut,
	RichTextEditorPreviewChangePaste,
	RichTextEditorPreviewChangeTextAttachment,
	RichTextEditorPreviewChangeSpace,
	RichTextEditorPreviewChangeEnter,
	RichTextEditorPreviewChangeBullet,
	RichTextEditorPreviewChangeMouseDown,
	RichTextEditorPreviewChangeArrowKey,
	RichTextEditorPreviewChangeKeyDown,
	RichTextEditorPreviewChangeDelete
};

@protocol RichTextEditorDelegate <NSObject>

@required

-(void)selectionForEditor:(RichTextEditor*)editor changedTo:(NSRange)range isBold:(BOOL)isBold isItalic:(BOOL)isItalic isUnderline:(BOOL)isUnderline isInBulletedList:(BOOL)isInBulletedList textBackgroundColor:(UIColor*)textBackgroundColor textColor:(UIColor*)textColor;

@optional

- (BOOL)richTextEditor:(RichTextEditor*)editor keyDownEvent:(UIEvent*)event; // return YES if handled by delegate, NO if RTE should process it
- (void)richTextEditor:(RichTextEditor*)editor changeAboutToOccurOfType:(RichTextEditorPreviewChange)type;

- (BOOL)handlesUndoRedoForText;
- (void)userPerformedUndo; // TODO: remove?
- (void)userPerformedRedo; // TODO: remove?
- (NSUInteger)levelsOfUndo;

@end

@interface RichTextEditor : UITextView

@property (assign) IBOutlet id <RichTextEditorDataSource> dataSource;
@property (assign) IBOutlet id <RichTextEditorDelegate> rteDelegate;

@property (nonatomic, assign) CGFloat defaultIndentationSize;
@property BOOL inBulletedList;

// If YES, only pastes text as rich text if the copy operation came from this class.
// Note: not this *object* -- this class (so other RichTextEditor boxes can paste
// between each other). If the text did not come from a RichTextEditor box, then
// pastes as plain text.
// If NO, performs the default paste: operation.
// Defaults to YES.
@property BOOL allowsRichTextPasteOnlyFromThisClass;

- (id)textViewDelegate;

- (void)setBorderColor:(UIColor*)borderColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)changeToAttributedString:(NSAttributedString*)string;
- (NSString *)htmlString;
- (void)setHtmlString:(NSString *)htmlString;
+ (NSString *)htmlStringFromAttributedText:(NSAttributedString*)text;
+ (NSAttributedString*)attributedStringFromHTMLString:(NSString *)htmlString;

+ (NSString *)convertPreviewChangeTypeToString:(RichTextEditorPreviewChange)changeType withNonSpecialChangeText:(BOOL)shouldReturnStringForNonSpecialType;

- (void)enableUndoToolbarButton:(BOOL)shouldEnable;
- (void)enableRedoToolbarButton:(BOOL)shouldEnable;

@end

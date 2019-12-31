//
//  RichTextEditorToolbar.m
//  RichTextEdtor
//
//  Created by Aryan Gh on 7/21/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/iOS-Rich-Text-Editor
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

#import "RichTextEditorToolbar.h"
#import <CoreText/CoreText.h>
#import "RichTextEditorFontSizePickerViewController.h"
#import "RichTextEditorFontPickerViewController.h"
#import "RichTextEditorColorPickerViewController.h"
#import "RichTextEditorToggleButton.h"
#import "UIFont+RichTextEditor.h"

#define ITEM_SEPARATOR_SPACE 5
#define ITEM_TOP_AND_BOTTOM_BORDER 5
#define ITEM_WIDTH 40

@interface RichTextEditorToolbar() <RichTextEditorFontSizePickerViewControllerDelegate, RichTextEditorFontSizePickerViewControllerDataSource, RichTextEditorFontPickerViewControllerDelegate, RichTextEditorFontPickerViewControllerDataSource, RichTextEditorColorPickerViewControllerDataSource, RichTextEditorColorPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak) UIViewController *presentedViewController; // e.g. for color picker
@property (nonatomic, strong) RichTextEditorToggleButton *btnDismissKeyboard;
@property (nonatomic, strong) RichTextEditorToggleButton *btnBold;
@property (nonatomic, strong) RichTextEditorToggleButton *btnItalic;
@property (nonatomic, strong) RichTextEditorToggleButton *btnUnderline;
@property (nonatomic, strong) RichTextEditorToggleButton *btnStrikeThrough;
@property (nonatomic, strong) RichTextEditorToggleButton *btnFontSize;
@property (nonatomic, strong) RichTextEditorToggleButton *btnFont;
@property (nonatomic, strong) RichTextEditorToggleButton *btnBackgroundColor;
@property (nonatomic, strong) RichTextEditorToggleButton *btnForegroundColor;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextAlignmentLeft;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextAlignmentCenter;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextAlignmentRight;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextAlignmentJustified;
@property (nonatomic, strong) RichTextEditorToggleButton *btnParagraphIndent;
@property (nonatomic, strong) RichTextEditorToggleButton *btnParagraphOutdent;
@property (nonatomic, strong) RichTextEditorToggleButton *btnParagraphFirstLineHeadIndent;
@property (nonatomic, strong) RichTextEditorToggleButton *btnBulletList;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextAttachment;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextUndo;
@property (nonatomic, strong) RichTextEditorToggleButton *btnTextRedo;

@end

@implementation RichTextEditorToolbar

#pragma mark - Initialization -

- (id)initWithFrame:(CGRect)frame delegate:(id <RichTextEditorToolbarDelegate>)delegate dataSource:(id <RichTextEditorToolbarDataSource>)dataSource {
	if (self = [super initWithFrame:frame]) {
		self.toolbarDelegate = delegate;
		self.dataSource = dataSource;

        NSBundle *frameWorkBundle = [NSBundle bundleForClass:[self class]];
        if (@available(iOS 11, *)) {
            self.backgroundColor = [UIColor colorNamed:@"toolbar-background" inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
        } else {
            self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        }
		self.layer.borderWidth = .7;
		self.layer.borderColor = UIColor.lightGrayColor.CGColor;
		
		[self initializeButtons];
        [self populateToolbar];
	}
	
	return self;
}

#pragma mark - Public Methods -

- (void)redraw {
    [self initializeButtons];
	[self populateToolbar];
}

- (void)updateStateWithAttributes:(NSDictionary *)attributes {
	UIFont *font = [attributes objectForKey:NSFontAttributeName];
	NSParagraphStyle *paragraphStyle = [attributes objectForKey:NSParagraphStyleAttributeName];
	[self.btnFontSize setTitle:[NSString stringWithFormat:@"%.f", font.pointSize] forState:UIControlStateNormal];
	[self.btnFont setTitle:font.familyName forState:UIControlStateNormal];
	
	self.btnBold.on = [font isBold];
	self.btnItalic.on = [font isItalic];
	
	self.btnTextAlignmentLeft.on = NO;
	self.btnTextAlignmentCenter.on = NO;
	self.btnTextAlignmentRight.on = NO;
	self.btnTextAlignmentJustified.on = NO;
	self.btnParagraphFirstLineHeadIndent.on = paragraphStyle.firstLineHeadIndent > paragraphStyle.headIndent ? YES : NO;
	
	switch (paragraphStyle.alignment) {
		case NSTextAlignmentLeft:
			self.btnTextAlignmentLeft.on = YES;
			break;
		case NSTextAlignmentCenter:
			self.btnTextAlignmentCenter.on = YES;
			break;
		case NSTextAlignmentRight:
			self.btnTextAlignmentRight.on = YES;
			break;
		case NSTextAlignmentJustified:
			self.btnTextAlignmentJustified.on = YES;
			break;
		default:
			self.btnTextAlignmentLeft.on = YES;
			break;
	}
	
	NSNumber *existingUnderlineStyle = [attributes objectForKey:NSUnderlineStyleAttributeName];
	self.btnUnderline.on = !existingUnderlineStyle || existingUnderlineStyle.intValue == NSUnderlineStyleNone ? NO :YES;
	
	NSNumber *existingStrikeThrough = [attributes objectForKey:NSStrikethroughStyleAttributeName];
	self.btnStrikeThrough.on = !existingStrikeThrough || existingStrikeThrough.intValue == NSUnderlineStyleNone ? NO :YES;
	
	[self populateToolbar];
}

#pragma mark - IBActions -

- (void)boldSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectBold];
}

- (void)italicSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectItalic];
}

- (void)underLineSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectUnderline];
}

- (void)strikeThroughSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectStrikeThrough];
}

- (void)bulletListSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectBulletListWithCaller:self];
}

- (void)paragraphIndentSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectParagraphIndentation:ParagraphIndentationIncrease];
}

- (void)paragraphOutdentSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectParagraphIndentation:ParagraphIndentationDecrease];
}

- (void)paragraphHeadIndentOutdentSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectParagraphFirstLineHeadIndent];
}

- (void)undoSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectUndo];
}

- (void)redoSelected:(UIButton *)sender {
	[self.toolbarDelegate richTextEditorToolbarDidSelectRedo];
}

- (void)dismissKeyboard:(UIButton *)sender {
    [self.toolbarDelegate richTextEditorToolbarDidSelectDismissKeyboard];
}

- (void)fontSizeSelected:(UIButton *)sender {
	UIViewController <RichTextEditorFontSizePicker> *fontSizePicker = [self.dataSource fontSizePickerForRichTextEditorToolbar];
	
    if (!fontSizePicker) {
		fontSizePicker = [[RichTextEditorFontSizePickerViewController alloc] init];
    }
	
	fontSizePicker.delegate = self;
	fontSizePicker.dataSource = self;
	[self presentViewController:fontSizePicker fromView:sender];
}

- (void)fontSelected:(UIButton *)sender {
	UIViewController <RichTextEditorFontPicker> *fontPicker = [self.dataSource fontPickerForRichTextEditorToolbar];
	
    if (!fontPicker) {
		fontPicker = [[RichTextEditorFontPickerViewController alloc] init];
    }
    
	fontPicker.delegate = self;
	fontPicker.dataSource = self;
	[self presentViewController:fontPicker fromView:sender];
}

- (void)textBackgroundColorSelected:(UIButton *)sender {
	UIViewController <RichTextEditorColorPicker> *colorPicker = [self.dataSource colorPickerForRichTextEditorToolbarWithAction:RichTextEditorColorPickerActionTextBackgroundColor];
	
    if (!colorPicker) {
		colorPicker = [[RichTextEditorColorPickerViewController alloc] init];
    }
    
	colorPicker.action = RichTextEditorColorPickerActionTextBackgroundColor;
	colorPicker.delegate = self;
	colorPicker.dataSource = self;
	[self presentViewController:colorPicker fromView:sender];
}

- (void)textForegroundColorSelected:(UIButton *)sender {
	UIViewController <RichTextEditorColorPicker> *colorPicker = [self.dataSource colorPickerForRichTextEditorToolbarWithAction:RichTextEditorColorPickerActionTextForegroundColor];
	
    if (!colorPicker) {
		colorPicker = [[RichTextEditorColorPickerViewController alloc] init];
    }
	
	colorPicker.action = RichTextEditorColorPickerActionTextForegroundColor;
	colorPicker.delegate = self;
	colorPicker.dataSource = self;
	[self presentViewController:colorPicker fromView:sender];
}

- (void)textAlignmentSelected:(UIButton *)sender {
	NSTextAlignment textAlignment = NSTextAlignmentLeft;
	
    if (sender == self.btnTextAlignmentLeft) {
		textAlignment = NSTextAlignmentLeft;
    }
    else if (sender == self.btnTextAlignmentCenter) {
		textAlignment = NSTextAlignmentCenter;
    }
    else if (sender == self.btnTextAlignmentRight) {
		textAlignment = NSTextAlignmentRight;
    }
    else {
		textAlignment = NSTextAlignmentJustified;
    }
	
	[self.toolbarDelegate richTextEditorToolbarDidSelectTextAlignment:textAlignment];
}

- (void)textAttachmentSelected:(UIButton *)sender {
	UIImagePickerController *vc = [[UIImagePickerController alloc] init];
	vc.delegate = self;
	[self presentViewController:vc fromView:self.btnTextAttachment];
}

#pragma mark - Private Methods -

- (void)populateToolbar {
	CGRect visibleRect;
	visibleRect.origin = self.contentOffset;
	visibleRect.size = self.bounds.size;
	
    // Remove any existing subviews.
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    // Populate the toolbar with the given features.
    RichTextEditorFeature features = [self.dataSource featuresEnabledForRichTextEditorToolbar];
    UIView *lastAddedView = nil;
    
    self.hidden = (features == RichTextEditorFeatureNone);
	
	if (self.hidden) {
		return;
	}
	
    // If iPhone device, allow for keyboard dismissal
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
        ((features & RichTextEditorFeatureDismissKeyboard) || (features & RichTextEditorFeatureAll))) {
        lastAddedView = [self addView:self.btnDismissKeyboard afterView:lastAddedView withSpacing:YES];
        lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
    }
	
	if (features & RichTextEditorFeatureUndoRedo || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextUndo afterView:lastAddedView withSpacing:YES];
		lastAddedView = [self addView:self.btnTextRedo afterView:lastAddedView withSpacing:YES];
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// Font selection
	if (features & RichTextEditorFeatureFont || features & RichTextEditorFeatureAll) {
		UIView *separatorView = [self separatorView];
		CGSize size = [self.btnFont sizeThatFits:CGSizeZero];
		CGRect rect = self.btnFont.frame;
		rect.size.width = MAX(size.width + 25, 120);
		self.btnFont.frame = rect;
		
		lastAddedView = [self addView:self.btnFont afterView:lastAddedView withSpacing:YES];
		lastAddedView = [self addView:separatorView afterView:lastAddedView withSpacing:YES];
	}
	
	// Font size
	if (features & RichTextEditorFeatureFontSize || features & RichTextEditorFeatureAll) {
		UIView *separatorView = [self separatorView];
		lastAddedView = [self addView:self.btnFontSize afterView:lastAddedView withSpacing:YES];
		lastAddedView = [self addView:separatorView afterView:lastAddedView withSpacing:YES];
	}
	
	// Bold
	if (features & RichTextEditorFeatureBold || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnBold afterView:lastAddedView withSpacing:YES];
	}
	
	// Italic
	if (features & RichTextEditorFeatureItalic || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnItalic afterView:lastAddedView withSpacing:YES];
	}
	
	// Underline
	if (features & RichTextEditorFeatureUnderline || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnUnderline afterView:lastAddedView withSpacing:YES];
	}
	
	// Strikethrough
	if (features & RichTextEditorFeatureStrikeThrough || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnStrikeThrough afterView:lastAddedView withSpacing:YES];
	}
	
	// Separator view after font properties.
	if (features & RichTextEditorFeatureBold || features & RichTextEditorFeatureItalic || features & RichTextEditorFeatureUnderline || features & RichTextEditorFeatureStrikeThrough || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// Align left
	if (features & RichTextEditorFeatureTextAlignmentLeft || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextAlignmentLeft afterView:lastAddedView withSpacing:YES];
	}
	
	// Align center
	if (features & RichTextEditorFeatureTextAlignmentCenter || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextAlignmentCenter afterView:lastAddedView withSpacing:YES];
	}
	
	// Align right
	if (features & RichTextEditorFeatureTextAlignmentRight || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextAlignmentRight afterView:lastAddedView withSpacing:YES];
	}
	
	// Align justified
	if (features & RichTextEditorFeatureTextAlignmentJustified || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextAlignmentJustified afterView:lastAddedView withSpacing:YES];
	}
	
	// Separator view after alignment section
	if (features & RichTextEditorFeatureTextAlignmentLeft || features & RichTextEditorFeatureTextAlignmentCenter || features & RichTextEditorFeatureTextAlignmentRight || features & RichTextEditorFeatureTextAlignmentJustified || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// Paragraph indentation
	if (features & RichTextEditorFeatureParagraphIndentation || features & RichTextEditorFeatureParagraphIndentationIncrease ||
        features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnParagraphOutdent afterView:lastAddedView  withSpacing:YES];
		lastAddedView = [self addView:self.btnParagraphIndent afterView:lastAddedView withSpacing:YES];
	}
	
	// Paragraph first line indentation
	if (features & RichTextEditorFeatureParagraphFirstLineIndentation || features & RichTextEditorFeatureParagraphIndentationDecrease ||
        features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnParagraphFirstLineHeadIndent afterView:lastAddedView withSpacing:YES];
	}
	
	// Separator view after Indentation
	if (features & RichTextEditorFeatureParagraphIndentation || features & RichTextEditorFeatureParagraphFirstLineIndentation ||
        features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// Background color
	if (features & RichTextEditorFeatureTextBackgroundColor || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnBackgroundColor afterView:lastAddedView withSpacing:YES];
	}
	
	// Text color
	if (features & RichTextEditorFeatureTextForegroundColor || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnForegroundColor afterView:lastAddedView withSpacing:YES];
	}
	
	// Separator view after color section
	if (features & RichTextEditorFeatureTextBackgroundColor || features & RichTextEditorFeatureTextForegroundColor || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// Bullet List
	if (features & RichTextEditorFeatureBulletList || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnBulletList afterView:lastAddedView withSpacing:YES];
	}
	
	// Separator view after color section
	if (features & RichTextEditorFeatureBulletList || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:[self separatorView] afterView:lastAddedView withSpacing:YES];
	}
	
	// I think he wanted TextAttachment here, not BulletList
	if (features & RichTextEditorTextAttachment || features & RichTextEditorFeatureAll) {
		lastAddedView = [self addView:self.btnTextAttachment afterView:lastAddedView withSpacing:YES];
	}
	
	[self scrollRectToVisible:visibleRect animated:NO];
}

- (void)initializeButtons {
	self.btnFont = [self buttonWithImageNamed:@"keyboard-arrow-up"
										width:120
								  andSelector:@selector(fontSelected:)];
	[self.btnFont setTitle:@"Font" forState:UIControlStateNormal];
	// Put the image on the right side -- http://stackoverflow.com/a/32174204/3938401
	self.btnFont.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFont.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFont.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFont.titleLabel.font = [self.btnFont.titleLabel.font fontWithSize:13];
	
	self.btnFontSize = [self buttonWithImageNamed:@"keyboard-arrow-up"
											width:50
									  andSelector:@selector(fontSizeSelected:)];
	[self.btnFontSize setTitle:@"14" forState:UIControlStateNormal];
	// Put the image on the right side -- http://stackoverflow.com/a/32174204/3938401
	self.btnFontSize.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFontSize.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFontSize.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
	self.btnFontSize.titleLabel.font = [self.btnFont.titleLabel.font fontWithSize:16];
	
	self.btnBold = [self buttonWithDefaultImageNamed:@"format-bold"
                                         andSelector:@selector(boldSelected:)
                                          forFeature:RichTextEditorFeatureBold];
	
	self.btnItalic = [self buttonWithDefaultImageNamed:@"format-italic"
                                           andSelector:@selector(italicSelected:)
                                            forFeature:RichTextEditorFeatureItalic];
	
	self.btnUnderline = [self buttonWithDefaultImageNamed:@"format-underlined"
                                              andSelector:@selector(underLineSelected:)
                                               forFeature:RichTextEditorFeatureUnderline];
	
	self.btnStrikeThrough = [self buttonWithDefaultImageNamed:@"format-strikethrough"
                                                  andSelector:@selector(strikeThroughSelected:)
                                                   forFeature:RichTextEditorFeatureStrikeThrough];
	
	self.btnTextAlignmentLeft = [self buttonWithDefaultImageNamed:@"format-align-left"
                                                      andSelector:@selector(textAlignmentSelected:)
                                                       forFeature:RichTextEditorFeatureTextAlignmentLeft];
	
	self.btnTextAlignmentCenter = [self buttonWithDefaultImageNamed:@"format-align-center"
                                                        andSelector:@selector(textAlignmentSelected:)
                                                         forFeature:RichTextEditorFeatureTextAlignmentCenter];
	
	self.btnTextAlignmentRight = [self buttonWithDefaultImageNamed:@"format-align-right"
                                                       andSelector:@selector(textAlignmentSelected:)
                                                        forFeature:RichTextEditorFeatureTextAlignmentRight];
	
	self.btnTextAlignmentJustified = [self buttonWithDefaultImageNamed:@"format-align-justify"
                                                           andSelector:@selector(textAlignmentSelected:)
                                                            forFeature:RichTextEditorFeatureTextAlignmentJustified];
	
	self.btnForegroundColor = [self buttonWithDefaultImageNamed:@"format-color"
                                                    andSelector:@selector(textForegroundColorSelected:)
                                                     forFeature:RichTextEditorFeatureTextForegroundColor];
	
	self.btnBackgroundColor = [self buttonWithDefaultImageNamed:@"format-color-fill"
                                                    andSelector:@selector(textBackgroundColorSelected:)
                                                     forFeature:RichTextEditorFeatureTextBackgroundColor];
	
	self.btnBulletList = [self buttonWithDefaultImageNamed:@"format-list-bulleted"
                                               andSelector:@selector(bulletListSelected:)
                                                forFeature:RichTextEditorFeatureBulletList];
	
	self.btnParagraphIndent = [self buttonWithDefaultImageNamed:@"indent-increase"
                                                    andSelector:@selector(paragraphIndentSelected:)
                                                     forFeature:RichTextEditorFeatureParagraphIndentationIncrease];
	
	self.btnParagraphOutdent = [self buttonWithDefaultImageNamed:@"indent-decrease"
                                                     andSelector:@selector(paragraphOutdentSelected:)
                                                      forFeature:RichTextEditorFeatureParagraphIndentationDecrease];
	
	self.btnParagraphFirstLineHeadIndent = [self buttonWithDefaultImageNamed:@"format-first-line-indent"
                                                                 andSelector:@selector(paragraphHeadIndentOutdentSelected:)
                                                                  forFeature:RichTextEditorFeatureParagraphFirstLineIndentation];
	
	self.btnTextAttachment = [self buttonWithDefaultImageNamed:@"insert-photo"
                                                   andSelector:@selector(textAttachmentSelected:)
                                                    forFeature:RichTextEditorTextAttachment];
    
	self.btnTextUndo = [self buttonWithDefaultImageNamed:@"undo"
                                             andSelector:@selector(undoSelected:)
                                              forFeature:RichTextEditorFeatureUndo];
    
	self.btnTextRedo = [self buttonWithDefaultImageNamed:@"redo"
                                             andSelector:@selector(redoSelected:)
                                              forFeature:RichTextEditorFeatureRedo];
    
    self.btnDismissKeyboard = [self buttonWithDefaultImageNamed:@"keyboard-hide"
                                                    andSelector:@selector(dismissKeyboard:)
                                                     forFeature:RichTextEditorFeatureDismissKeyboard];
}


- (void)enableUndoButton:(BOOL)shouldEnable {
	if (self.btnTextUndo) {
		self.btnTextUndo.enabled = shouldEnable;
	}
}

- (void)enableRedoButton:(BOOL)shouldEnable {
	if (self.btnTextRedo) {
		self.btnTextRedo.enabled = shouldEnable;
	}
}

- (RichTextEditorToggleButton *)createToolbarButtonWithWidth:(NSInteger)width andSelector:(SEL)selector {
    RichTextEditorToggleButton *button = [[RichTextEditorToggleButton alloc] init];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, width, 0);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    if (@available(iOS 13, *)) {
        button.titleLabel.textColor = UIColor.labelColor;
        [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
    } else {
        button.titleLabel.textColor = UIColor.blackColor;
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return button;
}

- (RichTextEditorToggleButton *)buttonWithImageNamed:(NSString *)imageName width:(NSInteger)width andSelector:(SEL)selector {
    RichTextEditorToggleButton *button = [self createToolbarButtonWithWidth:width andSelector:selector];
	
	NSBundle *frameWorkBundle = [NSBundle bundleForClass:[self class]];
	UIImage *image = [UIImage imageNamed:imageName inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
	[button setImage:image forState:UIControlStateNormal];
	
	return button;
}

- (RichTextEditorToggleButton *)buttonWithImageNamed:(NSString *)imageName andSelector:(SEL)selector {
	return [self buttonWithImageNamed:imageName width:ITEM_WIDTH andSelector:selector];
}

- (RichTextEditorToggleButton *)buttonWithDefaultImage:(UIImage *)image width:(NSInteger)width andSelector:(SEL)selector forFeature:(RichTextEditorFeature)feature {
    RichTextEditorToggleButton *button = [self createToolbarButtonWithWidth:width andSelector:selector];
    if ([self.dataSource respondsToSelector:@selector(imageForRichTextEditorToolbarFeature:)]) {
        UIImage *customImage = [self.dataSource imageForRichTextEditorToolbarFeature:feature];
        if (customImage) {
            [button setImage:customImage forState:UIControlStateNormal];
        }
        else {
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    else {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    return button;
}

- (RichTextEditorToggleButton *)buttonWithDefaultImage:(UIImage *)image andSelector:(SEL)selector forFeature:(RichTextEditorFeature)feature {
    return [self buttonWithDefaultImage:image width:ITEM_WIDTH andSelector:selector forFeature:feature];
}

- (RichTextEditorToggleButton *)buttonWithDefaultImageNamed:(NSString *)imageName andSelector:(SEL)selector forFeature:(RichTextEditorFeature)feature {
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
    return [self buttonWithDefaultImage:image width:ITEM_WIDTH andSelector:selector forFeature:feature];
}

- (UIView *)separatorView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    if (@available(iOS 13, *)) {
        view.backgroundColor = UIColor.opaqueSeparatorColor;
    } else {
        view.backgroundColor = UIColor.lightGrayColor;
    }
	
	return view;
}

// @return Returns the added view.
- (UIView*)addView:(UIView *)view afterView:(UIView *)otherView withSpacing:(BOOL)space {
	CGRect otherViewRect = otherView ? otherView.frame : CGRectZero;
	CGRect rect = view.frame;
	rect.origin.x = otherViewRect.size.width + otherViewRect.origin.x;
    if (space) {
		rect.origin.x += ITEM_SEPARATOR_SPACE;
    }
	
	rect.origin.y = ITEM_TOP_AND_BOTTOM_BORDER;
	rect.size.height = self.frame.size.height - (2 * ITEM_TOP_AND_BOTTOM_BORDER);
	view.frame = rect;
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	[self addSubview:view];
	[self updateContentSize];
	return view;
}

- (void)updateContentSize {
	NSInteger maxViewlocation = 0;
	
	for (UIView *view in self.subviews) {
		NSInteger endLocation = view.frame.size.width + view.frame.origin.x;
        if (endLocation > maxViewlocation) {
			maxViewlocation = endLocation;
        }
	}
	
	self.contentSize = CGSizeMake(maxViewlocation + ITEM_SEPARATOR_SPACE, self.frame.size.height);
}

- (void)presentViewController:(UIViewController *)viewController fromView:(UIView *)view {
	if ([self.dataSource presentationStyleForRichTextEditorToolbar] == RichTextEditorToolbarPresentationStyleModal) {
		viewController.modalPresentationStyle = [self.dataSource modalPresentationStyleForRichTextEditorToolbar];
		viewController.modalTransitionStyle = [self.dataSource modalTransitionStyleForRichTextEditorToolbar];
        if (viewController.modalPresentationStyle == UIModalPresentationPopover) {
            viewController.popoverPresentationController.sourceView = view;
        }
	}
	else if ([self.dataSource presentationStyleForRichTextEditorToolbar] == RichTextEditorToolbarPresentationStylePopover) {
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        viewController.popoverPresentationController.sourceView = view;
	}
    [[self.dataSource firstAvailableViewControllerForRichTextEditorToolbar] presentViewController:viewController animated:YES completion:nil];
    self.presentedViewController = viewController;
}

- (void)dismissViewController {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [[self.dataSource firstAvailableViewControllerForRichTextEditorToolbar] dismissViewControllerAnimated:YES completion:nil];
    }
    self.presentedViewController = nil; // it's already a weak pointer, but just for safety's sake...
	
	[self.toolbarDelegate richTextEditorToolbarDidDismissViewController];
}

#pragma mark - RichTextEditorColorPickerViewControllerDelegate & RichTextEditorColorPickerViewControllerDataSource Methods -

- (void)richTextEditorColorPickerViewControllerDidSelectColor:(UIColor *)color withAction:(RichTextEditorColorPickerAction)action {
	if (action == RichTextEditorColorPickerActionTextBackgroundColor) {
		[self.toolbarDelegate richTextEditorToolbarDidSelectTextBackgroundColor:color];
	}
	else {
		[self.toolbarDelegate richTextEditorToolbarDidSelectTextForegroundColor:color];
	}
	
	[self dismissViewController];
}

- (void)richTextEditorColorPickerViewControllerDidSelectClose {
	[self dismissViewController];
}

- (BOOL)richTextEditorColorPickerViewControllerShouldDisplayToolbar {
	return [self.dataSource presentationStyleForRichTextEditorToolbar] == RichTextEditorToolbarPresentationStyleModal;
}

#pragma mark - RichTextEditorFontSizePickerViewControllerDelegate & RichTextEditorFontSizePickerViewControllerDataSource Methods -

- (void)richTextEditorFontSizePickerViewControllerDidSelectFontSize:(NSNumber *)fontSize {
	[self.toolbarDelegate richTextEditorToolbarDidSelectFontSize:fontSize];
	[self dismissViewController];
}

- (void)richTextEditorFontSizePickerViewControllerDidSelectClose {
	[self dismissViewController];
}

- (BOOL)richTextEditorFontSizePickerViewControllerShouldDisplayToolbar {
	return ([self.dataSource presentationStyleForRichTextEditorToolbar] == RichTextEditorToolbarPresentationStyleModal) ? YES: NO;
}

- (NSArray *)richTextEditorFontSizePickerViewControllerCustomFontSizesForSelection {
	return [self.dataSource fontSizeSelectionForRichTextEditorToolbar];
}

#pragma mark - RichTextEditorFontPickerViewControllerDelegate & RichTextEditorFontPickerViewControllerDataSource Methods -

- (void)richTextEditorFontPickerViewControllerDidSelectFontWithName:(NSString *)fontName {
	[self.toolbarDelegate richTextEditorToolbarDidSelectFontWithName:fontName];
	[self dismissViewController];
}

- (void)richTextEditorFontPickerViewControllerDidSelectClose {
	[self dismissViewController];
}

- (NSArray *)richTextEditorFontPickerViewControllerCustomFontFamilyNamesForSelection {
	return [self.dataSource fontFamilySelectionForRichTextEditorToolbar];
}

- (BOOL)richTextEditorFontPickerViewControllerShouldDisplayToolbar {
	return ([self.dataSource presentationStyleForRichTextEditorToolbar] == RichTextEditorToolbarPresentationStyleModal) ? YES: NO;
}

#pragma mark - UIImagePickerViewControllerDelegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[self.toolbarDelegate richTextEditorToolbarDidSelectTextAttachment:image];
	[self dismissViewController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewController];
}

@end

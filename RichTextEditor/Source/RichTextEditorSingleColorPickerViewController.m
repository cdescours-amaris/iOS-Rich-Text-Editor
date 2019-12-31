//
//  RichTextEditorSingleColorPickerViewController.m
//  RichTextEditor
//
//  Created by Michael Babienco on 12/31/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import "RichTextEditorSingleColorPickerViewController.h"
#import "CircleWithCheckmarkCollectionViewCell.h"

@interface RichTextEditorSingleColorPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property UICollectionView *collectionView;
@property UILabel *titleLabel;

@end

@implementation RichTextEditorSingleColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.colors || self.colors.count == 0) {
        self.colors = @[UIColor.systemRedColor, UIColor.systemBlueColor, UIColor.systemGreenColor, UIColor.systemOrangeColor, UIColor.systemYellowColor, UIColor.systemPinkColor, UIColor.systemPurpleColor, UIColor.systemTealColor];
    }
    // adding navigation bar: https://stackoverflow.com/a/21448861/3938401
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    navItem.leftBarButtonItem = cancelBtn;
    navbar.translatesAutoresizingMaskIntoConstraints = NO;
    [navbar setItems:@[navItem]];
    navbar.items = @[navItem];
    [self.view addSubview:navbar];
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    if (self.action == RichTextEditorColorPickerActionTextForegroundColor) {
        self.titleLabel.text = NSLocalizedString(@"Pick text color", @"");
    } else if (self.action == RichTextEditorColorPickerActionTextBackgroundColor) {
        self.titleLabel.text = NSLocalizedString(@"Pick highlight color", @"");
    }
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //NSLog(@"%d", self.popoverPresentationController != nil);
    //NSLog(@"%d", self.modalPresentationStyle == UIModalPresentationPopover);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
        self.titleLabel.backgroundColor = UIColor.systemBackgroundColor;
        self.collectionView.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
        self.titleLabel.backgroundColor = UIColor.whiteColor;
        self.collectionView.backgroundColor = UIColor.whiteColor;
    }
    [self.view addSubview:self.collectionView];
    // https://stackoverflow.com/a/47076040/3938401
    CGFloat spacing = 6.0f;
    if (@available(iOS 11, *)) {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        [navbar.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:0].active = YES;
        [navbar.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:0].active = YES;
        [navbar.topAnchor constraintEqualToAnchor:guide.topAnchor constant:0].active = YES;
        
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:spacing].active = YES;
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-spacing].active = YES;
        [self.titleLabel.topAnchor constraintEqualToAnchor:navbar.bottomAnchor constant:spacing].active = YES;
        
        [self.collectionView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:spacing].active = YES;
        [self.collectionView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-spacing].active = YES;
        [self.collectionView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:spacing].active = YES;
        [self.collectionView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor constant:-spacing].active = YES;
    } else {
        UILayoutGuide *margins = self.view.layoutMarginsGuide;
        [navbar.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:0].active = YES;
        [navbar.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:0].active = YES;
        [navbar.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor constant:0].active = YES;
        
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:spacing].active = YES;
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:spacing].active = YES;
        [self.titleLabel.topAnchor constraintEqualToAnchor:navbar.bottomAnchor constant:spacing].active = YES;
        
        [self.collectionView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:spacing].active = YES;
        [self.collectionView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:-spacing].active = YES;
        [self.collectionView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:spacing].active = YES;
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:-spacing].active = YES;
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleWithCheckmarkCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"CircleCheckmarkCell"];
    
    self.preferredContentSize = CGSizeMake(300, 100);
    [self.collectionView reloadData];
}

-(void)onTapCancel:(id)sender {
    if (self.delegate) {
        [self.delegate richTextEditorColorPickerViewControllerDidSelectClose];
    }
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleWithCheckmarkCollectionViewCell *cell = (CircleWithCheckmarkCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CircleCheckmarkCell" forIndexPath:indexPath];
    cell.color = self.colors[indexPath.row];
    NSLog(@"%@", self.selectedColor);
    cell.selected = self.selectedColor && [cell.color isEqual:self.selectedColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate richTextEditorColorPickerViewControllerDidSelectColor:self.colors[indexPath.row] withAction:self.action];
    }
}

@end

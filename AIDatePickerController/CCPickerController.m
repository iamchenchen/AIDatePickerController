//
//  CCPickerController.m
//  Demo
//
//  Created by Chenchen Zheng on 11/12/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "CCPickerController.h"

static NSTimeInterval const CCAnimatedTransitionDuration = 0.4;

@interface CCPickerController () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


//where there are cancel and dismiss?
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *selectButton;
@property (nonatomic) UIButton *dismissButton;
@property (nonatomic) UIView *buttonDivierView;
@property (nonatomic) UIView *buttonContainerView;
@property (nonatomic) UIView *dataPickerContainerView;

@property (nonatomic) NSInteger selected;

//UIButton Actions

- (void)didTouchCancelButton:(id)sender;
- (void)didTouchSelectButton:(id)sender;

@end

@implementation CCPickerController

#pragma mark - Init


- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  // Custom transition
  self.modalPresentationStyle = UIModalPresentationCustom;
  self.transitioningDelegate = self;
  
  // Data Picker
  _dataPicker = [UIPickerView new];
  _dataPicker.translatesAutoresizingMaskIntoConstraints = NO;
  _dataPicker.backgroundColor = [UIColor whiteColor];
  
  return self;
}


+ (id)pickerWithData:(NSArray *)data selectedBlock:(CCDataPickerBlock)selectedBlock cancelBlock:(CCDataPickerVoidBlock)cancelBlock {
  CCPickerController *dataPicker = [CCPickerController new];
  dataPicker.data = [data copy];
  dataPicker.dataPicker.dataSource = dataPicker.self;
  dataPicker.dataPicker.delegate = dataPicker.self;
  dataPicker.dataBlock = [selectedBlock copy];
  dataPicker.voidBlock = [cancelBlock copy];
  
  return dataPicker;
}

#pragma mark - UIViewController

- (void)loadView
{
  [super loadView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor clearColor];
  
  //Dismiss View
  _dismissButton = [UIButton new];
  _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
  _dismissButton.userInteractionEnabled = YES;
  [_dismissButton addTarget:self action:@selector(didTouchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_dismissButton];
  
  // Data Picker Container
  _dataPickerContainerView = [UIView new];
  _dataPickerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
  _dataPickerContainerView.backgroundColor = [UIColor whiteColor];
  _dataPickerContainerView.clipsToBounds = YES;
  _dataPickerContainerView.layer.cornerRadius = 5.0;
  [self.view addSubview:_dataPickerContainerView];
  
  // Data Picker
  [_dataPickerContainerView addSubview:_dataPicker];

  // Button Container View
  _buttonContainerView = [UIView new];
  _buttonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
  _buttonContainerView.backgroundColor =  [UIColor whiteColor];
  _buttonContainerView.layer.cornerRadius = 5.0;
  [self.view addSubview:_buttonContainerView];
  
  // Button Divider
  _buttonDivierView = [UIView new];
  _buttonDivierView.translatesAutoresizingMaskIntoConstraints = NO;
  _buttonDivierView.backgroundColor =  [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
  [_buttonContainerView addSubview:_buttonDivierView];
  
  // Cancel Button
  _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
  _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
  [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [_cancelButton addTarget:self action:@selector(didTouchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
  [_buttonContainerView addSubview:_cancelButton];
  
  // Select Button
  _selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
  _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_selectButton addTarget:self action:@selector(didTouchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
  [_selectButton setTitle:NSLocalizedString(@"Select", nil) forState:UIControlStateNormal];

  CGFloat fontSize = _selectButton.titleLabel.font.pointSize;
  _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
  
  [_buttonContainerView addSubview:_selectButton];
  
  // Layout
  NSDictionary *views = NSDictionaryOfVariableBindings(_dismissButton,
                                                       _dataPickerContainerView,
                                                       _dataPicker,
                                                       _buttonContainerView,
                                                       _buttonDivierView,
                                                       _cancelButton,
                                                       _selectButton);
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton][_buttonDivierView(0.5)][_selectButton(_cancelButton)]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelButton]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonDivierView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_selectButton]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dataPicker]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dataPicker]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dismissButton]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_dataPickerContainerView]-5-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_buttonContainerView]-5-|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dismissButton][_dataPickerContainerView]-10-[_buttonContainerView(40)]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];

  
}

#pragma mark - UIButton Actions

- (void)didTouchCancelButton:(id)sender {
  if (self.voidBlock != nil) {
    self.voidBlock();
    self.voidBlock = nil;
  }
}

- (void)didTouchSelectButton:(id)sender {
  if (self.dataBlock != nil) {
    self.dataBlock(self.selected);
    self.dataBlock = nil;
  }
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return CCAnimatedTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView * containerView = [transitionContext containerView];
  UIView *dimmedView = [self dimmedView];
  
  // If we are presenting
  if (toViewController.view == self.view) {
    fromViewController.view.userInteractionEnabled = NO;
    
    // Adding the view in the right order
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:dimmedView];
    [containerView addSubview:toViewController.view];
    
    // Moving the view OUT
    CGRect frame = toViewController.view.frame;
    frame.origin.y = CGRectGetHeight(toViewController.view.bounds);
    toViewController.view.frame = frame;
    
    dimmedView.alpha = 0.0;
    
    [UIView animateWithDuration:CCAnimatedTransitionDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
      
      dimmedView.alpha = 0.5;
      
      // Moving the view IN
      CGRect frame = toViewController.view.frame;
      frame.origin.y = 0.0;
      toViewController.view.frame = frame;
      
    } completion:^(BOOL finished) {
      [transitionContext completeTransition:finished];
    }];
  }
  
  // If we are dismissing
  else {
    toViewController.view.userInteractionEnabled = YES;
    
    // Adding the view in the right order
    [containerView addSubview:toViewController.view];
    [containerView addSubview:dimmedView];
    [containerView addSubview:fromViewController.view];
    
    dimmedView.alpha = 0.5;
    
    [UIView animateWithDuration:CCAnimatedTransitionDuration delay:0.1 usingSpringWithDamping:1.0 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
      dimmedView.alpha = 0.0;
      
      // Moving the view OUT
      CGRect frame = fromViewController.view.frame;
      frame.origin.y = CGRectGetHeight(fromViewController.view.bounds);
      fromViewController.view.frame = frame;
      
    } completion:^(BOOL finished) {
      [transitionContext completeTransition:finished];
    }];
  }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
  return self;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return self;
}

#pragma mark - Factory Methods

- (UIView *)dimmedView {
  UIView *dimmedView = [[UIView alloc] initWithFrame:self.view.bounds];
  dimmedView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  dimmedView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
  dimmedView.backgroundColor = [UIColor blackColor];
  return dimmedView;
}



#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [self.data count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  self.selected = row;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.data objectAtIndex:row];
}


@end

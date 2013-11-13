//
//  CCPickerController.h
//  Demo
//
//  Created by Chenchen Zheng on 11/12/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The Block which is executed when the select button is touched.
 *
 *  @param selected row
 *  @return void
 */
typedef void (^CCDataPickerBlock)(NSUInteger selectedRow);

/**
 *  The Block which is executed when the cancel button is touched.
 *
 *  @param void
 *
 *  @return void
 */
typedef void (^CCDataPickerVoidBlock)(void);

@interface CCPickerController : UIViewController

/**
 *  The `UIDatePicker` object used in the component.
 */
@property (nonatomic) UIPickerView *dataPicker;

@property (nonatomic) NSArray *data;

@property (nonatomic) NSInteger selected;


/**
 * The Block which is executed when the select button is touched.
 */
@property (nonatomic, copy) CCDataPickerBlock dataBlock;

/**
 *  The Block which is executed when the cancel button is touched.
 */
@property (nonatomic, copy) CCDataPickerVoidBlock voidBlock;

/**
 *  Creates and returns a new date picker.
 *
 *  @param data          A list of data displayed. It cannot be 'nil'
 *  @param selectedBlock The Block which is executed when the select button is touched.
 *  @param cancelBlock   The Block which is executed when the cancel button is touched.
 *
 *  @return A newly created pickerView.
 */
+ (id)pickerWithData:(NSArray *)data andRow:(NSInteger) selectedRow selectedBlock:(CCDataPickerBlock)selectedBlock cancelBlock:(CCDataPickerVoidBlock)cancelBlock;

@end

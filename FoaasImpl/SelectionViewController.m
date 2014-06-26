//
//  SelectionViewController.m
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import "SelectionViewController.h"
#import "FoaasMethod.h"
#import "ViewController.h"
#import "QueryProcessor.h"

#define OFFSET_FOR_KEYBOARD 150.0f

@interface SelectionViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@end

@implementation SelectionViewController {
	__weak IBOutlet UIPickerView *pickerView;
	IBOutletCollection(UITextField) NSArray *_textFields;

	NSArray *_methods;
	NSUInteger _selectedMethod;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	RKLogInfo(@"PickerView..");
	pickerView.dataSource = self;
	pickerView.delegate = self;

	for (UITextField *field in _textFields) {
		field.enabled = NO;
		field.placeholder = @"Optional field";
		field.delegate = self;
	}

	QueryProcessor *processor = [[QueryProcessor alloc] init];
	_methods = [NSArray arrayWithArray:processor.knownMethods];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [_methods count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	FoaasMethod *method = [_methods objectAtIndex:row];
	return method.methodName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	FoaasMethod *method = [_methods objectAtIndex:row];
	RKLogInfo(@"Hovering %@", method.methodName);

	uint32_t index = 0;
	for (UITextField *field in _textFields) {
		field.text = @"";
		field.placeholder = @"Optional field";
		field.enabled = NO;
	}

	for (index = 0; index < [method.fields count]; index++) {
		UITextField *field = [_textFields objectAtIndex:index];
		field.enabled = YES;
		field.placeholder = (NSString *) [method.fields objectAtIndex:index];
	}

	_selectedMethod = row;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	RKLogInfo(@"Segue: %@", identifier);
	return YES;
}

- (IBAction)onButtonClicked:(id)sender
{
	FoaasMethod *method = [_methods objectAtIndex:_selectedMethod];
	NSMutableArray *values = [NSMutableArray array];

	for (uint32_t i = 0; i < [method.fields count]; i++) {
		UITextField *textField = [_textFields objectAtIndex:i];
		if ([textField.text isEqualToString:@""]) textField.text = @"Michael";
		NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[values addObject:trimmedString];
	}

	RKLogInfo(@"Button click, hence I'm on iPad");
	ViewController *detailsController = (ViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
	detailsController.method = [[FoaasMethod alloc] initWithMethodName:method.methodName andFields:values];

	[detailsController viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	FoaasMethod *method = [_methods objectAtIndex:_selectedMethod];
	NSMutableArray *values = [NSMutableArray array];

	for (uint32_t i = 0; i < [method.fields count]; i++) {
		UITextField *textField = [_textFields objectAtIndex:i];
		if ([textField.text isEqualToString:@""]) textField.text = @"Michael";
		NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[values addObject:trimmedString];
	}

	ViewController *viewController = segue.destinationViewController;
	viewController.navigationItem.title = [NSString stringWithFormat:@"Method: %@", method.methodName];
	viewController.method = [[FoaasMethod alloc] initWithMethodName:method.methodName andFields:values];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

# pragma mark - Keyboard handlers

- (void)keyboardWillShow
{
	if (self.view.frame.origin.y >= 0) {
		[self setViewMovedUp:YES];
	}
	else {
		[self setViewMovedUp:NO];
	}
}

- (void)keyboardWillHide
{
	[self keyboardWillShow];
}

- (void)setViewMovedUp:(BOOL)movedeUp
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f]; // Slide up gently

	CGRect rect = self.view.frame;
	if (movedeUp) {
		rect.origin.y -= OFFSET_FOR_KEYBOARD;
		rect.size.height += OFFSET_FOR_KEYBOARD;
	}
	else {
		rect.origin.y += OFFSET_FOR_KEYBOARD;
		rect.size.height -= OFFSET_FOR_KEYBOARD;
	}

	self.view.frame = rect;

	[UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Register keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow)
												 name:UIKeyboardWillShowNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide)
												 name:UIKeyboardWillHideNotification
											   object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
}

@end

//
//  ViewController.h
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoaasMethod;

@interface ViewController : UIViewController
@property (strong, nonatomic) FoaasMethod *method;

- (void)viewDidLoad;

@end

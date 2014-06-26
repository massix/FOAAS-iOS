//
//  ViewController.m
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import "ViewController.h"
#import "QueryProcessor.h"
#import "BModel.h"
#import "FoaasMethod.h"

@interface ViewController () <QueryProcessorDelegate>

@end

@implementation ViewController {
	__strong QueryProcessor *_processor;
	__weak IBOutlet UITextView *_textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_processor = [[QueryProcessor alloc] init];
	_processor.delegate = self;

	[_processor executeMethod:_method];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)processor:(QueryProcessor *)processor receivedModel:(BModel *)model
{
	NSString *subtitleString = [NSString stringWithFormat:@"\n\n%@", model.subtitle];
	NSShadow *shadowForText = [[NSShadow alloc] init];
	shadowForText.shadowColor = [UIColor blackColor];
	shadowForText.shadowBlurRadius = 1.0f;
	shadowForText.shadowOffset = CGSizeMake(0.0f, 2.0f);

	NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc] initWithString:subtitleString attributes:@{}];
	[subtitle addAttribute:NSFontAttributeName
					 value:[UIFont systemFontOfSize:14.0f]
					 range:(NSRange) {0, [subtitle length]}];

	[subtitle addAttribute:NSUnderlineStyleAttributeName
					 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
					 range:(NSRange){0, [subtitle length]}];

	NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] initWithString:model.message attributes:@{}];
	[finalMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:(NSRange){0, [finalMessage length]}];
	[finalMessage addAttribute:NSShadowAttributeName value:shadowForText range:(NSRange){0, [finalMessage length]}];

	[finalMessage appendAttributedString:subtitle];

	_textView.attributedText = finalMessage;
}

@end

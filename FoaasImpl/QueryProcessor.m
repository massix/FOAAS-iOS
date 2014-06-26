//
//  QueryProcessor.m
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import "QueryProcessor.h"
#import "BModel.h"
#import "FoaasMethod.h"

@implementation QueryProcessor {
	__strong RKObjectMapping *_mapping;
	__strong RKResponseDescriptor *_responseDescriptor;
	__strong NSURL *_url;
}

- (id)init
{
	self = [super init];

	_mapping = [RKObjectMapping mappingForClass:[BModel class]];
	[_mapping addAttributeMappingsFromDictionary:@{
		@"message":  @"message",
		@"subtitle": @"subtitle"
	}];

	_responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
																	   method:RKRequestMethodGET
																  pathPattern:nil
																	  keyPath:nil
																  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

	_knownMethods = @[
				 [[FoaasMethod alloc] initWithMethodName:@"off" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"you" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"donut" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"linus" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"king" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"chainsaw" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"thing" andFields:@[ @"thing", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"madison" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"pac" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"random" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"shakespeare" andFields:@[ @"name", @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"this" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"that" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"everyone" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"everything" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"pink" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"life" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"thanks" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"flying" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"fascinating" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"ap" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"op" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"samuel" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"random" andFields:@[ @"from" ]],
				 [[FoaasMethod alloc] initWithMethodName:@"date" andFields:@[ @"name", @"place", @"from" ]],
	];


	return self;
}

- (void)executeMethod:(FoaasMethod *)method
{
	NSString *stringUrl = [NSString stringWithFormat:@"http://foaas2.herokuapp.com/%@", method.methodName];;
	for (NSString *field in method.fields) {
		RKLogInfo(@"Appending %@", field);
		stringUrl = [NSString stringWithFormat:@"%@/%@", stringUrl, field];
	}

	RKLogInfo(@"Final URL: %@", stringUrl);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringUrl]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

	RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request
																			   responseDescriptors:@[_responseDescriptor]];

	[requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		if (_delegate) {
			[_delegate processor:self receivedModel:[mappingResult.array objectAtIndex:0]];
		}
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		// Handle this properly
	}];

	[requestOperation start];
}

@end

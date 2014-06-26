//
//  FoaasMethod.m
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import "FoaasMethod.h"

@implementation FoaasMethod

- (id)initWithMethodName:(NSString *)methodName andFields:(NSArray *)fields
{
	if (self = [super init]) {
		_methodName = methodName;
		_fields = [NSArray arrayWithArray:fields];
	}

	return self;
}

@end

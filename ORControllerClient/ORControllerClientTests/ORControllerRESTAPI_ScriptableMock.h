/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "ORControllerRESTAPI.h"

/**
 * Mock implementation of the ORControllerRESTAPI where results to method call can be 
 * predefined by setting the appropriate properties beforehand.
 */
@interface ORControllerRESTAPI_ScriptableMock : ORControllerRESTAPI

@property (nonatomic, strong) NSArray *panelIdentityListResult;
@property (nonatomic, strong) NSError *panelIdentityListError;

@property (nonatomic, strong) NSDictionary *sensorStatusResult;
@property (nonatomic, strong) NSError *sensorStatusError;
@property (nonatomic) NSUInteger sensorStatusCallCount;

@property (nonatomic, strong) NSDictionary *sensorPollResult;
@property (nonatomic, strong) NSError *sensorPollError;
/**
 * Number of times a call to the poll API will perform the defined behavior (success or error).
 * After that, it will be a no operation.
 */
@property (nonatomic) NSUInteger sensorPollMaxCall;
@property (nonatomic) NSUInteger sensorPollCallCount;

@end

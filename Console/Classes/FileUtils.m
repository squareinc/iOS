/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "FileUtils.h"
#import "DirectoryDefinition.h"
#import "StringUtils.h"
#import "CredentialUtil.h"
#import "URLConnectionHelper.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

@implementation FileUtils

NSFileManager *fileManager;

+ (void)initialize {
	if (self == [FileUtils class]) {
		fileManager = [NSFileManager defaultManager];
	}
}

+ (void)makeSurePathExists:(NSString *)path {
	if (![fileManager fileExistsAtPath:path]) {
		[fileManager createDirectoryAtPath:path  withIntermediateDirectories:YES attributes:nil error:NULL];
	}
}

@end

//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "module_project.h"

#import "ProjectBuilder.h"

#pragma mark -

@implementation module_project

+ (NSString *)command
{
	return @"project";
}

+ (void)usage
{
	bee.cli.LINE( nil );
	bee.cli.LINE( @"type 'bee project create myapp'" );
	bee.cli.LINE( @"type 'bee project create myapp ~/Desktop'" );
	bee.cli.LINE( @"type 'bee project build" );
	bee.cli.LINE( @"type 'bee project test" );
	bee.cli.LINE( nil );
}

+ (void)project_create
{
	if ( bee.cli.arguments.count < 3 )
	{
		[self usage];
		return;
	}
	
	NSString * applicationName = bee.cli.arguments[2];
	if ( nil == applicationName )
	{
		[self usage];
		return;
	}
	
	NSString * savePath = nil;

	if ( bee.cli.arguments.count >= 4 )
	{
		savePath = bee.cli.arguments[3];
	}
	
	if ( nil == savePath )
	{
		savePath = bee.cli.workingDirectory;
	}
	
	NSError *	error = NULL;
	BOOL		succeed = NO;
	
	// Create folders
	
	NSString * appPath = ((NSString *)[NSString stringWithFormat:@"%@/%@/", savePath, applicationName]).normalize;
	NSString * appViewPath = ((NSString *)[NSString stringWithFormat:@"%@/%@/view", savePath, applicationName]).normalize;
	NSString * appModelPath = ((NSString *)[NSString stringWithFormat:@"%@/%@/model", savePath, applicationName]).normalize;
	NSString * appControllerPath = ((NSString *)[NSString stringWithFormat:@"%@/%@/controller", savePath, applicationName]).normalize;
	
	[BeeSandbox touch:appPath];
	[BeeSandbox touch:appViewPath];
	[BeeSandbox touch:appModelPath];
	[BeeSandbox touch:appControllerPath];
	
	bee.cli.LINE( @"Create '%@'", appPath );
	bee.cli.LINE( @"Create '%@'", appViewPath );
	bee.cli.LINE( @"Create '%@'", appModelPath );
	bee.cli.LINE( @"Create '%@'", appControllerPath );
	
	// Create .xcodeproj and .pbxproj
	
	ProjectBuilder * builder = [[[ProjectBuilder alloc] init] autorelease];
	builder.applicationName = applicationName;
	builder.organizationName = @"YourCompany";
	builder.deploymentTarget = @"5.0";
	
	[builder addFile:[NSString stringWithFormat:@"%@.app", applicationName]];
	[builder addFile:[NSString stringWithFormat:@"%@-Info.plist", applicationName]];
	[builder addFile:[NSString stringWithFormat:@"%@-Prefix.pch", applicationName]];
	[builder addFile:@"main.m"];
	[builder addFile:@"Default.png"];
	[builder addFile:@"Default@2x.png"];
	[builder addFile:@"Default-568h@2x.png"];
	[builder addFile:@"icon.png"];
	[builder addFile:@"icon@2x.png"];
	[builder addFile:@"AppDelegate.h"];
	[builder addFile:@"AppDelegate.m"];
	
	[builder addOtherFlag:@"ObjC"];
	
	[builder addLibrary:@"xml2"];
	[builder addLibrary:@"xml2.2"];
	[builder addLibrary:@"sqlite3"];
	[builder addLibrary:@"z"];
	[builder addLibrary:@"z.1"];
	
	[builder addFramework:@"AudioToolbox"];
	[builder addFramework:@"CoreGraphics"];
	[builder addFramework:@"CFNetwork"];
	[builder addFramework:@"CoreFoundation"];
	[builder addFramework:@"CoreMedia"];
	[builder addFramework:@"CoreText"];
	[builder addFramework:@"CoreVideo"];
	[builder addFramework:@"Foundation"];
	[builder addFramework:@"MobileCoreServices"];
	[builder addFramework:@"Security"];
	[builder addFramework:@"SystemConfiguration"];
	[builder addFramework:@"UIKit"];
	[builder addFramework:@"QuartzCore"];
	
	NSString * projectContent = [builder toString];
	if ( nil == projectContent )
	{
		bee.cli.RED().LINE( @"%@", builder.errorDesc );
		return;
	}
	
	NSString *	projPath = ((NSString *)[NSString stringWithFormat:@"%@/%@.xcodeproj/", savePath, applicationName]).normalize;
	NSString *	projFile = ((NSString *)[NSString stringWithFormat:@"%@/project.pbxproj", projPath]).normalize;
	
	[BeeSandbox touch:projPath];
	
	error = NULL;
	succeed = [projectContent writeToFile:projFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	if ( NO == succeed )
	{
		bee.cli.RED().LINE( @"Failed to write .pbxproj file.\n%@", [error description] );
		return;
	}
	
	bee.cli.LINE( @"Create '%@'", projPath );
	
	// Create info.plist
	
	NSString * plistName = [NSString stringWithFormat:@"%@-Info.plist", applicationName];
	NSString * plistFile = ((NSString *)[NSString stringWithFormat:@"%@/%@", appPath, plistName]).normalize;
	
	[BeeSandbox touchFile:plistFile];
	
	NSMutableString * plistContent = [NSMutableString string];
	plistContent.LINE( @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" );
	plistContent.LINE( @"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" );
	plistContent.LINE( @"<plist version=\"1.0\">" );
	plistContent.LINE( @"<dict>" );
	plistContent.LINE( @"<key>CFBundleDevelopmentRegion</key>" );
	plistContent.LINE( @"<string>en</string>" );
	plistContent.LINE( @"<key>CFBundleDisplayName</key>" );
	plistContent.LINE( @"<string>%@</string>", applicationName );
	plistContent.LINE( @"<key>CFBundleExecutable</key>" );
	plistContent.LINE( @"<string>${EXECUTABLE_NAME}</string>" );
	plistContent.LINE( @"<key>CFBundleIdentifier</key>" );
	plistContent.LINE( @"<string>Your Bundle Identifier</string>" );
	plistContent.LINE( @"<key>CFBundleInfoDictionaryVersion</key>" );
	plistContent.LINE( @"<string>6.0</string>" );
	plistContent.LINE( @"<key>CFBundleName</key>" );
	plistContent.LINE( @"<string>%@</string>", applicationName );
	plistContent.LINE( @"<key>CFBundlePackageType</key>" );
	plistContent.LINE( @"<string>APPL</string>" );
	plistContent.LINE( @"<key>CFBundleShortVersionString</key>" );
	plistContent.LINE( @"<string>1.0</string>" );
	plistContent.LINE( @"<key>CFBundleSignature</key>" );
	plistContent.LINE( @"<string>????</string>" );
	plistContent.LINE( @"<key>CFBundleVersion</key>" );
	plistContent.LINE( @"<string>1.0</string>" );
	plistContent.LINE( @"<key>LSRequiresIPhoneOS</key>" );
	plistContent.LINE( @"<true/>" );
	plistContent.LINE( @"<key>UIPrerenderedIcon</key>" );
	plistContent.LINE( @"<true/>" );
	plistContent.LINE( @"<key>UIRequiredDeviceCapabilities</key>" );
	plistContent.LINE( @"<array>" );
	for ( NSString * arch in builder.architectures )
	{
		plistContent.LINE( @"<string>%@</string>", arch );
	}
	plistContent.LINE( @"</array>" );
	plistContent.LINE( @"<key>UIStatusBarHidden</key>" );
	plistContent.LINE( @"<false/>" );
	plistContent.LINE( @"<key>UIStatusBarStyle</key>" );
	plistContent.LINE( @"<string>UIStatusBarStyleBlackOpaque</string>" );
	plistContent.LINE( @"<key>UISupportedInterfaceOrientations</key>" );
	plistContent.LINE( @"<array>" );
	plistContent.LINE( @"<string>UIInterfaceOrientationPortrait</string>" );
	plistContent.LINE( @"</array>" );
	plistContent.LINE( @"</dict>" );
	plistContent.LINE( @"</plist>" );
	
	error = NULL;
	succeed = [plistContent writeToFile:plistFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	if ( NO == succeed )
	{
		bee.cli.RED().LINE( @"Failed to write info.plist file.\n%@", [error description] );
		return;
	}
	
	bee.cli.LINE( @"Create '%@'", plistName );
	
	// Create main.m
	
	NSString * mainName = @"main.m";
	NSString * mainFile = ((NSString *)[NSString stringWithFormat:@"%@/%@", appPath, mainName]).normalize;
	
	[BeeSandbox touchFile:mainFile];
	
	NSMutableString * mainContent = [NSMutableString string];
	mainContent.LINE( @"#import <UIKit/UIKit.h>" );
	mainContent.LINE( @"#import \"AppDelegate.h\"" );
	mainContent.LINE( nil );
	mainContent.LINE( @"int main( int argc, const char * argv[] )" );
	mainContent.LINE( @"{" );
	mainContent.LINE( @"	@autoreleasepool {" );
	mainContent.LINE( @"		return UIApplicationMain( argc, argv, nil, NSStringFromClass([AppDelegate class]) );" );
	mainContent.LINE( @"	}" );
	mainContent.LINE( @"	return 0;" );
	mainContent.LINE( @"}" );
	
	error = NULL;
	succeed = [mainContent writeToFile:mainFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	if ( NO == succeed )
	{
		bee.cli.RED().LINE( @"Failed to write main.m\n%@", [error description] );
		return;
	}
	
	bee.cli.LINE( @"Create '%@'", mainName );
	
	// Create other files
	
	NSMutableArray * otherFiles = [NSMutableArray array];
	[otherFiles addObject:@"Default.png"];
	[otherFiles addObject:@"Default@2x.png"];
	[otherFiles addObject:@"Default-568h@2x.png"];
	[otherFiles addObject:@"icon.png"];
	[otherFiles addObject:@"icon@2x.png"];
	[otherFiles addObject:@"AppDelegate.h"];
	[otherFiles addObject:@"AppDelegate.m"];
	
	for ( NSString * fileName in otherFiles )
	{
		NSString * fullPath = ((NSString *)[NSString stringWithFormat:@"%@/%@/%@", savePath, applicationName, fileName]).normalize;
		[BeeSandbox touchFile:fullPath];
		
		bee.cli.LINE( @"Create '%@'", fileName );
	}
	
	bee.cli.LINE( nil );
	bee.cli.LINE( @"DONE" );
	bee.cli.LINE( nil );
}

+ (void)project_build
{
}

+ (void)project_test
{
}

+ (BOOL)execute
{
	NSString * command1 = [bee.cli.arguments objectAtIndex:0];
	NSString * command2 = [bee.cli.arguments objectAtIndex:1];

	if ( [command2 isEqualToString:@"create"] )
	{
		[self project_create];
		
		return YES;
	}
	else if ( [command2 isEqualToString:@"build"] )
	{
		[self project_build];
		
		return YES;
	}
	else if ( [command2 isEqualToString:@"test"] )
	{
		[self project_test];
		
		return YES;
	}
	
	return NO;
}

@end

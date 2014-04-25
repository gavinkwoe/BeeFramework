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

#import "ProjectBuilder.h"

#pragma mark -

@implementation PBXNode
{
	NSString * _key;
}

static NSMutableArray * __nodes = nil;

+ (instancetype)node
{
	return [[[self alloc] init] autorelease];
}

+ (instancetype)findNode:(NSString *)key
{
	for ( PBXNode * node in __nodes )
	{
		if ( [node.key isEqualToString:key] )
		{
			return node;
		}
	}
	
	return nil;
}

- (void)load
{
}

- (void)unload
{
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		if ( nil == __nodes )
		{
			__nodes = [[NSMutableArray nonRetainingArray] retain];
		}
		
		[__nodes addObject:self];

//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_key release];
	[__nodes removeObject:self];
	
	[super dealloc];
}

- (NSString *)key
{	
	return _key;
}

- (void)generateKey
{
	CFUUIDRef	uuidObj = CFUUIDCreate( nil );
	NSString *	uuid = (NSString *)CFUUIDCreateString( nil, uuidObj );
	
	[_key release];
	_key = [[uuid MD5] retain];
	
	CFRelease(uuidObj);
}

@end

#pragma mark -

@implementation PBXBuildFile

@synthesize isa = _isa;
@synthesize fileRef = _fileRef;

- (void)load
{
	self.isa = @"PBXBuildFile";

	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.fileRef = nil;
}

@end

#pragma mark -

@implementation PBXFileReference
{
	PBXFileReferenceType	_type;
}

@synthesize isa = _isa;
@synthesize explicitFileType = _explicitFileType;
@synthesize lastKnownFileType = _lastKnownFileType;
@synthesize includeInIndex = _includeInIndex;
@synthesize fileEncoding = _fileEncoding;
@synthesize path = _path;
@synthesize sourceTree = _sourceTree;

- (void)load
{
	self.isa = @"PBXFileReference";
	
	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.explicitFileType = nil;
	self.lastKnownFileType = nil;
	self.includeInIndex = nil;
	self.fileEncoding = nil;
	self.path = nil;
	self.sourceTree = nil;
}

+ (instancetype)node:(NSString *)path
{
	PBXFileReference * fileRef = [PBXFileReference node];
	
	NSString * pathExtension = [path pathExtension];
	if ( [pathExtension matchAnyOf:@[@"app"]] )
	{
		fileRef.explicitFileType = @"wrapper.application";
		fileRef.includeInIndex = @0;
		fileRef.path = path;
		fileRef.sourceTree = @"BUILT_PRODUCTS_DIR";
		
		[fileRef setType:PBXFileReferenceTypeProduct];
	}
	else if ( [pathExtension matchAnyOf:@[@"plist"]] )
	{
		fileRef.lastKnownFileType = @"text.plist.xml";
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeResource];
	}
	else if ( [pathExtension matchAnyOf:@[@"pch"]] )
	{
		fileRef.lastKnownFileType = @"sourcecode.c.h";
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeSource];
	}
	else if ( [pathExtension matchAnyOf:@[@"h"]] )
	{
		fileRef.lastKnownFileType = @"sourcecode.c.h";
		fileRef.fileEncoding = @4;
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeSource];
	}
	else if ( [pathExtension matchAnyOf:@[@"m", @"mm"]] )
	{
		fileRef.lastKnownFileType = @"sourcecode.c.objc";
		fileRef.fileEncoding = @4;
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeSource];
	}
	else if ( [pathExtension matchAnyOf:@[@"png"]] )
	{
		fileRef.lastKnownFileType = @"image.png";
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeResource];
	}
	else if ( [pathExtension matchAnyOf:@[@"jpg", @"jpeg"]] )
	{
		fileRef.lastKnownFileType = @"image.jpg";
		fileRef.path = path;
		fileRef.sourceTree = @"<group>";
		
		[fileRef setType:PBXFileReferenceTypeResource];
	}

	return fileRef;
}

- (BOOL)isBuildable
{
	if ( PBXFileReferenceTypeSource == _type || PBXFileReferenceTypeResource == _type )
	{
		return YES;
	}
	
	return NO;
}

- (PBXFileReferenceType)type
{
	return _type;
}

- (void)setType:(PBXFileReferenceType)type
{
	_type = type;
}

@end

#pragma mark -

@implementation PBXBuildPhase

@synthesize isa = _isa;
@synthesize buildActionMask = _buildActionMask;
@synthesize files = _files;
@synthesize runOnlyForDeploymentPostprocessing = _runOnlyForDeploymentPostprocessing;

- (void)load
{
	self.isa = @"PBXBuildPhase";
	self.files = [NSMutableArray array];
	
	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.buildActionMask = nil;
	self.files = nil;
	self.runOnlyForDeploymentPostprocessing = nil;
}

@end

#pragma mark -

@implementation PBXFrameworksBuildPhase

- (void)load
{
	self.isa = @"PBXFrameworksBuildPhase";
	
	[self generateKey];
}

- (void)unload
{
}

@end

#pragma mark -

@implementation PBXResourcesBuildPhase

- (void)load
{
	self.isa = @"PBXResourcesBuildPhase";
	
	[self generateKey];
}

- (void)unload
{
}

@end

#pragma mark -

@implementation PBXSourcesBuildPhase

- (void)load
{
//	[super load];
	
	self.isa = @"PBXSourcesBuildPhase";
	
	[self generateKey];
}

- (void)unload
{
}

@end

#pragma mark -

@implementation PBXGroup

@synthesize isa = _isa;
@synthesize name = _name;
@synthesize path = _path;
@synthesize children = _children;
@synthesize sourceTree = _sourceTree;

- (void)load
{
	self.isa = @"PBXGroup";
	self.children = [NSMutableArray array];

	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.name = nil;
	self.path = nil;
	self.children = nil;
	self.sourceTree = nil;
}

@end

#pragma mark -

@implementation PBXNativeTarget

@synthesize isa = _isa;
@synthesize buildConfigurationList = _buildConfigurationList;
@synthesize buildPhases = _buildPhases;
@synthesize buildRules = _buildRules;
@synthesize dependencies = _dependencies;
@synthesize name = _name;
@synthesize productName = _productName;
@synthesize productReference = _productReference;
@synthesize productType = _productType;

- (void)load
{
	self.isa = @"PBXNativeTarget";
	self.buildPhases = [NSMutableArray array];
	self.buildRules = [NSMutableArray array];
	self.dependencies = [NSMutableArray array];
	
	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.buildConfigurationList = nil;
	self.buildPhases = nil;
	self.buildRules = nil;
	self.dependencies = nil;
	self.name = nil;
	self.productName = nil;
	self.productReference = nil;
	self.productType = nil;
}

@end

#pragma mark -

@implementation PBXProject

@synthesize isa = _isa;
@synthesize attributes = _attributes;
@synthesize buildConfigurationList = _buildConfigurationList;
@synthesize compatibilityVersion = _compatibilityVersion;
@synthesize developmentRegion = _developmentRegion;
@synthesize hasScannedForEncodings = _hasScannedForEncodings;
@synthesize knownRegions = _knownRegions;
@synthesize mainGroup = _mainGroup;
@synthesize productRefGroup = _productRefGroup;
@synthesize projectDirPath = _projectDirPath;
@synthesize projectRoot = _projectRoot;
@synthesize targets = _targets;

- (void)load
{
	self.isa = @"PBXProject";
	self.attributes = [NSMutableDictionary dictionary];
	self.knownRegions = [NSMutableArray array];
	self.targets = [NSMutableArray array];
	
	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.attributes = nil;
	self.buildConfigurationList = nil;
	self.compatibilityVersion = nil;
	self.developmentRegion = nil;
	self.hasScannedForEncodings = nil;
	self.knownRegions = nil;
	self.mainGroup = nil;
	self.productRefGroup = nil;
	self.projectDirPath = nil;
	self.projectRoot = nil;
	self.targets = nil;
}

@end

#pragma mark -

@implementation XCBuildConfiguration

@synthesize isa = _isa;
@synthesize buildSettings = _buildSettings;
@synthesize name = _name;

- (void)load
{
	self.isa = @"XCBuildConfiguration";
	self.buildSettings = [NSMutableDictionary dictionary];

	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.buildSettings = nil;
	self.name = nil;
}

@end

#pragma mark -

@implementation XCConfigurationList

@synthesize isa = _isa;
@synthesize buildConfigurations = _buildConfigurations;
@synthesize defaultConfigurationIsVisible = _defaultConfigurationIsVisible;
@synthesize defaultConfigurationName = _defaultConfigurationName;

- (void)load
{
	self.isa = @"XCConfigurationList";
	self.buildConfigurations = [NSMutableArray array];

	[self generateKey];
}

- (void)unload
{
	self.isa = nil;
	self.buildConfigurations = nil;
	self.defaultConfigurationIsVisible = nil;
	self.defaultConfigurationName = nil;
}

@end

#pragma mark -

@implementation PListBuilder

+ (NSString *)wrapString:(NSString *)string
{
	if ( nil == string || 0 == string.length )
		return nil;
	
	if ( NSNotFound != [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\t @+-=<>()[]"]].location )
	{
		return [NSString stringWithFormat:@"\"%@\"", string];
	}
	
	return string;
}

+ (NSString *)objectToString:(id)obj indent:(int)indent
{
	return [self objectToString:obj indent:indent key:nil];
}

+ (NSString *)objectToString:(id)obj indent:(int)indent key:(NSString *)parentKey
{
	NSMutableString *	content = [NSMutableString string];
	NSString *			prefix = [@"\t" repeat:indent];
	
	if ( [obj isKindOfClass:[PBXNode class]] )
	{
		content.APPEND( prefix );
		content.APPEND( @"%@ = {\n", [(PBXNode *)obj key] );
		
		Class classType = [obj class];
		
		for ( ;; )
		{
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( classType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				NSString *	name = [NSString stringWithUTF8String:property_getName(properties[i])];
				id			value = [obj valueForKey:name];
				
				if ( nil == value )
					continue;
				
				if ( [value isKindOfClass:[PBXNode class]] )
				{
					content.APPEND( prefix );
					content.APPEND( @"%@", [self objectToString:value indent:indent + 1] );
				}
				else if ( [value isKindOfClass:[NSNumber class]] )
				{
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @"%@ = %@;\n", name, value );
				}
				else if ( [value isKindOfClass:[NSString class]] )
				{
					if ( 0 == [(NSString *)value length] || NSNotFound != [value rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@" @+-=<>()[]"]].location )
					{
						content.APPEND( prefix );
						content.APPEND( @"\t" );
						content.APPEND( @"%@ = \"%@\";\n", name, value );
					}
					else
					{
						content.APPEND( prefix );
						content.APPEND( @"\t" );
						content.APPEND( @"%@ = %@;\n", name, value );
					}
				}
				else if ( [value isKindOfClass:[NSArray class]] )
				{
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @"%@ = (\n", name );
					
					for ( id subVal in (NSArray *)value )
					{
						content.APPEND( prefix );
						//	content.APPEND( @"\t" );
						content.APPEND( @"%@,\n", [self objectToString:subVal indent:indent] );
					}
					
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @");\n" );
				}
				else if ( [value isKindOfClass:[NSDictionary class]] )
				{
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @"%@ = {\n", name );
					
					for ( NSString * key in (NSDictionary *)value )
					{
						id subVal = [(NSDictionary *)value objectForKey:key];
						
						content.APPEND( prefix );
						//	content.APPEND( @"\t" );
						content.APPEND( @"%@;\n", [self objectToString:subVal indent:indent key:key] );
					}
					
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @"};\n" );
				}
				else
				{
					content.APPEND( prefix );
					content.APPEND( @"\t" );
					content.APPEND( @"%@;\n", [self objectToString:value indent:indent] );
				}
			}
			
			free( properties );
			
			classType = class_getSuperclass( classType );
			if ( nil == classType || classType == [NSObject class] )
				break;
		}
		
		content.APPEND( prefix );
		content.APPEND( @"};\n" );
	}
	else
	{
		content.APPEND( prefix );
		
		if ( parentKey )
		{
			content.APPEND( @"%@ = ", [self wrapString:parentKey] );
		}
		
		if ( [obj isKindOfClass:[NSNumber class]] )
		{
			content.APPEND( @"%@", obj );
		}
		else if ( [obj isKindOfClass:[NSString class]] )
		{
			content.APPEND( @"%@", [self wrapString:obj] );
		}
		else if ( [obj isKindOfClass:[NSArray class]] )
		{
			content.APPEND( @"(\n" );
			
			for ( id subVal in (NSArray *)obj )
			{
				content.APPEND( prefix );
				content.APPEND( @"%@,\n", [self objectToString:subVal indent:indent + 1] );
			}
			
			content.APPEND( prefix );
			content.APPEND( @"\t" );
			content.APPEND( @")" );
		}
		else if ( [obj isKindOfClass:[NSDictionary class]] )
		{
			content.APPEND( @"{\n" );
			
			for ( NSString * key in (NSDictionary *)obj )
			{
				id subVal = [(NSDictionary *)obj objectForKey:key];
				
				content.APPEND( prefix );
				content.APPEND( @"%@ = %@;\n", [self wrapString:key], [self objectToString:subVal indent:indent + 1] );
			}
			
			content.APPEND( prefix );
			content.APPEND( @"\t" );
			content.APPEND( @"}" );
		}
	}
	
	return content;
}

@end

#pragma mark -

@implementation ProjectBuilder

@synthesize applicationName = _applicationName;
@synthesize organizationName = _organizationName;
@synthesize deploymentTarget = _deploymentTarget;

@synthesize fileNames = _fileNames;
@synthesize libraries = _libraries;
@synthesize frameworks = _frameworks;
@synthesize otherFlags = _otherFlags;
@synthesize architectures = _architectures;
@synthesize headerSearchPaths = _headerSearchPaths;
@synthesize librarySearchPaths = _librarySearchPaths;

@synthesize errorDesc = _errorDesc;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.applicationName = @"YourApplication";
		self.organizationName = @"YourCompany";
		self.deploymentTarget = @"5.0";
		
		self.fileNames = [NSMutableArray array];
		self.libraries = [NSMutableArray array];
		self.frameworks = [NSMutableArray array];
		self.otherFlags = [NSMutableArray array];
		self.architectures = [NSMutableArray array];
		self.headerSearchPaths = [NSMutableArray array];
		self.librarySearchPaths = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	self.applicationName = nil;
	self.organizationName = nil;
	self.deploymentTarget = nil;
	
	self.fileNames = nil;
	self.libraries = nil;
	self.frameworks = nil;
	self.otherFlags = nil;
	self.architectures = nil;

	self.headerSearchPaths = nil;
	self.librarySearchPaths = nil;

	[super dealloc];
}

- (void)addFile:(NSString *)file
{
	[self.fileNames addObject:file];
}

- (void)addLibrary:(NSString *)lib
{
	[self.libraries addObject:lib];
}

- (void)addFramework:(NSString *)framework
{
	[self.frameworks addObject:framework];
}

- (void)addOtherFlag:(NSString *)flag
{
	[self.otherFlags addObject:flag];
}

- (void)addArchitecture:(NSString *)arch
{
	[self.architectures addObject:arch];
}

- (void)addHeaderSearchPath:(NSString *)path
{
	[self.headerSearchPaths addObject:path];
}

- (void)addLibrarySearchPath:(NSString *)path
{
	[self.librarySearchPaths addObject:path];
}

- (NSArray *)linkFlags
{
	NSMutableArray * linkFlags = [NSMutableArray array];
	
	for ( NSString * flag in self.otherFlags )
	{
		[linkFlags addObject:[NSString stringWithFormat:@"-%@", flag]];
	}
	
	for ( NSString * lib in self.libraries )
	{
		[linkFlags addObject:[NSString stringWithFormat:@"-l%@", lib]];
	}
	
	for ( NSString * framework in self.frameworks )
	{
		[linkFlags addObject:@"-framework"];
		[linkFlags addObject:framework];
	}
	
	return linkFlags;
}

- (NSDictionary *)defaultProjectSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];

	buildSetting[@"ALWAYS_SEARCH_USER_PATHS"]			= @"NO";
	buildSetting[@"CLANG_CXX_LANGUAGE_STANDARD"]		= @"gnu++0x";
	buildSetting[@"CLANG_CXX_LIBRARY"]					= @"libc++";
	buildSetting[@"CLANG_WARN_CONSTANT_CONVERSION"]		= @"YES";
	buildSetting[@"CLANG_WARN_EMPTY_BODY"]				= @"YES";
	buildSetting[@"CLANG_WARN_ENUM_CONVERSION"]			= @"YES";
	buildSetting[@"CLANG_WARN_INT_CONVERSION"]			= @"YES";
	buildSetting[@"CLANG_WARN__DUPLICATE_METHOD_MATCH"]	= @"YES";
	buildSetting[@"CODE_SIGN_IDENTITY[sdk=iphoneos*]"]	= @"iPhone Developer";
	buildSetting[@"COPY_PHASE_STRIP"]					= @"NO";
	buildSetting[@"GCC_C_LANGUAGE_STANDARD"]			= @"gnu99";
	buildSetting[@"GCC_WARN_ABOUT_RETURN_TYPE"]			= @"YES";
	buildSetting[@"GCC_WARN_UNINITIALIZED_AUTOS"]		= @"YES";
	buildSetting[@"GCC_WARN_UNUSED_VARIABLE"]			= @"YES";
	buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]			= @"6.1";
	buildSetting[@"SDKROOT"]							= @"iphoneos";

	return buildSetting;
}

- (NSDictionary *)debugProjectSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
	[buildSetting addEntriesFromDictionary:[self defaultProjectSetting]];
	
	buildSetting[@"GCC_DYNAMIC_NO_PIC"]					= @"NO";
	buildSetting[@"GCC_OPTIMIZATION_LEVEL"]				= @0;
	buildSetting[@"GCC_PREPROCESSOR_DEFINITIONS"]		= @[@"DEBUG=1", @"$(inherited)"];
	buildSetting[@"GCC_SYMBOLS_PRIVATE_EXTERN"]			= @"NO";
	buildSetting[@"ONLY_ACTIVE_ARCH"]					= @"YES";

	return buildSetting;
}

- (NSDictionary *)releaseProjectSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
	[buildSetting addEntriesFromDictionary:[self defaultProjectSetting]];
	
	buildSetting[@"OTHER_CFLAGS"]						= @"-DNS_BLOCK_ASSERTIONS=1";
	buildSetting[@"VALIDATE_PRODUCT"]					= @"YES";

	return buildSetting;
}

- (NSDictionary *)defaultTargetSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];

	buildSetting[@"ARCHS"]							= self.architectures;
	buildSetting[@"GCC_PRECOMPILE_PREFIX_HEADER"]	= @"YES";
	buildSetting[@"HEADER_SEARCH_PATHS"]			= self.headerSearchPaths;
	buildSetting[@"LIBRARY_SEARCH_PATHS"]			= self.librarySearchPaths;
	buildSetting[@"GCC_PREFIX_HEADER"]				= [NSString stringWithFormat:@"%@/%@-Prefix.pch", self.applicationName, self.applicationName];
	buildSetting[@"INFOPLIST_FILE"]					= [NSString stringWithFormat:@"%@/%@-Info.plist", self.applicationName, self.applicationName];
	buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]		= self.deploymentTarget;
	buildSetting[@"OTHER_LDFLAGS"]					= [self linkFlags];
	buildSetting[@"PRODUCT_NAME"]					= @"$(TARGET_NAME)";
	buildSetting[@"WRAPPER_EXTENSION"]				= @"app";

	return buildSetting;
}

- (NSDictionary *)debugTargetSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
	[buildSetting addEntriesFromDictionary:[self defaultTargetSetting]];
	return buildSetting;
}

- (NSDictionary *)releaseTargetSetting
{
	NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
	[buildSetting addEntriesFromDictionary:[self defaultTargetSetting]];
	return buildSetting;
}

- (NSString *)toString
{	
// Add project configurations

	XCBuildConfiguration * projDebugConfig = [XCBuildConfiguration node];
	projDebugConfig.name = @"Debug";
	[projDebugConfig.buildSettings addEntriesFromDictionary:[self debugProjectSetting]];

	XCBuildConfiguration * projReleaseConfig = [XCBuildConfiguration node];
	projReleaseConfig.name = @"Release";
	[projDebugConfig.buildSettings addEntriesFromDictionary:[self releaseProjectSetting]];

	XCConfigurationList * projectConfigList = [XCConfigurationList node];
	projectConfigList.defaultConfigurationIsVisible = @0;
	projectConfigList.defaultConfigurationName = @"Debug";
	[projectConfigList.buildConfigurations addObject:projDebugConfig.key];
	[projectConfigList.buildConfigurations addObject:projReleaseConfig.key];
	
// Add target configurations
	
	XCBuildConfiguration * targetDebugConfig = [XCBuildConfiguration node];
	targetDebugConfig.name = @"Debug";
	[targetDebugConfig.buildSettings addEntriesFromDictionary:[self debugTargetSetting]];

	XCBuildConfiguration * targetReleaseConfig = [XCBuildConfiguration node];
	targetReleaseConfig.name = @"Release";
	[targetReleaseConfig.buildSettings addEntriesFromDictionary:[self debugTargetSetting]];

	XCConfigurationList * targetConfigList = [XCConfigurationList node];
	targetConfigList.defaultConfigurationIsVisible = @0;
	targetConfigList.defaultConfigurationName = @"Debug";
	[targetConfigList.buildConfigurations addObject:targetDebugConfig.key];
	[targetConfigList.buildConfigurations addObject:targetReleaseConfig.key];

// Add build phases
	
	PBXSourcesBuildPhase * sourcesBuildPhase = [PBXSourcesBuildPhase node];
	sourcesBuildPhase.buildActionMask = @"2147483647";
	sourcesBuildPhase.runOnlyForDeploymentPostprocessing = @0;

	PBXResourcesBuildPhase * resourcesBuildPhase = [PBXResourcesBuildPhase node];
	resourcesBuildPhase.buildActionMask = @"2147483647";
	resourcesBuildPhase.runOnlyForDeploymentPostprocessing = @0;
	
	PBXFrameworksBuildPhase * frameworksBuildPhase = [PBXFrameworksBuildPhase node];
	frameworksBuildPhase.buildActionMask = @"2147483647";
	frameworksBuildPhase.runOnlyForDeploymentPostprocessing = @0;

// Add target
	
	PBXNativeTarget * target = [PBXNativeTarget node];
	target.name = self.applicationName;
	target.productName = self.applicationName;
	target.productType = @"com.apple.product-type.application";
	target.buildConfigurationList = targetConfigList.key;
	[target.buildPhases addObject:sourcesBuildPhase.key];
	[target.buildPhases addObject:frameworksBuildPhase.key];
	[target.buildPhases addObject:resourcesBuildPhase.key];

// Create groups
	
	PBXGroup * applicationGroup = [PBXGroup node];
	applicationGroup.path = self.applicationName;
	applicationGroup.sourceTree = @"<group>";
		
	PBXGroup * productsGroup = [PBXGroup node];
	productsGroup.name = @"Products";
	productsGroup.sourceTree = @"<group>";

	PBXGroup * mainGroup = [PBXGroup node];
	mainGroup.sourceTree = @"<group>";
	[mainGroup.children addObject:applicationGroup.key];
	[mainGroup.children addObject:productsGroup.key];

// Add source files

	NSMutableArray * fileReferences = [NSMutableArray array];
	NSMutableArray * buildFiles = [NSMutableArray array];

	for ( NSString * fileName in self.fileNames )
	{
		PBXFileReference * fileRef = [PBXFileReference node:fileName];
		if ( fileRef )
		{
			[fileReferences addObject:fileRef];

			if ( PBXFileReferenceTypeSource == [fileRef type] ||
				PBXFileReferenceTypeResource == [fileRef type] )
			{
				[applicationGroup.children addObject:fileRef.key];
			}
			else if ( PBXFileReferenceTypeProduct == [fileRef type] )
			{
				[productsGroup.children addObject:fileRef.key];
			}

			if ( [fileRef isBuildable] )
			{
				PBXBuildFile * buildFile = [PBXBuildFile node];
				if ( buildFile )
				{
					buildFile.fileRef = fileRef.key;
					[buildFiles addObject:buildFile];
					
					if ( PBXFileReferenceTypeSource == [fileRef type] )
					{
						[sourcesBuildPhase.files addObject:buildFile.key];
					}
					else if ( PBXFileReferenceTypeFramework == [fileRef type] )
					{
						[frameworksBuildPhase.files addObject:buildFile.key];
					}
					else if ( PBXFileReferenceTypeResource == [fileRef type] )
					{
						[resourcesBuildPhase.files addObject:buildFile.key];
					}

					if ( PBXFileReferenceTypeProduct == [fileRef type] )
					{
						target.productReference = fileRef.key;
					}
				}
			}
		}
	}

// Add project

	PBXProject * project = [PBXProject node];
	project.attributes[@"LastUpgradeCheck"] = @"0460";
	project.attributes[@"ORGANIZATIONNAME"] = self.organizationName;
	project.buildConfigurationList = projectConfigList.key;
	project.compatibilityVersion = @"Xcode 3.2";
	project.developmentRegion = @"English";
	project.hasScannedForEncodings = @0;
	project.mainGroup = mainGroup.key;
	project.productRefGroup = productsGroup.key;
	project.projectDirPath = @"";
	project.projectRoot = @"";
	[project.knownRegions addObject:@"en"];
	[project.targets addObject:target.key];

// Build string

	NSMutableString * content = [NSMutableString string];
	
	content.LINE( @"// !$*UTF8*$!" );
	content.LINE( @"{" );
	content.LINE( @"	archiveVersion = 1;" );
	content.LINE( @"	classes = {" );
	content.LINE( @"	};" );
	content.LINE( @"	objectVersion = 46;" );
	content.LINE( @"	objects = {" );
	content.LINE( nil );
	
	int indent = 2;

	content.LINE( @"	/* Begin PBXBuildFile section */" );
	for ( PBXBuildFile * buildFile in buildFiles )
	{
		content.APPEND( [PListBuilder objectToString:buildFile indent:indent] );
	}
	content.LINE( @"	/* End PBXBuildFile section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin PBXFileReference section */" );
	for ( PBXFileReference * fileRef in fileReferences )
	{
		content.APPEND( [PListBuilder objectToString:fileRef indent:indent] );
	}
	content.LINE( @"	/* End PBXFileReference section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin PBXFrameworksBuildPhase section */" );
	{
		content.APPEND( [PListBuilder objectToString:frameworksBuildPhase indent:indent] );
	}
	content.LINE( @"	/* End PBXFrameworksBuildPhase section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin PBXGroup section */" );
	{
		content.APPEND( [PListBuilder objectToString:mainGroup indent:indent] );
		content.APPEND( [PListBuilder objectToString:applicationGroup indent:indent] );
		content.APPEND( [PListBuilder objectToString:productsGroup indent:indent] );
	}
	content.LINE( @"	/* End PBXGroup section */" );
	content.LINE( nil );
	
	content.LINE( @"	/* Begin PBXNativeTarget section */" );
	{
		content.APPEND( [PListBuilder objectToString:target indent:indent] );
	}
	content.LINE( @"	/* End PBXNativeTarget section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin PBXProject section */" );
	{
		content.APPEND( [PListBuilder objectToString:project indent:indent] );
	}
	content.LINE( @"	/* End PBXProject section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin PBXResourcesBuildPhase section */" );
	{
		content.APPEND( [PListBuilder objectToString:resourcesBuildPhase indent:indent] );
	}
	content.LINE( @"	/* End PBXResourcesBuildPhase section */" );
	content.LINE( nil );
	
	content.LINE( @"	/* Begin PBXSourcesBuildPhase section */" );
	{
		content.APPEND( [PListBuilder objectToString:sourcesBuildPhase indent:indent] );
	}
	content.LINE( @"	/* End PBXSourcesBuildPhase section */" );
	content.LINE( nil );
	
	content.LINE( @"	/* Begin XCBuildConfiguration section */" );
	{
		content.APPEND( [PListBuilder objectToString:projDebugConfig indent:indent] );
		content.APPEND( [PListBuilder objectToString:projReleaseConfig indent:indent] );
		content.APPEND( [PListBuilder objectToString:targetDebugConfig indent:indent] );
		content.APPEND( [PListBuilder objectToString:targetReleaseConfig indent:indent] );
	}
	content.LINE( @"	/* End XCBuildConfiguration section */" );
	content.LINE( nil );

	content.LINE( @"	/* Begin XCConfigurationList section */" );
	{
		content.APPEND( [PListBuilder objectToString:projectConfigList indent:indent] );
		content.APPEND( [PListBuilder objectToString:targetConfigList indent:indent] );
	}
	content.LINE( @"	/* End XCConfigurationList section */" );
	content.LINE( nil );

	content.LINE( @"	};" );
	content.LINE( @"	rootObject = %@;", project.key );
	content.LINE( @"}" );
	content.LINE( nil );

	return content;
}

@end

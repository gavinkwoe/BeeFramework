#Step 1

1. Locate `bee.services.share.tencentweibo` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.share.tencentweibo.h"

#Step 2

Add below into your .plist file

	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLIconFile</key>
			<string>icon@2x</string>
			<key>CFBundleURLName</key>
			<string>weixin</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>Your weixin ID</string>
			</array>
		</dict>
	</array>

#Step 2

<pre>
bee.services.share.weixin.config.appId = @"<Your app id>";
bee.services.share.weixin.config.appKey = @"<Your app key>";
bee.services.share.weixin.ON();
</pre>

#Step 4

<pre>
if ( bee.services.share.weixin.installed )
{
	bee.services.share.weixin.config.appId = @"<Your app id>";
	bee.services.share.weixin.config.appKey = @"<Your app key>";
	bee.services.share.weixin.ON();

	bee.services.share.weixin.post.text = @"<Text>";
	bee.services.share.weixin.SHARE_TO_FRIEND();
	
	... or ... 
	
	bee.services.share.weixin.SHARE_TO_TIMELINE();
}
else
{
	bee.services.share.weixin.OPEN_STORE();
}
</pre>

#Good luck

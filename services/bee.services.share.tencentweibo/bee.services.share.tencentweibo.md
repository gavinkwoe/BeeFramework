#Step 1

1. Locate `bee.services.share.tencentweibo` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.share.tencentweibo.h"

#Step 2

<pre>
bee.services.share.tencentweibo.config.appKey = @"<Your app key>";
bee.services.share.tencentweibo.config.appSecret = @"<Your app secret>";
bee.services.share.tencentweibo.config.redirectURI = @"<Your redirect url>";
bee.services.share.tencentweibo.ON();
</pre>

#Step 3

####Authorize

<pre>
bee.services.share.tencentweibo.AUTHORIZE();
</pre>

####Share

<pre>
bee.services.share.tencentweibo.post.text = @"<Text>";
bee.services.share.tencentweibo.post.photo = @"<Photo>"; // or UIImage
bee.services.share.tencentweibo.whenBegin = ^
{
};
bee.services.share.tencentweibo.whenSucceed = ^
{
};
bee.services.share.tencentweibo.whenFailed = ^
{
};
bee.services.share.tencentweibo.whenCancelled = ^
{
};
bee.services.share.tencentweibo.SHARE();
</pre>

#Good luck

#Step 1

1. Locate `bee.services.share.sinaweibo` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.share.sinaweibo.h"

#Step 2

<pre>
bee.services.share.sinaweibo.config.appKey = @"<Your app key>";
bee.services.share.sinaweibo.config.appSecret = @"<Your app secret>";
bee.services.share.sinaweibo.config.redirectURI = @"<Your redirect url>";
bee.services.share.sinaweibo.ON();
</pre>

#Step 3

####Authorize

<pre>
bee.services.share.sinaweibo.AUTHORIZE();
</pre>

####Share

<pre>
bee.services.share.sinaweibo.post.text = @"<Text>";
bee.services.share.sinaweibo.post.photo = @"<Photo>"; // or UIImage
bee.services.share.sinaweibo.whenBegin = ^
{
};
bee.services.share.sinaweibo.whenSucceed = ^
{
};
bee.services.share.sinaweibo.whenFailed = ^
{
};
bee.services.share.sinaweibo.whenCancelled = ^
{
};
bee.services.share.sinaweibo.SHARE();
</pre>

#Good luck

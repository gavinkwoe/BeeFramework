#Step 1

1. Locate `bee.services.alipay` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.alipay.h"

#Step 2

<pre>
bee.services.alipay.config.parnter = @"";
bee.services.alipay.config.seller = @"";
bee.services.alipay.config.privateKey = @"";
bee.services.alipay.config.publicKey = @"";
bee.services.alipay.config.notifyURL = @"http://";
</pre>

#Step 3

<pre>
bee.services.alipay.order.no = <sn>;
bee.services.alipay.order.name = <name>;
bee.services.alipay.order.desc = <desc>;
bee.services.alipay.order.price = <price>;
bee.services.alipay.whenWaiting = ^
{
};
bee.services.alipay.whenSucceed = ^
{
};
bee.services.alipay.whenFailed = ^
{
};
bee.services.alipay.PAY();	// or .ON();

</pre>

#Good luck!

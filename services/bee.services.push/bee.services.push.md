#Step 1

1. Locate `bee.services.push` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.push.h"

#Step 2

<pre>
bee.services.push.whenRegistered = ^
{
	// TODO:
};
bee.services.push.whenReceived = ^
{
	for ( PushNotification * n in bee.services.push.notifications )
	{
		// TODO:
	}
};
</pre>

#Step 3

<pre>
bee.services.push.ON();
bee.services.push.OFF();

...

bee.services.push.CLEAR();
bee.services.push.CHECK();
</pre>

#Good luck

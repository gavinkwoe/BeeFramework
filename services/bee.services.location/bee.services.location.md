#Step 1

1. Locate `bee.services.location` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.location.h"

#Step 2

<pre>
bee.services.location.whenUpdate = ^
{
	VAR_DUMP( bee.services.location.location );
};
</pre>

#Step 3

<pre>
bee.services.location.ON();
bee.services.location.OFF();
</pre>

#Good luck

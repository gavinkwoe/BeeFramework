# Dribbble
====

Create date:|2014-01-24
-|-
Author:|http://dribbble.com/api
Website:|none

### Configuration
====

Environment|IP address
-|-
Development:|api.dribbble.com
Testing:|api.dribbble.com
Production:|api.dribbble.com

### API
====


#### Players

* __[/players/:id](/players/:id)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			RESP_PLAYERS_ID|___PLAYER*___


* __[/players/:id/draftees](/players/:id/draftees)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			players|___[PLAYER*]___
			total|___INT___


* __[/players/:id/followers](/players/:id/followers)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			players|___[PLAYER*]___
			total|___INT___


* __[/players/:id/following](/players/:id/following)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			players|___[PLAYER*]___
			total|___INT___


* __[/players/:id/shots](/players/:id/shots)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-
			page|___INT___
			per_page|___INT___

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			shots|___[SHOT*]___
			total|___INT___


* __[/players/:id/shots/following](/players/:id/shots/following)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-
			page|___INT___
			per_page|___INT___

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			shots|___[SHOT*]___
			total|___INT___


* __[/players/:id/shots/likes](/players/:id/shots/likes)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-
			page|___INT___
			per_page|___INT___

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			shots|___[SHOT*]___
			total|___INT___



#### Shots

* __[/shots/:id](/shots/:id)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			RESP_SHOTS_ID|___SHOT*___


* __[/shots/:id/comments](/shots/:id/comments)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-
			page|___INT___
			per_page|___INT___

	+ ___Response___

		Name|Type
		-|-
			comments|___[COMMENT*]___
			page|___INT___
			pages|___INT___
			per_page|___INT___
			total|___INT___


* __[/shots/:id/rebounds](/shots/:id/rebounds)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			shots|___[SHOT*]___
			total|___INT___


* __[/shots/:list](/shots/:list)__

	___(null)___

	+ ___Request___

		Name|Type
		-|-
			page|___INT___
			per_page|___INT___

	+ ___Response___

		Name|Type
		-|-
			page|___INT___
			pages|___INT___
			per_page|___INT___
			shots|___[SHOT*]___
			total|___INT___



### Model
====

* __COMMENT__

	Name|Type
	-|-
		body|___TEXT___
		created_at|___TEXT___
		likes_count|___INT___
		player|___PLAYER*___
		id|___INT___

* __PLAYER__

	Name|Type
	-|-
		avatar_url|___TEXT___
		comments_count|___INT___
		comments_received_count|___INT___
		created_at|___TEXT___
		drafted_by_player_id|-
		draftees_count|___INT___
		followers_count|___INT___
		following_count|___INT___
		likes_count|___INT___
		likes_received_count|___INT___
		location|___TEXT___
		name|___TEXT___
		rebounds_count|___INT___
		rebounds_received_count|___INT___
		shots_count|___INT___
		twitter_screen_name|___TEXT___
		url|___TEXT___
		username|___TEXT___
		id|___INT___

* __SHOT__

	Name|Type
	-|-
		comments_count|___INT___
		created_at|___TEXT___
		height|___INT___
		image_teaser_url|___TEXT___
		image_url|___TEXT___
		likes_count|___INT___
		player|___PLAYER*___
		rebound_source_id|___INT___
		rebounds_count|___INT___
		short_url|___TEXT___
		title|___TEXT___
		url|___TEXT___
		views_count|___INT___
		width|___INT___
		id|___INT___



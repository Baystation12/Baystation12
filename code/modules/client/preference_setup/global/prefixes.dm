/singleton/prefix
	var/name
	var/default_key
	var/is_locked = FALSE

/singleton/prefix/language
	name = "Language"
	default_key = ","

/singleton/prefix/radio_channel_selection
	name = "Radio, channel selection"
	default_key = ":"
	is_locked = TRUE

/singleton/prefix/radio_main_channel
	name = "Radio, main channel"
	default_key = ";"

/singleton/prefix/audible_emote
	name = "Emote, audible"
	default_key = "!"

/singleton/prefix/visible_emote
	name = "Emote, visible"
	default_key = "^"

/singleton/prefix/custom_emote
	name = "Emote, custom"
	default_key = "/"

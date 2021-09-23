/decl/prefix
	var/name
	var/default_key
	var/is_locked = FALSE

/decl/prefix/language
	name = "Language"
	default_key = ","

/decl/prefix/radio_channel_selection
	name = "Radio, channel selection"
	default_key = ":"
	is_locked = TRUE

/decl/prefix/radio_main_channel
	name = "Radio, main channel"
	default_key = ";"

/decl/prefix/audible_emote
	name = "Emote, audible"
	default_key = "!"

/decl/prefix/visible_emote
	name = "Emote, visible"
	default_key = "^"

/decl/prefix/custom_emote
	name = "Emote, custom"
	default_key = "/"

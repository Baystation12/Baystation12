/singleton/audio
	var/source //Path to file source
	var/display //A display title we use in the game
	var/volume //If present, a `normal` volume
	var/title //The real title
	var/author
	var/collection
	var/singleton/license/license
	var/url


//Repository scopes
/singleton/audio/effect
/singleton/audio/track


/singleton/audio/New()
	. = ..()
	license = GET_SINGLETON(license)


/singleton/audio/VV_static()
	return ..() + vars

/singleton/audio/proc/get_info(with_meta = TRUE)
	. = SPAN_GOOD("[title][!author?"":" by [author]"][!collection?"":" ([collection])"]")
	if (with_meta)
		. = "[.][!url?"":"\[<a href='[url]'>link</a>\]"]\[<a href='[license.url]'>license</a>\]"


/singleton/audio/proc/get_sound(channel)
	var/sound/S = sound(source, FALSE, FALSE, channel, volume || 100)
	return S


/singleton/audio/track/get_sound(channel = GLOB.lobby_sound_channel)
	var/sound/S = ..()
	S.repeat = TRUE
	return S

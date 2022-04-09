/decl/audio
	var/source //Path to file source
	var/display //A display title we use in the game
	var/volume //If present, a `normal` volume
	var/title //The real title
	var/author
	var/collection
	var/decl/license/license
	var/url


//Repository scopes
/decl/audio/effect
/decl/audio/track


/decl/audio/New()
	. = ..()
	license = decls_repository.get_decl(license)


/decl/audio/VV_static()
	return ..() + vars

/decl/audio/proc/get_info(with_meta = TRUE)
	. = SPAN_GOOD("[title][!author?"":" by [author]"][!collection?"":" ([collection])"]")
	if (with_meta)
		. = "[.][!url?"":"\[<a href='[url]'>link</a>\]"]\[<a href='[license.url]'>license</a>\]"


/decl/audio/proc/get_sound(channel)
	var/sound/S = sound(source, FALSE, FALSE, channel, volume || 100)
	return S


/decl/audio/track/get_sound(channel = GLOB.lobby_sound_channel)
	var/sound/S = ..()
	S.repeat = TRUE
	return S

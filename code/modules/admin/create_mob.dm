/var/create_mob_html = null
/datum/admins/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(replacetext(create_mob_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=425x475")

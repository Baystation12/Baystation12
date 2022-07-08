var/global/create_object_html = null

/datum/admins/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext_char(create_object_html, "null /* object types */", "\"[objectjs]\"")

	show_browser(user, replacetext_char(create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=575x575")

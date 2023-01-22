var/global/create_turf_html = null
/datum/admins/proc/create_turf(var/mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext_char(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	show_browser(user, replacetext_char(create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=575x575")

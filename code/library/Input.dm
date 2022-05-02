/Input/var/static/const/max_name_length = 32

/Input/var/static/const/max_line_length = 128

/Input/var/static/const/max_text_length = 1024

/Input/var/static/const/default_confirm_accept = "Okay"

/Input/var/static/const/default_confirm_cancel = "Cancel"


//-- defaults config ends --


/Input/proc/Confirm(user, query, accept = default_confirm_accept, cancel = default_confirm_cancel)
	return alert(user, query, null, cancel, accept) == accept


/Input/proc/GetLine(user, query, default, max_length = max_line_length, regex/sanitizer)
	var/response = input(user, query, null, default) as null | text
	if (!isnull(response))
		return Text.Sanitize(response, max_length, sanitizer)


/Input/proc/GetText(user, query, default, max_length = max_text_length, regex/sanitizer)
	var/response = input(user, query, null, default) as null | message
	if (!isnull(response))
		return Text.Sanitize(response, max_length, sanitizer)


/Input/Destroy(force)
	if (force)
		return ..()
	return QDEL_HINT_LETMELIVE

VAR_FINAL/global/Input/Input = new

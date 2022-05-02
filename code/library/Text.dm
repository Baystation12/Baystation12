/Text/var/static/const/default_sanitizer = "EN"


//-- defaults config ends --


/Text/var/static/const/sanitizer_en = "EN"

/Text/var/static/const/sanitizer_ru = "RU"

/Text/var/static/list/standard_sanitizers = list(
	// "EN" - Allows printable symbols in the Basic Latin codeblock, except for > and <
	"[sanitizer_en]" = regex(@"[^\x20-\x3b\x3d\x3f-\x7e\n]", "g"),
	// "RU" - Allows symbols in the "EN" set, plus the Cyrillic codeblock
	"[sanitizer_ru]" = regex(@"[^\x20-\x3b\x3d\x3f-\x7e\n\u0400-\u04ff]", "g")
)

/* *
* Sanitize text by replacing every symbol matching sanitizers with
* the text of replacer, then trimming the result to max_length if
* specified.
* sanitizers may be:
* null - the default sanitizer is used
* text - the Text.* const refering to a standard sanitizer
* regex - a regex to match against
* list - a list of either of the above
* FALSE - no sanitization is performed
*/
/Text/proc/Sanitize(text, max_length, list/sanitizers = default_sanitizer, replacer = "")
	if (sanitizers != FALSE)
		if (!islist(sanitizers))
			sanitizers = list(sanitizers)
		for (var/regex/sanitizer as anything in sanitizers)
			if (istext(sanitizer))
				sanitizer = standard_sanitizers[sanitizer]
			text = replacetext_char(text, sanitizer, replacer)
	if (max_length && length(text) > max_length)
		text = copytext_char(text, 1, max_length)
	return text


/Text/Destroy(force)
	if (force)
		return ..()
	return QDEL_HINT_LETMELIVE

VAR_FINAL/global/Text/Text = new

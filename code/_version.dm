/* *
DM version compatibility macros & procs
Retain even if empty - the future exists
*/

#if DM_VERSION < 515

/proc/ceil(number)
	return -round(-number)

/proc/floor(number)
	return round(number)

/proc/fract(number)
	return number - trunc(number)

/proc/ftime()
	throw EXCEPTION("ftime not available below 515")

/proc/get_steps_to()
	throw EXCEPTION("get_steps_to not available below 515")

/proc/isinf(number)
	return number == POSITIVE_INFINITY || number == NEGATIVE_INFINITY

/proc/isnan(number)
	return isnum(number) && number != number

/proc/ispointer()
	throw EXCEPTION("ispointer not available below 515")

/proc/nameof(thing)
	throw EXCEPTION("nameof not available below 515")

/proc/noise_hash()
	throw EXCEPTION("noise_hash not available below 515")

/proc/refcount(datum)
	throw EXCEPTION("refcount not available below 515")

/proc/trimtext(text)
	var/static/regex/pattern
	if (!pattern)
		pattern = regex(@"^\s*(.*?)\s*$", "g")
	return replacetext_char(text, pattern, "$1")

/proc/trunc(number)
	if (number < 0)
		return -round(-number)
	return round(number)

/client/proc/RenderIcon(atom)
	throw EXCEPTION("client::RenderIcon() not available below 515")

#define PROC_REF(X) (.proc/##X)
#define TYPE_PROC_REF(TYPE, X) (##TYPE.proc/##X)
#define GLOBAL_PROC_REF(X) (.proc/##X)
#define CALL_EXT call

#else

#define PROC_REF(X) (nameof(.proc/##X))
#define TYPE_PROC_REF(TYPE, X) (nameof(##TYPE.proc/##X))
#define GLOBAL_PROC_REF(X) (/proc/##X)
#define CALL_EXT call_ext

#endif

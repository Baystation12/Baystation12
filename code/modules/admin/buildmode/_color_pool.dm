/**
Temporary color pool using text/number/path/instance keys.
Once fixed distinct colors are expended, md5(key) is used.
Null key is always #000000.
*/

/color_pool
	var/list/available = list( //source: https://sashamaps.net/docs/resources/20-colors
		"#ffffff", "#a9a9a9", "#e6194b", "#3cb44b", "#ffe119", "#4363d8",
		"#f58231", "#42d4f4", "#f032e6", "#fabebe", "#469990", "#e6beff",
		"#9a6324", "#fffac8", "#800000", "#aaffc3", "#000075"
	)
	var/list/assigned = list()

/color_pool/proc/get(key)
	if (isnull(key))
		return "#000000"
	if (isnum(key) || ispath(key))
		key = "[key]"
	else if (!istext(key))
		key = "\ref[key]"
	var/result = assigned[key]
	if (!result)
		var/count = length(available)
		if (!count)
			result = "#[copytext(md5(key), 1, 7)]"
		else
			result = available[count]
			available.Cut(count)
		assigned[key] = result
	return result

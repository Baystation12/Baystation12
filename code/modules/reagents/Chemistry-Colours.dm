/datum/reagents/proc/get_color()
	if(!reagent_list || !reagent_list.len)
		return "#ffffffff"
	if(reagent_list.len == 1) // It's pretty common and saves a lot of work
		var/datum/reagent/R = reagent_list[1]
		return R.color + num2hex(R.alpha)

	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0
	for(var/datum/reagent/R in reagent_list)
		var/hex = uppertext(R.color) + num2hex(R.alpha)
		colors[1] += hex2num(copytext(hex, 2, 4)) * R.volume * R.color_weight
		colors[2] += hex2num(copytext(hex, 4, 6)) * R.volume * R.color_weight
		colors[3] += hex2num(copytext(hex, 6, 8)) * R.volume * R.color_weight
		colors[4] += hex2num(copytext(hex, 8, 10)) * R.volume * R.color_weight
		tot_w += R.volume * R.color_weight

	return rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)
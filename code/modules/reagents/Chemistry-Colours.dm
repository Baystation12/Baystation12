/proc/mix_color_from_reagents(var/list/reagent_list)
	if(!reagent_list || !length(reagent_list))
		return 0

	var/contents = length(reagent_list)
	var/list/weight = list(contents)
	var/list/color = list(contents)
	var/i

	//fill the list of weights
	var/listsum = 0
	for(i=1; i<contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/reagentweight = re.volume
		if(istype(re, /datum/reagent/paint))
			reagentweight *= 10 //Paint colours a mixture ten times as much
		weight[i] = reagentweight
		listsum += reagentweight

	//renormalize
	for(i=1; i<contents; i++)
		weight[i] /= listsum

	//fill the list of colours
	for(i=1; i<contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/hue = re.color
		if(length(hue) != 7)
			color[i] = 0
			return
		color[i]=hex2num(copytext(color,-6))

	//mix them
	var/mixedcolor
	for(i=1; i<contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
	if(mixedcolor<0x0000 || mixedcolor>0xFFFF)
		return

	//assemble back into #RRGGBB format
	var/finalcolor = num2hex(mixedcolor)
	var/colorlength = length(finalcolor)
	finalcolor = copytext(finalcolor,-colorlength+1) //We don't want every colour to start with "0"
	while(length(finalcolor)<6)
		finalcolor = text("0[]",finalcolor) //Takes care of leading zeroes
	finalcolor = text("#[]",finalcolor)

	world << finalcolor

	return finalcolor

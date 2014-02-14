/proc/mix_colour_from_reagents(var/list/reagent_list)
	if(!reagent_list || !length(reagent_list))
		return 0

	var/contents = length(reagent_list)
	var/list/weight = new /list(contents)
	var/list/redcolour = new /list(contents)
	var/list/greencolour = new /list(contents)
	var/list/bluecolour = new /list(contents)
	var/i

	//fill the list of weights
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/reagentweight = re.volume
		if(istype(re, /datum/reagent/paint))
			reagentweight *= 20 //Paint colours a mixture twenty times as much
		weight[i] = reagentweight


	//fill the lists of colours
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/hue = re.colour
		if(length(hue) != 7)
			return 0
		redcolour[i]=hex2num(copytext(hue,2,4))
		greencolour[i]=hex2num(copytext(hue,4,6))
		bluecolour[i]=hex2num(copytext(hue,6,8))

	//mix all the colours
	var/red = mixOneColor(weight,redcolour)
	var/green = mixOneColor(weight,greencolour)
	var/blue = mixOneColor(weight,bluecolour)

	//assemble all the pieces
	var/finalcolour = "#[red][green][blue]"
	return finalcolour

/proc/mixOneColor(var/list/weight, var/list/colour)
	if (!weight || !colour || length(weight)!=length(colour))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolour = 0
	for(i=1; i<=contents; i++)
		mixedcolour += weight[i]*colour[i]
	mixedcolour = round(mixedcolour)

	//until someone writes a formal proof for this algorithm, let's keep this in
	if(mixedcolour<0x00 || mixedcolour>0xFF)
		return 0

	var/finalcolour = num2hex(mixedcolour)
	while(length(finalcolour)<2)
		finalcolour = text("0[]",finalcolour) //Takes care of leading zeroes
	return finalcolour

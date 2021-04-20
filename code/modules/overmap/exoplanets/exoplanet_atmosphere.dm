/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if (habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = gas_data.gases.Copy()
		if (prob(90)) //all phoron planet should be rare
			newgases -= GAS_PHORON
		if (prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= GAS_ALIEN
		newgases -= GAS_STEAM

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if (habitability_class == HABITABILITY_OKAY)
			atmosphere.gas[GAS_OXYGEN] += MOLES_O2STANDARD
			total_moles -= MOLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while (i <= gasnum && total_moles && newgases.len)
			if (badflag && sanity)
				for(var/g in newgases)
					if (gas_data.flags[g] & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			if (sanity) //make sure atmosphere is not flammable... always
				if (gas_data.flags[ng] & XGM_GAS_OXIDIZER)
					badflag |= XGM_GAS_FUEL
				if (gas_data.flags[ng] & XGM_GAS_FUEL)
					badflag |= XGM_GAS_OXIDIZER
				sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if (i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list()
	for (var/g in atmosphere.gas)
		if (gas_data.tile_overlay_color[g])
			colors += gas_data.tile_overlay_color[g]
	if (colors.len)
		return MixColors(colors)
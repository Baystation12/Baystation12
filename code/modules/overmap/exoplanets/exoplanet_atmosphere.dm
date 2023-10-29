/obj/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if (habitability_weight == HABITABILITY_LOCKED)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/habitability
		var/list/newgases = gas_data.gases.Copy()
		if (prob(90)) //all phoron planet should be rare
			newgases -= GAS_PHORON
		if (prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= GAS_ALIEN
		newgases -= GAS_STEAM

		switch(habitability_weight)
			if (HABITABILITY_TYPICAL)
				habitability = NORMAL_RAND
			if (HABITABILITY_BAD)
				habitability = LINEAR_RAND
			if (HABITABILITY_EXTREME)
				habitability = SQUARE_RAND
			else
				habitability = UNIFORM_RAND

		var/total_moles = MOLES_CELLSTANDARD * (rand(7, 40) / 10)
		var/generator/new_moles = generator("num", 0.15 * total_moles, 0.6 * total_moles, habitability)
		var/badflag = 0

		var/gasnum = rand(max(habitability_weight - 1, 1), 4)
		var/i = 0

		while (i <= gasnum && total_moles && length(newgases))
			if (badflag)
				for(var/g in newgases)
					if (gas_data.flags[g] & badflag)
						newgases -= g

			var/ng = pick_n_take(newgases)	//pick a gas

			if (gas_data.flags[ng] & XGM_GAS_OXIDIZER)
				badflag |= XGM_GAS_OXIDIZER
				if (prob(33))
					badflag |= (XGM_GAS_FUSION_FUEL | XGM_GAS_FUEL)

			if ((gas_data.flags[ng] & XGM_GAS_FUEL) || (gas_data.flags[ng] & XGM_GAS_FUSION_FUEL))
				badflag |= (XGM_GAS_FUSION_FUEL | XGM_GAS_FUEL)
				if (prob(33))
					badflag |= XGM_GAS_OXIDIZER

			var/part = new_moles.Rand() //allocate percentage to it
			if (i == gasnum || !length(newgases)) //if it's last gas, let it have all remaining moles
				part = total_moles

			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++
	atmosphere.update_values()


/obj/overmap/visitable/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list()
	for (var/g in atmosphere.gas)
		if (gas_data.tile_overlay_color[g])
			colors += gas_data.tile_overlay_color[g]
	if (length(colors))
		return MixColors(colors)

/obj/item/device/scanner/xenobio
	name = "xenolife scanner"
	desc = "Multipurpose organic life scanner. With spectral breath analyzer you can find out what snacks Ian had! Or what gasses alien life breathes."
	icon_state = "xenobio"
	item_state = "analyzer"
	scan_sound = 'sound/effects/scanbeep.ogg'
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/list/valid_targets = list(
		/mob/living/carbon/human,
		/mob/living/simple_animal,
		/mob/living/carbon/slime
	)

/obj/item/device/scanner/xenobio/is_valid_scan_target(atom/O)
	if(is_type_in_list(O, valid_targets))
		return TRUE
	return FALSE

/obj/item/device/scanner/xenobio/scan(mob/O, mob/user)
	scan_title = O.name
	scan_data = xenobio_scan_results(O)
	user.show_message(SPAN_NOTICE(scan_data))

/proc/list_gases(var/gases)
	. = list()
	for(var/g in gases)
		. += "[gas_data.name[g]] ([gases[g]]%)"
	return english_list(.)

/proc/xenobio_scan_results(mob/target)
	. = list()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		. += "Data for [H]:"
		. += "Species:\t[H.species]"
		. += "Breathes:\t[gas_data.name[H.species.breath_type]]"
		. += "Exhales:\t[gas_data.name[H.species.exhale_type]]"
		. += "Known toxins:\t[english_list(H.species.poison_types)]"
		. += "Temperature comfort zone:\t[H.species.cold_discomfort_level] K to [H.species.heat_discomfort_level] K"
		. += "Pressure comfort zone:\t[H.species.warning_low_pressure] kPa to [H.species.warning_high_pressure] kPa"
	else if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		. += "Data for [A]:"
		. += "Species:\t[initial(A.name)]"
		. += "Breathes:\t[list_gases(A.min_gas)]"
		. += "Known toxins:\t[list_gases(A.max_gas)]"
		. += "Temperature comfort zone:\t[A.minbodytemp] K to [A.maxbodytemp] K"
	else if(istype(target, /mob/living/carbon/slime/))
		var/mob/living/carbon/slime/T = target
		. += "Slime scan result for \the [T]:"
		. += "[T.colour] [T.is_adult ? "adult" : "baby"] slime"
		. += "Nutrition:\t[T.nutrition]/[T.get_max_nutrition()]"
		if(T.nutrition < T.get_starve_nutrition())
			. += "<span class='alert'>Warning:\tthe slime is starving!</span>"
		else if (T.nutrition < T.get_hunger_nutrition())
			. += "<span class='warning'>Warning:\tthe slime is hungry.</span>"
		. += "Electric charge strength:\t[T.powerlevel]"
		. += "Health:\t[round((T.health * 100) / T.maxHealth)]%"

		var/list/mutations = T.GetMutations()

		if(!mutations.len)
			. += "This slime will never mutate."
		else
			var/list/mutationChances = list()
			for(var/i in mutations)
				if(i == T.colour)
					continue
				if(mutationChances[i])
					mutationChances[i] += T.mutation_chance / mutations.len
				else
					mutationChances[i] = T.mutation_chance / mutations.len

			var/list/mutationTexts = list("[T.colour] ([100 - T.mutation_chance]%)")
			for(var/i in mutationChances)
				mutationTexts += "[i] ([mutationChances[i]]%)"

			. += "Possible colours on splitting:\t[english_list(mutationTexts)]"

		if (T.cores > 1)
			. += "Anomalous slime core amount detected."
		. += "Growth progress:\t[T.amount_grown]/10."
	else
		. += "Incompatible life form, analysis failed."
	
	. = jointext(., "<br>")

/obj/item/device/slime_scanner
	name = "xenolife scanner"
	desc = "Multipurpose organic life scanner. With spectral breath analyzer you can find out what snacks Ian had! Or what gasses alien life breathes."
	icon_state = "xenobio"
	item_state = "analyzer"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	matter = list(MATERIAL_ALUMINIUM = 30 ,MATERIAL_GLASS = 20, MATERIAL_PLASTIC = 15)

/obj/item/device/slime_scanner/proc/list_gases(var/gases)
	. = list()
	for(var/g in gases)
		. += "[gas_data.name[g]] ([gases[g]]%)"
	return english_list(.)

/obj/item/device/slime_scanner/afterattack(mob/target, mob/user, proximity)
	if(!proximity)
		return

	if(!istype(target))
		return

	user.visible_message("\The [user] scans \the [target] with \the [src]")
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		user.show_message("<span class='notice'>Data for [H]:</span>")
		user.show_message("Species:\t[H.species]")
		user.show_message("Breathes:\t[gas_data.name[H.species.breath_type]]")
		user.show_message("Exhales:\t[gas_data.name[H.species.exhale_type]]")
		user.show_message("Known toxins:\t[english_list(H.species.poison_types)]")
		user.show_message("Temperature comfort zone:\t[H.species.cold_discomfort_level] K to [H.species.heat_discomfort_level] K")
		user.show_message("Pressure comfort zone:\t[H.species.warning_low_pressure] kPa to [H.species.warning_high_pressure] kPa")
	else if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		user.show_message("<span class='notice'>Data for [A]:</span>")
		user.show_message("Species:\t[initial(A.name)]")
		user.show_message("Breathes:\t[list_gases(A.min_gas)]")
		user.show_message("Known toxins:\t[list_gases(A.max_gas)]")
		user.show_message("Temperature comfort zone:\t[A.minbodytemp] K to [A.maxbodytemp] K")
	else if(istype(target, /mob/living/carbon/slime/))
		var/mob/living/carbon/slime/T = target
		user.show_message("<span class='notice'>Slime scan result for \the [T]:</span>")
		user.show_message("[T.colour] [T.is_adult ? "adult" : "baby"] slime")
		user.show_message("Nutrition:\t[T.nutrition]/[T.get_max_nutrition()]")
		if(T.nutrition < T.get_starve_nutrition())
			user.show_message("<span class='alert'>Warning:\tthe slime is starving!</span>")
		else if (T.nutrition < T.get_hunger_nutrition())
			user.show_message("<span class='warning'>Warning:\tthe slime is hungry.</span>")
		user.show_message("Electric charge strength:\t[T.powerlevel]")
		user.show_message("Health:\t[round((T.health * 100) / T.maxHealth)]%")

		var/list/mutations = T.GetMutations()

		if(!mutations.len)
			user.show_message("This slime will never mutate.")
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

			user.show_message("Possible colours on splitting:\t[english_list(mutationTexts)]")

		if (T.cores > 1)
			user.show_message("Anomalous slime core amount detected.")
		user.show_message("Growth progress:\t[T.amount_grown]/10.")
	else
		user.show_message("Incompatible life form, analysis failed.")

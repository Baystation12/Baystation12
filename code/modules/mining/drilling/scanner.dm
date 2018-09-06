/turf/simulated/var/surveyed

/obj/item/weapon/mining_scanner
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0-old" //GET A BETTER SPRITE.
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 150)
	var/survey_data = 0

/obj/item/weapon/mining_scanner/examine(mob/user)
	..()
	to_chat(user,"A tiny indicator on the [src] shows it holds [survey_data] good explorer points.")

/obj/item/weapon/mining_scanner/attack_self(mob/user as mob)
	to_chat(user, "You begin sweeping \the [src] about, scanning for metal deposits.")

	if(!do_after(user, 50,src))
		return

	var/list/metals = list(
		"surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0
		)
	var/new_data = 0
	for(var/turf/simulated/T in range(2, get_turf(user)))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type
			var/data_value = 1

			switch(metal)
				if(MATERIAL_SAND, MATERIAL_GRAPHENE, MATERIAL_IRON)
					ore_type = "surface minerals"
				if(MATERIAL_GOLD, MATERIAL_SILVER, MATERIAL_DIAMOND)
					ore_type = "precious metals"
					data_value = 2
				if(MATERIAL_URANIUM)
					ore_type = "nuclear fuel"
					data_value = 3
				if(MATERIAL_PHORON, MATERIAL_OSMIUM, MATERIAL_HYDROGEN)
					ore_type = "exotic matter"
					data_value = 4

			if(ore_type) metals[ore_type] += T.resources[metal]

			if(!T.surveyed)
				new_data += data_value * T.resources[metal]

		T.surveyed = 1

	to_chat(user, "\icon[src] <span class='notice'>The scanner beeps and displays a readout.</span>")

	for(var/ore_type in metals)
		var/result = "no sign"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"


		to_chat(user, "- [result] of [ore_type].")

	if(new_data)
		survey_data += new_data
		playsound(loc, 'sound/machines/ping.ogg', 40, 1)
		to_chat(user,"<span class='notice'>New survey data stored - [new_data] GEP.</span>")

/obj/item/weapon/mining_scanner/verb/get_data()
	set category = "Object"
	set name = "Get Survey Data"
	set src in usr

	var/mob/M = usr
	if(!istype(M))
		return
	if(M.incapacitated())
		return
	if(!survey_data)
		to_chat(M,"<span class='warning'>There is no survey data stored on the [src].</span>")
		return
	visible_message("<span class='notice'>The [src] spits out a disk containing [survey_data] GEP.</span>")
	var/obj/item/weapon/disk/survey/D = new(get_turf(src))
	D.data = survey_data
	survey_data = 0
	M.put_in_hands(D)

/obj/item/weapon/disk/survey
	name = "survey data disk"
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	var/data

/obj/item/weapon/disk/survey/examine(mob/user)
	..()
	to_chat(user,"A tiny indicator on the [src] shows it holds [data] good explorer points.")

/obj/item/weapon/disk/survey/Value()
	if(data < 10000)
		return 0.07*data
	if(data < 30000)
		return 0.1*data
	return 0.15*data
/datum/reagent/blood
	data = new/list(
		"donor" = null,
		"species" = SPECIES_HUMAN,
		"blood_DNA" = null,
		"blood_type" = null,
		"blood_colour" = COLOR_BLOOD_HUMAN,
		"trace_chem" = null,
		"dose_chem" = null,
		"virus2" = list(),
		"antibodies" = list(),
		"has_oxy" = 1
	)
	name = "Blood"
	description = "A red (or blue) liquid commonly found inside animals, most of whom are pretty insistent about it being left where you found it."
	reagent_state = LIQUID
	metabolism = REM * 5
	color = "#c80000"
	taste_description = "iron"
	taste_mult = 1.3
	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

	chilling_products = list(/datum/reagent/coagulated_blood)
	chilling_point = 249
	chilling_message = "coagulates and clumps together."

	heating_products = list(/datum/reagent/coagulated_blood)
	heating_point = 318
	heating_message = "coagulates and clumps together."

/datum/reagent/blood/initialize_data(var/newdata)
	..()
	if(data && data["blood_colour"])
		color = data["blood_colour"]
	return

/datum/reagent/blood/proc/sync_to(var/mob/living/carbon/C)
	data["donor"] = weakref(C)
	if (!data["virus2"])
		data["virus2"] = list()
	data["virus2"] |= virus_copylist(C.virus2)
	data["antibodies"] = C.antibodies
	data["blood_DNA"] = C.dna.unique_enzymes
	data["blood_type"] = C.dna.b_type
	data["species"] = C.species.name
	data["has_oxy"] = C.species.blood_oxy
	var/list/temp_chem = list()
	for(var/datum/reagent/R in C.reagents.reagent_list)
		temp_chem[R.type] = R.volume
	data["trace_chem"] = temp_chem
	data["dose_chem"] = C.chem_doses.Copy()
	data["blood_colour"] = C.species.get_blood_colour(C)
	color = data["blood_colour"]

/datum/reagent/blood/mix_data(var/newdata, var/newamount)
	if(!islist(newdata))
		return
	if(!data["virus2"])
		data["virus2"] = list()
	data["virus2"] |= newdata["virus2"]
	if(!data["antibodies"])
		data["antibodies"] = list()
	data["antibodies"] |= newdata["antibodies"]

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	if(t["virus2"])
		var/list/v = t["virus2"]
		t["virus2"] = v.Copy()
	return t

/datum/reagent/blood/touch_turf(var/turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	var/weakref/W = data["donor"]
	if (!W)
		blood_splatter(T, src, 1)
		return
	W = W.resolve()
	if(ishuman(W))
		blood_splatter(T, src, 1)
	else if(isalien(W))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	if(M.chem_doses[type] > 5)
		M.adjustToxLoss(removed)
	if(M.chem_doses[type] > 15)
		M.adjustToxLoss(removed)
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V && V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())
	if(data && data["antibodies"])
		M.antibodies |= data["antibodies"]

/datum/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.inject_blood(src, volume)
	remove_self(volume)

// pure concentrated antibodies
/datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#0050f0"

/datum/reagent/antibodies/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(src.data)
		M.antibodies |= src.data["antibodies"]
	..()

// Water!
#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/datum/reagent/water
	name = "Water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064c877"
	metabolism = REM * 10
	taste_description = "water"
	glass_name = "water"
	glass_desc = "The father of all refreshments."
	chilling_products = list(/datum/reagent/drink/ice)
	chilling_point = T0C
	heating_products = list(/datum/reagent/water/boiling)
	heating_point = T100C
	heating_message = "starts to boil."

/datum/reagent/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(2 * removed)

/datum/reagent/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(2 * removed)

/datum/reagent/water/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		var/turf/simulated/S = T
		S.wet_floor(8, TRUE)

/datum/reagent/water/touch_obj(var/obj/O)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		var/needed = L.fire_stacks * 10
		if(amount > needed)
			L.fire_stacks = 0
			L.ExtinguishMob()
			remove_self(needed)
		else
			L.adjust_fire_stacks(-(amount / 10))
			remove_self(amount)

/datum/reagent/water/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(10 * removed)	// Babies have 150 health, adults have 200; So, 15 units and 20
	var/mob/living/carbon/slime/S = M
	if(!S.client && istype(S))
		if(S.Target) // Like cats
			S.Target = null
		if(S.Victim)
			S.Feedstop()
	if(M.chem_doses[type] == removed)
		M.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")
		M.confused = max(M.confused, 2)

/datum/reagent/water/boiling
	name = "Boiling water"
	chilling_products = list(/datum/reagent/water)
	chilling_point =   99 CELCIUS
	chilling_message = "stops boiling."
	heating_products =  list(null)
	heating_point =    null

// Ice is a drink for some reason.
/datum/reagent/drink/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

	heating_message = "cracks and melts."
	heating_products = list(/datum/reagent/water)
	heating_point = 299 // This is about 26C, higher than the actual melting point of ice but allows drinks to be made properly without weird workarounds.

// Fuel.
/datum/reagent/fuel
	name = "Welding fuel"
	description = "A stable hydrazine-based compound whose exact manufacturing specifications are a closely-guarded secret. One of the most common fuels in human space. Extremely flammable."
	taste_description = "gross metal"
	reagent_state = LIQUID
	color = "#660000"
	touch_met = 5

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/fuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed)

/datum/reagent/fuel/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!

/datum/reagent/fuel/ex_act(obj/item/weapon/reagent_containers/holder, severity)
	if(volume <= 50)
		return
	var/turf/T = get_turf(holder)
	if(volume > 500)
		explosion(T,1,2,4)
	else if(volume > 100)
		explosion(T,0,1,3)
	else if(volume > 50)
		explosion(T,-1,1,2)
	remove_self(volume)

/datum/reagent/coagulated_blood
	name = "Coagulated Blood"
	color = "#aa0000"
	taste_description = "chewy iron"
	taste_mult = 1.5
	description = "When exposed to unsuitable conditions, such as the floor or an oven, blood becomes coagulated and useless for transfusions. It's great for making blood pudding, though."
	glass_name = "tomato salsa"
	glass_desc = "Are you sure this is tomato salsa?"

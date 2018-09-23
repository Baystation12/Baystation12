//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/weapon/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."

/obj/item/device/analyzer/plant_analyzer
	name = "plant analyzer"
	desc = "A hand-held botanical scanner used to analyze plants."
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"
	var/form_title
	var/last_data

/obj/item/device/analyzer/plant_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = "Object"
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/device/analyzer/plant_analyzer/Topic(href, href_list)
	if(..())
		return
	if(href_list["print"])
		print_report(usr)

/obj/item/device/analyzer/plant_analyzer/proc/print_report(var/mob/living/user)
	if(!last_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
	P.SetName("paper - [form_title]")
	P.info = "[last_data]"
	if(istype(user,/mob/living/carbon/human) && !(user.l_hand && user.r_hand))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return

/obj/item/device/analyzer/plant_analyzer/attack_self(mob/user as mob)
	print_report(user)
	return 0

/obj/item/device/analyzer/plant_analyzer/afterattack(obj/target, mob/user, flag)
	if(!flag) return

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	if(istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/obj/item/weapon/reagent_containers/food/snacks/grown))

		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/weapon/grown))

		var/obj/item/weapon/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed

	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))

		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents

	if(!grown_seed)
		to_chat(user, "<span class='danger'>[src] can tell you nothing about \the [target].</span>")
		return

	form_title = "[grown_seed.seed_name] (#[grown_seed.uid])"
	var/dat = "<h3>Plant data for [form_title]</h3>"
	user.visible_message("<span class='notice'>[user] runs the scanner over \the [target].</span>")

	dat += "<h2>General Data</h2>"

	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>[grown_seed.get_trait(TRAIT_ENDURANCE)]</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>[grown_seed.get_trait(TRAIT_YIELD)]</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>[grown_seed.get_trait(TRAIT_MATURATION)]</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>[grown_seed.get_trait(TRAIT_PRODUCTION)]</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>[grown_seed.get_trait(TRAIT_POTENCY)]</td></tr>"
	dat += "</table>"

	if(grown_reagents && grown_reagents.reagent_list && grown_reagents.reagent_list.len)
		dat += "<h2>Reagent Data</h2>"

		dat += "<br>This sample contains: "
		for(var/datum/reagent/R in grown_reagents.reagent_list)
			dat += "<br>- [R.name], [grown_reagents.get_reagent_amount(R.type)] unit(s)"

	dat += "<h2>Other Data</h2>"

	if(grown_seed.get_trait(TRAIT_HARVEST_REPEAT))
		dat += "This plant can be harvested repeatedly.<br>"

	if(grown_seed.get_trait(TRAIT_IMMUTABLE) == -1)
		dat += "This plant is highly mutable.<br>"
	else if(grown_seed.get_trait(TRAIT_IMMUTABLE) > 0)
		dat += "This plant does not possess genetics that are alterable.<br>"

	if(grown_seed.get_trait(TRAIT_REQUIRES_NUTRIENTS))
		if(grown_seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
			dat += "It consumes a small amount of nutrient fluid.<br>"
		else if(grown_seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
			dat += "It requires a heavy supply of nutrient fluid.<br>"
		else
			dat += "It requires a supply of nutrient fluid.<br>"

	if(grown_seed.get_trait(TRAIT_REQUIRES_WATER))
		if(grown_seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
			dat += "It requires very little water.<br>"
		else if(grown_seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
			dat += "It requires a large amount of water.<br>"
		else
			dat += "It requires a stable supply of water.<br>"

	if(grown_seed.mutants && grown_seed.mutants.len)
		dat += "It exhibits a high degree of potential subspecies shift.<br>"

	dat += "It thrives in a temperature of [grown_seed.get_trait(TRAIT_IDEAL_HEAT)] Kelvin."

	if(grown_seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
		dat += "<br>It is well adapted to low pressure levels."
	if(grown_seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
		dat += "<br>It is well adapted to high pressure levels."

	if(grown_seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
		dat += "<br>It is well adapted to a range of temperatures."
	else if(grown_seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
		dat += "<br>It is very sensitive to temperature shifts."

	dat += "<br>It thrives in a light level of [grown_seed.get_trait(TRAIT_IDEAL_LIGHT)] lumen[grown_seed.get_trait(TRAIT_IDEAL_LIGHT) == 1 ? "" : "s"]."

	if(grown_seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
		dat += "<br>It is well adapted to a range of light levels."
	else if(grown_seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
		dat += "<br>It is very sensitive to light level shifts."

	if(grown_seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to toxins."
	else if(grown_seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to toxins."

	if(grown_seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to pests."
	else if(grown_seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to pests."

	if(grown_seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to weeds."
	else if(grown_seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to weeds."

	switch(grown_seed.get_trait(TRAIT_SPREAD))
		if(1)
			dat += "<br>It is able to be planted outside of a tray."
		if(2)
			dat += "<br>It is a robust and vigorous vine that will spread rapidly."

	switch(grown_seed.get_trait(TRAIT_CARNIVOROUS))
		if(1)
			dat += "<br>It is carnivorous and will eat tray pests for sustenance."
		if(2)
			dat	+= "<br>It is carnivorous and poses a significant threat to living things around it."

	if(grown_seed.get_trait(TRAIT_PARASITE))
		dat += "<br>It is capable of parisitizing and gaining sustenance from tray weeds."
	if(grown_seed.get_trait(TRAIT_ALTER_TEMP))
		dat += "<br>It will periodically alter the local temperature by [grown_seed.get_trait(TRAIT_ALTER_TEMP)] degrees Kelvin."

	if(grown_seed.get_trait(TRAIT_BIOLUM))
		dat += "<br>It is [grown_seed.get_trait(TRAIT_BIOLUM_COLOUR)  ? "<font color='[grown_seed.get_trait(TRAIT_BIOLUM_COLOUR)]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(grown_seed.get_trait(TRAIT_PRODUCES_POWER))
		dat += "<br>The fruit will function as a battery if prepared appropriately."

	if(grown_seed.get_trait(TRAIT_STINGS))
		dat += "<br>The fruit is covered in stinging spines."

	if(grown_seed.get_trait(TRAIT_JUICY) == 1)
		dat += "<br>The fruit is soft-skinned and juicy."
	else if(grown_seed.get_trait(TRAIT_JUICY) == 2)
		dat += "<br>The fruit is excessively juicy."

	if(grown_seed.get_trait(TRAIT_EXPLOSIVE))
		dat += "<br>The fruit is internally unstable."

	if(grown_seed.get_trait(TRAIT_TELEPORTING))
		dat += "<br>The fruit is temporal/spatially unstable."

	if(grown_seed.get_trait(TRAIT_EXUDE_GASSES))
		dat += "<br>It will release gas into the environment."

	if(grown_seed.get_trait(TRAIT_CONSUME_GASSES))
		dat += "<br>It will remove gas from the environment."

	if(dat)
		last_data = dat
		dat += "<br><br>\[<a href='?src=\ref[src];print=1'>print report</a>\]"
		user << browse(dat,"window=plant_analyzer")

	return

/* Paint and crayons */

/datum/reagent/crayon_dust
	name = "Crayon dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "the back of class"
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/crayon_dust/red
	name = "Red crayon dust"
	color = "#fe191a"

/datum/reagent/crayon_dust/orange
	name = "Orange crayon dust"
	color = "#ffbe4f"

/datum/reagent/crayon_dust/yellow
	name = "Yellow crayon dust"
	color = "#fdfe7d"

/datum/reagent/crayon_dust/green
	name = "Green crayon dust"
	color = "#18a31a"

/datum/reagent/crayon_dust/blue
	name = "Blue crayon dust"
	color = "#247cff"

/datum/reagent/crayon_dust/purple
	name = "Purple crayon dust"
	color = "#cc0099"

/datum/reagent/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	color = "#808080"

/datum/reagent/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	color = "#846f35"

/datum/reagent/paint
	name = "Paint"
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20

/datum/reagent/paint/touch_turf(var/turf/T)
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/datum/reagent/paint/touch_obj(var/obj/O)
	if(istype(O))
		O.color = color

/datum/reagent/paint/touch_mob(var/mob/M)
	if(istype(M) && !isobserver(M)) //painting observers: not allowed
		M.color = color //maybe someday change this to paint only clothes and exposed body parts for human mobs.

/datum/reagent/paint/get_data()
	return color

/datum/reagent/paint/initialize_data(var/newdata)
	color = newdata
	return

/datum/reagent/paint/mix_data(var/newdata, var/newamount)
	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0

	var/hex1 = uppertext(color)
	var/hex2 = uppertext(newdata)
	if(length(hex1) == 7)
		hex1 += "FF"
	if(length(hex2) == 7)
		hex2 += "FF"
	if(length(hex1) != 9 || length(hex2) != 9)
		return
	colors[1] += hex2num(copytext(hex1, 2, 4)) * volume
	colors[2] += hex2num(copytext(hex1, 4, 6)) * volume
	colors[3] += hex2num(copytext(hex1, 6, 8)) * volume
	colors[4] += hex2num(copytext(hex1, 8, 10)) * volume
	tot_w += volume
	colors[1] += hex2num(copytext(hex2, 2, 4)) * newamount
	colors[2] += hex2num(copytext(hex2, 4, 6)) * newamount
	colors[3] += hex2num(copytext(hex2, 6, 8)) * newamount
	colors[4] += hex2num(copytext(hex2, 8, 10)) * newamount
	tot_w += newamount

	color = rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)
	return

/* Things that didn't fit anywhere else */

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	reagent_state = LIQUID
	color = "#c8a5dc"
	flags = AFFECTS_DEAD //This can even heal dead people.

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/datum/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.rejuvenate()

/datum/reagent/gold
	name = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "expensive metal"
	reagent_state = SOLID
	color = "#f7c430"
	value = 7

/datum/reagent/silver
	name = "Silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "expensive yet reasonable metal"
	reagent_state = SOLID
	color = "#d0d0d0"
	value = 4

/datum/reagent/uranium
	name = "Uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "the inside of a reactor"
	reagent_state = SOLID
	color = "#b8b8c0"
	value = 9

/datum/reagent/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_ingest(M, alien, removed)

/datum/reagent/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_damage(5 * removed, IRRADIATE, armor_pen = 100)

/datum/reagent/uranium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/water/holywater
	name = "Holy Water"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#e0e8ef"

	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/datum/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M)) // Any location
		if(iscultist(M))
			if(prob(10))
				GLOB.cult.offer_uncult(M)
			if(prob(2))
				var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(M.loc)
				M.visible_message("<span class='warning'>\The [M] coughs up \the [S]!</span>")
		else if(M.mind && GLOB.godcult.is_antagonist(M.mind))
			if(volume > 5)
				M.adjustHalLoss(5)
				M.adjustBruteLoss(1)
				if(prob(10)) //Only annoy them a /bit/
					to_chat(M,"<span class='danger'>You feel your insides curdle and burn!</span> \[<a href='?src=\ref[src];deconvert=\ref[M]'>Give Into Purity</a>\]")

/datum/reagent/water/holywater/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/mob/living/carbon/C = locate(href_list["deconvert"])
		if(C.mind)
			GLOB.godcult.remove_antagonist(C.mind,1)

/datum/reagent/water/holywater/touch_turf(var/turf/T)
	if(volume >= 5)
		T.holy = 1
	return

/datum/reagent/diethylamine
	name = "Diethylamine"
	description = "A secondary amine, mildly corrosive."
	taste_description = "iron"
	reagent_state = LIQUID
	color = "#604030"
	value = 0.9

/datum/reagent/surfactant // Foam precursor
	name = "Azosurfactant"
	description = "A isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#9e6b38"
	value = 0.05

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#664b63"

/datum/reagent/thermite
	name = "Thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50
	value = 6

/datum/reagent/thermite/touch_turf(var/turf/T)
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")
			remove_self(5)
	return

/datum/reagent/thermite/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/thermite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustFireLoss(3 * removed)

/datum/reagent/napalm
	name = "Napalm"
	description = "A sticky volatile substance made from mixing quick burning goo with slow burning goo, to make a viscous average burning goo that sticks to everything."
	taste_description = "burnt corn"
	reagent_state = LIQUID
	color = "#673910"
	touch_met = 50

/datum/reagent/napalm/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)

/datum/reagent/napalm/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 100)

/datum/reagent/napalm/b
	name = "Napalm B"
	taste_description = "burnt plastic and metal"

/datum/reagent/space_cleaner
	name = "Space cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#a5f0ee"
	touch_met = 50
	value = 0.7

/datum/reagent/space_cleaner/touch_obj(var/obj/O)
	O.clean_blood()

/datum/reagent/space_cleaner/touch_turf(var/turf/T)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
			if(S.wet > 1)
				S.unwet_floor(FALSE)
		T.clean_blood()


		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

/datum/reagent/space_cleaner/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.wear_mask)
		if(M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(H.shoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)
		else
			H.clean_blood(1)
			return
	M.clean_blood()

/datum/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#009ca8"
	value = 0.6

/datum/reagent/lube/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(80)

/datum/reagent/lube/oil // TODO: Robot Overhaul in general
	name = "Oil"
	description = "A thick greasy industrial lubricant. Commonly found in robotics."
	taste_description = "greasy diesel"
	color = "#000000"

/datum/reagent/lube/oil/touch_turf(var/turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/blood/oil/streak(T)

/datum/reagent/glycerol
	name = "Glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	taste_description = "sweetness"
	reagent_state = LIQUID
	color = "#808080"
	value = 8

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"
	value = 9

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

#define COOLANT_LATENT_HEAT 19000 //Twice as good at cooling than water is, but may cool below 20c. It'll cause freezing that atmos will have to deal with..
/datum/reagent/coolant
	name = "Coolant"
	description = "Industrial cooling substance."
	taste_description = "sourness"
	taste_mult = 1.1
	reagent_state = LIQUID
	color = "#c8a5dc"
	value = 0.8

/datum/reagent/coolant/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = 0 // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * COOLANT_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")


/datum/reagent/ultraglue
	name = "Ultra Glue"
	description = "An extremely powerful bonding agent."
	taste_description = "a special education class"
	color = "#ffffcc"

/datum/reagent/woodpulp
	name = "Wood Pulp"
	description = "A mass of wood fibers."
	taste_description = "wood"
	reagent_state = SOLID
	color = WOOD_COLOR_GENERIC

/datum/reagent/bamboo
	name = "Bamboo Pulp"
	description = "A mass of bamboo fibers."
	taste_description = "grass"
	reagent_state = SOLID
	color = WOOD_COLOR_PALE2

/datum/reagent/luminol
	name = "Luminol"
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#f2f3f4"
	value = 1.4

/datum/reagent/luminol/touch_obj(var/obj/O)
	O.reveal_blood()

/datum/reagent/luminol/touch_mob(var/mob/living/L)
	L.reveal_blood()

/datum/reagent/helium
	name = "Helium"
	description = "A noble gas. It makes your voice squeaky."
	taste_description = "nothing"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/datum/reagent/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

// This is only really used to poison vox.
/datum/reagent/oxygen
	name = "Oxygen"
	description = "An ubiquitous oxidizing agent."
	taste_description = "nothing"
	reagent_state = LIQUID
	color = COLOR_GRAY80

/datum/reagent/oxygen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)

/datum/reagent/carbon_monoxide
	name = "Carbon Monoxide"
	description = "A dangerous carbon comubstion byproduct."
	taste_description = "stale air"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // As with helium.

/datum/reagent/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(!istype(M) || alien == IS_DIONA)
		return
	var/warning_message
	var/warning_prob = 10
	var/dosage = M.chem_doses[type]
	if(dosage >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(10,20)
		M.co2_alert = 1
	else if(dosage >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.co2_alert = 1
		M.adjustOxyLoss(3,5)
	else if(dosage >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
		M.co2_alert = 0
	else
		M.co2_alert = 0
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")

/datum/reagent/anfo
	name = "ANFO"
	description = "Ammonia Nitrate Fuel Oil mix, an explosive compound known for centuries. Safe to handle, can be set off with a small explosion."
	taste_description = "fertilizer and fuel"
	reagent_state = SOLID
	color = "#dbc3c3"
	var/boompower = 1

/datum/reagent/anfo/ex_act(obj/item/weapon/reagent_containers/holder, severity)
	var/activated_volume = volume
	switch(severity)
		if(2)
			if(prob(max(0, 2*(volume - 120))))
				activated_volume = rand(volume/4, volume)
		if(3)
			if(prob(max(0, 2*(volume - 60))))
				activated_volume = rand(0, max(volume, 120))
	if(activated_volume < 30) //whiff
		return
	var/turf/T = get_turf(holder)
	if(T)
		var/adj_power = round(boompower * activated_volume/60)
		var/datum/gas_mixture/products = new(_temperature = 5 * PHORON_FLASHPOINT)
		var/gas_moles = 3 * volume
		products.adjust_multi(GAS_CO2, 0.5 * gas_moles, GAS_NITROGEN, 0.3 * gas_moles, GAS_STEAM, 0.2 * gas_moles)
		T.assume_air(products)
		explosion(T, adj_power, adj_power + 1, adj_power*2 + 2)
		remove_self(activated_volume)

/datum/reagent/anfo/plus
	name = "ANFO+"
	description = "Ammonia Nitrate Fuel Oil, with aluminium powder, an explosive compound known for centuries. Safe to handle, can be set off with a small explosion."
	color = "#ffe8e8"
	boompower = 2
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = 0
	waterproof = FALSE
	item_flags = null

	var/lit = 0
	var/icon_on
	var/type_butt = null
	var/chem_volume = 0
	var/smoketime = 0
	var/brand
	var/gas_consumption = 0.04

	z_flags = ZMM_MANGLE_PLANES

/obj/item/clothing/mask/smokable/New()
	..()
	atom_flags |= ATOM_FLAG_NO_REACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/smokable/Destroy()
	. = ..()
	if(lit)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/fire_act()
	light(0)

/obj/item/clothing/mask/smokable/proc/smoke(amount)
	smoketime -= amount
	if(reagents && reagents.total_volume) // check if it has any reagents at all
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2) // Most of it is not inhaled... balance reasons.
				add_trace_DNA(C)
		else // else just remove some of the reagents
			reagents.remove_any(REM)
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.internal)
				environment = C.internal.return_air()
		if(environment.get_by_flag(XGM_GAS_OXIDIZER) < gas_consumption)
			extinguish()
		else
			environment.remove_by_flag(XGM_GAS_OXIDIZER, gas_consumption)
			environment.adjust_gas(GAS_CO2, 0.5*gas_consumption,0)
			environment.adjust_gas(GAS_CO, 0.5*gas_consumption)

/obj/item/clothing/mask/smokable/Process()
	var/turf/location = get_turf(src)
	if(submerged() || smoketime < 1)
		extinguish()
		return
	smoke(1)
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/smokable/on_update_icon()
	if(lit && icon_on)
		icon_state = icon_on
		item_state = icon_on
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/water_act(depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)

/obj/item/clothing/mask/smokable/proc/is_wet()
	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc
		return locate(/datum/reagent/water) in C.touching.reagent_list

/obj/item/clothing/mask/smokable/proc/light(flavor_text = "[usr] lights the [name].")
	if(QDELETED(src))
		return
	if(!lit)
		if(is_wet())
			to_chat(usr, SPAN_WARNING("You are too wet to light \the [src]."))
			return
		if(submerged())
			to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
			return
		lit = 1
		damtype = DAMAGE_BURN
		if(reagents.get_reagent_amount(/datum/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		atom_flags &= ~ATOM_FLAG_NO_REACT // allowing reagents to react after being lit
		HANDLE_REACTIONS(reagents)
		update_icon()
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/proc/extinguish(mob/user, no_message)
	lit = 0
	damtype = DAMAGE_BRUTE
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	update_icon()


/obj/item/clothing/mask/smokable/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_FLAME_OR_HEAT_SOURCE] = "<p>Lights \the [initial(name)].</p>"


/obj/item/clothing/mask/smokable/use_tool(obj/item/tool, mob/user, list/click_params)
	// Flame/Heat Source - Light smokable
	if (isFlameOrHeatSource(tool))
		light(SPAN_NOTICE("\The [user] lights \the [src] with \a [tool]."))
		return TRUE

	return ..()


/obj/item/clothing/mask/smokable/attack(mob/living/M, mob/living/user, def_zone)
	if(istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light(SPAN_NOTICE("\The [user] coldly lights the \the [src] with the burning body of \the [M]."))
		return 1
	else
		return ..()


/obj/item/clothing/mask/smokable/IsFlameSource()
	return lit


/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A small paper cylinder filled with processed tobacco and various fillers."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 5
	smoketime = 300
	brand = "\improper Trans-Stellar Duty-free"
	var/list/filling = list(/datum/reagent/tobacco = 1)

/obj/item/clothing/mask/smokable/cigarette/New()
	..()
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])

/obj/item/clothing/mask/smokable/cigarette/light(flavor_text = "[usr] lights the [name].")
	..()
	if(is_processing)
		set_scent_by_reagents(src)

/obj/item/clothing/mask/smokable/cigarette/on_update_icon()
	..()
	overlays.Cut()
	if(lit)
		overlays += overlay_image(icon, "cigon", flags=RESET_COLOR)

/obj/item/clothing/mask/smokable/cigarette/trident/on_update_icon()
	..()
	overlays.Cut()
	if(lit)
		overlays += overlay_image(icon, "cigarello-on", flags=RESET_COLOR)

/obj/item/clothing/mask/smokable/extinguish(mob/user, no_message)
	..()
	remove_extension(src, /datum/extension/scent)
	if (type_butt)
		var/obj/item/butt = new type_butt(get_turf(src))
		transfer_fingerprints_to(butt)
		butt.color = color
		if(brand)
			butt.desc += " This one is a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out."))
			// if the mob has free hands, put the cig in them
			M.put_in_any_hand_if_possible(butt)
		qdel(src)

/obj/item/clothing/mask/smokable/cigarette/menthol
	name = "menthol cigarette"
	desc = "A cigarette with a little minty kick. Well, minty in theory."
	icon_state = "cigmentol"
	brand = "\improper Temperamento Menthol"
	color = "#ddffe8"
	type_butt = /obj/item/trash/cigbutt/menthol
	filling = list(/datum/reagent/tobacco = 1, /datum/reagent/menthol = 1)

/obj/item/trash/cigbutt/menthol
	icon_state = "cigbuttmentol"

/obj/item/clothing/mask/smokable/cigarette/luckystars
	brand = "\improper Lucky Star"

/obj/item/clothing/mask/smokable/cigarette/jerichos
	name = "rugged cigarette"
	brand = "\improper Jericho"
	icon_state = "cigjer"
	color = "#dcdcdc"
	type_butt = /obj/item/trash/cigbutt/jerichos
	filling = list(/datum/reagent/tobacco/bad = 1.5)

/obj/item/trash/cigbutt/jerichos
	icon_state = "cigbuttjer"

/obj/item/clothing/mask/smokable/cigarette/carcinomas
	name = "dark cigarette"
	brand = "\improper Carcinoma Angel"
	color = "#869286"

/obj/item/clothing/mask/smokable/cigarette/professionals
	name = "thin cigarette"
	brand = "\improper Professional"
	icon_state = "cigpro"
	type_butt = /obj/item/trash/cigbutt/professionals
	filling = list(/datum/reagent/tobacco/bad = 1)

/obj/item/trash/cigbutt/professionals
	icon_state = "cigbuttpro"

/obj/item/clothing/mask/smokable/cigarette/killthroat
	brand = "\improper Acme Co. cigarette"
	filling = list(/datum/reagent/tobacco = 1, /datum/reagent/fuel = 0.5)

/obj/item/clothing/mask/smokable/cigarette/dromedaryco
	brand = "\improper Dromedary Co. cigarette"

/obj/item/clothing/mask/smokable/cigarette/trident
	name = "wood tip cigar"
	brand = "\improper Trident cigar"
	desc = "A narrow cigar with a wooden tip."
	icon_state = "cigarello"
	item_state = "cigaroff"
	smoketime = 600
	chem_volume = 10
	type_butt = /obj/item/trash/cigbutt/woodbutt
	filling = list(/datum/reagent/tobacco/fine = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/mint
	icon_state = "cigarelloMi"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/menthol = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/berry
	icon_state = "cigarelloBe"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/drink/juice/berry = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/cherry
	icon_state = "cigarelloCh"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/nutriment/cherryjelly = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/grape
	icon_state = "cigarelloGr"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/drink/juice/grape = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/watermelon
	icon_state = "cigarelloWm"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/drink/juice/watermelon = 2)

/obj/item/clothing/mask/smokable/cigarette/trident/orange
	icon_state = "cigarelloOr"
	filling = list(/datum/reagent/tobacco/fine = 2, /datum/reagent/drink/juice/orange = 2)

/obj/item/trash/cigbutt/woodbutt
	name = "wooden tip"
	desc = "A wooden mouthpiece from a cigar. Smells rather bad."
	icon_state = "woodbutt"
	matter = list(MATERIAL_WOOD = 1)


/obj/item/clothing/mask/smokable/cigarette/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_FLAME_SOURCE] = "<p>Lights the [initial(name)].</p>"


/obj/item/clothing/mask/smokable/cigarette/use_tool(obj/item/tool, mob/user, list/click_params)
	// Flame Source - Light cigarette
	if (tool.IsFlameSource())
		light(SPAN_NOTICE("\The [user] lights \the [src] with \a [tool]."))
		user.update_inv_wear_mask(0)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand(1)
		return TRUE

	return ..()


/obj/item/clothing/mask/smokable/cigarette/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
			return 1
		to_chat(H, SPAN_NOTICE("You take a drag on your [name]."))
		smoke(5)
		add_trace_DNA(H)
		return 1
	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		if(!glass.is_open_container())
			to_chat(user, SPAN_NOTICE("You need to take the lid off first."))
			return
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] puts out the lit [src]."))
		extinguish(no_message = 1)
	return ..()

/obj/item/clothing/mask/smokable/cigarette/get_icon_state(mob/user_mob, slot)
	return item_state

/obj/item/clothing/mask/smokable/cigarette/get_mob_overlay(mob/user_mob, slot)
	var/image/res = ..()
	if(lit == 1)
		var/image/ember = overlay_image(res.icon, "cigember", flags=RESET_COLOR)
		ember.layer = ABOVE_LIGHTING_LAYER
		ember.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		res.overlays += ember
	return res

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 15
	brand = null
	filling = list(/datum/reagent/tobacco/fine = 5)

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	brand = "Cohiba Robusto"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	smoketime = 3000
	chem_volume = 20
	brand = "Havana"
	filling = list(/datum/reagent/tobacco/fine = 10)

/obj/item/trash/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/obj_mask.dmi'
	icon_state = "cigbutt"
	randpixel = 10
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 1

/obj/item/trash/cigbutt/New()
	..()
	SetTransform(rotation = rand(0, 360))

/obj/item/trash/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"


//Bizarre
/obj/item/clothing/mask/smokable/cigarette/rolled/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat, with a smoky scent."
	icon_state = "cigar3off"

	item_state = "cigaroff"
	icon_on = "cigar3on"
	type_butt = /obj/item/trash/cigbutt/sausagebutt
	chem_volume = 6
	smoketime = 5000
	brand = "sausage... wait what."
	filling = list(/datum/reagent/nutriment/protein = 6)

/obj/item/trash/cigbutt/sausagebutt
	name = "sausage butt"
	desc = "A piece of burnt meat."
	icon_state = "sausagebutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	w_class = ITEM_SIZE_TINY
	icon_on = "pipeon"  //Note - these are in masks.dmi
	smoketime = 0
	chem_volume = 50

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/light(flavor_text = "[usr] lights the [name].")
	if(!lit && smoketime)
		if(submerged())
			to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
			return
		lit = 1
		damtype = DAMAGE_BURN
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		set_scent_by_reagents(src)

/obj/item/clothing/mask/smokable/pipe/extinguish(mob/user, no_message)
	..()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	if(ismob(loc))
		var/mob/living/M = loc
		if (!no_message)
			to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
	remove_extension(src, /datum/extension/scent)

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] puts out [src]."), SPAN_NOTICE("You put out [src]."))
		lit = 0
		update_icon()
		STOP_PROCESSING(SSobj, src)
		remove_extension(src, /datum/extension/scent)
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message(SPAN_NOTICE("[user] empties out [src]."), SPAN_NOTICE("You empty out [src]."))
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = 0
		reagents.clear_reagents()
		SetName("empty [initial(name)]")


/obj/item/clothing/mask/smokable/pipe/get_interactions_info()
	. = ..()
	.["Fruit"] = "<p>If dried, packs the fruit and its reagents into the pipe for smoking.</p>"


/obj/item/clothing/mask/smokable/pipe/use_tool(obj/item/tool, mob/user, list/click_params)
	// Fruit - Insert dried plants for smoking
	if (istype(tool, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/fruit = tool
		if (!fruit.dry)
			to_chat(user, SPAN_WARNING("\The [tool] must be dried before you can stuff it into \the [src]."))
			return TRUE
		if (smoketime)
			to_chat(user, SPAN_WARNING("\The [src] is already packed."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		smoketime = 1000
		if (fruit.reagents)
			fruit.reagents.trans_to_obj(src, fruit.reagents.total_volume)
		user.visible_message(
			SPAN_NOTICE("\The [user] packs \the [initial(name)] with some [fruit]."),
			SPAN_NOTICE("You pack \the [initial(name)] with some [fruit].")
		)
		SetName("[fruit.name]-packed [initial(name)]")
		qdel(fruit)
		return TRUE

	return ..()


/obj/item/clothing/mask/smokable/pipe/IsFlameSource()
	return FALSE


/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	chem_volume = 35

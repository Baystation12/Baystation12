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
	var/genericmes = "<span class='notice'>USER lights their NAME with the FLAME.</span>"
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/brand
	var/gas_consumption = 0.04

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

/obj/item/clothing/mask/smokable/water_act(var/depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)

/obj/item/clothing/mask/smokable/proc/is_wet()
	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc
		return locate(/datum/reagent/water) in C.touching.reagent_list

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(QDELETED(src))
		return
	if(!lit)
		if(is_wet())
			to_chat(usr, "<span class='warning'>You are too wet to light \the [src].</span>")
			return
		if(submerged())
			to_chat(usr, "<span class='warning'>You cannot light \the [src] underwater.</span>")
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

/obj/item/clothing/mask/smokable/proc/extinguish(var/mob/user, var/no_message)
	lit = 0
	damtype = DAMAGE_BRUTE
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	update_icon()

/obj/item/clothing/mask/smokable/attackby(var/obj/item/W, var/mob/user)
	..()
	if(isflamesource(W) || is_hot(W))
		var/text = matchmes
		if(istype(W, /obj/item/flame/match))
			text = matchmes
		else if(istype(W, /obj/item/flame/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/flame/lighter))
			text = lightermes
		else if(isWelder(W))
			text = weldermes
		else if(istype(W, /obj/item/device/assembly/igniter))
			text = ignitermes
		else
			text = genericmes
		text = replacetext_char(text, "USER", "[user]")
		text = replacetext_char(text, "NAME", "[name]")
		text = replacetext_char(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/attack(var/mob/living/M, var/mob/living/user, def_zone)
	if(istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light("<span class='notice'>\The [user] coldly lights the \the [src] with the burning body of \the [M].</span>")
		return 1
	else
		return ..()

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
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"
	brand = "\improper Trans-Stellar Duty-free"
	var/list/filling = list(/datum/reagent/tobacco = 1)

/obj/item/clothing/mask/smokable/cigarette/New()
	..()
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])

/obj/item/clothing/mask/smokable/cigarette/light(var/flavor_text = "[usr] lights the [name].")
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

/obj/item/clothing/mask/smokable/extinguish(var/mob/user, var/no_message)
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
				to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
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

/obj/item/clothing/mask/smokable/cigarette/attackby(var/obj/item/W, var/mob/user)
	..()

	if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light their [name] in the process.</span>")

	return

/obj/item/clothing/mask/smokable/cigarette/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, "<span class='warning'>\The [blocked] is in the way!</span>")
			return 1
		to_chat(H, "<span class='notice'>You take a drag on your [name].</span>")
		smoke(5)
		add_trace_DNA(H)
		return 1
	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, var/mob/user, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		if(!glass.is_open_container())
			to_chat(user, "<span class='notice'>You need to take the lid off first.</span>")
			return
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>You dip \the [src] into \the [glass].</span>")
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, "<span class='notice'>[glass] is empty.</span>")
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")

/obj/item/clothing/mask/smokable/cigarette/attack_self(var/mob/user)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] puts out the lit [src].</span>")
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
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
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

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(var/obj/item/W, var/mob/user)
	..()

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

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
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!lit && smoketime)
		if(submerged())
			to_chat(usr, "<span class='warning'>You cannot light \the [src] underwater.</span>")
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

/obj/item/clothing/mask/smokable/pipe/extinguish(var/mob/user, var/no_message)
	..()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	if(ismob(loc))
		var/mob/living/M = loc
		if (!no_message)
			to_chat(M, "<span class='notice'>Your [name] goes out, and you empty the ash.</span>")
	remove_extension(src, /datum/extension/scent)

/obj/item/clothing/mask/smokable/pipe/attack_self(var/mob/user)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		lit = 0
		update_icon()
		STOP_PROCESSING(SSobj, src)
		remove_extension(src, /datum/extension/scent)
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message("<span class='notice'>[user] empties out [src].</span>", "<span class='notice'>You empty out [src].</span>")
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = 0
		reagents.clear_reagents()
		SetName("empty [initial(name)]")

/obj/item/clothing/mask/smokable/pipe/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/melee/energy/sword))
		return

	..()

	if (istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			to_chat(user, "<span class='notice'>[G] must be dried before you stuff it into [src].</span>")
			return
		if (smoketime)
			to_chat(user, "<span class='notice'>[src] is already packed.</span>")
			return
		smoketime = 1000
		if(G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		SetName("[G.name]-packed [initial(name)]")
		qdel(G)

	else if(istype(W, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = W
		if(L.lit)
			light("<span class='notice'>[user] manages to light their [name] with [W].</span>")

	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/device/assembly/igniter))
		light("<span class='notice'>[user] fiddles with [W], and manages to light their [name] with the power of science.</span>")

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	chem_volume = 35

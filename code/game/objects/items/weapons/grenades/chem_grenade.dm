/obj/item/grenade/chem_grenade
	name = "grenade casing"
	icon_state = "chemg"
	item_state = "grenade"
	desc = "A hand made chemical grenade."
	w_class = ITEM_SIZE_SMALL
	force = 2.0
	det_time = null
	unacidable = TRUE
	var/stage = 0
	var/state = 0
	var/path = 0
	var/obj/item/device/assembly_holder/detonator = null
	var/list/beakers = new/list()
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/beaker, /obj/item/reagent_containers/glass/bottle)
	var/affected_area = 3


/obj/item/grenade/chem_grenade/Initialize()
	. = ..()
	create_reagents(1000)


/obj/item/grenade/chem_grenade/attack_self(mob/user)
	if(!stage || stage==1)
		if(detonator)
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator=null
			det_time = null
			stage=0
			icon_state = initial(icon_state)
		else if(beakers.len)
			for(var/obj/B in beakers)
				if(istype(B))
					beakers -= B
					user.put_in_hands(B)
		SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
	if(stage > 1 && !active && clown_check(user))
		to_chat(user, "<span class='warning'>You prime \the [name]!</span>")
		log_and_message_admins("has primed \a [src].")
		activate()
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()


/obj/item/grenade/chem_grenade/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/assembly_holder) && (!stage || stage==1) && path != 2)
		var/obj/item/device/assembly_holder/det = W
		if(istype(det.a_left,det.a_right.type) || (!isigniter(det.a_left) && !isigniter(det.a_right)))
			to_chat(user, "<span class='warning'>Assembly must contain one igniter.</span>")
			return
		if(!det.secured)
			to_chat(user, "<span class='warning'>Assembly must be secured with screwdriver.</span>")
			return
		if(!user.unEquip(det, src))
			return
		path = 1
		log_and_message_admins("has attached \a [W] to \the [src].")
		to_chat(user, "<span class='notice'>You add [W] to the metal casing.</span>")
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, -3)
		detonator = det
		if(istimer(detonator.a_left))
			var/obj/item/device/assembly/timer/T = detonator.a_left
			det_time = 10*T.time
		if(istimer(detonator.a_right))
			var/obj/item/device/assembly/timer/T = detonator.a_right
			det_time = 10*T.time
		icon_state = initial(icon_state) +"_ass"
		SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
		stage = 1
	else if(isScrewdriver(W) && path != 2)
		if(stage == 1)
			path = 1
			if(beakers.len)
				to_chat(user, "<span class='notice'>You lock the assembly.</span>")
				SetName("grenade")
			else
//					to_chat(user, "<span class='warning'>You need to add at least one beaker before locking the assembly.</span>")
				to_chat(user, "<span class='notice'>You lock the empty assembly.</span>")
				SetName("fake grenade")
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
			icon_state = initial(icon_state) +"_locked"
			stage = 2
		else if(stage == 2)
			if(active && prob(95))
				to_chat(user, "<span class='warning'>You trigger the assembly!</span>")
				detonate()
				return
			else
				to_chat(user, "<span class='notice'>You unlock the assembly.</span>")
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
				SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
				icon_state = initial(icon_state) + (detonator?"_ass":"")
				stage = 1
				active = 0
	else if(is_type_in_list(W, allowed_containers) && (!stage || stage==1) && path != 2)
		path = 1
		if(beakers.len == 2)
			to_chat(user, "<span class='warning'>The grenade can not hold more containers.</span>")
			return
		else
			if(W.reagents.total_volume)
				if(!user.unEquip(W, src))
					return
				to_chat(user, "<span class='notice'>You add \the [W] to the assembly.</span>")
				beakers += W
				stage = 1
				SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
			else
				to_chat(user, "<span class='warning'>\The [W] is empty.</span>")


/obj/item/grenade/chem_grenade/activate(mob/user)
	if(active) return
	if(detonator)
		if(!isigniter(detonator.a_left))
			detonator.a_left.activate()
			active = 1
		if(!isigniter(detonator.a_right))
			detonator.a_right.activate()
			active = 1
	if(active)
		icon_state = initial(icon_state) + "_active"
		if(user)
			log_and_message_admins("has primed \a [src].")
	return


/obj/item/grenade/chem_grenade/proc/primed(primed = TRUE)
	if(active)
		icon_state = initial(icon_state) + (primed?"_primed":"_active")


/obj/item/grenade/chem_grenade/detonate(mob/living/user)
	if(!stage || stage<2) return
	var/has_reagents = 0
	for(var/obj/item/reagent_containers/glass/G in beakers)
		if(G.reagents.total_volume) has_reagents = 1
	active = 0
	if(!has_reagents)
		icon_state = initial(icon_state) +"_locked"
		playsound(loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		spawn(0) //Otherwise det_time is erroneously set to 0 after this
			if(istimer(detonator.a_left)) //Make sure description reflects that the timer has been reset
				var/obj/item/device/assembly/timer/T = detonator.a_left
				det_time = 10*T.time
			if(istimer(detonator.a_right))
				var/obj/item/device/assembly/timer/T = detonator.a_right
				det_time = 10*T.time
		return
	playsound(loc, 'sound/effects/bamf.ogg', 50, 1)
	for(var/obj/item/reagent_containers/glass/G in beakers)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)
	if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
		var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
		steam.set_up(10, 0, get_turf(src))
		steam.attach(src)
		steam.start()
		for(var/atom/A in view(affected_area, loc))
			if( A == src )
				continue
			reagents.touch(A)
	if(istype(loc, /mob/living/carbon))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/C = loc
		C.drop_from_inventory(src)
		C.throw_mode_off()
	set_invisibility(INVISIBILITY_MAXIMUM) //Why am i doing this?
	spawn(50)		   //To make sure all reagents can work
		qdel(src)	   //correctly before deleting the grenade.


/obj/item/grenade/chem_grenade/examine(mob/user)
	. = ..()
	if(detonator)
		to_chat(user, "With attached [detonator.name]")


/obj/item/grenade/chem_grenade/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/reagent_containers/glass)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	affected_area = 4


/obj/item/grenade/chem_grenade/metalfoam
	name = "metal-foam grenade"
	desc = "Used for emergency sealing of air breaches."
	path = 1
	stage = 2


/obj/item/grenade/chem_grenade/metalfoam/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/aluminium, 30)
	B2.reagents.add_reagent(/datum/reagent/foaming_agent, 10)
	B2.reagents.add_reagent(/datum/reagent/acid/polyacid, 10)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"


/obj/item/grenade/chem_grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2


/obj/item/grenade/chem_grenade/incendiary/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/aluminium, 15)
	B1.reagents.add_reagent(/datum/reagent/fuel,20)
	B2.reagents.add_reagent(/datum/reagent/toxin/phoron, 15)
	B2.reagents.add_reagent(/datum/reagent/acid, 15)
	B1.reagents.add_reagent(/datum/reagent/fuel,20)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"


/obj/item/grenade/chem_grenade/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	path = 1
	stage = 2


/obj/item/grenade/chem_grenade/antiweed/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/toxin/plantbgone, 25)
	B1.reagents.add_reagent(/datum/reagent/potassium, 25)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/sugar, 25)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = "grenade"


/obj/item/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = 2
	path = 1

/obj/item/grenade/chem_grenade/cleaner/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/surfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/space_cleaner, 10)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"


/obj/item/grenade/chem_grenade/teargas
	name = "tear gas grenade"
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."
	stage = 2
	path = 1


/obj/item/grenade/chem_grenade/teargas/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/phosphorus, 40)
	B1.reagents.add_reagent(/datum/reagent/potassium, 40)
	B1.reagents.add_reagent(/datum/reagent/capsaicin/condensed, 40)
	B2.reagents.add_reagent(/datum/reagent/sugar, 40)
	B2.reagents.add_reagent(/datum/reagent/capsaicin/condensed, 80)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"


/obj/item/grenade/chem_grenade/water
	name = "water grenade"
	desc = "A water grenade, generally used for firefighting."
	icon_state = "waterg"
	item_state = "waterg"
	stage = 2
	path = 1


/obj/item/grenade/chem_grenade/water/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"

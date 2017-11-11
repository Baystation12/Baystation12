//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A good, durable combination wrench, with self-adjusting, universal open- and ring-end mechanisms to match a wide variety of nuts and bolts."
	description_info = "This versatile tool is used for dismantling machine frames, anchoring or unanchoring heavy objects like vending machines and emitters, and much more. In general, if you want something to move or stop moving entirely, you ought to use a wrench on it."
	description_fluff = "The classic open-end wrench (or spanner, if you prefer) hasn't changed significantly in shape in over 500 years, though these days they employ a bit of automated trickery to match various bolt sizes and configurations."
	description_antag = "Not only is this handy tool good for making off with machines, but it even makes a weapon in a pinch!"
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	item_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	center_of_mass = "x=17;y=16"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/wrench/New()
	icon_state = "wrench[pick("","_red","_black")]"

/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "Your archetypal flathead screwdriver, with a nice, heavy polymer handle."
	description_info = "This tool is used to expose or safely hide away cabling. It can open and shut the maintenance panels on vending machines, airlocks, and much more. You can also use it, in combination with a crowbar, to install or remove windows."
	description_fluff = "Screws have not changed significantly in centuries, and neither have the drivers used to install and remove them."
	description_antag = "In the world of breaking and entering, tools like multitools and wirecutters are the bread; the screwdriver is the butter. In a pinch, try targetting someone's eyes and stabbing them with it - it'll really hurt!"
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 4.0
	w_class = ITEM_SIZE_TINY
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	center_of_mass = "x=16;y=7"
	attack_verb = list("stabbed")
	lock_picking_level = 5

/obj/item/weapon/screwdriver/New()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	..()

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != BP_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "A special pair of pliers with cutting edges. Various brackets and manipulators built into the handle allow it to repair severed wiring."
	description_info = "This tool will cut wiring anywhere you see it - make sure to wear insulated gloves! When used on more complicated machines or airlocks, it can not only cut cables, but repair them, as well."
	description_fluff = "With modern alloys, today's wirecutters can snap through cables of astonishing thickness."
	description_antag = "These cutters can be used to cripple the power anywhere on the ship. All it takes is some creativity, and being in the right place at the right time."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 3.0
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	center_of_mass = "x=18;y=10"
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	desc = "A heavy but portable welding gun with its own internal fuel tank. It features a simple toggle switch, and a port for attaching an external tank."
	description_info = "Use in your hand to toggle the welder on and off. Click on an object to try to weld it. You can seal airlocks, attach heavy-duty machines like emitters and disposal chutes, and repair damaged walls - these are only a few of its uses. Each use of the welder will consume a unit of fuel. Be sure to wear eye protection such as goggles, a mask, or certain voidsuit helmets, otherwise you risk damaging your eyes! You can refill the welder with a welder tank by clicking on it, but be sure to turn it off first!"
	description_fluff = "One of many tools of ancient design, still used in today's busy world of engineering with only minor tweaks here and there. Compact machinery and innovations in fuel storage have allowed for conveniences like this one-piece, handheld welder to exist."
	description_antag = "You can use a welder to rapidly seal off doors, ventilation ducts, and scrubbers. It also makes for a devastating weapon. Modify it with a screwdriver and stick some metal rods on it, and you've got the beginnings of a flamethrower."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	center_of_mass = "x=14;y=15"

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL

	//Cost to make in the autolathe
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weapon/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	..()

/obj/item/weapon/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/weldingtool/examine(mob/user)
	if(..(user, 0))
		to_chat(user, text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel ))


/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/screwdriver))
		if(welding)
			to_chat(user, "<span class='danger'>Stop welding first!</span>")
			return
		status = !status
		if(status)
			to_chat(user, "<span class='notice'>You secure the welder.</span>")
		else
			to_chat(user, "<span class='notice'>The welder can now be attached and modified.</span>")
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.reset_plane_and_layer()
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return

	..()
	return


/obj/item/weapon/weldingtool/Process()
	if(welding)
		if(!remove_fuel(0.05))
			setWelding(0)

/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !src.welding)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>Welder refueled</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return


/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		burn_fuel(amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, "<span class='notice'>You need more welding fuel to complete this task.</span>")
		return 0

/obj/item/weapon/weldingtool/proc/burn_fuel(var/amount)
	var/mob/living/in_mob = null

	//consider ourselves in a mob if we are in the mob's contents and not in their hands
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		if(!(L.l_hand == src || L.r_hand == src))
			in_mob = L

	if(in_mob)
		amount = max(amount, 2)
		reagents.trans_type_to(in_mob, /datum/reagent/fuel, amount)
		in_mob.IgniteMob()

	else
		reagents.remove_reagent(/datum/reagent/fuel, amount)
		var/turf/location = get_turf(src.loc)
		if(location)
			location.hotspot_expose(700, 5)

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return src.welding

/obj/item/weapon/weldingtool/get_storage_cost()
	if(isOn())
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/obj/item/weapon/weldingtool/update_icon()
	..()
	icon_state = welding ? "welder1" : "welder"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, "<span class='notice'>You switch the [src] on.</span>")
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			src.force = 15
			src.damtype = "fire"
			welding = 1
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			if(M)
				to_chat(M, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
	//Otherwise
	else if(!set_welding && welding)
		STOP_PROCESSING(SSobj, src)
		if(M)
			to_chat(M, "<span class='notice'>You switch \the [src] off.</span>")
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		src.force = 3
		src.damtype = "brute"
		src.welding = 0
		update_icon()

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(!E)
			return
		var/safety = H.eyecheck()
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				to_chat(H, "<span class='warning'>Your eyes sting a little.</span>")
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				to_chat(H, "<span class='warning'>Your eyes burn.</span>")
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(FLASH_PROTECTION_REDUCED)
				to_chat(H, "<span class='danger'>Your equipment intensifies the welder's glow. Your eyes itch and burn severely.</span>")
				H.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.damage > 10)
				to_chat(user, "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>")

			if (E.damage >= E.min_broken_damage)
				to_chat(H, "<span class='danger'>You go blind!</span>")
				H.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				to_chat(H, "<span class='danger'>You go blind!</span>")
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED


/obj/item/weapon/weldingtool/mini
	name = "miniature welding tool"
	desc = "A welder with a very small fuel tank, meant for quick emergency use."
	max_fuel = 5
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 15, "glass" = 5)

/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A heavy-duty portable welder, with an extra large fuel tank to ensure it won't suddenly go cold on you."
	max_fuel = 40
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 60)

/obj/item/weapon/weldingtool/hugetank
	name = "upgraded welding tool"
	desc = "A portable welding tool of astonishing weight. It appears to have had a very large after-market fuel tank installed."
	max_fuel = 80
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 120)

/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	max_fuel = 40
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 120)
	var/last_gen = 0

/obj/item/weapon/weldingtool/experimental/New()
	description_info += "<br><br>This welder will passively regenerate fuel."

/obj/item/weapon/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = ((world.time-last_gen)/25)
	reagents += (gen_amount)
	if(reagents > max_fuel)
		reagents = max_fuel

/obj/item/weapon/weldingtool/attack(mob/living/M, mob/living/user, target_zone)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[target_zone]

		if(!S || !(S.robotic >= ORGAN_ROBOT) || user.a_intent != I_HELP)
			return ..()

		if(!welding)
			to_chat(user, "<span class='warning'>You'll need to turn [src] on to patch the damage on [M]'s [S.name]!</span>")
			return 1

		if(S.robo_repair(15, BRUTE, "some dents", src, user))
			remove_fuel(1, user)

	else
		return ..()

/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	description_info = "Crowbars have countless uses: click on floor tiles to pry them loose. Use alongside a screwdriver to install or remove windows. Force open emergency shutters, or depowered airlocks. Open the panel of an unlocked APC. Pry a computer's circuit board free. And much more!"
	description_fluff = "As is the case with most standard-issue tools, crowbars are a simple and timeless design, the only difference being that advanced materials like plasteel have made them uncommonly tough."
	description_antag = "Need to bypass a bolted door? You can use a crowbar to pry the electronics out of an airlock, provided that it has no power and has been welded shut."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 7.0
	throwforce = 7.0
	throw_range = 3
	item_state = "crowbar"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 140)
	center_of_mass = "x=16;y=20"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge at one end and a hard rubber pommel handle at the other."
	icon_state = "prybar"
	item_state = "crowbar"
	force = 4.0
	throwforce = 6.0
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 80)

/*
 * Combitool
 */


/*/obj/item/weapon/combitool
	name = "combi-tool"
	desc = "It even has one of those nubbins for doing the thingy."
	icon = 'icons/obj/items.dmi'
	icon_state = "combitool"
	w_class = ITEM_SIZE_SMALL

	var/list/spawn_tools = list(
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/material/kitchen/utensil/knife,
		/obj/item/weapon/material/kitchen/utensil/fork,
		/obj/item/weapon/material/hatchet
		)
	var/list/tools = list()
	var/current_tool = 1

/obj/item/weapon/combitool/examine()
	..()
	if(loc == usr && tools.len)
		to_chat(usr, "It has the following fittings:")
		for(var/obj/item/tool in tools)
			to_chat(usr, "\icon[tool] - [tool.name][tools[current_tool]==tool?" (selected)":""]")

/obj/item/weapon/combitool/New()
	..()
	for(var/type in spawn_tools)
		tools |= new type(src)

/obj/item/weapon/combitool/attack_self(mob/user as mob)
	if(++current_tool > tools.len) current_tool = 1
	var/obj/item/tool = tools[current_tool]
	if(!tool)
		to_chat(user, "You can't seem to find any fittings in \the [src].")
	else
		to_chat(user, "You switch \the [src] to the [tool.name] fitting.")
	return 1

/obj/item/weapon/combitool/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!M.Adjacent(user))
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	return (tool ? tool.attack(M,user) : 0)

/obj/item/weapon/combitool/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	tool.loc = user
	var/resolved = target.attackby(tool,user)
	if(!resolved && tool && target)
		tool.afterattack(target,user,1)
	if(tool)
		tool.loc = src*/

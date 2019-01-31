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
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	item_state = "wrench"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 7
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 150)
	center_of_mass = "x=17;y=16"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/wrench/Initialize()
	icon_state = "wrench[pick("","_red","_black","_green","_blue")]"
	. = ..()

/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "Your archetypal flathead screwdriver, with a nice, heavy polymer handle."
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 4.0
	w_class = ITEM_SIZE_TINY
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	matter = list(MATERIAL_STEEL = 75)
	center_of_mass = "x=16;y=7"
	attack_verb = list("stabbed")
	lock_picking_level = 5
	sharp = TRUE

/obj/item/weapon/screwdriver/Initialize()
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
	. = ..()

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != BP_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "A special pair of pliers with cutting edges. Various brackets and manipulators built into the handle allow it to repair severed wiring."
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 3.0
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 80)
	center_of_mass = "x=18;y=10"
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/weapon/wirecutters/Initialize()
	switch(pick("red","yellow","green","blue","black"))
		if ("red")
			icon_state = "cutters"
			item_state = "cutters"
		if ("yellow")
			icon_state = "cutters_yellow"
			item_state = "cutters_yellow"
		if ("green")
			icon_state = "cutters_green"
			item_state = "cutters_green"
		if ("blue")
			icon_state = "cutters_blue"
			item_state = "cutters_blue"
		if ("black")
			icon_state = "cutters_black"
			item_state = "cutters_black"
	. = ..()

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
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
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder_m"
	item_state = "welder"
	desc = "A heavy but portable welding gun with its own interchangeable fuel tank. It features a simple toggle switch and a port for attaching an external tank."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	center_of_mass = "x=14;y=15"
	waterproof = FALSE

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL

	//Cost to make in the autolathe
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/welding_resource = "welding fuel"
	var/obj/item/weapon/welder_tank/tank = /obj/item/weapon/welder_tank // where the fuel is stored

/obj/item/weapon/weldingtool/Initialize()
	if(ispath(tank))
		tank = new tank

	set_extension(src, /datum/extension/base_icon_state, /datum/extension/base_icon_state, icon_state)
	update_icon()

	. = ..()

/obj/item/weapon/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)

	QDEL_NULL(tank)

	return ..()

/obj/item/weapon/weldingtool/examine(mob/user)
	if(..(user, 0))
		show_fuel(user)

/obj/item/weapon/weldingtool/proc/show_fuel(var/mob/user)
	if(tank)
		to_chat(user, "\icon[tank] \The [tank] contains [get_fuel()]/[tank.max_fuel] units of [welding_resource]!")
	else
		to_chat(user, "There is no tank attached.")

/obj/item/weapon/weldingtool/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return

	if(istype(over, /obj/item/weapon/weldpack))
		var/obj/item/weapon/weldpack/wp = over
		if(wp.welder)
			to_chat(usr, "\The [wp] already has \a [wp.welder] attached.")
		else if(usr.unEquip(src, wp))
			wp.welder = src
			usr.visible_message("[usr] attaches \the [src] to \the [wp].", "You attach \the [src] to \the [wp].")
			wp.update_icon()
		return

	..()

/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(welding)
		to_chat(user, "<span class='danger'>Stop welding first!</span>")
		return

	if(isScrewdriver(W))
		status = !status
		if(status)
			to_chat(user, "<span class='notice'>You secure the welder.</span>")
		else
			to_chat(user, "<span class='notice'>The welder can now be attached and modified.</span>")
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/material/rods)))
		var/obj/item/stack/material/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		user.drop_from_inventory(src, F)
		F.weldtool = src
		master = F
		add_fingerprint(user)
		return

	if(istype(W, /obj/item/weapon/welder_tank))
		if(tank)
			to_chat(user, "Remove the current tank first.")
			return

		if(W.w_class >= w_class)
			to_chat(user, "\The [W] is too large to fit in \the [src].")
			return

		if(!user.unEquip(W, src))
			return
		tank = W
		user.visible_message("[user] slots \a [W] into \the [src].", "You slot \a [W] into \the [src].")
		update_icon()
		return

	..()


/obj/item/weapon/weldingtool/attack_hand(mob/user as mob)
	if(tank && user.get_inactive_hand() == src)
		if(!welding)
			if(tank.can_remove)
				user.visible_message("[user] removes \the [tank] from \the [src].", "You remove \the [tank] from \the [src].")
				user.put_in_hands(tank)
				tank = null
				update_icon()
			else
				to_chat(user, "\The [tank] can't be removed.")
		else
			to_chat(user, "<span class='danger'>Stop welding first!</span>")

	else
		..()

/obj/item/weapon/weldingtool/water_act()
	if(welding && !waterproof)
		setWelding(0)

/obj/item/weapon/weldingtool/Process()
	if(welding)
		if((!waterproof && submerged()) || !remove_fuel(0.05))
			setWelding(0)

/obj/item/weapon/weldingtool/afterattack(var/obj/O, var/mob/user, proximity)
	if(!proximity)
		return

	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !welding)
		if(!tank)
			to_chat(user, SPAN_WARNING("\The [src] has no tank attached!"))
			return
		O.reagents.trans_to_obj(tank, tank.max_fuel)
		to_chat(user, SPAN_NOTICE("You refuel \the [tank]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if(welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		else if(istype(O))
			O.HandleObjectHeating(src, user, 700)
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return tank ? tank.reagents.get_reagent_amount(/datum/reagent/fuel) : 0

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
			to_chat(M, "<span class='notice'>You need more [welding_resource] to complete this task.</span>")
		return 0

/obj/item/weapon/weldingtool/proc/burn_fuel(var/amount)
	if(!tank)
		return

	var/mob/living/in_mob = null

	//consider ourselves in a mob if we are in the mob's contents and not in their hands
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		if(!(L.l_hand == src || L.r_hand == src))
			in_mob = L

	if(in_mob)
		amount = max(amount, 2)
		tank.reagents.trans_type_to(in_mob, /datum/reagent/fuel, amount)
		in_mob.IgniteMob()

	else
		tank.reagents.remove_reagent(/datum/reagent/fuel, amount)
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

/obj/item/weapon/weldingtool/on_update_icon()
	..()

	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
	icon_state = welding ? "[bis.base_icon_state]1" : "[bis.base_icon_state]"
	item_state = welding ? "welder1" : "welder"

	underlays.Cut()
	if(tank)
		var/image/tank_image = image(tank.icon, icon_state = tank.icon_state)
		tank_image.pixel_z = 0
		underlays += tank_image

	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	if(!welding && !waterproof && submerged())
		if(M)
			to_chat(M, "<span class='warning'>You cannot light \the [src] underwater.</span>")
		return

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
				to_chat(M, "<span class='notice'>You need more [welding_resource] to complete this task.</span>")
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
			if (E.damage >= E.min_bruised_damage)
				to_chat(H, "<span class='danger'>You go blind!</span>")
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED

/obj/item/weapon/welder_tank
	name = "welding fuel tank"
	desc = "An interchangeable fuel tank meant for a welding tool."
	icon = 'icons/obj/tools.dmi'
	icon_state = "fuel_m"
	w_class = ITEM_SIZE_SMALL
	var/max_fuel = 20
	var/can_remove = 1

/obj/item/weapon/welder_tank/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	. = ..()

/obj/item/weapon/welder_tank/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>You refuel \the [src].</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

/obj/item/weapon/weldingtool/mini
	name = "miniature welding tool"
	icon_state = "welder_s"
	item_state = "welder"
	desc = "A smaller welder, meant for quick or emergency use."
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_GLASS = 5)
	w_class = ITEM_SIZE_SMALL
	tank = /obj/item/weapon/welder_tank/mini

/obj/item/weapon/welder_tank/mini
	name = "small welding fuel tank"
	icon_state = "fuel_s"
	w_class = ITEM_SIZE_TINY
	max_fuel = 5
	can_remove = 0

/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	icon_state = "welder_l"
	item_state = "welder"
	desc = "A heavy-duty portable welder, made to ensure it won't suddenly go cold on you."
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 60)
	w_class = ITEM_SIZE_LARGE
	tank = /obj/item/weapon/welder_tank/large

/obj/item/weapon/welder_tank/large
	name = "large welding fuel tank"
	icon_state = "fuel_l"
	w_class = ITEM_SIZE_NORMAL
	max_fuel = 40

/obj/item/weapon/weldingtool/hugetank
	name = "upgraded welding tool"
	icon_state = "welder_h"
	item_state = "welder"
	desc = "A sizable welding tool with room to accomodate the largest of fuel tanks."
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 120)
	tank = /obj/item/weapon/welder_tank/huge

/obj/item/weapon/welder_tank/huge
	name = "huge welding fuel tank"
	icon_state = "fuel_h"
	w_class = ITEM_SIZE_LARGE
	max_fuel = 80

/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	icon_state = "welder_l"
	item_state = "welder"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 120)
	tank = /obj/item/weapon/welder_tank/experimental

/obj/item/weapon/welder_tank/experimental
	name = "experimental welding fuel tank"
	icon_state = "fuel_x"
	w_class = ITEM_SIZE_NORMAL
	max_fuel = 40
	can_remove = 0
	var/last_gen = 0

/obj/item/weapon/welder_tank/experimental/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/welder_tank/experimental/Destroy()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/welder_tank/experimental/Process()
	var/cur_fuel = reagents.get_reagent_amount(/datum/reagent/fuel)
	if(cur_fuel < max_fuel)
		var/gen_amount = ((world.time-last_gen)/25)
		reagents.add_reagent(/datum/reagent/fuel, gen_amount)
		last_gen = world.time

/obj/item/weapon/weldingtool/attack(mob/living/M, mob/living/user, target_zone)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[target_zone]

		if(!S || !BP_IS_ROBOTIC(S) || user.a_intent != I_HELP)
			return ..()

		if(BP_IS_BRITTLE(S))
			to_chat(user, "<span class='warning'>\The [M]'s [S.name] is hard and brittle - \the [src]  cannot repair it.</span>")
			return 1

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
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 14
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -20
	throwforce = 7.0
	throw_range = 3
	item_state = "crowbar"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 140)
	center_of_mass = "x=16;y=20"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations - collect them all."
	icon_state = "prybar"
	item_state = "crowbar"
	force = 4.0
	throwforce = 6.0
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 80)

/obj/item/weapon/crowbar/prybar/Initialize()
	icon_state = "prybar[pick("","_red","_green","_aubergine","_blue")]"
	. = ..()

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

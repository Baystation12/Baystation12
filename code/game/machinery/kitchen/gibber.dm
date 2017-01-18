
/obj/machinery/gibber
	name = "meat grinder"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	req_access = list(access_kitchen,access_morgue)

	var/operating = 0        //Is it on?
	var/dirty = 0            // Does it need cleaning?
	var/mob/living/occupant  // Mob who has been put inside
	var/gib_time = 40        // Time from starting until meat appears
	var/gib_throw_dir = WEST // Direction to spit meat and gibs in.

	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					gib_throw_dir = i
					qdel(input_obj)
					break

		if(!input_plate)
			log_misc("a [src] didn't find an input plate.")
			return

/obj/machinery/gibber/autogibber/Bumped(var/atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.loc = src
			M.gib()


/obj/machinery/gibber/initialize()
	. = ..()
	update_icon()

/obj/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		src.overlays += image('icons/obj/kitchen.dmi', "grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/gibber/relaymove(mob/user as mob)
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is locked and running, wait for it to finish.</span>")
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/examine()
	..()
	to_chat(usr, "The safety guard is [emagged ? "<span class='danger'>disabled</span>" : "enabled"].")

/obj/machinery/gibber/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, "<span class='danger'>You [emagged ? "disable" : "enable"] \the [src]'s safety guard.</span>")
	return 1

/obj/machinery/gibber/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(G.state < GRAB_AGGRESSIVE)
			to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
			return
		move_into_gibber(user,G.affecting)
		user.drop_from_inventory(G)
	else if(istype(W, /obj/item/organ))
		user.drop_from_inventory(W)
		qdel(W)
		user.visible_message("<span class='danger'>\The [user] feeds \the [W] into \the [src], obliterating it.</span>")
	else
		return ..()

/obj/machinery/gibber/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_gibber(user,target)

/obj/machinery/gibber/proc/move_into_gibber(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		to_chat(user, "<span class='danger'>\The [src] is full, empty it first!</span>")
		return

	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is locked and running, wait for it to finish.</span>")
		return

	if(!(istype(victim, /mob/living/carbon)) && !(istype(victim, /mob/living/simple_animal)) )
		to_chat(user, "<span class='danger'>This is not suitable for \the [src]!</span>")
		return

	if(istype(victim,/mob/living/carbon/human) && !emagged)
		to_chat(user, "<span class='danger'>\The [src] safety guard is engaged!</span>")
		return


	if(victim.abiotic(1))
		to_chat(user, "<span class='danger'>\The [victim] may not have any abiotic items on.</span>")
		return

	user.visible_message("<span class='danger'>\The [user] starts to put \the [victim] into \the [src]!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 30, src) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("<span class='danger'>\The [user] stuffs \the [victim] into \the [src]!</span>")
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.loc = src
		src.occupant = victim
		update_icon()

/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if(operating || !src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	update_icon()
	return

/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='danger'>You hear a loud metallic grinding sound.</span>")
		return

	use_power(1000)
	visible_message("<span class='danger'>You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound.</span>")
	src.operating = 1
	update_icon()

	var/slab_name = occupant.name
	var/slab_count = 3
	var/slab_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	var/slab_nutrition = 20
	if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		slab_nutrition = C.nutrition / 15

	// Some mobs have specific meat item types.
	if(istype(src.occupant,/mob/living/simple_animal))
		var/mob/living/simple_animal/critter = src.occupant
		if(critter.meat_amount)
			slab_count = critter.meat_amount
		if(critter.meat_type)
			slab_type = critter.meat_type
	else if(istype(src.occupant,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = occupant
		slab_name = src.occupant.real_name
		slab_type = H.isSynthetic() ? /obj/item/stack/material/steel : H.species.meat_type

	// Small mobs don't give as much nutrition.
	if(issmall(src.occupant))
		slab_nutrition *= 0.5
	slab_nutrition /= slab_count

	for(var/i=1 to slab_count)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/new_meat = new slab_type(src, rand(3,8))
		if(istype(new_meat))
			new_meat.name = "[slab_name] [new_meat.name]"
			new_meat.reagents.add_reagent("nutriment",slab_nutrition)
			if(src.occupant.reagents)
				src.occupant.reagents.trans_to_obj(new_meat, round(occupant.reagents.total_volume/slab_count,1))

	admin_attack_log(user, occupant, "Gibbed the victim", "Was gibbed", "gibbed")
	src.occupant.ghostize()

	spawn(gib_time)

		src.operating = 0
		src.occupant.gib()
		qdel(src.occupant)

		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/obj/thing in contents)
			// There's a chance that the gibber will fail to destroy some evidence.
			if(istype(thing,/obj/item/organ) && prob(80))
				qdel(thing)
				continue
			thing.loc = get_turf(thing) // Drop it onto the turf for throwing.
			thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(0,3),emagged ? 100 : 50) // Being pelted with bits of meat and bone would hurt.
		update_icon()



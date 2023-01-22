
/obj/machinery/gibber
	name = "meat grinder"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE
	req_access = list(access_kitchen,access_morgue)
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "meat grinder"
	machine_desc = "Messily turns animals - living or dead - into edible meat. Installed safety mechanisms prevent use on humans."

	var/operating = 0        //Is it on?
	var/dirty = 0            // Does it need cleaning?
	var/mob/living/occupant  // Mob who has been put inside
	var/gib_time = 40        // Time from starting until meat appears
	var/gib_throw_dir = WEST // Direction to spit meat and gibs in.

	idle_power_usage = 2
	active_power_usage = 500

/obj/machinery/gibber/Initialize()
	. = ..()
	update_icon()

/obj/machinery/gibber/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant = null
	. = ..()

/obj/machinery/gibber/on_update_icon()
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

/obj/machinery/gibber/physical_attack_hand(mob/user)
	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is locked and running, wait for it to finish.</span>")
		return TRUE
	src.startgibbing(user)
	return TRUE

/obj/machinery/gibber/examine(mob/user)
	. = ..()
	to_chat(user, "The safety guard is [emagged ? "<span class='danger'>disabled</span>" : "enabled"].")

/obj/machinery/gibber/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, "<span class='danger'>You [emagged ? "disable" : "enable"] \the [src]'s safety guard.</span>")
	return 1

/obj/machinery/gibber/components_are_accessible(path)
	return !operating && ..()

/obj/machinery/gibber/cannot_transition_to(state_path, mob/user)
	if(operating)
		return SPAN_NOTICE("You must wait for \the [src] to finish operating first!")
	return ..()

/obj/machinery/gibber/attackby(var/obj/item/W, var/mob/user)
	if(!operating)
		return
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(!G.force_danger())
			to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
			return
		move_into_gibber(user,G.affecting)
		qdel(G)
	else if(istype(W, /obj/item/organ))
		if(!user.unEquip(W))
			return
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
	if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("<span class='danger'>\The [user] stuffs \the [victim] into \the [src]!</span>")
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
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
	for(var/obj/O in (contents - component_parts))
		O.dropInto(loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.dropInto(loc)
	src.occupant = null
	update_icon()
	return

/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='danger'>You hear a loud metallic grinding sound.</span>")
		return

	use_power_oneoff(1000)
	visible_message("<span class='danger'>You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound.</span>")
	src.operating = 1
	update_icon()

	admin_attack_log(user, occupant, "Gibbed the victim", "Was gibbed", "gibbed")
	src.occupant.ghostize()
	addtimer(CALLBACK(src, .proc/finish_gibbing), gib_time)

	var/list/gib_products = shuffle(occupant.harvest_meat() | occupant.harvest_skin() | occupant.harvest_bones())
	if(length(gib_products) <= 0)
		return

	var/slab_name =  occupant.name
	var/slab_nutrition = 20

	if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		slab_nutrition = C.nutrition / 15

	if(istype(occupant, /mob/living/carbon/human))
		slab_name = occupant.real_name

	// Small mobs don't give as much nutrition.
	if(issmall(src.occupant))
		slab_nutrition *= 0.5

	slab_nutrition /= gib_products.len

	var/drop_products = Floor(gib_products.len * 0.35)
	for(var/atom/movable/thing in gib_products)
		if(drop_products)
			drop_products--
			qdel(thing)
		else
			thing.forceMove(src)
			if(istype(thing, /obj/item/reagent_containers/food/snacks/meat))
				var/obj/item/reagent_containers/food/snacks/meat/slab = thing
				slab.SetName("[slab_name] [slab.name]")
				slab.reagents.add_reagent(/datum/reagent/nutriment,slab_nutrition)

/obj/machinery/gibber/proc/finish_gibbing()
	operating = 0
	if(QDELETED(occupant))
		occupant = null
		return
	occupant.gib()
	qdel(occupant)

	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	for (var/obj/thing in (contents - component_parts))
		// There's a chance that the gibber will fail to destroy some evidence.
		if(istype(thing,/obj/item/organ) && prob(80))
			qdel(thing)
			continue
		thing.dropInto(loc) // Attempts to drop it onto the turf for throwing.
		thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(0,3),emagged ? 30 : 15) // Being pelted with bits of meat and bone would hurt.
	update_icon()

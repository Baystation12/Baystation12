/obj/item/device/assembly/chem_mixer
	name = "chemical mixer"
	icon_state = "chem_mixer"
	item_state = "assembly"
	desc = "A crude frame that automatically mixes two beakers together."
	w_class = 2.0
	force = 2.0
	var/used = 0
	var/list/beakers = new/list()
	var/max_beakers = 2
	var/list/allowed_containers = list(/obj/item/weapon/reagent_containers/glass/beaker, /obj/item/weapon/reagent_containers/glass/bottle)
	var/affected_area = 3
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE
	wire_num = 3
	dangerous = 1

/obj/item/device/assembly/chem_mixer/update_icon()
	icon_state = "[initial(icon_state)][beakers.len]"

/obj/item/device/assembly/chem_mixer/signal_failure()
	if(prob(5))
		activate()

/obj/item/device/assembly/chem_mixer/New()
	..()
	create_reagents(1000)
	update_icon()

/obj/item/device/assembly/chem_mixer/Destroy()
	for(var/obj/O in beakers)
		qdel(O)
	return ..()

/obj/item/device/assembly/chem_mixer/proc/attach_container(var/obj/item/W)
	if(is_type_in_list(W, allowed_containers))
		W.forceMove(src)
		beakers += W
	update_icon()

/obj/item/device/assembly/chem_mixer/attackby(var/obj/item/W, var/mob/living/carbon/user)
	if(is_type_in_list(W, allowed_containers))
		if(beakers.len >= max_beakers)
			user << "<span class='warning'>\The [src] can not hold more containers.</span>"
			return
		else
			if(W.reagents.total_volume)
				user << "<span class='notice'>You add \the [W] to the assembly.</span>"
				user.drop_item()
				attach_container(W)
			else
				user << "<span class='warning'>\The [W] is empty.</span>"
	else if(istype(W, /obj/item/stack/cable_coil) && used)
		var/obj/item/stack/cable_coil/C = W
		if(C.use(5))
			user << "<span class='notice'>You reset \the [src]!</span>"
			used = 0
		else
			user << "<span class='notice'>You need atleast 5 units of cable to do that!</span>"
			return
	else
		..(W, user)
	update_icon()


/obj/item/device/assembly/chem_mixer/examine(var/mob/user)
	..()
	if(beakers.len)
		user << "It contains [beakers.len] reagent containers!"
	if(used)
		user << "It looks like it needs to be reset!"

/obj/item/device/assembly/chem_mixer/activate()
	if(used)
		return 0
	playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)
	for(var/obj/item/weapon/reagent_containers/G in beakers)
		G.reagents.trans_to_obj((holder ? holder : src), G.reagents.total_volume)

	if((holder && holder.reagents.total_volume) || (!holder && src.reagents.total_volume)) //The possible reactions didnt use up all reagents.
		var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
		var/turf/T = (holder ? get_turf(holder) : get_turf(src))
		steam.set_up(10, 0, T)
		steam.attach(holder ? holder : src)
		steam.start()
		for(var/atom/A in view(affected_area, T))
			src.reagents.touch(A)

	if(holder && istype(holder.loc, /mob/living/carbon/human))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/human/H = loc
		if(H)
			H.drop_from_inventory(holder)
			H.throw_mode_off()

	used = 1
	update_icon()
	return 1

/obj/item/device/assembly/chem_mixer/igniter_act()
	activate() // ignores wire checks

/obj/item/device/assembly/chem_mixer/get_buttons()
	return list("Eject Beakers", "Activate")

/obj/item/device/assembly/chem_mixer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["option"])
		if(href_list["option"] == "Eject Beakers")
			for(var/obj/O in beakers)
				O.forceMove(get_turf(src))
				beakers -= O
			return 1
		if(href_list["option"] == "Activate")
			process_activation()
			return 1
	update_icon()

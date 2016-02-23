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
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	update_icon()

/obj/item/device/assembly/chem_mixer/proc/attach_container(var/obj/item/W)
	if(is_type_in_list(W, allowed_containers))
		W.forceMove(src)
		beakers += W

/obj/item/device/assembly/chem_mixer/attackby(var/obj/item/W, var/mob/living/carbon/user)
	if(is_type_in_list(W, allowed_containers))
		if(beakers.len >= max_beakers)
			user << "<span class='warning'>\The [src] can not hold more containers.</span>"
			return
		else
			if(W.reagents.total_volume)
				user << "<span class='notice'>You add \the [W] to the assembly.</span>"
				user.remove_from_mob(src)
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
		return
	playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)
	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		G.reagents.trans_to(src, G.reagents.total_volume)

	if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
		var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
		steam.set_up(10, 0, get_turf(src))
		steam.attach(src)
		steam.start()
		for(var/atom/A in view(affected_area, get_turf(src)))
			src.reagents.touch(A)

	if(istype(holder.loc, /mob/living/carbon))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/human/H = loc
		H.drop_item()
		H.throw_mode_off()

	invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
	spawn(50)		   //To make sure all reagents can work
		used = 1
	update_icon()

/obj/item/device/assembly/chem_mixer/igniter_act()
	process_activation()

/obj/item/device/assembly/chem_mixer/get_buttons()
	return list("Eject Beakers", "Activate")

/obj/item/device/assembly/chem_mixer/Topic(href, href_list)
	if(href_list["option"])
		if(href_list["option"] == "Eject Beakers")
			for(var/obj/O in beakers)
				O.forceMove(get_turf(src))
				beakers -= O
		if(href_list["option"] == "Activate")
			process_activation()
	..()

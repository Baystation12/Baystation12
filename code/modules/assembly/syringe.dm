/obj/item/device/assembly/syringe
	name = "injection device"
	desc = "A syringe with what looks like it has a spring in it. Creepy."
	icon_state = "syringe"
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_SPECIAL
	wire_num = 4
	var/time = 50

	var/obj/item/weapon/reagent_containers/syringe/syringe_holder

	holder_attackby = list(/obj/item/weapon/reagent_containers/syringe)

/obj/item/device/assembly/syringe/New()
	..()
	syringe_holder = new(src)

/obj/item/device/assembly/syringe/activate()
	var/mob/living/carbon/human/target = locate(/mob/living/carbon/human) in view(2)
	if(target)
		misc_special(target)

/obj/item/device/assembly/syringe/misc_special(var/mob/target)
	add_debug_log("Activating hydraulic motors in direction of [target] \[[src]\]")
	var/injtime = time //Injecting through a hardsuit takes longer due to needing to find a port.
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.wear_suit)
			if(istype(H.wear_suit, /obj/item/clothing/suit/space))
				injtime = injtime * 2
			else if(!H.can_inject(src, 1))
				return 0
	else if(isliving(target))
		var/mob/living/M = target
		if(!M.can_inject(src, 1))
			return 0
	if(injtime == time)
		target << "<small><span class='warning'>You feel something prodding into your skin!</span></small>"
	else
		target << "<small><span class='warning'>You feel something trying to prod into your skin!</span>"
	spawn(injtime)
		if(!(target in view(2))) return 0
		target.visible_message("<span class='warning'>\The [src] jabs into \the [target]'s skin!</span>")
		syringe_holder.reagents.trans_to_mob(target, 20, CHEM_BLOOD)

/obj/item/device/assembly/syringe/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/target = O
		if(!target.reagents.total_volume)
			user << "<span class='notice'>[target] is empty.</span>"
			return
		if(!syringe_holder.reagents.get_free_space())
			user << "<span class='warning'>The [src] is full!</span>"
			return
		var/trans = target.reagents.trans_to_obj(syringe_holder, target.amount_per_transfer_from_this)
		user << "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>"
		update_icon()

/obj/item/device/assembly/syringe/attack(var/atom/A, var/mob/user)
	return syringe_holder.attack(A, user)
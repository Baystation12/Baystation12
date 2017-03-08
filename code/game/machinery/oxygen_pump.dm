/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "emerg"

	var/obj/item/weapon/tank/tank
	var/obj/item/clothing/mask/gas/contained
	var/mob/living/carbon/breather

	var/spawn_type = /obj/item/weapon/tank/emergency/oxygen/engi

	power_channel = ENVIRON
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.

/obj/machinery/oxygen_pump/New()
	..()
	tank = new spawn_type (src)
	contained = new (src)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		breather.internals = null
	if(tank)
		qdel(tank)
	if(breather)
		breather.remove_from_mob(contained)
	qdel(contained)
	contained = null
	breather = null
	return ..()

/obj/machinery/oxygen_pump/MouseDrop(over_object, src_location, over_location)
	..()
	if(in_range(src, usr) && ishuman(over_object) && Adjacent(over_object))
		var/mob/living/carbon/human/target = over_object
		if(target.wear_mask)
			to_chat(usr, "<span class='warning'>\The [target] is already wearing a mask!</span>")
			return
		usr.visible_message("\The [usr] begins placing the mask onto [target]..")
		if(do_after(usr, 50))
			attach_mask(target)
			src.add_fingerprint(usr)

/obj/machinery/oxygen_pump/attack_hand(var/mob/living/carbon/user)
	if(stat & MAINT)
		if(tank)
			user.visible_message("<span class='notice'>\The [user] removes \the [tank] from \the [src].</span>", "<span class='notice'>You remove \the [tank] from \the [src].</span>")
			user.put_in_hands(tank)
			src.add_fingerprint(user)
			tank.add_fingerprint(user)
			tank = null
		else to_chat(user, "<span class='warning'>There is no tank in \the [src]!</span>")
	else if(contained.loc == src && !breather)
		if(user.wear_mask)
			to_chat(user, "<span class='notice'>You're already wearing a mask!</span>")
			return
		user.visible_message("<span class='notice'>\The [user] takes \the [contained] out of \the [src]!</span>", "<span class='notice'>You take \the [contained] out of \the [src]!</span>")
		attach_mask(user)
	else if(user == breather)
		if(tank)
			tank.ui_interact(user)
		else
			to_chat(user, "<span class='warning'>There is no tank installed!</span>")
	else
		to_chat(user, "<span class='notice'>\The [contained] has already been taken out!</span>")
/obj/machinery/oxygen_pump/proc/attach_mask(var/mob/living/carbon/C)
	if(C && istype(C))
		contained.forceMove(get_turf(C))
		C.equip_to_slot(contained, slot_wear_mask)
		if(tank)
			tank.forceMove(C)
		breather = C
		spawn(1)
		if(!breather.internal && tank)
			breather.internal = tank
			breather.internals.icon_state = "internal1"
		use_power = 2


/obj/machinery/oxygen_pump/attackby(var/mob/user, var/obj/item/I)
	if(istype(I, /obj/item/weapon/screwdriver))
		stat ^= MAINT
		user.visible_message("<span class='notice'>\The [user] [stat & MAINT ? "opens" : "closes"] \the [src].</span>", "<span class='notice'>You [stat & MAINT ? "open" : "close"] \the [src].</span>")
		//TO-DO: Open icon
	if(istype(I, /obj/item/weapon/tank) && (stat & MAINT))
		if(tank)
			to_chat(user, "<span class='warning'>\The [src] already has a tank installed!</span>")
		else
			user.drop_item()
			I.forceMove(src)
			tank = I
			user.visible_message("<span class='notice'>\The [user] installs \the [tank] into \the [src].</span>", "<span class='notice'>You install \the [tank] into \the [src].</span>")
			src.add_fingerprint(user)
	if(I == contained)
		to_chat(user, "<span class='notice'>You place \the [contained] back into \the [src].</span>")
		if(tank)
			tank.forceMove(src)
		breather.remove_from_mob(contained)
		contained.forceMove(src)
		src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
		breather = null
		use_power = 1

/obj/machinery/oxygen_pump/examine(var/mob/user)
	. = ..()
	if(tank)
		to_chat(user, "The meter shows [round(tank.air_contents.return_pressure())]")
	else
		to_chat(user, "<span class='warning'>It is missing a tank!</span>")
	return


/obj/machinery/oxygen_pump/process()
	if(breather)
		if(!Adjacent(breather) || breather.wear_mask != contained)
			if(tank)
				tank.forceMove(src)
			breather.remove_from_mob(contained)
			contained.forceMove(src)
			src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
			breather = null
			use_power = 1
		else if(!breather.internal && tank)
			breather.internal = tank
			breather.internals.icon_state = "internal1"
	return

/obj/machinery/oxygen_pump/anesthetic
	name = "anesthetic pump"
	spawn_type = /obj/item/weapon/tank/anesthetic
	icon_state = "anesthetic_tank" //Isdo

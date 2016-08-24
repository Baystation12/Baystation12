/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "oxygen"

	var/obj/item/weapon/tank/tank
	var/obj/item/clothing/mask/gas/contained
	var/mob/living/carbon/breather
	var/mob/living/carbon/refilling

	power_channel = ENVIRON // Equipment or environment?
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.
	anchored = 1

/obj/machinery/oxygen_pump/New()
	..()
	tank = new /obj/item/weapon/tank/emergency_oxygen/double (src)
	contained = new (src)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		breather.internals = null
	qdel(tank)
	if(breather)
		breather.remove_from_mob(contained)
	qdel(contained)
	breather = null
	..()

/obj/machinery/oxygen_pump/MouseDrop(over_object, src_location, over_location)
	..()
	if(in_range(src, usr) && ishuman(over_object) && Adjacent(over_object))
		var/mob/living/carbon/human/target = over_object
		if(target.wear_mask)
			usr << "<span class='warning'>[target] is already wearing a mask!</span>"
			return
		usr.visible_message("[usr] begins placing the mask onto [target]..")
		if(do_after(usr, 50))
			attach_mask(target)
			src.add_fingerprint(usr)

/obj/machinery/oxygen_pump/attack_hand(var/mob/living/carbon/user)
	if(stat & MAINT)
		if(tank)
			user.visible_message("<span class='notice'>[user] removes \the [tank] from \the [src].</span>", "<span class='notice'>You remove \the [tank] from \the [src].</span>")
			user.put_in_hands(tank)
			src.add_fingerprint(user)
			tank.add_fingerprint(user)
			tank = null
		else user << "<span class='warning'>There is no tank in \the [src]!</span>"
	else if(contained.loc == src && !breather)
		if(user.wear_mask)
			user << "<span class='notice'>You're already wearing a mask!</span>"
			return
		user.visible_message("<span class='notice'>[user] takes \the [contained] out of \the [src]!</span>", "<span class='notice'>You take \the [contained] out of \the [src]!</span>")
		attach_mask(user)
	else if(user == breather)
		tank.ui_interact(user)
	else
		user << "<span class='notice'>\The [contained] has already been taken out!</span>"

/obj/machinery/oxygen_pump/proc/attach_mask(var/mob/living/carbon/C)
	if(C && istype(C))
		contained.forceMove(get_turf(C))
		C.equip_to_slot(contained, slot_wear_mask)
		tank.forceMove(C)
		breather = C
		spawn(1)
		if(!breather.internal)
			breather.internal = tank
			breather.internals.icon_state = "internal1"
		use_power = 2


/obj/machinery/oxygen_pump/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		stat ^= MAINT
		user.visible_message("<span class='notice'>[user] [stat & MAINT ? "opens" : "closes"] \the [src].</span>", "<span class='notice'>You [stat & MAINT ? "open" : "close"] \the [src].</span>")
		//TO-DO: Open icon
	if(istype(I, /obj/item/weapon/tank))
		if(stat & MAINT)
			if(tank)
				user << "<span class='warning'>\The [src] already has a tank installed!</span>"
			else
				user.drop_item()
				I.forceMove(src)
				tank = I
				user.visible_message("<span class='notice'>[user] installs \the [tank] into \the [src].</span>", "<span class='notice'>You install \the [tank] into \the [src].</span>")
				src.add_fingerprint(user)
		else
			var/obj/item/weapon/tank/T = I
			if(refilling)
				if(user == refilling)
					user << "<span class='notice'>You are already using \the [src]!</span>"
					return
				user << "<span class='warning'>\The [refilling] is already using \the [src]!</span>"
				return
			if(tank)
				var/p = tank.air_contents.return_pressure()
				if(p <= 100)
					user << "<span class='warning'>There is not enough air in \the [src]!</span>"
					return
			user.visible_message("<span class='notice'>\The [user] begins refilling \the [I]..</span>")
			refilling = user
			if(do_after(user, 500))
				T.air_contents.adjust_gas("oxygen", 0.1, 1)
				refilling = null
			else
				refilling = null
	if(I == contained)
		user << "<span class='notice'>You place \the [contained] back into \the [src].</span>"
		tank.forceMove(src)
		breather.remove_from_mob(contained)
		contained.forceMove(src)
		src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
		breather = null
		use_power = 1

/obj/machinery/oxygen_pump/examine(var/mob/user)
	..()
	if(tank)
		user << "The meter is [round(tank.air_contents.return_pressure() ? tank.air_contents.return_pressure() : 0) ? "<span class='warning'>red!</span>" : "<span class='notice'>green.</span>"]"
	else
		user << "The meter is <span class='warning'>blank.</span>"
	return


/obj/machinery/oxygen_pump/process()
	if(breather)
		if(!Adjacent(breather) || breather.wear_mask != contained)
			tank.forceMove(src)
			breather.remove_from_mob(contained)
			contained.forceMove(src)
			src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
			breather = null
			use_power = 1
		else if(!breather.internal)
			breather.internal = tank
			breather.internals.icon_state = "internal1"
	return




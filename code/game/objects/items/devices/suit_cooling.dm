/obj/item/device/suit_cooling_unit
	name = "portable cooling unit"
	desc = "A large portable heat sink with liquid cooled radiator packaged into a modified backpack."
	description_info = "You may wear this instead of your packpack to cool yourself down. It is commonly used by IPCs, \
	as it allows them to go into low pressure environments for more than few seconds without overhating. It runs off energy provided by internal power cell. \
	Remember to turn it on by clicking it when it's your in your hand before you put it on."

	w_class = ITEM_SIZE_LARGE
	icon = 'icons/obj/suitcooler.dmi'
	icon_state = "suitcooler0"
	item_state = "coolingpack"			// beautiful codersprites until someone makes a prettier one.
	slot_flags = SLOT_BACK

	//copied from tank.dm
	flags = CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	action_button_name = "Toggle Heatsink"

	matter = list("steel" = 15000, "glass" = 3500)
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)

	var/on = 0								//is it turned on?
	var/cover_open = 0						//is the cover open?
	var/obj/item/weapon/cell/cell
	var/max_cooling = 12					// in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 2 KILOWATTS	// energy usage at full power
	var/thermostat = T20C

/obj/item/device/suit_cooling_unit/ui_action_click()
	toggle(usr)

/obj/item/device/suit_cooling_unit/Initialize()
	. = ..()
	GLOB.processing_objects |= src
	cell = new/obj/item/weapon/cell/high()		// 10K rated cell.
	cell.forceMove(src)

/obj/item/device/suit_cooling_unit/process()
	if (!on || !cell)
		return

	if (!is_in_slot())
		return

	var/mob/living/carbon/human/H = loc

	var/temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj

	cell.use(charge_usage * CELLRATE)
	ADD_ICON_QUEUE(src)

	if(cell.charge <= 0)
		turn_off(1)

// Checks whether the cooling unit is being worn on the back/suit slot.
// That way you can't carry it in your hands while it's running to cool yourself down.
/obj/item/device/suit_cooling_unit/proc/is_in_slot()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return 0

	return (H.back == src) || (H.s_store == src)

/obj/item/device/suit_cooling_unit/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	update_icon()

/obj/item/device/suit_cooling_unit/proc/turn_off(var/failed)
	if(failed) visible_message("\The [src] clicks and whines as it powers down.")
	on = 0
	update_icon()

/obj/item/device/suit_cooling_unit/attack_self(var/mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.forceMove(get_turf(src))

		cell.add_fingerprint(user)
		cell.update_icon()

		to_chat(user, "You remove \the [src.cell].")
		src.cell = null
		update_icon()
		return

	toggle(user)

/obj/item/device/suit_cooling_unit/proc/toggle(var/mob/user)
	if(on)
		turn_off()
	else
		turn_on()
	to_chat(user, "<span class='notice'>You switch \the [src] [on ? "on" : "off"].</span>")

/obj/item/device/suit_cooling_unit/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if(cover_open)
			cover_open = 0
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = 1
			to_chat(user, "You unscrew the panel.")
		update_icon()
		return

	if (istype(W, /obj/item/weapon/cell))
		if(cover_open)
			if(cell)
				to_chat(user, "There is a [cell] already installed here.")
			else
				user.drop_item()
				W.forceMove(src)
				cell = W
				to_chat(user, "You insert the [cell].")
		update_icon()
		return

	return ..()

/obj/item/device/suit_cooling_unit/update_icon()
	overlays.Cut()
	if (cover_open)
		if (cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
		return

	icon_state = "suitcooler0"

	if(!cell || !on)
		return

	switch(round(cell.percent()))
		if(86 to INFINITY)
			overlays.Add("battery-0")
		if(69 to 85)
			overlays.Add("battery-1")
		if(52 to 68)
			overlays.Add("battery-2")
		if(35 to 51)
			overlays.Add("battery-3")
		if(18 to 34)
			overlays.Add("battery-4")
		if(-INFINITY to 17)
			overlays.Add("battery-5")


/obj/item/device/suit_cooling_unit/examine(mob/user)
	if(!..(user, 1))
		return

	if (on)
		to_chat(user, "It's switched on and running.")
	else
		to_chat(user, "It is switched off.")

	if (cover_open)
		to_chat(user, "The panel is open.")

	if (cell)
		to_chat(user, "The charge meter reads [round(cell.percent())]%.")

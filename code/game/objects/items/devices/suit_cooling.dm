/obj/item/device/suit_cooling_unit
	name = "portable cooling unit"
	desc = "A large portable heat sink with liquid cooled radiator packaged into a modified backpack."
	w_class = ITEM_SIZE_LARGE
	icon = 'icons/obj/suitcooler.dmi'
	icon_state = "suitcooler0"
	item_state = "coolingpack"
	slot_flags = SLOT_BACK

	//copied from tank.dm
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	action_button_name = "Toggle Heatsink"

	matter = list(MATERIAL_ALUMINIUM = 15000, MATERIAL_GLASS = 3500)
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)

	var/on = 0								//is it turned on?
	var/cover_open = 0						//is the cover open?
	var/obj/item/cell/cell
	var/max_cooling = 12					// in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 2 KILOWATTS	// energy usage at full power
	var/thermostat = T20C

/obj/item/device/suit_cooling_unit/ui_action_click(mob/living/user)
	toggle(usr)

/obj/item/device/suit_cooling_unit/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	cell = new/obj/item/cell/high()		// 10K rated cell.
	cell.forceMove(src)

/obj/item/device/suit_cooling_unit/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/suit_cooling_unit/Process()
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
	update_icon()

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

/obj/item/device/suit_cooling_unit/proc/turn_off(failed)
	if(failed) visible_message("\The [src] clicks and whines as it powers down.")
	on = 0
	update_icon()

/obj/item/device/suit_cooling_unit/attack_self(mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.dropInto(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		to_chat(user, "You remove \the [src.cell].")
		src.cell = null
		update_icon()
		return

	toggle(user)

/obj/item/device/suit_cooling_unit/proc/toggle(mob/user)
	if(on)
		turn_off()
	else
		turn_on()
	to_chat(user, SPAN_NOTICE("You switch \the [src] [on ? "on" : "off"]."))


/obj/item/device/suit_cooling_unit/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Toggle cover
	if (isScrewdriver(tool))
		cover_open = !cover_open
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [cover_open ? "opens" : "closes"] \a [src]'s panel with \a [tool]."),
			SPAN_NOTICE("You [cover_open ? "open" : "close"] \the [src]'s panel with \the [tool].")
		)
		return TRUE

	// Power Cell - Install cell
	if (istype(tool, /obj/item/cell))
		if (!cover_open)
			USE_FEEDBACK_FAILURE("\The [src]'s panel is closed.")
			return TRUE
		if (cell)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [cell] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		cell = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \a [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)

	return ..()


/obj/item/device/suit_cooling_unit/on_update_icon()
	ClearOverlays()
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
			AddOverlays("battery-0")
		if(69 to 85)
			AddOverlays("battery-1")
		if(52 to 68)
			AddOverlays("battery-2")
		if(35 to 51)
			AddOverlays("battery-3")
		if(18 to 34)
			AddOverlays("battery-4")
		if(-INFINITY to 17)
			AddOverlays("battery-5")


/obj/item/device/suit_cooling_unit/examine(mob/user, distance)
	. = ..()
	if(distance >= 1)
		return

	if (on)
		to_chat(user, "It's switched on and running.")
	else
		to_chat(user, "It is switched off.")

	if (cover_open)
		to_chat(user, "The panel is open.")

	if (cell)
		to_chat(user, "The charge meter reads [round(cell.percent())]%.")

/obj/machinery/external_cooling_device
	name = "\improper External Cooling Device"
	icon = 'mods/ipc_cooling_unit/icons/ipc_icons.dmi'
	icon_state = "basepowered"
	desc = "It's a bulky machine that delivers life-giving cold through a hose."
	anchored = FALSE
	density = TRUE
	var/mob/living/carbon/human/attached
	var/obj/item/cell/cell = /obj/item/cell/high
	var/active = FALSE
	var/closed = TRUE
	var/set_temperature = T0C

/obj/machinery/external_cooling_device/New()
	..()
	if(ispath(cell))
		cell = new cell(src)
	update_icon()

/obj/machinery/external_cooling_device/examine(mob/user)
	. = ..()

	to_chat(user, "The external cooling device is [active ? "on" : "off"] and the hatch is [!closed ? "open" : "closed"].")
	if(!closed)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(),1) : 0]%")


/obj/machinery/external_cooling_device/Topic(href, href_list, state = GLOB.physical_state)
	if (..())
		return 1

	switch(href_list["op"])

		if("temp")
			var/value = text2num(href_list["val"])

			// limit to 0-90 degC
			set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)

		if("cellremove")
			if(!closed && cell && !usr.get_active_hand())
				usr.visible_message(
				SPAN_NOTICE("The [usr] removes \the [cell] from \the [src]."),
				SPAN_NOTICE("You remove \the [cell] from \the [src].")
				)
				cell.update_icon()
				usr.put_in_hands(cell)
				cell.add_fingerprint(usr)
				cell = null

		if("cellinstall")
			if(!closed && !cell)
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					if(!usr.unEquip(C, src))
						return TOPIC_NOACTION
					cell = C
					C.add_fingerprint(usr)
					usr.visible_message(
						SPAN_NOTICE("\The [usr] inserts \the [C] into \the [src]."),
						SPAN_NOTICE("You insert \the [C] into \the [src].")
					)

		if("Power_On")
			if(cell)
				active = !active

		if("Power_Off")
			active = !active

	update_icon()
	updateDialog()

/obj/machinery/external_cooling_device/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	..(severity)


/obj/machinery/external_cooling_device/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/external_cooling_device/interact(mob/user)
	var/list/dat = list()
	dat += "Power cell: "
	if(cell)
		dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
	else
		dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

	if(!active)
		dat += "<A href='byond://?src=\ref[src];op=Power_Off'>Power On</A><BR>"
	else
		dat += "<A href='byond://?src=\ref[src];op=Power_On'>Power Off</A><BR>"

	dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

	dat += "Set Temperature: "

	dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

	dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
	dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

	var/datum/browser/popup = new(usr, "spaceheater", "External Cooling Device Control Panel")
	popup.set_content(jointext(dat, null))
	popup.set_title_image(usr.browse_rsc_icon(src.icon, "sheater-standby"))
	popup.open()


/obj/machinery/external_cooling_device/on_update_icon(rebuild_overlay = 1)
	if(!cell)
		icon_state = "base"
	else
		icon_state = "basepowered"

	if(rebuild_overlay)
		ClearOverlays()
		if(attached)
			AddOverlays("o_h")
		if(!closed)
			AddOverlays("o_m")
		if(active && cell)
			AddOverlays("o_w")


/obj/machinery/external_cooling_device/MouseDrop(over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return
	if(attached)
		cooling_detach()
	else if(ishuman(over_object))
		hook_up(over_object, usr)

/obj/machinery/external_cooling_device/use_tool(obj/item/W, mob/living/user, list/click_params)

	if(istype(W, /obj/item/screwdriver))
		closed = !closed
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You [closed ? "tighten" : "unscrew"] ECD panel"))
		on_update_icon()
	if(!closed)
		if (istype(W, /obj/item/cell))
			if(!isnull(src.cell))
				USE_FEEDBACK_FAILURE("There is already a cell loaded!")
				return
			if(!user.unEquip(W, src))
				return
			cell = W
			to_chat(user, "You attach \the [W] to \the [src].")
			on_update_icon()
	else
		return ..()


/obj/machinery/external_cooling_device/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached = null
	QDEL_NULL(cell)
	. = ..()

/obj/machinery/external_cooling_device/Process()

	if(!cell)
		return

	if(attached)
		if(!Adjacent(attached))
			rip_out()
			return
	if(active)
		if(!attached)
			return
		if(attached.bodytemperature > set_temperature)
			attached.bodytemperature -= 20
			queue_icon_update()
			cell.use(5)

/obj/machinery/external_cooling_device/verb/cooling_detach()
	set category = "Object"
	set name = "Detach cooling device"
	set src in range(1)

	if(!attached)
		return

	if(!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return

	if(!usr.skill_check(SKILL_DEVICES, SKILL_BASIC))
		rip_out()
	else
		visible_message(SPAN_NOTICE("\The [attached] is taken off \the [src]."))
		attached = null
	update_icon()


/obj/machinery/external_cooling_device/proc/rip_out()
	visible_message(SPAN_WARNING("\The tube is ripped out of \the [src.attached]!"))
	attached.apply_damage(1, DAMAGE_BRUTE, pick(BP_GROIN, BP_CHEST), damage_flags=DAMAGE_FLAG_SHARP)
	attached = null
	update_icon()

/obj/machinery/external_cooling_device/proc/hook_up(mob/living/carbon/human/target, mob/user)
	if(do_ECD_hookup(target, user, src))
		attached = target
		update_icon()

/obj/machinery/external_cooling_device/proc/do_ECD_hookup(mob/living/carbon/human/target, mob/user, obj/ECD)
	to_chat(user, SPAN_NOTICE("You start to hook up \the [target] to \the [ECD]."))
	if(!user.do_skilled(2 SECONDS, SKILL_DEVICES, target))
		return FALSE

	if(prob(user.skill_fail_chance(SKILL_DEVICES, 40, SKILL_MIN)))
		user.visible_message(
			SPAN_WARNING("\The [user] fails while trying to hook \the [target] up to \the [ECD], stabbing them instead!"),
			SPAN_WARNING("You fail while trying to hook \the [target] up to \the [ECD], stabbing yourself instead!")
		)
		target.apply_damage(5, DAMAGE_BRUTE, pick(BP_GROIN, BP_CHEST), damage_flags=DAMAGE_FLAG_SHARP)
		return FALSE

	user.visible_message(
		SPAN_NOTICE("\The [user] hooks \the [target] up to \the [ECD]."),
		SPAN_NOTICE("You hook \the [target] up to \the [ECD]")
	)
	return TRUE

/obj/item/frame_holder
	matter = list(MATERIAL_STEEL = 175000, MATERIAL_PLASTIC = 50000, MATERIAL_OSMIUM = 30000)

/obj/item/frame_holder/New(var/newloc)
	new /obj/structure/heavy_vehicle_frame(newloc)
	qdel(src)

/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for an exosuit, apparently."
	icon = 'icons/mecha/mech_parts.dmi'
	icon_state = "backbone"
	density = 1
	pixel_x = -8

	// Holders for the final product.
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/is_wired = 0
	var/is_reinforced = 0
	var/set_name

/obj/structure/heavy_vehicle_frame/Destroy()

	if(arms)
		qdel(arms)
		arms = null
	if(legs)
		qdel(legs)
		legs = null
	if(head)
		qdel(head)
		head = null
	if(body)
		qdel(body)
		body = null

	. = ..()

/obj/structure/heavy_vehicle_frame/examine()
	. = ..()
	if(.)
		if(!arms)
			to_chat(usr, "<span class='warning'>It is missing arms.</span>")
		if(!legs)
			to_chat(usr, "<span class='warning'>It is missing legs.</span>")
		if(!head)
			to_chat(usr, "<span class='warning'>It is missing a head.</span>")
		if(!body)
			to_chat(usr, "<span class='warning'>It is missing a chassis.</span>")
		if(is_wired == 1)
			to_chat(usr, "<span class='warning'>It has not had its wiring adjusted.</span>")
		else if(!is_wired)
			to_chat(usr, "<span class='warning'>It has not yet been wired.</span>")
		if(is_reinforced == 1)
			to_chat(usr, "<span class='warning'>It has not had its internal reinforcement secured.</span>")
		else if(is_reinforced == 2)
			to_chat(usr, "<span class='warning'>It has not had its internal reinforcement welded in.</span>")
		else if(!is_reinforced)
			to_chat(usr, "<span class='warning'>It does not have any internal reinforcement.</span>")

/obj/structure/heavy_vehicle_frame/update_icon()
	overlays.Cut()
	overlays |= get_mech_icon(arms, legs, head, body)
	if(body)
		if(legs)
			anchored = 1
		density = 1
		overlays += get_mech_image("[body.icon_state]_cockpit", body.icon, body.color)
		if(body.open_cabin)
			overlays |= get_mech_image("[body.icon_state]_open_overlay", body.icon, body.color)
	else
		anchored = 0
		density = 0

	opacity = density

/obj/structure/heavy_vehicle_frame/New()
	..()
	set_dir(SOUTH)
	update_icon()

/obj/structure/heavy_vehicle_frame/set_dir()
	..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(var/obj/item/thing, var/mob/user)

	// Removing components.
	if(isCrowbar(thing))
		var/obj/item/component
		if(arms)
			component = arms
			arms = null
		else if(body)
			component = body
			body = null
		else if(legs)
			component = legs
			legs = null
		else if(head)
			component = head
			head = null
		else
			to_chat(user, "<span class='warning'>There are no components to remove.</span>")
			return

		user.visible_message("<span class='notice'>\The [user] crowbars \the [component] off \the [src].</span>")
		component.forceMove(get_turf(src))
		user.put_in_hands(component)
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		update_icon()
		return

	// Final construction step.
	else if(isScrewdriver(thing))

		// Check for basic components.
		if(!(arms && legs && head && body))
			to_chat(user,  "<span class='warning'>There are still parts missing from \the [src].</span>")
			return

		// Check for wiring.
		if(is_wired < 2)
			if(is_wired == 1)
				to_chat(user, "<span class='warning'>\The [src]'s wiring has not been adjusted!</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] is not wired!</span>")
			return

		// Check for basing metal internal plating.
		if(is_reinforced < 3)
			if(is_reinforced == 1)
				to_chat(user, "<span class='warning'>\The [src]'s internal reinforcement has not been secured!</span>")
			else if(is_reinforced == 2)
				to_chat(user, "<span class='warning'>\The [src]'s internal reinforcement has not been welded down!</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] has no internal reinforcement!</span>")
			return

		// We're all done. Finalize the mech and pass the frame to the new system.
		var/mob/living/heavy_vehicle/M = new(get_turf(src), src)

		visible_message("<span class='notice'>\The [user] finishes off \the [M].</span>")
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

		arms = null
		legs = null
		head = null
		body = null
		qdel(src)

		return

	// Installing wiring.
	else if(isCoil(thing))

		if(is_wired)
			to_chat(user, "<span class='warning'>\The [src] has already been wired.</span>")
			return

		var/obj/item/stack/cable_coil/CC = thing
		if(CC.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need at least ten units of cable to complete the exosuit.</span>")
			return

		user.visible_message("\The [user] begins wiring \the [src]...")

		if(!do_after(user, 30))
			return

		if(!CC || !user || !src || CC.amount < 10 || is_wired)
			return

		CC.use(10)
		user.visible_message("\The [user] installs wiring in \the [src].")
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		is_wired = 1
	// Securing wiring.
	else if(isWirecutter(thing))
		if(!is_wired)
			to_chat(user, "There is no wiring in \the [src] to neaten.")
			return
		visible_message("\The [user] [(is_wired == 2) ? "snips some of" : "neatens"] the wiring in \the [src].")
		playsound(user.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		is_wired = (is_wired == 2) ? 1 : 2
	// Installing metal.
	else if(istype(thing, /obj/item/stack/material))
		var/obj/item/stack/material/M = thing
		if(M.material && M.material.name == "plasteel")
			if(is_reinforced)
				to_chat(user, "<span class='warning'>There is already plasteel reinforcement installed in \the [src].</span>")
				return
			if(M.amount < 10)
				to_chat(user, "<span class='warning'>You need at least fifteen sheets of plasteel to reinforce \the [src].</span>")
				return
			visible_message("\The [user] reinforces \the [src] with \the [M].")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			is_reinforced = 1
			M.use(10)
		else
			return ..()
	// Securing metal.
	else if(isWrench(thing))
		if(!is_reinforced)
			to_chat(user, "<span class='warning'>There is no metal to secure inside \the [src].</span>")
			return
		if(is_reinforced == 3)
			to_chat(user, "<span class='warning'>\The [src]'s internal reinforcment has been welded in.</span>")
			return
		visible_message("\The [user] [(is_reinforced == 2) ? "unsecures" : "secures"] the metal reinforcement in \the [src].")
		playsound(user.loc, 'sound/items/Ratchet.ogg', 100, 1)
		is_reinforced = (is_reinforced == 2) ? 1 : 2
	// Welding metal.
	else if(isWelder(thing))
		var/obj/item/weapon/weldingtool/WT = thing
		if(!is_reinforced)
			to_chat(user, "<span class='warning'>There is no metal to secure inside \the [src].</span>")
			return
		if(is_reinforced == 1)
			to_chat(user, "<span class='warning'>The reinforcement inside \the [src] has not been secured.</span>")
			return
		if(!WT.isOn())
			to_chat(user, "<span class='warning'>Turn \the [WT] on, first.</span>")
			return
		if(WT.remove_fuel(1, user))
			visible_message("\The [user] [(is_reinforced == 3) ? "unwelds the reinforcement from" : "welds the reinforcement into"] \the [src].")
			is_reinforced = (is_reinforced == 3) ? 2 : 3
			playsound(user.loc, 'sound/items/Welder.ogg', 50, 1)
		else
			to_chat(user, "<span class='warning'>Not enough fuel!</span>")
			return
	// Installing basic components.
	else if(istype(thing,/obj/item/mech_component/manipulators))
		if(arms)
			to_chat(user, "<span class='warning'>\The [src] already has manipulators installed.</span>")
			return
		if(install_component(thing, user)) arms = thing
	else if(istype(thing,/obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, "<span class='warning'>\The [src] already has a propulsion system installed.</span>")
			return
		if(install_component(thing, user)) legs = thing
	else if(istype(thing,/obj/item/mech_component/sensors))
		if(head)
			to_chat(user, "<span class='warning'>\The [src] already has a sensor array installed.</span>")
			return
		if(install_component(thing, user)) head = thing
	else if(istype(thing,/obj/item/mech_component/chassis))
		if(body)
			to_chat(user, "<span class='warning'>\The [src] already has an outer chassis installed.</span>")
			return
		if(install_component(thing, user)) body = thing
	else
		return ..()
	update_icon()
	return

/obj/structure/heavy_vehicle_frame/proc/install_component(var/obj/item/thing, var/mob/user)
	var/obj/item/mech_component/MC = thing
	if(istype(MC) && !MC.ready_to_install())
		if(user)
			to_chat(user, "<span class='warning'>\The [MC] [MC.gender == PLURAL ? "are" : "is"] not ready to install.</span>")
		return 0
	user.drop_from_inventory(thing)
	thing.forceMove(src)
	visible_message("\The [user] installs \the [thing] into \the [src].")
	playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
	return 1

/obj/item/bodybag/rescue
	name = "rescue bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/closets/rescuebag.dmi'
	icon_state = "folded"
	origin_tech = list(TECH_BIO = 2)
	var/obj/item/tank/airtank

/obj/item/bodybag/rescue/loaded
	airtank = /obj/item/tank/oxygen_emergency_double

/obj/item/bodybag/rescue/Initialize()
	. = ..()
	if(ispath(airtank))
		airtank = new airtank(src)
	update_icon()

/obj/item/bodybag/rescue/Destroy()
	QDEL_NULL(airtank)
	return ..()

/obj/item/bodybag/rescue/attack_self(mob/user)
	var/obj/structure/closet/body_bag/rescue/R = new /obj/structure/closet/body_bag/rescue(user.loc)
	R.add_fingerprint(user)
	if(airtank)
		R.set_tank(airtank)
		airtank = null
	qdel(src)

/obj/item/bodybag/rescue/attackby(obj/item/W, mob/user, click_params)
	if(istype(W,/obj/item/tank))
		if(airtank)
			to_chat(user, "\The [src] already has an air tank installed.")
			return 1
		else if(user.unEquip(W))
			W.forceMove(src)
			airtank = W
			to_chat(user, "You install \the [W] in \the [src].")
			return 1
	else if(airtank && isScrewdriver(W))
		to_chat(user, "You remove \the [airtank] from \the [src].")
		airtank.dropInto(loc)
		airtank = null
	else
		..()

/obj/item/bodybag/rescue/examine(mob/user)
	. = ..()
	if(airtank)
		to_chat(user,"The pressure meter on \the [airtank] shows '[airtank.air_contents.return_pressure()] kPa'.")
		to_chat(user,"The distribution valve on \the [airtank] is set to '[airtank.distribute_pressure] kPa'.")
	else
		to_chat(user, SPAN_WARNING("The air tank is missing."))

/obj/structure/closet/body_bag/rescue
	name = "rescue bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/closets/rescuebag.dmi'
	item_path = /obj/item/bodybag/rescue
	storage_types = CLOSET_STORAGE_MOBS
	var/obj/item/tank/airtank
	var/datum/gas_mixture/atmo

/obj/structure/closet/body_bag/rescue/Initialize()
	. = ..()
	atmo = new()
	atmo.volume = 0.1*CELL_VOLUME
	START_PROCESSING(SSobj, src)

/obj/structure/closet/body_bag/rescue/Destroy()
	QDEL_NULL(airtank)
	return ..()

/obj/structure/closet/body_bag/rescue/proc/set_tank(obj/item/tank/newtank)
	airtank = newtank
	if(airtank)
		airtank.forceMove(null)
	update_icon()

/obj/structure/closet/body_bag/rescue/on_update_icon()
	..()
	overlays.Cut()
	if(airtank)
		overlays += image(icon, "tank")


/obj/structure/closet/body_bag/rescue/get_interactions_info()
	. = ..()
	.["Air Tank"] = "<p>Attaches the air tank to be used as an air supply for anyone in the bag. There can only be one air tank attached at a time.</p>"
	.[CODEX_INTERACTION_SCREWDRIVER] = "<p>Detaches the air tank, if one is present.</p>"


/obj/structure/closet/body_bag/rescue/use_tool(obj/item/tool, mob/user, list/click_params)
	// Air tank - Installs the tank
	if (istype(tool, /obj/item/tank))
		if (airtank)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [airtank] installed."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		set_tank(tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		update_icon()
		return TRUE

	// Screwdriver - Remove airtank
	if (isScrewdriver(tool))
		if (!airtank)
			to_chat(user, SPAN_WARNING("\The [src] has no air tank to remove."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] detaches \the [src]'s [airtank.name] with \a [tool]."),
			SPAN_NOTICE("You detach \the [src]'s [airtank.name] with \the [tool].")
		)
		airtank.dropInto(loc)
		airtank = null
		update_icon()
		return TRUE

	return ..()


/obj/structure/closet/body_bag/rescue/fold(user)
	var/obj/item/tank/my_tank = airtank
	airtank = null // Apparently this is required to avoid breaking my_tank checks further down after the parent proc runs qdel(src)
	var/obj/item/bodybag/rescue/folded = ..()
	if (folded && istype(folded))
		if (my_tank)
			my_tank.air_contents.merge(atmo)
			folded.airtank = my_tank
			my_tank.forceMove(folded)
	else
		airtank = my_tank

/obj/structure/closet/body_bag/rescue/Process()
	if(!airtank)
		return
	var/env_pressure = atmo.return_pressure()
	var/pressure_delta = max(airtank.distribute_pressure, 51) - env_pressure
	if(airtank.air_contents.temperature > 0 && pressure_delta > 0)
		var/transfer_moles = calculate_transfer_moles(airtank.air_contents, atmo, pressure_delta)
		pump_gas_passive(airtank, airtank.air_contents, atmo, transfer_moles)

/obj/structure/closet/body_bag/rescue/return_air() //Used to make stasis bags protect from vacuum.
	return atmo

/obj/structure/closet/body_bag/rescue/examine(mob/user)
	. = ..()
	if(airtank)
		to_chat(user,"The pressure meter on \the [airtank] shows '[airtank.air_contents.return_pressure()] kPa'.")
		to_chat(user,"The distribution valve on \the [airtank] is set to '[airtank.distribute_pressure] kPa'.")
	else
		to_chat(user, SPAN_WARNING("The air tank is missing."))
	to_chat(user,"The pressure meter on [src] shows '[atmo.return_pressure()] kPa'.")
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		to_chat(user, SPAN_INFO("You peer into \the [src]."))
		for(var/mob/living/L in contents)
			L.examine(arglist(args))

/obj/machinery/bluespace_beacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = 1		// underfloor
	anchored = 1
	idle_power_usage = 0
	var/obj/item/device/radio/beacon/Beacon

	New()
		..()
		var/turf/T = get_turf(src)
		Beacon = new /obj/item/device/radio/beacon(T)
		Beacon.invisibility = INVISIBILITY_MAXIMUM

		hide(!T.is_plating())

	Destroy()
		QDEL_NULL(Beacon)
		. = ..()

	// update the invisibility and icon
	hide(var/intact)
		set_invisibility(intact ? 101 : 0)
		update_icon()

	// update the icon_state
	update_icon()
		var/state="floor_beacon"

		if(invisibility)
			icon_state = "[state]f"

		else
			icon_state = "[state]"

	Process()
		if(!Beacon)
			Beacon = new /obj/item/device/radio/beacon(get_turf(src))
			Beacon.set_invisibility(INVISIBILITY_MAXIMUM)
		if(Beacon)
			if(Beacon.loc != loc)
				Beacon.forceMove(loc)

		update_icon()



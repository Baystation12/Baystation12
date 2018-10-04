/obj/machinery/telecomms_jammers
	name = "radio jammer"
	var/jamming_active = 1
	var/jam_power = 50 //This is the amount of compression added to a signal when it is jammed by this device.
	var/jam_chance = 50
	var/jam_range = 1 //The jamming range, in tiles.

/obj/machinery/telecomms_jammers/New()
	. = ..()
	telecomms_list += src

/obj/machinery/telecomms_jammers/Destroy()
	telecomms_list -= src
	. = ..()

/obj/machinery/telecomms_jammers/verb/toggle_jamming()
	set name = "Toggle Comms Jammer"
	set src in view(1)

	if(!istype(usr,/mob/living))
		return

	jamming_active = !jamming_active
	to_chat(usr,"<span class = 'warning'>The [src] is now [jamming_active ? "online":"deactivated"].</span>")


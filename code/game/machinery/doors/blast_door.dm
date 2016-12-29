// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are supposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

/obj/machinery/door/blast
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null

	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null

	closed_layer = ABOVE_WINDOW_LAYER
	var/id = 1.0
	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/begins_closed = TRUE
	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/material/implicit_material

/obj/machinery/door/blast/initialize()
	..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

	if(!begins_closed)
		icon_state = icon_state_open
		density = 0
		opacity = 0
		layer = open_layer

	implicit_material = get_material_by_name("plasteel")

/obj/machinery/door/airlock/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	var/turf/T = get_turf(src)
	T.calc_rad_resistance()
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	flick(icon_state_opening, src)
	src.density = 0
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operating = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	src.operating = 1
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.density = 1
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(1)
	sleep(15)
	src.operating = 0

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle()
	if(src.density)
		src.force_open()
	else
		src.force_close()

/obj/machinery/door/blast/get_material()
	return implicit_material

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/material/twohanded/fireaxe) && C:wielded == 1))
		if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
			force_toggle()
		else
			to_chat(usr, "<span class='notice'>[src]'s motors resist your effort.</span>")
		return
	if(istype(C, /obj/item/stack/material) && C.get_material_name() == "plasteel")
		var/amt = Ceiling((maxhealth - health)/150)
		if(!amt)
			to_chat(usr, "<span class='notice'>\The [src] is already fully repaired.</span>")
			return
		var/obj/item/stack/P = C
		if(P.amount < amt)
			to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")
			return
		to_chat(usr, "<span class='notice'>You begin repairing [src]...</span>")
		if(do_after(usr, 30, src))
			if(P.use(amt))
				to_chat(usr, "<span class='notice'>You have repaired \the [src]</span>")
				src.repair()
			else
				to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")



// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_open()
	if(autoclose)
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_close()


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = maxhealth
	if(stat & BROKEN)
		stat &= ~BROKEN


/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()



// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600
	block_air_zones = 1

/obj/machinery/door/blast/regular/open
	begins_closed = FALSE

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"

/obj/machinery/door/blast/shutters/open
	begins_closed = FALSE

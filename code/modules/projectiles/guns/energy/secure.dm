/obj/item/weapon/gun/energy/secure
	icon = 'icons/obj/gun_secure.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)

	desc = "A basic energy-based gun with a secure authorization chip."
	req_access = list(access_brig)
	var/list/authorized_modes = list(ALWAYS_AUTHORIZED) // index of this list should line up with firemodes, unincluded firemodes at the end will default to unauthorized
	var/registered_owner
	var/emagged = 0

/obj/item/weapon/gun/energy/secure/Initialize()
	if(!authorized_modes)
		authorized_modes = list()

	for(var/i = authorized_modes.len + 1 to firemodes.len)
		authorized_modes.Add(UNAUTHORIZED)

	. = ..()

/obj/item/weapon/gun/energy/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		if(!emagged)
			if(!registered_owner)
				if(allowed(user))
					var/obj/item/weapon/card/id/id = W
					GLOB.registered_weapons += src
					registered_owner = id.registered_name
					user.visible_message("[user] swipes an ID through \the [src], registering it.", "You swipe an ID through \the [src], registering it.")
				else
					to_chat(user, "<span class='warning'>Access denied.</span>")
			else
				to_chat(user, "This weapon is already registered, you must reset it first.")
		else
			to_chat(user, "You swipe your ID, but nothing happens.")
	else
		..()

/obj/item/weapon/gun/energy/secure/verb/reset()
	set name = "Reset Registration"
	set category = "Object"
	set src in usr

	if(issilicon(usr))
		return

	if(allowed(usr))
		usr.visible_message("[usr] presses the reset button on \the [src], resetting its registration.", "You press the reset button on \the [src], resetting its registration.")
		registered_owner = null
		GLOB.registered_weapons -= src

/obj/item/weapon/gun/energy/secure/Destroy()
	GLOB.registered_weapons -= src

	. = ..()

/obj/item/weapon/gun/energy/secure/proc/authorize(var/mode, var/authorized, var/by)
	if(emagged || mode < 1 || mode > authorized_modes.len || authorized_modes[mode] == authorized)
		return 0

	authorized_modes[mode] = authorized

	if(mode == sel_mode && !authorized)
		switch_firemodes()

	var/mob/M = get_holder_of_type(src, /mob)
	if(M)
		to_chat(M, "<span class='notice'>Your [src.name] has been [authorized ? "granted" : "denied"] [firemodes[mode]] fire authorization by [by].</span>")

	return 1

/obj/item/weapon/gun/energy/secure/special_check()
	if(!emagged && (!authorized_modes[sel_mode] || !registered_owner))
		audible_message("<span class='warning'>\The [src] buzzes, refusing to fire.</span>")
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 30, 0)
		return 0

	. = ..()

/obj/item/weapon/gun/energy/secure/switch_firemodes()
	var/next_mode = get_next_authorized_mode()
	if(firemodes.len <= 1 || next_mode == null || sel_mode == next_mode)
		return null

	sel_mode = next_mode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	update_icon()

	return new_mode

/obj/item/weapon/gun/energy/secure/examine(var/mob/user)
	..()

	if(registered_owner)
		to_chat(user, "A small screen on the side of the weapon indicates that it is registered to [registered_owner].")

/obj/item/weapon/gun/energy/secure/proc/get_next_authorized_mode()
	. = sel_mode
	do
		.++
		if(. > authorized_modes.len)
			. = 1
		if(. == sel_mode) // just in case all modes are unauthorized
			return null
	while(!authorized_modes[.] && !emagged)

/obj/item/weapon/gun/energy/secure/emag_act(var/charges, var/mob/user)
	if(emagged || !charges)
		return NO_EMAG_ACT
	else
		emagged = 1
		registered_owner = null
		GLOB.registered_weapons -= src
		to_chat(user, "The authorization chip fries, giving you full use of \the [src].")
		return 1


/obj/item/weapon/gun/energy/secure/stunrevolver
	name = "stun revolver"
	desc = "This A&M X6 is fitted with an NT1019 chip, a component that allows remote authorization of weapon functionality, created by NanoTrasen following the Baetiff Incident."
	icon_state = "revolverstun100"
	modifystate = "revolverstun"
	item_state = null

	projectile_type = /obj/item/projectile/energy/electrode
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_DATA = 2)
	max_shots = 8
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/energy/electrode, modifystate="revolverstun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/energy/electrode/stunshot, modifystate="revolvershock")
		)

/obj/item/weapon/gun/energy/secure/gun
	name = "energy gun"
	desc = "A more secure LAEP90, the LAEP90-S is designed to please paranoid constituents. Body cam not included."
	icon = 'icons/obj/gun_secure.dmi'
	icon_state = "energystun100"
	modifystate = "energystun"
	item_state = null	//so the human update icon uses the icon_state instead.

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_DATA = 2)
	max_shots = 10
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="energyshock"),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill"),
		)

/obj/item/weapon/gun/energy/secure/gun/small
	name = "small energy gun"
	desc = "Combining the two LAEP90 variants, the secure and compact LAEP90-CS is the next best thing to keeping your security forces on a literal leash."
	icon_state = "smallgunstun100"
	modifystate = "smallgunstun"

	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3, TECH_DATA = 2)
	max_shots = 5
	w_class = ITEM_SIZE_SMALL
	force = 2

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="smallgunstun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="smallgunshock"),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam/smalllaser, modifystate="smallgunkill"),
		)
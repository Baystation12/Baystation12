/obj/item/weapon/gun
	var/list/authorized_modes = list(ALWAYS_AUTHORIZED) // index of this list should line up with firemodes, unincluded firemodes at the end will use default
	var/default_mode_authorization = UNAUTHORIZED
	var/registered_owner
	var/standby

/obj/item/weapon/gun/Initialize()
	if(is_secure_gun())
		if(!authorized_modes)
			authorized_modes = list()

		for(var/i = authorized_modes.len + 1 to firemodes.len)
			authorized_modes.Add(default_mode_authorization)

	. = ..()

/obj/item/weapon/gun/Destroy()
	GLOB.registered_weapons -= src
	. = ..()

/obj/item/weapon/gun/examine(var/mob/user)
	..()
	if(registered_owner)
		to_chat(user, "A small screen on the side of the weapon indicates that it is registered to [registered_owner].")

/obj/item/weapon/gun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id) && is_secure_gun())
		if(!registered_owner)
			var/obj/item/weapon/card/id/id = W
			GLOB.registered_weapons += src
			verbs += /obj/item/weapon/gun/proc/reset_registration
			registered_owner = id.registered_name
			user.visible_message("[user] swipes an ID through \the [src], registering it.", "You swipe an ID through \the [src], registering it.")
		else
			to_chat(user, "This weapon is already registered, you must reset it first.")
	else
		..()

/obj/item/weapon/gun/emag_act(var/charges, var/mob/user)
	if(!charges)
		return NO_EMAG_ACT
	else if (is_secure_gun())
		registered_owner = null
		GLOB.registered_weapons -= src
		verbs -= /obj/item/weapon/gun/proc/reset_registration
		req_access.Cut()
		req_one_access.Cut()
		to_chat(user, "The authorization chip fries, giving you full use of \the [src].")
		return 1
	else
		return ..()

/obj/item/weapon/gun/proc/reset_registration()
	set name = "Reset Registration"
	set category = "Object"
	set src in usr

	if(issilicon(usr))
		return

	if(allowed(usr))
		usr.visible_message("[usr] presses the reset button on \the [src], resetting its registration.", "You press the reset button on \the [src], resetting its registration.")
		registered_owner = null
		GLOB.registered_weapons -= src
		verbs -= /obj/item/weapon/gun/proc/reset_registration

/obj/item/weapon/gun/proc/authorize(var/mode, var/authorized, var/by)
	if(mode < 1 || mode > authorized_modes.len || authorized_modes[mode] == authorized)
		return 0

	authorized_modes[mode] = authorized

	if(mode == sel_mode && !authorized)
		switch_firemodes()

	var/mob/M = get_holder_of_type(src, /mob)
	if(M)
		to_chat(M, "<span class='notice'>Your [src.name] has been [authorized ? "granted" : "denied"] [firemodes[mode]] fire authorization by [by].</span>")

	return 1

/obj/item/weapon/gun/proc/is_secure_gun()
	return req_one_access.len || req_access.len

/obj/item/weapon/gun/proc/free_fire()
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	return security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level)

/obj/item/weapon/gun/special_check()
	if(is_secure_gun() && !free_fire() && (!authorized_modes[sel_mode] || !registered_owner))
		audible_message("<span class='warning'>\The [src] buzzes, refusing to fire.</span>")
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 30, 0)
		return 0

	. = ..()

/obj/item/weapon/gun/get_next_firemode()
	if(!is_secure_gun())
		return ..()
	. = sel_mode
	do
		.++
		if(. > authorized_modes.len)
			. = 1
		if(. == sel_mode) // just in case all modes are unauthorized
			return null
	while(!authorized_modes[.] && !free_fire())
GLOBAL_LIST_INIT(secure_weapons, list())

/obj/item/gun
	var/list/authorized_modes = list(ALWAYS_AUTHORIZED) // index of this list should line up with firemodes, unincluded firemodes at the end will use default
	var/default_mode_authorization = UNAUTHORIZED
	var/registered_owner

/obj/item/gun/Initialize()
	if(is_secure_gun())
		GLOB.secure_weapons |= src
		if(!authorized_modes)
			authorized_modes = list()

		for(var/i = length(authorized_modes) + 1 to length(firemodes))
			authorized_modes.Add(default_mode_authorization)

	. = ..()

/obj/item/gun/Destroy()
	GLOB.secure_weapons -= src
	. = ..()

/obj/item/gun/examine(mob/user, distance)
	. = ..()
	if(distance <= 0 && is_secure_gun())
		to_chat(user, "The registration screen shows, \"" + (registered_owner ? "[registered_owner]" : "unregistered") + "\"")


/obj/item/gun/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Register gun
	if (is_secure_gun())
		var/obj/item/card/id/id = tool.GetIdCard()
		if (istype(id))
			if (registered_owner)
				USE_FEEDBACK_FAILURE("\The [src] is already registered to \"[registered_owner]\".")
				return TRUE
			verbs += /obj/item/gun/proc/reset_registration
			registered_owner = id.registered_name
			var/idname = GET_ID_NAME(id, tool)
			user.visible_message(
				SPAN_NOTICE("\The [user] runs \a [tool] over \the [src]'s ID scanner."),
				SPAN_NOTICE("You scan [idname] over \the [src]'s ID scanner, registering it to \"[registered_owner]\"."),
				range = 3
			)
			return TRUE

	return ..()


/obj/item/gun/emag_act(charges, mob/user)
	if(!charges)
		return NO_EMAG_ACT

	if(is_secure_gun())
		registered_owner = null
		verbs -= /obj/item/gun/proc/reset_registration
		req_access.Cut()
		GLOB.secure_weapons -= src
		to_chat(user, SPAN_NOTICE("\The [src]'s authorization chip fries, giving you full access."))
		return 1

	return ..()


/obj/item/gun/proc/reset_registration()
	set name = "Reset Registration"
	set category = "Object"
	set src in usr

	if(issilicon(usr))
		to_chat(usr, SPAN_WARNING("You are not permitted to modify weapon registrations."))
		return

	usr.visible_message("[usr] presses the reset button on \the [src].", range = 3)
	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("\The [src] buzzes quietly, refusing your access."))
		return

	to_chat(usr, SPAN_NOTICE("\The [src] chimes quietly as its registration resets."))
	registered_owner = null
	verbs -= /obj/item/gun/proc/reset_registration


/obj/item/gun/proc/authorize(mode, authorized)
	if(mode < 1 || mode > length(authorized_modes) || authorized_modes[mode] == authorized)
		return FALSE

	authorized_modes[mode] = authorized

	if(mode == sel_mode && !authorized)
		toggle_safety()

	var/mob/user = get_holder_of_type(src, /mob)
	if(user)
		to_chat(user, SPAN_NOTICE("Your [src.name] has been [authorized ? "granted" : "denied"] [firemodes[mode]] fire authorization."))

	return TRUE

/obj/item/gun/proc/is_secure_gun()
	return length(req_access)

/obj/item/gun/proc/free_fire()
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	return security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level)

/obj/item/gun/special_check()
	if(is_secure_gun() && !free_fire() && (!authorized_modes[sel_mode] || !registered_owner))
		audible_message(SPAN_WARNING("\The [src] buzzes, refusing to fire."), hearing_distance = 3)
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 10, 0)
		return 0

	. = ..()

/obj/item/gun/get_next_firemode()
	if(!is_secure_gun())
		return ..()
	. = sel_mode
	do
		.++
		if(. > length(authorized_modes))
			. = 1
		if(. == sel_mode) // just in case all modes are unauthorized
			return null
	while (!authorized_modes[.] && !free_fire())

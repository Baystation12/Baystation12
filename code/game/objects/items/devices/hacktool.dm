/obj/item/device/multitool/hacktool
	var/is_hacking = 0
	var/max_known_targets

	var/in_hack_mode = 0
	var/list/known_targets
	var/list/supported_types
	var/datum/topic_state/default/must_hack/hack_state

/obj/item/device/multitool/hacktool/New()
	..()
	known_targets = list()
	max_known_targets = 5 + rand(1,3)
	supported_types = list(/obj/machinery/door/airlock)
	hack_state = new(src)

/obj/item/device/multitool/hacktool/Destroy()
	for(var/T in known_targets)
		var/atom/target = T
		GLOB.destroyed_event.unregister(target, src)
	known_targets.Cut()
	qdel(hack_state)
	hack_state = null
	return ..()


/obj/item/device/multitool/hacktool/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Toggle hack mode
	if (isScrewdriver(tool))
		in_hack_mode = !in_hack_mode
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts \a [src] with \a [tool]."),
			SPAN_NOTICE("You adjust \the [src] with \the [tool]. It is now in [in_hack_mode ? "hacking" : "normal"] mode.")
		)
		return TRUE

	return ..()


/obj/item/device/multitool/hacktool/resolve_attackby(atom/A, mob/user)
	sanity_check()

	if(!in_hack_mode || !attempt_hack(user, A)) //will still show the unable to hack message, oh well
		return ..()

	A.ui_interact(user, state = hack_state)
	return 1

/obj/item/device/multitool/hacktool/proc/attempt_hack(mob/user, atom/target)
	if(is_hacking)
		to_chat(user, SPAN_WARNING("You are already hacking!"))
		return 1
	if(!is_type_in_list(target, supported_types))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("Unable to hack this target.")]")
		return 0
	var/found = known_targets.Find(target)
	if(found)
		known_targets.Swap(1, found)	// Move the last hacked item first
		return 1

	to_chat(user, SPAN_NOTICE("You begin hacking \the [target]..."))
	is_hacking = 1
	// Hackin takes roughly 15-25 seconds. Fairly small random span to avoid people simply aborting and trying again.
	var/hack_result = do_after(user, (15 SECONDS + rand(0, 5 SECONDS) + rand(0, 5 SECONDS)), target, do_flags = (DO_DEFAULT | DO_BOTH_UNIQUE_ACT) & ~DO_SHOW_PROGRESS)
	is_hacking = 0

	if(hack_result && in_hack_mode)
		to_chat(user, SPAN_NOTICE("Your hacking attempt was succesful!"))
		user.playsound_local(get_turf(src), 'sound/piano/A#6.ogg', 50)
		known_targets.Insert(1, target)	// Insert the newly hacked target first,
		GLOB.destroyed_event.register(target, src, TYPE_PROC_REF(/obj/item/device/multitool/hacktool, on_target_destroy))
	else
		to_chat(user, SPAN_WARNING("Your hacking attempt failed!"))
	return 1

/obj/item/device/multitool/hacktool/proc/sanity_check()
	if(max_known_targets < 1) max_known_targets = 1
	// Cut away the oldest items if the capacity has been reached
	if(length(known_targets) > max_known_targets)
		for(var/i = (max_known_targets + 1) to length(known_targets))
			var/atom/A = known_targets[i]
			GLOB.destroyed_event.unregister(A, src)
		known_targets.Cut(max_known_targets + 1)

/obj/item/device/multitool/hacktool/proc/on_target_destroy(target)
	known_targets -= target

/datum/topic_state/default/must_hack
	var/obj/item/device/multitool/hacktool/hacktool
	check_access = FALSE

/datum/topic_state/default/must_hack/New(hacktool)
	src.hacktool = hacktool
	..()

/datum/topic_state/default/must_hack/Destroy()
	hacktool = null
	return ..()

/datum/topic_state/default/must_hack/can_use_topic(src_object, mob/user)
	if(!hacktool || !hacktool.in_hack_mode || !(src_object in hacktool.known_targets))
		return STATUS_CLOSE
	return ..()

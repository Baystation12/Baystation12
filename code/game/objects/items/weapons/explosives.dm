/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ESOTERIC = 2)
	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/image_overlay = null

/obj/item/plastique/New()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies/assemblies.dmi', "plastic-explosive2")
	..()

/obj/item/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/plastique/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(isScrewdriver(I))
		open_panel = !open_panel
		to_chat(user, SPAN_NOTICE("You [open_panel ? "open" : "close"] the wire panel."))
		return TRUE
	if (isWirecutter(I) || isMultitool(I) || istype(I, /obj/item/device/assembly/signaler ))
		wires.Interact(user)
		return TRUE
	else
		return ..()

/obj/item/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if (newtime < 10)
		to_chat(user, SPAN_WARNING("You cannot set the timer to be less than 10 seconds."))
		return

	if (user.get_active_hand() == src)
		newtime = clamp(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for [timer] seconds.")

/obj/item/plastique/use_after(atom/clicked, mob/living/user, click_parameters)
	if (ismob(clicked) || istype(clicked, /turf/unsimulated) || istype(clicked, /turf/simulated/shuttle) || istype(clicked, /obj/item/clothing/accessory/storage) || istype(clicked, /obj/item/clothing/under))
		return FALSE

	to_chat(user, "Planting explosives...")
	user.do_attack_animation(clicked)

	if(do_after(user, 5 SECONDS, clicked, DO_DEFAULT | DO_USER_UNIQUE_ACT) && in_range(user, clicked))
		if(!user.unequip_item())
			FEEDBACK_UNEQUIP_FAILURE(user, src)
			return TRUE
		target = clicked
		forceMove(null)

		if (ismob(target))
			admin_attack_log(user, target, "Planted \a [src] with a [timer] second fuse.", "Had \a [src] with a [timer] second fuse planted on them.", "planted \a [src] with a [timer] second fuse on")
			user.visible_message(SPAN_DANGER("[user.name] finished planting an explosive on [target.name]!"))
			log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")

		else
			log_and_message_admins("planted \a [src] with a [timer] second fuse on \the [target].")

		target.AddOverlays(image_overlay)
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		run_timer()
	return TRUE

/obj/item/plastique/proc/explode(location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, 2, EX_ACT_LIGHT)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.kill_health()
		else if(istype(target, /mob/living))
			target.ex_act(EX_ACT_HEAVY) // c4 can't gib mobs anymore.
		else
			target.ex_act(EX_ACT_DEVASTATING)
	if(target)
		target.CutOverlays(image_overlay)
	qdel(src)

/obj/item/plastique/proc/run_timer()
	set waitfor = 0
	var/T = timer
	while(T > 0)
		sleep(1 SECOND)
		if(target)
			playsound(target, 'sound/items/timer.ogg', 50)
		else
			playsound(loc, 'sound/items/timer.ogg', 50)
		T--
	explode(get_turf(target))

/obj/aiming_overlay
	name = ""
	desc = "Stick 'em up!"
	icon = 'icons/effects/Targeted.dmi'
	icon_state = "locking"
	anchored = 1
	density = 0
	opacity = 0
	layer = FLY_LAYER
	simulated = 0
	mouse_opacity = 0

	var/mob/living/aiming_at   // Who are we currently targeting, if anyone?
	var/obj/item/aiming_with   // What are we targeting with?
	var/mob/owner              // Who do we belong to?
	var/locked =    0          // Have we locked on?
	var/lock_time = 0          // When -will- we lock on?
	var/active =    0          // Is our owner intending to take hostages?
	var/target_permissions = 0 // Permission bitflags.

/obj/aiming_overlay/New(var/newowner)
	..()
	owner = newowner
	loc = null
	verbs.Cut()

/obj/aiming_overlay/proc/toggle_permission(var/perm)

	if(target_permissions & perm)
		target_permissions &= ~perm
	else
		target_permissions |= perm

	// Update HUD icons.
	if(owner.gun_move_icon)
		if(!(target_permissions & TARGET_CAN_MOVE))
			owner.gun_move_icon.icon_state = "no_walk0"
			owner.gun_move_icon.name = "Allow Movement"
		else
			owner.gun_move_icon.icon_state = "no_walk1"
			owner.gun_move_icon.name = "Disallow Movement"

	if(owner.item_use_icon)
		if(!(target_permissions & TARGET_CAN_CLICK))
			owner.item_use_icon.icon_state = "no_item0"
			owner.item_use_icon.name = "Allow Item Use"
		else
			owner.item_use_icon.icon_state = "no_item1"
			owner.item_use_icon.name = "Disallow Item Use"

	if(owner.radio_use_icon)
		if(!(target_permissions & TARGET_CAN_RADIO))
			owner.radio_use_icon.icon_state = "no_radio0"
			owner.radio_use_icon.name = "Allow Radio Use"
		else
			owner.radio_use_icon.icon_state = "no_radio1"
			owner.radio_use_icon.name = "Disallow Radio Use"

	var/message = "no longer permitted to "
	var/use_span = "warning"
	if(target_permissions & perm)
		message = "now permitted to "
		use_span = "notice"

	switch(perm)
		if(TARGET_CAN_MOVE)
			message += "move"
		if(TARGET_CAN_CLICK)
			message += "use items"
		if(TARGET_CAN_RADIO)
			message += "use a radio"
		else
			return

	owner << "<span class='[use_span]'>[aiming_at ? "\The [aiming_at] is" : "Your targets are"] [message].</span>"
	if(aiming_at)
		aiming_at << "<span class='[use_span]'>You are [message].</span>"

/obj/aiming_overlay/process()
	if(!owner)
		qdel(src)
		return
	..()
	update_aiming()

/obj/aiming_overlay/Destroy()
	if(aiming_at)
		aiming_at.aimed -= src
		aiming_at = null
	owner = null
	aiming_with = null
	processing_objects -= src
	return ..()

obj/aiming_overlay/proc/update_aiming_deferred()
	set waitfor = 0
	sleep(0)
	update_aiming()

/obj/aiming_overlay/proc/update_aiming()

	if(!owner)
		qdel(src)
		return

	if(!aiming_at)
		cancel_aiming()
		return

	if(!locked && lock_time >= world.time)
		locked = 1
		update_icon()

	var/cancel_aim = 1

	if(!(aiming_with in owner) || (istype(owner, /mob/living/carbon/human) && (owner.l_hand != aiming_with && owner.r_hand != aiming_with)))
		owner << "<span class='warning'>You must keep hold of your weapon!</span>"
	else if(!aiming_at || !istype(aiming_at.loc, /turf))
		owner << "<span class='warning'>You have lost sight of your target!</span>"
	else if(owner.incapacitated() || owner.lying || owner.restrained())
		owner << "<span class='warning'>You must be conscious and standing to keep track of your target!</span>"
	else if(aiming_at.alpha == 0 || (aiming_at.invisibility > owner.see_invisible))
		owner << "<span class='warning'>Your target has become invisible!</span>"
	else if(get_dist(get_turf(owner), get_turf(aiming_at)) > 7) // !(owner in viewers(aiming_at, 7))
		owner << "<span class='warning'>Your target is too far away to track!</span>"
	else
		cancel_aim = 0

	forceMove(get_turf(aiming_at))

	if(cancel_aim)
		cancel_aiming()
		return

	if(!owner.incapacitated() && owner.client)
		spawn(0)
			owner.set_dir(get_dir(get_turf(owner), get_turf(src)))

/obj/aiming_overlay/proc/aim_at(var/mob/target, var/obj/thing)

	if(!owner)
		return

	if(owner.incapacitated())
		owner << "<span class='warning'>You cannot aim a gun in your current state.</span>"
		return
	if(owner.lying)
		owner << "<span class='warning'>You cannot aim a gun while prone.</span>"
		return
	if(owner.restrained())
		owner << "<span class='warning'>You cannot aim a gun while handcuffed.</span>"
		return

	if(aiming_at)
		if(aiming_at == target)
			return
		aiming_at.aimed -= src
		owner.visible_message("<span class='danger'>\The [owner] turns \the [thing] on \the [target]!</span>")
	else
		owner.visible_message("<span class='danger'>\The [owner] aims \the [thing] at \the [target]!</span>")

	if(owner.client)
		owner.client.add_gun_icons()
	target << "<span class='danger'>You now have a gun pointed at you. No sudden moves!</span>"
	aiming_with = thing
	aiming_at = target
	if(istype(aiming_with, /obj/item/weapon/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOn.ogg', 50,1)
	forceMove(get_turf(target))
	processing_objects |= src

	aiming_at.aimed |= src
	toggle_active(1)
	locked = 0
	update_icon()
	lock_time = world.time + 35

/obj/aiming_overlay/update_icon()
	if(locked)
		icon_state = "locked"
	else
		icon_state = "locking"

/obj/aiming_overlay/proc/toggle_active(var/force_state = null)
	if(!isnull(force_state))
		if(active == force_state)
			return
		active = force_state
	else
		active = !active

	if(!active)
		cancel_aiming()

	if(owner.client)
		if(active)
			owner << "<span class='notice'>You will now aim rather than fire.</span>"
			owner.client.add_gun_icons()
		else
			owner << "<span class='notice'>You will no longer aim rather than fire.</span>"
			owner.client.remove_gun_icons()

/obj/aiming_overlay/proc/cancel_aiming(var/no_message = 0)
	if(!aiming_with || !aiming_at)
		return
	if(istype(aiming_with, /obj/item/weapon/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOff.ogg', 50,1)
	if(!no_message)
		owner.visible_message("<span class='notice'>\The [owner] lowers \the [aiming_with].</span>")

	aiming_with = null
	aiming_at.aimed -= src
	aiming_at = null
	loc = null
	processing_objects -= src


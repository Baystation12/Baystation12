
/datum/computer_file/program/suit_sensors/proc/update_icon_state()
	var/datum/nano_module/crew_monitor/crew_monitor = NM
	var/old_state = program_icon_state
	if(crew_monitor.follow_mob)
		program_icon_state = camera_icon_state
	else
		program_icon_state = initial(program_icon_state)
	if(istype(computer) && program_icon_state != old_state)
		computer.update_icon()

/datum/nano_module/crew_monitor
	var/mob/living/carbon/human/follow_mob
	var/list/view_mobs = list()

/datum/nano_module/crew_monitor/proc/view_camera(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	if(istype(target))
		var/obj/item/clothing/glasses/hud/tactical/T = target.glasses
		if(istype(T) && T.enable_camera)
			follow_mob = target
			user.set_machine(nano_host())
			user.reset_view(target)
			to_chat(user,"<span class='info'>Now viewing [target] HUD camera...</span>")
		else
			to_chat(user,"<span class='notice'>Error 1 attempting to view HUD camera! (invalid tachud)</span>")
	else
		to_chat(user,"<span class='notice'>Error 2 attempting to view HUD camera! (invalid target person)</span>")

/datum/nano_module/crew_monitor/check_eye(var/mob/user)
	if(follow_mob)
		var/obj/item/clothing/glasses/hud/tactical/T = follow_mob.glasses
		if(istype(T) && T.enable_camera)
			return 0

	cancel_camera()
	return -1

/datum/nano_module/crew_monitor/proc/cancel_camera()
	if(view_mobs.len)
		for(var/mob/M in view_mobs)
			M.machine = null
			M.reset_view(null)
			to_chat(M,"<span class='notice'>Cancelling [follow_mob ? "[follow_mob.real_name] " : ""]HUD camera view.</span>")
		view_mobs = list()
	follow_mob = null

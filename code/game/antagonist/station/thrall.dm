GLOBAL_DATUM_INIT(thralls, /datum/antagonist/thrall, new)

/datum/antagonist/thrall
	role_text = "Thrall"
	role_text_plural = "Thralls"
	welcome_text = "Your mind is no longer solely your own..."
	id = MODE_THRALL
	flags = ANTAG_IMPLANT_IMMUNE

	var/list/thrall_controllers = list()
	var/controller_name //The name of said controller

/datum/antagonist/thrall/create_objectives(datum/mind/player)
	var/mob/living/controller = thrall_controllers["\ref[player]"]
	if(!controller && !controller_name) //checks for name in the event of a fake controller
		return // Someone is playing with buttons they shouldn't be.
	if(!controller_name)
		controller_name = controller.real_name
	var/datum/objective/obey = new
	obey.owner = player
	obey.explanation_text = "Obey your master, [controller_name], in all things."
	player.objectives |= obey

/datum/antagonist/thrall/add_antagonist(datum/mind/player, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance, mob/new_controller, fake_controller)
	if(fake_controller)
		controller_name = fake_controller
		. = ..()

	else
		if(new_controller)
			. = ..()
			if(.)
				thrall_controllers["\ref[player]"] = new_controller
		else
			return FALSE


/datum/antagonist/thrall/greet(datum/mind/player)
	. = ..()
	var/mob/living/controller = thrall_controllers["\ref[player]"]
	if(controller)
		to_chat(player, SPAN_DANGER("Your will has been subjugated by that of [controller_name]. Obey them in all things and execute their will."))

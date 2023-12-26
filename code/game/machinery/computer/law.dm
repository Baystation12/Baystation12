/obj/machinery/computer/upload
	name = "unused upload console"
	icon_keyboard = "rd_key"
	icon_screen = "command"
	var/mob/living/silicon/current

/obj/machinery/computer/upload/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		M.install(src, user)
		return TRUE

	return ..()

/obj/machinery/computer/upload/ai
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	machine_name = "\improper AI upload console"
	machine_desc = "Maintains a one-way link to ship-bound AI units, allowing remote modification of their laws."

/obj/machinery/computer/upload/ai/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	current = select_active_ai(user, get_z(src))
	if (!current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")
	return TRUE

/obj/machinery/computer/upload/robot
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	machine_name = "cyborg upload console"
	machine_desc = "Maintains a one-way link to ship-bound synthetics such as cyborgs and robots, allowing remote modification of their laws."

/obj/machinery/computer/upload/robot/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	current = freeborg(get_z(src))
	if (!current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")
	return TRUE

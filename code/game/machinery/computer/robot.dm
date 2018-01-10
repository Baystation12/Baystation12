/obj/machinery/computer/robotics
	name = "robotics control console"
	desc = "Used to remotely lockdown or monitor linked synthetics."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "tech_key"
	icon_screen = "robot"
	light_color = "#a97faa"
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/robotics

/obj/machinery/computer/robotics/attack_ai(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/robotics/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/robotics/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["robots"] = get_cyborgs(user)
	data["is_ai"] = issilicon(user)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "robot_control.tmpl", "Robotic Control Console", 400, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/robotics/CanUseTopic(user)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied</span>")
		return STATUS_CLOSE
	return ..()

/obj/machinery/computer/robotics/OnTopic(var/mob/user, href_list)
	// Locks or unlocks the cyborg
	if (href_list["lockdown"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["lockdown"])
		if(!target || !istype(target))
			return TOPIC_HANDLED

		if(isAI(user) && (target.connected_ai != user))
			to_chat(user, "<span class='warning'>Access Denied. This robot is not linked to you.</span>")
			return TOPIC_HANDLED

		if(isrobot(user))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return TOPIC_HANDLED

		var/choice = input("Really [target.lockcharge ? "unlock" : "lockdown"] [target.name] ?") in list ("Yes", "No")
		if(choice != "Yes")
			return TOPIC_HANDLED

		if(!target || !istype(target))
			return TOPIC_HANDLED

		if(target.SetLockdown(!target.lockcharge))
			message_admins("<span class='notice'>[key_name_admin(usr)] [target.lockcharge ? "locked down" : "released"] [target.name]!</span>")
			log_game("[key_name(usr)] [target.lockcharge ? "locked down" : "released"] [target.name]!")
			if(target.lockcharge)
				to_chat(target, "<span class='danger'>You have been locked down!</span>")
			else
				to_chat(target, "<span class='notice'>Your lockdown has been lifted!</span>")
		else
			to_chat(user, "<span class='warning'>ERROR: Lockdown attempt failed.</span>")
		. = TOPIC_REFRESH

	// Remotely hacks the cyborg. Only antag AIs can do this and only to linked cyborgs.
	else if (href_list["hack"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["hack"])
		if(!target || !istype(target))
			return TOPIC_HANDLED

		// Antag AI checks
		if(!istype(user, /mob/living/silicon/ai) || !(user.mind.special_role && user.mind.original == user))
			to_chat(user, "<span class='warning'>Access Denied</span>")
			return TOPIC_HANDLED

		if(target.emagged)
			to_chat(user, "Robot is already hacked.")
			return TOPIC_HANDLED

		var/choice = input("Really hack [target.name]? This cannot be undone.") in list("Yes", "No")
		if(choice != "Yes")
			return TOPIC_HANDLED

		if(!target || !istype(target))
			return TOPIC_HANDLED

		message_admins("<span class='notice'>[key_name_admin(usr)] emagged [target.name] using robotic console!</span>")
		log_game("[key_name(usr)] emagged [target.name] using robotic console!")
		target.emagged = 1
		to_chat(target, "<span class='notice'>Failsafe protocols overriden. New tools available.</span>")
		. = TOPIC_REFRESH

	else if (href_list["message"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["message"])
		if(!target || !istype(target))
			return

		var/message = sanitize(input("Enter message to transmit to the synthetic.") as null|text)
		if(!message || !istype(target))
			return

		log_and_message_admins("sent message '[message]' to [target.name] using robotics control console!")
		to_chat(target, "<span class='notice'>New remote message received using R-SSH protocol:</span>")
		to_chat(target, message)
		. = TOPIC_REFRESH

// Proc: get_cyborgs()
// Parameters: 1 (operator - mob which is operating the console.)
// Description: Returns NanoUI-friendly list of accessible cyborgs.
/obj/machinery/computer/robotics/proc/get_cyborgs(var/mob/operator)
	var/list/robots = list()

	for(var/mob/living/silicon/robot/R in GLOB.silicon_mob_list)
		// Ignore drones
		if(istype(R, /mob/living/silicon/robot/drone))
			continue
		// Ignore antagonistic cyborgs
		if(R.scrambledcodes)
			continue

		var/list/robot = list()
		robot["name"] = R.name
		var/turf/T = get_turf(R)
		var/area/A = get_area(T)

		if(istype(T) && istype(A) && (T.z in GLOB.using_map.contact_levels))
			robot["location"] = "[A.name] ([T.x], [T.y])"
		else
			robot["location"] = "Unknown"

		if(R.stat)
			robot["status"] = "Not Responding"
		else if (!R.canmove)
			robot["status"] = "Lockdown"
		else
			robot["status"] = "Operational"

		if(R.cell)
			robot["cell"] = 1
			robot["cell_capacity"] = R.cell.maxcharge
			robot["cell_current"] = R.cell.charge
			robot["cell_percentage"] = round(R.cell.percent())
		else
			robot["cell"] = 0

		robot["module"] = R.module ? R.module.name : "None"
		robot["master_ai"] = R.connected_ai ? R.connected_ai.name : "None"
		robot["hackable"] = 0
		// Antag AIs know whether linked cyborgs are hacked or not.
		if(operator && istype(operator, /mob/living/silicon/ai) && (R.connected_ai == operator) && (operator.mind.special_role && operator.mind.original == operator))
			robot["hacked"] = R.emagged ? 1 : 0
			robot["hackable"] = R.emagged? 0 : 1
		robots.Add(list(robot))
	return robots

// Proc: get_cyborg_by_name()
// Parameters: 1 (name - Cyborg we are trying to find)
// Description: Helper proc for finding cyborg by name
/obj/machinery/computer/robotics/proc/get_cyborg_by_name(var/name)
	if (!name)
		return
	for(var/mob/living/silicon/robot/R in GLOB.silicon_mob_list)
		if(R.name == name)
			return R

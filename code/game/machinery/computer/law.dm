/obj/machinery/computer/upload
	name = "unused upload console"
	icon_keyboard = "rd_key"
	icon_screen = "command"
	var/mob/living/silicon/current

/obj/machinery/computer/upload/attack_hand(mob/user)
	if(..())
		return TRUE

	if(stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return TRUE
	if(stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return TRUE

/obj/machinery/computer/upload/attackby(obj/item/weapon/O, mob/user)
	if(istype(O, /obj/item/weapon/aiModule))
		var/obj/item/weapon/aiModule/M = O
		M.install(src, user)
	else
		..()

/obj/machinery/computer/upload/ai
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	circuit = /obj/item/weapon/circuitboard/aiupload

/obj/machinery/computer/upload/ai/attack_hand(mob/user)
	if(..())
		return TRUE

	current = select_active_ai(user, (get_turf(src))?.z)

	if (!current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")

/obj/machinery/computer/upload/robot
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	circuit = /obj/item/weapon/circuitboard/borgupload

/obj/machinery/computer/upload/robot/attack_hand(mob/user)
	if(..())
		return TRUE

	current = freeborg((get_turf(src))?.z)

	if (!current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")

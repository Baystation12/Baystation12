// The computer var is for the remote computer with these.
/datum/terminal/remote
	name = "Remote Terminal"
	var/obj/item/modular_computer/origin_computer

/datum/terminal/remote/New(mob/user, obj/item/modular_computer/computer, obj/item/modular_computer/origin)
	..(user, computer)
	origin_computer = origin
	START_PROCESSING(SSprocessing, src)

/datum/terminal/remote/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(origin_computer && origin_computer.terminals)
		origin_computer.terminals -= src
	origin_computer = null
	return ..()

/datum/terminal/remote/Process()
	if(!origin_computer.network_card || !origin_computer.network_card.check_functionality())
		return PROCESS_KILL
	if(!computer.network_card || !computer.network_card.check_functionality())
		return PROCESS_KILL
	if(!ntnet_global.check_function())
		return PROCESS_KILL
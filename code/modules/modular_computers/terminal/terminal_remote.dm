// The computer var is for the remote computer with these.
/datum/terminal/remote
	name = "Remote Terminal"
	var/datum/extension/interactive/ntos/origin_computer

/datum/terminal/remote/New(mob/user, datum/extension/interactive/ntos/computer, datum/extension/interactive/ntos/origin)
	origin_computer = origin
	..(user, computer)

/datum/terminal/remote/Destroy()
	if(origin_computer && origin_computer.terminals)
		origin_computer.terminals -= src
	origin_computer = null
	return ..()

/datum/terminal/remote/can_use(mob/user)
	if(!user)
		return FALSE

	if(!computer || !computer.on || !origin_computer || !origin_computer.on)
		return FALSE
	if(!CanInteractWith(user, origin_computer, GLOB.default_state))
		return FALSE

	if(!origin_computer.get_ntnet_status() || !computer.get_ntnet_status())
		return FALSE

	return TRUE
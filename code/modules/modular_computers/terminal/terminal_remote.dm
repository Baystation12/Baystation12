// The computer var is for the remote computer with these.
/datum/terminal/remote
	name = "Remote Terminal"
	var/obj/item/modular_computer/origin_computer

/datum/terminal/remote/New(mob/user, obj/item/modular_computer/computer, obj/item/modular_computer/origin)
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

	if(!computer || !computer.enabled || !origin_computer || !origin_computer.enabled)
		return FALSE
	if(!CanInteractWith(user, origin_computer, GLOB.default_state))
		return FALSE


	if(!origin_computer.network_card || !origin_computer.network_card.check_functionality())
		return FALSE
	if(!computer.network_card || !computer.network_card.check_functionality())
		return FALSE
	if(!ntnet_global.check_function())
		return FALSE

	return TRUE
/mob/living/silicon/robot/drone/battle
	name = "cheap drone"
	real_name = "cheap drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	cell_emp_mult = 1
	universal_speak = 0
	universal_understand = 0
	gender = NEUTER
	pass_flags = PASSTABLE
	braintype = "Robot"
	lawupdate = 0
	density = 1
	req_access = list()
	integrated_light_power = 4
	local_transmit = 0
	possession_candidate = 0

	can_pull_size = 5
	can_pull_mobs = MOB_PULL_SMALLER

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	mob_size = MOB_MEDIUM

	holder_type = /obj/item/weapon/holder/drone

	var/obj/machinery/space_battle/drone_control/computer

	updatename()
		var/team = 0
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team
		real_name = "cheap drone (#[team]-[pick("Cheese", "Pickles", "Nachos", "Pasta", "Potato")])"
		name = real_name

	Destroy()
		return_to_body()
		computer = null
		return ..()

/mob/living/silicon/robot/drone/battle/New()
	..()
	verbs += /mob/living/silicon/robot/drone/battle/proc/return_to_body
	cell.maxcharge = 800
	cell.charge = 800

/mob/living/silicon/robot/drone/battle/proc/return_to_body()
	set name = "Return To Body"
	set desc = "Return to your own body"
	set category = "Fire Control"

	if(computer)
		computer.return_to_body()
	else
		usr << "<span class='warning'>You are forever trapped in this body!</span>"
		return

/obj/machinery/space_battle/drone_control
	name = "drone control"
	desc = "A computer for controlling a drone"

	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1

	idle_power_usage = 750
	use_power = 1

	var/mob/living/silicon/robot/drone/battle/controlled
	var/mob/living/carbon/human/controller

	New()
		..()
		spawn(10)
			var/mob/living/silicon/robot/drone/battle/newdrone = locate() in view(2)
			if(newdrone)
				controlled = newdrone
				controlled.computer = src

	attack_hand(var/mob/user)
		if(!(stat & (BROKEN|NOPOWER)))
			if(controller)
				user << "<span class='warning'>[controller] is currently controlling that!</span>"
				return
			if(!controlled)
				var/mob/living/silicon/robot/drone/battle/newdrone = locate() in view(2)
				if(newdrone)
					controlled = newdrone
				else
					user << "<span class='warning'>No drone detected!</span>"
					return
			else if(controlled.stat)
				user << "<span class='warning'>\The [controlled] is not responding!</span>"
				return
			controller = user
			controlled.key = user.key
			if(!user.key)
				user.key = "@sb[user.key]"
			user.teleop = controlled
			controlled.computer = src
			return


	proc/return_to_body()
		if(!controller) return
		controller.ckey = null
		controller.ckey = controlled.ckey
		controlled.ckey = null
		controller.teleop = null
		controller = null
		return

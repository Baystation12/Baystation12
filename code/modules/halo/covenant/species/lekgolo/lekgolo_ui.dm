
#define MGALEKGOLO_TURN_DELAY 0.7 SECONDS

/obj/item/hunter_action
	icon = 'code/modules/halo/covenant/species/lekgolo/hunter_actions.dmi'
	var/mob/living/simple_animal/mgalekgolo/owner

/obj/item/hunter_action/New()
	. = ..()
	owner = loc
	if(!istype(owner))
		qdel(src)

/obj/item/hunter_action/crouch
	action_button_name = "Crouch"
	icon_state = "crouch"

/obj/item/hunter_action/crouch/ui_action_click()
	if(owner)
		owner.toggle_crouch()

/mob/living/simple_animal/mgalekgolo/verb/toggle_crouch()
	set category = "IC"
	set name = "Toggle crouch"

	if(crouched)
		visible_message("\icon[src] <span class='notice'>[src] stands up.</span>")
	else
		visible_message("\icon[src] <span class='warning'>[src] drops into a combat crouch.</span>")

	if(do_after(src, 5))
		crouched = !crouched
		icon_state = "hunter[crouched]"
		if(crouched)
			speed = crouch_speed
		else
			speed = initial(speed)

		//dont worry about updating the icon, it's more trouble than its worth
		/*
		var/obj/item/hunter_action/crouch/crouch_action = locate() in src
		if(crouch_action)
			if(crouched)
				crouch_action.action_button_name = "Stand up"
				crouch_action.icon_state = "stand"
			else
				crouch_action.action_button_name = "Crouch"
				crouch_action.icon_state = "crouch"
				*/

/obj/item/hunter_action/turn_cw
	action_button_name = "Turn clockwise"
	icon_state = "turn_cw"

/obj/item/hunter_action/turn_cw/ui_action_click()
	if(owner)
		owner.turn_cw()

/mob/living/simple_animal/mgalekgolo/verb/turn_cw()
	set category = "IC"
	set name = "Turn Clockwise"

	visible_message("\icon[src] <span class='notice'>[src] shuffles to face the right.</span>")
	facedir(GLOB.cw_dir[dir], 1)

/obj/item/hunter_action/turn_ccw
	action_button_name = "Turn counter-clockwise"
	icon_state = "turn_ccw"

/obj/item/hunter_action/turn_ccw/ui_action_click()
	if(owner)
		owner.turn_ccw()

/mob/living/simple_animal/mgalekgolo/verb/turn_ccw()
	set category = "IC"
	set name = "Turn Counterclockwise"

	visible_message("\icon[src] <span class='notice'>[src] shuffles to face the left.</span>")
	facedir(GLOB.cww_dir[dir], 1)

//see code\modules\mob\mob.dm
/mob/living/simple_animal/mgalekgolo/set_dir(var/new_dir)
	if(!turning)
		turning = 1
		if(!crouched || do_after(src, MGALEKGOLO_TURN_DELAY))
			. = ..()
		turning = 0
	else
		to_chat(src,"<span class = 'notice'>You're already turning!</span>")
	return

#undef MGALEKGOLO_TURN_DELAY

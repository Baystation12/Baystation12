/obj/item/organ/external/chest/insectoid/nabber
	name = "thorax"
	encased = "carapace"
	action_button_name = "Perform Threat Display"

/obj/item/organ/external/chest/insectoid/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-threat"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/chest/insectoid/nabber/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(owner.incapacitated())
			to_chat(owner, "<span class='warning'>You can't do a threat display in your current state.</span>")
			return
		if(owner.skin_state == SKIN_NORMAL)
			if(owner.pulling_punches)
				to_chat(owner, "<span class='warning'>You must be in your hunting stance to do a threat display.</span>")
			else
				var/message = alert(owner, "Would you like to show a scary message?",,"Cancel","Yes", "No")
				if(message == "Cancel")
					return
				else if(message == "Yes")
					owner.visible_message("<span class='warning'>[owner]'s skin shifts to a deep red colour with dark chevrons running down in an almost hypnotic \
						pattern. Standing tall, \he strikes, sharp spikes aimed at those threatening \him, claws whooshing through the air past them.</span>")
				playsound(owner.loc, 'sound/effects/angrybug.ogg', 60, 0)
				owner.skin_state = SKIN_THREAT
				owner.update_skin()
				addtimer(CALLBACK(owner, /mob/living/carbon/human/proc/reset_skin), 10 SECONDS, TIMER_UNIQUE)
		else if(owner.skin_state == SKIN_THREAT)
			owner.reset_skin()

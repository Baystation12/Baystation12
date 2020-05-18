/spell/veil_of_shadows
	name = "Veil of Shadows"
	desc = "Become intangable, invisible. Like a ghost."
	charge_max = 400
	invocation_type = SpI_EMOTE
	invocation = "flickers out of existance"
	school = "Divine" //Means that it doesn't proc the deity's spell cost.
	spell_flags = 0
	duration = 100
	var/timer_id
	var/light_steps = 4

	hud_state = "wiz_statue"

/spell/veil_of_shadows/choose_targets()
	if(!timer_id && istype(holder,/mob/living/carbon/human))
		return list(holder)
	. = null

/spell/veil_of_shadows/cast(var/list/targets, var/mob/user)
	var/mob/living/carbon/human/H = user
	H.AddMovementHandler(/datum/movement_handler/mob/incorporeal)
	if(H.add_cloaking_source(src))
		H.visible_message("<span class='warning'>\The [H] shrinks from view!</span>")
	GLOB.moved_event.register(H,src,.proc/check_light)
	timer_id = addtimer(CALLBACK(src,.proc/cancel_veil),duration, TIMER_STOPPABLE)

/spell/veil_of_shadows/proc/cancel_veil()
	var/mob/living/carbon/human/H = holder
	H.RemoveMovementHandler(/datum/movement_handler/mob/incorporeal)
	deltimer(timer_id)
	timer_id = null
	var/turf/T = get_turf(H)
	if(T.get_lumcount() > 0.1) //If we're somewhere somewhat shadowy we can stay invis as long as we stand still
		drop_cloak()
	else
		GLOB.moved_event.unregister(H,src)
		GLOB.moved_event.register(H,src,.proc/drop_cloak)

/spell/veil_of_shadows/proc/drop_cloak()
	var/mob/living/carbon/human/H = holder
	if(H.remove_cloaking_source(src))
		H.visible_message("<span class='notice'>\The [H] appears from nowhere!</span>")
	GLOB.moved_event.unregister(H,src)

/spell/veil_of_shadows/proc/check_light()
	if(light_steps)
		light_steps--
		return
	light_steps = initial(light_steps)
	for(var/obj/machinery/light/light in view(1,holder))
		light.flicker(20)

/spell/veil_of_shadows/Destroy()
	deltimer(timer_id)
	cancel_veil()
	.= ..()
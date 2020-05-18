
/obj/machinery/vitals_monitor
	name = "vitals monitor"
	desc = "A bulky yet mobile machine, showing some odd graphs."
	icon = 'icons/obj/heartmonitor.dmi'
	icon_state = "base"
	anchored = FALSE
	power_channel = EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	stat_immune = NOINPUT
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed

	var/mob/living/carbon/human/victim
	var/beep = TRUE

/obj/machinery/vitals_monitor/Destroy()
	victim = null
	. = ..()
	
/obj/machinery/vitals_monitor/examine(mob/user)
	. = ..()
	if(victim)
		if(stat & NOPOWER)
			to_chat(user, SPAN_NOTICE("It's unpowered."))
			return
		to_chat(user, SPAN_NOTICE("Vitals of [victim]:"))
		to_chat(user, SPAN_NOTICE("Pulse: [victim.get_pulse(GETPULSE_TOOL)]"))

		var/brain_activity = "none"
		var/obj/item/organ/internal/brain/brain = victim.internal_organs_by_name[BP_BRAIN]
		if(istype(brain) && victim.stat != DEAD && !(victim.status_flags & FAKEDEATH))
			if(user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
				switch(brain.get_current_damage_threshold())
					if(0 to 2)
						brain_activity = "normal"
					if(3 to 5)
						brain_activity = "weak"
					if(6 to INFINITY)
						brain_activity = "extremely weak"
			else
				brain_activity = "some"
		to_chat(user, SPAN_NOTICE("Brain activity: [brain_activity]"))

		var/breathing = "none"
		var/obj/item/organ/internal/lungs/lungs = victim.internal_organs_by_name[BP_LUNGS]
		if(istype(lungs) && !(victim.status_flags & FAKEDEATH))
			if(lungs.breath_fail_ratio < 0.3)
				breathing = "normal"
			else if(lungs.breath_fail_ratio < 1)
				breathing = "shallow"
		
		to_chat(user, SPAN_NOTICE("Breathing: [breathing]"))

/obj/machinery/vitals_monitor/Process()
	if(QDELETED(victim))
		victim = null
	if(victim && !Adjacent(victim))
		victim = null
		update_use_power(POWER_USE_IDLE)
	if(victim)
		update_icon()
	if(beep && victim && victim.pulse())
		playsound(src, 'sound/machines/quiet_beep.ogg')
	
/obj/machinery/vitals_monitor/MouseDrop(over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return
	if(victim)
		victim = null
		update_use_power(POWER_USE_IDLE)
	else if(ishuman(over_object))
		victim = over_object
		update_use_power(POWER_USE_ACTIVE)
		visible_message(SPAN_NOTICE("\The [src] is now showing data for [victim]."))

/obj/machinery/vitals_monitor/on_update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		return
	overlays += image(icon, icon_state = "screen")

	if(!victim)
		return
	
	switch(victim.pulse())
		if(PULSE_NONE)
			overlays += image(icon, icon_state = "pulse_flatline")
			overlays += image(icon, icon_state = "pulse_warning")
		if(PULSE_SLOW, PULSE_NORM,)
			overlays += image(icon, icon_state = "pulse_normal")
		if(PULSE_FAST, PULSE_2FAST)
			overlays += image(icon, icon_state = "pulse_veryfast")
		if(PULSE_THREADY)
			overlays += image(icon, icon_state = "pulse_thready")
			overlays += image(icon, icon_state = "pulse_warning")

	var/obj/item/organ/internal/brain/brain = victim.internal_organs_by_name[BP_BRAIN]
	if(istype(brain) && victim.stat != DEAD && !(victim.status_flags & FAKEDEATH))
		switch(brain.get_current_damage_threshold())
			if(0 to 2)
				overlays += image(icon, icon_state = "brain_ok")
			if(3 to 5)
				overlays += image(icon, icon_state = "brain_bad")
			if(6 to INFINITY)
				overlays += image(icon, icon_state = "brain_verybad")
				overlays += image(icon, icon_state = "brain_warning")
	else
		overlays += image(icon, icon_state = "brain_warning")

	var/obj/item/organ/internal/lungs/lungs = victim.internal_organs_by_name[BP_LUNGS]
	if(istype(lungs) && !(victim.status_flags & FAKEDEATH))
		if(lungs.breath_fail_ratio < 0.3)
			overlays += image(icon, icon_state = "breathing_normal")
		else if(lungs.breath_fail_ratio < 1)
			overlays += image(icon, icon_state = "breathing_shallow")
		else
			overlays += image(icon, icon_state = "breathing_warning")
	else
		overlays += image(icon, icon_state = "breathing_warning")

/obj/machinery/vitals_monitor/verb/toggle_beep()
	set name = "Toggle Monitor Beeping"
	set category = "Object"
	set src in view(1)

	var/mob/user = usr
	if(!istype(user))
		return
	
	if(CanPhysicallyInteract(user))
		beep = !beep
		to_chat(user, SPAN_NOTICE("You turn the sound on \the [src] [beep ? "on" : "off"]."))
		
/obj/item/weapon/stock_parts/circuitboard/vitals_monitor
	name = "circuit board (Vitals Monitor)"
	build_path = /obj/machinery/vitals_monitor
	board_type = "machine"
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/weapon/cell/high = 1
	)
#define PULSE_ALERT 1
#define BRAIN_ALERT 2
#define LUNGS_ALERT 3

/obj/machinery/vitals_monitor
	name = "vitals monitor"
	desc = "A bulky yet mobile machine, showing some odd graphs."
	icon = 'icons/obj/machines/heartmonitor.dmi'
	icon_state = "base"
	anchored = FALSE
	power_channel = EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	stat_immune = MACHINE_STAT_NOINPUT
	uncreated_component_parts = null
	construct_state = /singleton/machine_construction/default/panel_closed

	var/mob/living/carbon/human/victim
	var/obj/machinery/optable/connected_optable = null
	var/beep = TRUE

	//alert stuff
	var/read_alerts = TRUE
	var/alert_cooldown = 50 // buffer to prevent rapid changes in state
	var/last_alert_time = 0
	var/list/alerts = null
	var/list/last_alert = null

	///Does it give info on fractures and arterial?
	var/detailed = FALSE

/obj/machinery/vitals_monitor/Initialize()
	. = ..()
	alerts = new(3)
	last_alert = new(3)
	for (dir in list(NORTH,EAST,SOUTH,WEST))
		connected_optable = locate(/obj/machinery/optable, get_step(src, dir))
		if (connected_optable)
			connected_optable.connected_monitor = src
			break

/obj/machinery/vitals_monitor/Destroy()
	victim = null
	update_optable()
	. = ..()

/obj/machinery/vitals_monitor/examine(mob/user)
	. = ..()
	if (victim)
		if (!is_powered())
			to_chat(user, SPAN_NOTICE("It's unpowered."))
			return
		to_chat(user, SPAN_NOTICE("Vitals of [victim]:"))
		to_chat(user, SPAN_NOTICE("Pulse: [victim.get_pulse(GETPULSE_TOOL)]"))
		to_chat(user, SPAN_NOTICE("Blood pressure: [victim.get_blood_pressure()]"))
		to_chat(user, SPAN_NOTICE("Blood oxygenation: [victim.get_blood_oxygenation()]%"))
		to_chat(user, SPAN_NOTICE("Body temperature: [victim.bodytemperature-T0C]&deg;C ([victim.bodytemperature*1.8-459.67]&deg;F)"))

		var/brain_activity = "none"
		var/obj/item/organ/internal/brain/brain = victim.internal_organs_by_name[BP_BRAIN]
		var/danger = FALSE
		if (istype(brain) && victim.stat != DEAD && !GET_FLAGS(victim.status_flags, FAKEDEATH))
			if (user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
				switch (brain.get_current_damage_threshold())
					if (0)
						brain_activity = "normal"
					if (1 to 2)
						brain_activity = "minor brain damage"
					if (3 to 5)
						brain_activity = "weak"
						danger = TRUE
					if (6 to 8)
						brain_activity = "extremely weak"
						danger = TRUE
					if (9 to INFINITY)
						brain_activity = "fading"
						danger = TRUE

			else
				brain_activity = "some"
		if (!danger)
			to_chat(user, SPAN_NOTICE("Brain activity: [brain_activity]"))
		else
			to_chat(user, SPAN_WARNING("Brain activity: [brain_activity]"))

		var/breathing = "none"
		var/obj/item/organ/internal/lungs/lungs = victim.internal_organs_by_name[BP_LUNGS]
		if (istype(lungs) && !GET_FLAGS(victim.status_flags, FAKEDEATH))
			if (lungs.breath_fail_ratio < 0.3)
				breathing = "normal"
			else if (lungs.breath_fail_ratio < 1)
				breathing = "shallow"

		to_chat(user, SPAN_NOTICE("Breathing: [breathing]"))

		if (detailed && user.skill_check(SKILL_MEDICAL, SKILL_TRAINED))
			for (var/name in victim.organs_by_name)
				var/obj/item/organ/external/organ = victim.organs_by_name[name]
				if (!organ)
					continue
				var/limb = organ.name
				var/dat = null
				if (GET_FLAGS(organ.status, ORGAN_BROKEN | ORGAN_ARTERY_CUT))
					dat += "[limb]: "
				if (GET_FLAGS(organ.status, ORGAN_BROKEN))
					dat += SPAN_CLASS("scan_warning", "Bone fracture. ")
				if (GET_FLAGS(organ.status, ORGAN_ARTERY_CUT))
					dat += SPAN_CLASS("scan_warning", "Arterial bleeding.")
				if (dat)
					dat = capitalize(dat)
					to_chat(user, SPAN_WARNING("[dat]"))

	if (connected_optable)
		to_chat(user, SPAN_NOTICE("Connected to \the [connected_optable]."))

/obj/machinery/vitals_monitor/Process()
	if (QDELETED(victim))
		update_victim()
	if (victim && !Adjacent(victim))
		update_victim()
	if (connected_optable && !Adjacent(connected_optable))
		update_victim()
		update_optable()
	if (victim)
		update_icon()

/obj/machinery/vitals_monitor/proc/update_victim(new_victim = null)
	var/old_victim = victim
	victim = new_victim
	if (victim)
		visible_message(SPAN_NOTICE("\The [src] is now showing data for \the [victim]."))
	else
		if (old_victim != new_victim) // Protects against qdel edge case. In all other cases we want a message printed.
			visible_message(SPAN_NOTICE("\The [src] is no longer showing data from [isnull(old_victim)? "any patient" : "\the [old_victim]"]."))
	update_use_power(isnull(victim)? POWER_USE_IDLE : POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/vitals_monitor/proc/update_optable(obj/machinery/optable/new_optable = null)
	if (new_optable == connected_optable)
		return
	if (connected_optable) //gotta clear existing connections first
		connected_optable.connected_monitor = null
	connected_optable = new_optable
	if (connected_optable)
		connected_optable.connected_monitor = src
		visible_message(SPAN_NOTICE("\The [src] is now relaying information from \the [connected_optable]"))
		//In case there's already a patient on the table
		update_victim(connected_optable.victim)
	else
		visible_message(SPAN_NOTICE("\The [src] is no longer relaying data from a connected operating table."))

/obj/machinery/vitals_monitor/MouseDrop(over_object, src_location, over_location)
	if (!CanMouseDrop(over_object))
		return
	update_optable()
	if (victim)
		update_victim()
	else if (ishuman(over_object))
		update_victim(over_object)
	else if (istype(over_object, /obj/machinery/optable))
		var/obj/machinery/optable/new_table_connection = over_object
		update_optable(new_table_connection)

/obj/machinery/vitals_monitor/on_update_icon()
	ClearOverlays()
	if (!is_powered())
		return
	AddOverlays(image(icon, icon_state = "screen"))

	handle_pulse()
	handle_brain()
	handle_lungs()
	handle_alerts()

/obj/machinery/vitals_monitor/proc/handle_pulse()
	if (!victim)
		return
	var/obj/item/organ/internal/heart/heart = victim.internal_organs_by_name[BP_HEART]
	if (istype(heart) && !BP_IS_ROBOTIC(heart))
		switch (victim.pulse())
			if (PULSE_NONE)
				AddOverlays(emissive_appearance(icon, "pulse_flatline"))
				AddOverlays(emissive_appearance(icon, "pulse_warning"))
				AddOverlays(image(icon, icon_state = "pulse_flatline"))
				AddOverlays(image(icon, icon_state = "pulse_warning"))
				if (beep)
					playsound(src, 'sound/machines/flatline.ogg', 20)
				if (read_alerts)
					alerts[PULSE_ALERT] = "Cardiac flatline detected!"
			if (PULSE_SLOW, PULSE_NORM,)
				AddOverlays(emissive_appearance(icon, "pulse_normal"))
				AddOverlays(image(icon, icon_state = "pulse_normal"))
				if (beep)
					playsound(src, 'sound/machines/quiet_beep.ogg', 40)
			if (PULSE_FAST, PULSE_2FAST)
				AddOverlays(emissive_appearance(icon, "pulse_veryfast"))
				AddOverlays(image(icon, icon_state = "pulse_veryfast"))
				if (beep)
					playsound(src, 'sound/machines/quiet_double_beep.ogg', 40)
			if (PULSE_THREADY)
				AddOverlays(emissive_appearance(icon, "pulse_thready"))
				AddOverlays(image(icon, icon_state = "pulse_thready"))
				AddOverlays(emissive_appearance(icon, "pulse_warning"))
				AddOverlays(image(icon, icon_state = "pulse_warning"))
				if (beep)
					playsound(src, 'sound/machines/ekg_alert.ogg', 40)
				if (read_alerts)
					alerts[PULSE_ALERT] = "Excessive heartbeat! Possible Shock Detected!"
	else
		AddOverlays(emissive_appearance(icon, "pulse_warning"))
		AddOverlays(image(icon, icon_state = "pulse_warning"))

/obj/machinery/vitals_monitor/proc/handle_brain()
	if (!victim)
		return
	var/obj/item/organ/internal/brain/brain = victim.internal_organs_by_name[BP_BRAIN]
	if (istype(brain) && victim.stat != DEAD && !(victim.status_flags & FAKEDEATH))
		switch (brain.get_current_damage_threshold())
			if (0 to 2)
				AddOverlays(emissive_appearance(icon, "brain_ok"))
				AddOverlays(image(icon, icon_state = "brain_ok"))
			if (3 to 5)
				AddOverlays(emissive_appearance(icon, "breathing_bad"))
				AddOverlays(image(icon, icon_state = "brain_bad"))
				if (read_alerts)
					alerts[BRAIN_ALERT] = "Weak brain activity!"
			if (6 to INFINITY)
				AddOverlays(emissive_appearance(icon, "brain_verybad"))
				AddOverlays(image(icon, icon_state = "brain_verybad"))
				AddOverlays(emissive_appearance(icon, "brain_warning"))
				AddOverlays(image(icon, icon_state = "brain_warning"))
				if (read_alerts)
					alerts[BRAIN_ALERT] = "Very weak brain activity!"
	else
		AddOverlays(emissive_appearance(icon, "brain_warning"))
		AddOverlays(image(icon, icon_state = "brain_warning"))

/obj/machinery/vitals_monitor/proc/handle_lungs()
	if (!victim)
		return
	var/obj/item/organ/internal/lungs/lungs = victim.internal_organs_by_name[BP_LUNGS]
	if (istype(lungs) && !(victim.status_flags & FAKEDEATH))
		if (lungs.breath_fail_ratio < 0.3)
			AddOverlays(emissive_appearance(icon, "breathing_normal"))
			AddOverlays(image(icon, icon_state = "breathing_normal"))
		else if (lungs.breath_fail_ratio < 1)
			AddOverlays(emissive_appearance(icon, "breathing_shallow"))
			AddOverlays(image(icon, icon_state = "breathing_shallow"))
			if (read_alerts)
				alerts[LUNGS_ALERT] = "Abnormal breathing detected!"
		else
			AddOverlays(emissive_appearance(icon, "breathing_warning"))
			AddOverlays(image(icon, icon_state = "breathing_warning"))
			if (read_alerts)
				alerts[LUNGS_ALERT] = "Patient is not breathing!"
	else
		AddOverlays(emissive_appearance(icon, "breathing_warning"))
		AddOverlays(image(icon, icon_state = "breathing_warning"))

/obj/machinery/vitals_monitor/proc/handle_alerts()
	if (!victim || !read_alerts) //Clear our alerts
		alerts[PULSE_ALERT] = ""
		alerts[BRAIN_ALERT] = ""
		alerts[LUNGS_ALERT] = ""
		return
	if (last_alert_time + alert_cooldown < world.time)
		if (alerts[PULSE_ALERT] && alerts[PULSE_ALERT] != last_alert[PULSE_ALERT])
			audible_message(SPAN_WARNING("<b>\The [src]</b> beeps, \"[alerts[PULSE_ALERT]]\""))
		if (alerts[BRAIN_ALERT] && alerts[BRAIN_ALERT] != last_alert[BRAIN_ALERT])
			audible_message(SPAN_WARNING("<b>\The [src]</b> alarms, \"[alerts[BRAIN_ALERT]]\""))
		if (alerts[LUNGS_ALERT] && alerts[LUNGS_ALERT] != last_alert[LUNGS_ALERT])
			audible_message(SPAN_WARNING("<b>\The [src]</b> warns, \"[alerts[LUNGS_ALERT]]\""))
		last_alert = alerts.Copy()
		last_alert_time = world.time



/obj/machinery/vitals_monitor/verb/toggle_beep()
	set name = "Toggle Monitor Beeping"
	set category = "Object"
	set src in view(1)

	var/mob/user = usr
	if (!istype(user))
		return

	if (CanPhysicallyInteract(user))
		beep = !beep
		to_chat(user, SPAN_NOTICE("You turn the sound on \the [src] [beep ? "on" : "off"]."))

/obj/machinery/vitals_monitor/verb/toggle_alerts()
	set name = "Toggle Alert Annunciator"
	set category = "Object"
	set src in view(1)

	var/mob/user = usr
	if (!istype(user))
		return

	if (CanPhysicallyInteract(user))
		read_alerts = !read_alerts
		to_chat(user, SPAN_NOTICE("You turn the alert reader on \the [src] [read_alerts ? "on" : "off"]."))

/obj/item/stock_parts/circuitboard/vitals_monitor
	name = "circuit board (vitals monitor)"
	build_path = /obj/machinery/vitals_monitor
	board_type = "machine"
	req_components = list(
		/obj/item/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell/high = 1,
		/obj/item/stock_parts/scanning_module = 2
	)

/obj/machinery/vitals_monitor/RefreshParts()
	..()
	var/T = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	if (T >= 6)
		detailed = TRUE
	else
		detailed = FALSE

#undef PULSE_ALERT
#undef BRAIN_ALERT
#undef LUNGS_ALERT

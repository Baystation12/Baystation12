//Survival/Stasis sleepers
/obj/machinery/sleeper/survival_pod
	name = "stasis pod"
	desc = "A comfortable pod for stasing of wounded occupants. Similar pods were on first humanity's colonial ships. Now days, you can see them in EMT centers with stasis setting from 20x to 22x."
	icon = 'packs/infinity/icons/obj/Cryogenic2.dmi'
	icon_state = "stasis_0"
	stasis = 20
	active_power_usage = 55000

/obj/machinery/sleeper/survival_pod/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.outside_state)
	var/data[0]

	data["power"] = stat & (MACHINE_BROKEN_GENERIC|MACHINE_STAT_NOPOWER) ? 0 : 1

	if(occupant)
		var/scan = user.skill_check(SKILL_MEDICAL, SKILL_ADEPT) ? medical_scan_results(occupant) : "<span class='white'><b>Contains: \the [occupant]</b></span>"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		data["occupant"] = scan
	else
		data["occupant"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "_inf-mod-stasis.tmpl", "Stasis Pod UI", 400, 300, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/sleeper/survival_pod/on_update_icon()
	if(!occupant)
		icon_state = "stasis_0"
	else if(inoperable())
		icon_state = "stasis_1"
	else
		icon_state = "stasis_2"

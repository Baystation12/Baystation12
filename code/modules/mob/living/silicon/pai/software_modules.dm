/datum/pai_software
	// Name for the software. This is used as the button text when buying or opening/toggling the software
	var/name = "pAI software module"
	// RAM cost; pAIs start with 100 RAM, spending it on programs
	var/ram_cost = 0
	// ID for the software. This must be unique
	var/id = ""
	// Whether this software is a toggle or not
	// Toggled software should override toggle() and is_active()
	// Non-toggled software should override on_ui_interact() and Topic()
	var/toggle = 1
	// Whether pAIs should automatically receive this module at no cost
	var/default = 0

	proc/on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		return

	proc/toggle(mob/living/silicon/pai/user)
		return

	proc/is_active(mob/living/silicon/pai/user)
		return 0

	proc/on_purchase(mob/living/silicon/pai/user)
		return

/datum/pai_software/directives
	name = "Directives"
	ram_cost = 0
	id = "directives"
	toggle = 0
	default = 1

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		data["master"] = user.master
		data["dna"] = user.master_dna
		data["prime"] = user.pai_law0
		data["supplemental"] = user.pai_laws

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_directives.tmpl", "pAI Directives", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list["getdna"])
			var/mob/living/M = P.loc
			var/count = 0

			// Find the carrier
			while(!istype(M, /mob/living))
				if(!M || !M.loc || count > 6)
					//For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
					to_chat(src, "You are not being carried by anyone!")
					return 0
				M = M.loc
				count++

			// Check the carrier
			var/answer = input(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", "No") in list("Yes", "No")
			if(answer == "Yes")
				var/turf/T = get_turf_or_move(P.loc)
				for (var/mob/v in viewers(T))
					v.show_message("<span class='notice'>[M] presses \his thumb against [P].</span>", 3, "<span class='notice'>[P] makes a sharp clicking sound as it extracts DNA material from [M].</span>", 2)
				var/datum/dna/dna = M.dna
				to_chat(P, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
				if(dna.unique_enzymes == P.master_dna)
					to_chat(P, "<b>DNA is a match to stored Master DNA.</b>")
				else
					to_chat(P, "<b>DNA does not match stored Master DNA.</b>")
			else
				to_chat(P, "[M] does not seem like \he is going to provide a DNA sample willingly.")
			return 1

/datum/pai_software/radio_config
	name = "Radio Configuration"
	ram_cost = 0
	id = "radio"
	toggle = 0
	default = 1

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui = null, force_open = 1)
		var/data[0]

		data["listening"] = user.silicon_radio.broadcasting
		data["frequency"] = format_frequency(user.silicon_radio.frequency)

		var/channels[0]
		for(var/ch_name in user.silicon_radio.channels)
			var/ch_stat = user.silicon_radio.channels[ch_name]
			var/ch_dat[0]
			ch_dat["name"] = ch_name
			// FREQ_LISTENING is const in /obj/item/device/radio
			ch_dat["listening"] = !!(ch_stat & user.silicon_radio.FREQ_LISTENING)
			channels[++channels.len] = ch_dat

		data["channels"] = channels

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			ui = new(user, user, id, "pai_radio.tmpl", "Radio Configuration", 300, 150)
			ui.set_initial_data(data)
			ui.open()

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		P.silicon_radio.Topic(href, href_list)
		return 1

/datum/pai_software/crew_manifest
	name = "Crew Manifest"
	ram_cost = 5
	id = "manifest"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]
		// This is dumb, but NanoUI breaks if it has no data to send
		data["crew_manifest"] = html_crew_manifest()

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "crew_manifest.tmpl", "Crew Manifest", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/datum/pai_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		data["cable"] = user.cable != null
		data["machine"] = user.cable && (user.cable.machine != null)
		data["inprogress"] = user.hackdoor != null
		data["progress_a"] = round(user.hackprogress / 10)
		data["progress_b"] = user.hackprogress % 10
		data["aborted"] = user.hack_aborted

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_doorjack.tmpl", "Door Jack", 300, 150)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/pai/P = usr
		if(!istype(P)) return

		if(href_list["jack"])
			if(P.cable && P.cable.machine)
				P.hackdoor = P.cable.machine
				P.hackloop()
			return 1
		else if(href_list["cancel"])
			P.hackdoor = null
			return 1
		else if(href_list["cable"])
			var/turf/T = get_turf_or_move(P.loc)
			P.hack_aborted = 0
			P.cable = new /obj/item/weapon/pai_cable(T)
			for(var/mob/M in viewers(T))
				M.show_message("<span class='warning'>A port on [P] opens to reveal [P.cable], which promptly falls to the floor.</span>", 3,
				               "<span class='warning'>You hear the soft click of something light and hard falling to the ground.</span>", 2)
			return 1

/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf_or_move(src.loc)
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		if(T.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")
	var/obj/machinery/door/D = cable.machine
	if(!istype(D))
		hack_aborted = 1
		hackprogress = 0
		cable.machine = null
		hackdoor = null
		return
	while(hackprogress < 1000)
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress = min(hackprogress+rand(1, 20), 1000)
		else
			hack_aborted = 1
			hackprogress = 0
			hackdoor = null
			return
		if(hackprogress >= 1000)
			hackprogress = 0
			D.open()
			cable.machine = null
			return
		sleep(10)			// Update every second

/datum/pai_software/atmosphere_sensor
	name = "Atmosphere Sensor"
	ram_cost = 5
	id = "atmos_sense"
	toggle = 0

	on_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		var/turf/T = get_turf_or_move(user.loc)
		if(!T)
			data["reading"] = 0
			data["pressure"] = 0
			data["temperature"] = 0
			data["temperatureC"] = 0
			data["gas"] = list()
		else
			var/datum/gas_mixture/env = T.return_air()
			data["reading"] = 1
			var/pres = env.return_pressure() * 10
			data["pressure"] = "[round(pres/10)].[pres%10]"
			data["temperature"] = round(env.temperature)
			data["temperatureC"] = round(env.temperature-T0C)

			var/t_moles = env.total_moles
			var/gases[0]
			for(var/g in env.gas)
				var/gas[0]
				gas["name"] = gas_data.name[g]
				gas["percent"] = round((env.gas[g] / t_moles) * 100)
				gases[++gases.len] = gas
			data["gas"] = gases

		ui = SSnano.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_atmosphere.tmpl", "Atmosphere Sensor", 350, 300)
			ui.set_initial_data(data)
			ui.open()

/datum/pai_software/sec_hud
	name = "Security HUD"
	ram_cost = 20
	id = "sec_hud"

	toggle(mob/living/silicon/pai/user)
		user.secHUD = !user.secHUD

	is_active(mob/living/silicon/pai/user)
		return user.secHUD

/datum/pai_software/med_hud
	name = "Medical HUD"
	ram_cost = 20
	id = "med_hud"

	toggle(mob/living/silicon/pai/user)
		user.medHUD = !user.medHUD

	is_active(mob/living/silicon/pai/user)
		return user.medHUD

/datum/pai_software/translator
	name = "Universal Translator"
	ram_cost = 35
	id = "translator"
	var/list/languages = list(LANGUAGE_SPACER, LANGUAGE_GUTTER, LANGUAGE_UNATHI_SINTA, LANGUAGE_SKRELLIAN, LANGUAGE_EAL, LANGUAGE_HUMAN_ARABIC, LANGUAGE_HUMAN_CHINESE, LANGUAGE_HUMAN_IBERIAN, LANGUAGE_HUMAN_INDIAN, LANGUAGE_HUMAN_RUSSIAN, LANGUAGE_HUMAN_SELENIAN)

	toggle(mob/living/silicon/pai/user)
		// 	Sol Common, Tradeband and Gutter are added with New() and are therefore the current default, always active languages
		user.translator_on = !user.translator_on
		if(user.translator_on)
			for(var/language in languages)
				user.add_language(language)
		else
			for(var/language in languages)
				user.remove_language(language)

	is_active(mob/living/silicon/pai/user)
		return user.translator_on
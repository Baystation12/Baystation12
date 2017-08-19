/datum/musical_evidence
	var/non_null_status = 0
	var/flags = 0
	var/five_lengths[5]
	var/three_values[3]
	var/report = ""


/datum/musical_evidence/proc/compare(datum/musical_evidence/other)
	var/equality = 1
	for (var/i = 1 to 5)
		equality &= src.five_lengths[i] == other.five_lengths[i]
	for (var/i = 1 to 3)
		equality &= src.three_values[i] == other.three_values[i]

	return (equality && src.non_null_status == other.non_null_status && src.flags == other.flags && src.report == other.report)


/datum/musical_debug
	var/datum/synthesized_song/source
	var/datum/musical_evidence/last_state = ""
	var/additional_messages = ""
	var/recording = 1

	var/list/datum/musical_evidence/evidence = list()


/datum/musical_debug/New(datum/musical_debug/source)
	src.source = source
	if (GLOB.musical_config.debug_active) src.record_state()


/datum/musical_debug/proc/obtain_state()
	var/datum/musical_evidence/data = new
	#define SANITY_CHECK(allow_flag, variable, true_result) !(data.non_null_status & allow_flag) && isnull(variable) ? true_result : 0
	data.non_null_status |= SANITY_CHECK(0, source, 1<<0) // isnull(source) ? 1<<0 : 0
	data.non_null_status |= SANITY_CHECK(1<<0, source.player, 1<<1) // isnull(source.player) ? 1<<1 : 0
	data.non_null_status |= SANITY_CHECK(0, source.instrument_data, 1<<2) // isnull(source.instrument_data) ? 1<<2 : 0
	data.non_null_status |= SANITY_CHECK(1<<1, source.player.song, 1<<3) // isnull(source.player.song) ? 1<<3 : 0
	data.non_null_status |= SANITY_CHECK(1<<1, source.player.instrument, 1<<4) // isnull(source.player.instrument) ? 1<<4 : 0
	data.non_null_status |= SANITY_CHECK(1<<1, source.player.actual_instrument, 1<<5) // isnull(source.player.actual_instrument) ? 1<<5 : 0
	if (!(data.non_null_status & 1<<1) && source.player.actual_instrument && istype(source.player.actual_instrument, /obj/item/device/synthesized_instrument) || istype(source.player.actual_instrument, /obj/structure/synthesized_instrument))
		data.non_null_status |= 1<<6
	data.non_null_status |= SANITY_CHECK(1<<1, source.player.event_manager, 1<<7) // isnull(source.player.event_manager) ? 1<<7 : 0
	#undef SANITY_CHECK

	data.five_lengths[1] = source.lines.len
	data.five_lengths[2] = source.free_channels.len
	data.five_lengths[3] = source.player.event_manager.events.len
	data.five_lengths[4] = source.player.present_listeners.len
	data.five_lengths[5] = source.player.stored_locations.len

	data.three_values[1] = source.tempo
	data.three_values[2] = source.sustain_timer
	data.three_values[3] = source.soft_coeff

	data.flags |= source.linear_decay ? 1<<0 : 0
	data.flags |= source.player.event_manager.active ? 1<<1 : 0
	data.flags |= source.player.event_manager.suspended ? 1<<2 : 0
	data.flags |= source.player.event_manager.kill_loop ? 1<<3 : 0
	data.flags |= source.playing ? 1<<4 : 0
	data.flags |= source.autorepeat ? 1<<5 : 0

	data.report = src.additional_messages
	return data


/datum/musical_debug/proc/record_state()
	set background = 1
	spawn while (1)
		sleep(world.tick_lag)
		if (src.recording)
			var/datum/musical_evidence/data = src.obtain_state()
			src.additional_messages = ""
			if (src.last_state && data && data.compare(src.last_state))
				continue
			if (src.evidence.len > GLOB.musical_config.debug_max_reports - 1)
				src.evidence.Cut(1, evidence.len - GLOB.musical_config.debug_max_reports + 2)
			src.evidence[num2text(world.time)] += data
			src.last_state = data


/datum/musical_debug/proc/access_panel(mob/living/caller)
	message_admins("[caller] has just accessed debug panel of musical instruments.")
	src.show_panel(caller)


/datum/musical_debug/proc/show_panel(mob/living/caller)
	set background = 1
	var/dat = ""
	#define STATUS_CHAR(name) (name ? "+" : "-")
	for (var/trace in src.evidence)
		var/datum/musical_evidence/evidence = src.evidence[trace]
		var/flags_ok = !evidence.flags == 0
		var/sustain_sane = evidence.three_values[2] >= 1 && evidence.three_values[2] <= GLOB.musical_config.longest_sustain_timer
		sustain_sane &= evidence.three_values[3] >= GLOB.musical_config.gentlest_drop && evidence.three_values[3] <= GLOB.musical_config.steepest_drop
		var/capacity_ok = evidence.five_lengths[2] > 0 && evidence.five_lengths[3] <= GLOB.musical_config.max_events
		var/null_ok = !evidence.non_null_status
		var/report_non_empty = evidence.report

		var/dat_line = ""
		dat_line += "<a href='?src=\ref[src];output_event=[trace]'>@ tick [trace]: "
		dat_line += STATUS_CHAR(flags_ok)
		dat_line += STATUS_CHAR(sustain_sane)
		dat_line += STATUS_CHAR(capacity_ok)
		dat_line += STATUS_CHAR(null_ok)
		dat_line += STATUS_CHAR(evidence.report)
		dat_line += (report_non_empty ? "!" : "")
		dat_line += "</a><br>"
		dat = dat_line + dat

	#undef STATUS_CHAR
	dat = "<a href='?src=\ref[src];toggle_recording=1'>Toggle recording</a><br>" + dat
	dat = "<a href='?src=\ref[src];refresh=1'>Refresh</a><br>" + dat
	var/datum/browser/popup = new(caller, "debug_musical", "Debug Musical", 700, 500)
	popup.set_content(dat)
	popup.open()


/datum/musical_debug/proc/append_message(msg)
	src.additional_messages += msg + "<br>"


/datum/musical_debug/Topic(href, href_list)
	if (href_list["output_event"])
		var/key = href_list["output_event"]
		if (key in src.evidence)
			var/datum/musical_evidence/E = src.evidence[key]
			usr << key
			usr << E.flags
			usr << E.non_null_status
			for (var/i = 1 to 5)
				usr << E.five_lengths[i]
			for (var/i = 1 to 3)
				usr << E.three_values[i]
			if (E.report) usr << E.report
		else
			usr << "No longer accessible"
	if (href_list["toggle_recording"])
		src.recording = !src.recording
		usr << "[!src.recording ? "not" : ""] recording"
	if (href_list["refresh"])
		src.show_panel(usr)
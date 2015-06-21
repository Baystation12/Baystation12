/datum/game_mode/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "Some crewmembers are attempting to start a revolution!"
	extended_round_description = "Revolutionaries - Kill the Captain, HoP, HoS, CE, RD and CMO. Convert other crewmembers (excluding the heads of staff, and security officers) to your cause by flashing them. Protect your leaders.<BR>\nPersonnel - Protect the heads of staff. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head)."
	required_players = 4
	required_players_secret = 15
	required_enemies = 3
	auto_recall_shuttle = 1
	end_on_antag_death = 1
	shuttle_delay = 3
	antag_tag = MODE_REVOLUTIONARY

/datum/game_mode/revolution/New()
	if(config && config.rp_rev)
		extended_round_description = "Revolutionaries - Remove the heads of staff from power. Convert other crewmembers to your cause using the 'Convert Bourgeoise' verb. Protect your leaders."

/datum/game_mode/revolution/send_intercept()

	..()

	if(config.announce_revheads)
		spawn(54000)
			var/intercepttext = ""
			command_announcement.Announce("Summary downloaded and printed out at all communications consoles.", "Local agitators have been determined.")
			intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Requested status information:</FONT><HR>"
			intercepttext += "We have determined several members of your staff to be political activists. They are:"
			for(var/datum/mind/revmind in revs.head_revolutionaries)
				intercepttext += "<br>[revmind.current.real_name]"
			intercepttext += "<br>Please arrest them at once."
			for (var/obj/machinery/computer/communications/comm in world)
				if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
					var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
					intercept.name = "Cent. Com. Status Summary"
					intercept.info = intercepttext
					comm.messagetitle.Add("Cent. Com. Status Summary")
					comm.messagetext.Add(intercepttext)
			spawn(12000)
				command_announcement.Announce("Repeating the previous message over intercoms due to urgency. The station has political agitators onboard by the names of [reveal_rev_heads()], please arrest them at once.", "Local agitators have been determined.")

/datum/game_mode/revolution/proc/reveal_rev_heads()
	. = ""
	for(var/i = 1, i <= revs.head_revolutionaries.len,i++)
		var/datum/mind/revmind = revs.head_revolutionaries[i]
		if(i < revs.head_revolutionaries.len)
			. += "[revmind.current.real_name],"
		else
			. += "and [revmind.current.real_name]"
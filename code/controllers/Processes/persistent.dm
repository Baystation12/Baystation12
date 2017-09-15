var/paychecks = 0

/datum/controller/process/persistent
	var/paycheckticks = 0
	var/obj/machinery/message_server/linkedServer = null

/datum/controller/process/persistent/setup()
	name = "persistent"
	schedule_interval = 60 SECONDS // every minute.

	spawn(300)
		if(!linkedServer)
			if(message_servers && message_servers.len > 0)
				linkedServer = message_servers[1]

/datum/controller/process/persistent/doWork()
//	var/datum/category_item/player_setup_item/general/persistent/PERSISTENT = new()
	for(var/client/C in GLOB.clients)
		if(C.inactivity/10 > 120) // 2 minutes AFK or more we begin counting.
			var/timeafk = round(C.inactivity/3, 1) // Take 1/3rd of the total AFK time.
			if(timeafk > 1000)
				continue // Too much AFKing, we quit.
			var/playtimeseconds = round(60-(timeafk/10), 1) // Divide by 10 to get seconds.
			C.prefs.department_playtime += playtimeseconds
			if(!C.prefs.promoted && calculate_department_rank(C.mob) <= 3)
				C.prefs.dept_experience += playtimeseconds
		else
			C.prefs.department_playtime += 60
			C.prefs.dept_experience += 60

		if(C.mob && ticks % 5) // Calculate once every 5 minutes
			calculate_department_rank(C.mob) //Checks time played and sets rank accordingly.
		C.prefs.save_character(1)

	paycheckticks++
	if(paycheckticks >= 120) // 120 ticks = an hour.
		paycheckticks = 0
		paychecks++
		command_announcement.Announce("Paychecks have been processed for crew of [station_name()].", "[GLOB.using_map.boss_name]")
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.stat != 2) // Not fucking dead either, and must be working for NT.
				var/paycheck = calculate_paycheck(M, add = 1, paychecks = paychecks)
				if(paycheck)
					var/totalpercentage = 14+(M.client.prefs.permadeath ? 12 : 4)
					var/totalpaycheck = (paycheck / 100 * totalpercentage) + paycheck
					world << "Total Percentage: [totalpercentage], Total paycheck = [totalpaycheck]"
					var/sender = "NanoTrasen Financial Department"
					var/message = {"
						<b>!WARNING: CONFIDENTIAL!</b>\n
						--------------------\n
						Employee Name: [M.name] <br>Employee Assignment: [M.job]\n
						Total work time: [M.client.prefs.department_playtime]\n
						Current Department Rank: [get_department_rank_title(M.client.prefs.char_department, calculate_department_rank(M))]\n
						--------------------\n
						Total Paycheck: $[totalpaycheck]\n
						<b>Taxes:</b>\n
						Income Tax: $-[totalpaycheck / 100 * 14] (14%)\n
						Pension Tax: $-[totalpaycheck / 100 * (M.client.prefs.permadeath ? 12 : 4)] ([M.client.prefs.permadeath ? 12 : 4]%)\n
						Net Income: $[paycheck]\n
						"}
					SendPDAMessage(M, sender, message)

/datum/controller/process/persistent/proc/SendPDAMessage(var/mob/living/carbon/M, var/sender, var/message)
	var/obj/item/device/pda/PDARec = null
	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner || P.toff || P.hidden)	continue
		if(P.owner == M.real_name)
			PDARec = P
			//Sender isn't faking as someone who exists
			if(!isnull(PDARec))
				linkedServer.send_pda_message("[P.owner]", "NT Financial Dept","[message]")
				P.new_message("NT Financial Dept", "NT Financial Dept", "NanoTrasen", message)
				P.tnote.Add(list(list("sent" = 0, "owner" = "NanoTrasen", "job" = "NT Financial Dept", "message" = "[message]", "target" = "\ref[src]")))
				if (!P.message_silent)
					playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)

/*
	for(var/obj/item/device/pda/P in PDAs)
		if(P.owner == M.real_name) //If we can find his/her PDA..
			var/datum/reception/reception = get_reception(sender, P, message)
			message = reception.message
			var/send_result = reception.message_server.send_pda_message("[P.owner]","NT Financial Dept","[message]")
			if(P || send_result)
				if (!P.message_silent)
					playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
					for (var/mob/O in hearers(3, P.loc))
						if(!P.message_silent) O.show_message(text("\icon[P] *[P.ttone]*"))

						to_chat(M, "\icon[P] <b>Message from [sender]</b> (Unable to Reply)")
		else //Otherwise try method 2.
			P = locate(M.contents)
			if(P)
				var/datum/reception/reception = get_reception(sender, P, message)
				message = reception.message
				var/send_result = reception.message_server.send_pda_message("[P.owner]","NT Financial Dept","[message]")
				if(P || send_result)
*/

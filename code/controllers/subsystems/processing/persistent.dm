var/global/paychecks = 0
SUBSYSTEM_DEF(persistent)
	name = "Persistent"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 60 SECONDS

	var/paycheckticks = 0
	var/obj/machinery/message_server/linkedServer = null

/datum/controller/subsystem/persistent/Initialize(timeofday)
	spawn(200)
		if(!linkedServer)
			if(GLOB.message_servers.len)
				linkedServer = GLOB.message_servers[1]
	..()

/datum/controller/subsystem/persistent/fire(resumed = 0)
//	var/datum/category_item/player_setup_item/general/persistent/PERSISTENT = new()
	for(var/client/C in GLOB.clients)
		var/mob/living/carbon/human/H = C.mob
		if(!H || !ishuman(H) || !H.CharRecords)	continue
		if(C.inactivity/10 > 120) // 2 minutes AFK or more we begin counting.
			var/timeafk = round(C.inactivity/3, 1) // Take 1/3rd of the total AFK time.
			if(timeafk > 1000)
				continue // Too much AFKing, we quit.
			var/playtimeseconds = round(60-(timeafk/10), 1) // Divide by 10 to get seconds.
			H.CharRecords.department_playtime += playtimeseconds
			if(!H.CharRecords.promoted && calculate_department_rank(H) <= 3)
				H.CharRecords.department_experience += playtimeseconds
		else
			H.CharRecords.department_playtime += 60
			H.CharRecords.department_experience += 60

		if(H && ticks % 3) // Calculate once every 3 minutes
			calculate_department_rank(H) //Checks time played and sets rank accordingly.
		H.CharRecords.save_persistent()

	paycheckticks++
	if(paycheckticks >= 120) // 120 ticks = an hour.
		paycheckticks = 0
		paychecks++
		command_announcement.Announce("Paychecks have been processed for crew of [station_name()].", "[GLOB.using_map.boss_name]")
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.stat != 2) // Not fucking dead either, and must be working for NT.
				var/paycheck = calculate_paycheck(M)
				if(paycheck)
					var/sender = "NanoTrasen Financial Department"
					var/message = {"
						<b>!WARNING: CONFIDENTIAL!</b>\n
						--------------------\n
						Employee Name: [M.name] <br>Employee Assignment: [M.job]\n
						Total work time: [M.CharRecords.department_playtime]\n
						Current Department Rank: [get_department_rank_title(get_department(M.CharRecords.char_department, 1), calculate_department_rank(M))]\n
						--------------------\n
						Gross Paycheck: $[paycheck]\n
						<b>Taxes:</b>\n
						Income Tax: $-[get_tax_deduction("income", paycheck)] (20%)\n
						Pension Tax: $-[get_tax_deduction("pension:", paycheck, M.CharRecords.permadeath ? 1 : 0)] ([M.CharRecords.permadeath ? 16 : 10]%)\n
						Net Income: $[send_paycheck(M, paycheck)]\n
						"}
					SendPDAMessage(M, sender, message)


/datum/controller/subsystem/persistent/proc/SendPDAMessage(var/mob/living/carbon/M, var/sender, var/message)
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
/*
var/const/ENG               =(1<<0)
var/const/SEC               =(1<<1)
var/const/MED               =(1<<2)
var/const/SCI               =(1<<3)
var/const/CIV               =(1<<4)
var/const/COM               =(1<<5)
var/const/MSC               =(1<<6)
var/const/SRV               =(1<<7)
var/const/SUP               =(1<<8)
var/const/SPT               =(1<<9)
var/const/EXP               =(1<<10)

*/
GLOBAL_LIST_EMPTY(assistant_occupations)

GLOBAL_LIST_EMPTY(command_positions)

GLOBAL_LIST_EMPTY(engineering_positions)

GLOBAL_LIST_EMPTY(medical_positions)

GLOBAL_LIST_EMPTY(science_positions)

GLOBAL_LIST_EMPTY(civilian_positions)

GLOBAL_LIST_EMPTY(security_positions)

GLOBAL_LIST_INIT(nonhuman_positions, list("pAI"))

GLOBAL_LIST_EMPTY(service_positions)

GLOBAL_LIST_EMPTY(supply_positions)

GLOBAL_LIST_EMPTY(support_positions)

GLOBAL_LIST_EMPTY(exploration_positions)

GLOBAL_LIST_EMPTY(unsorted_positions) // for nano manifest


/proc/guest_jobbans(var/job)
	return (job in GLOB.command_positions)

/proc/get_job_datums()
	. = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		. += job

	return .

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	. = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			. = J.alt_titles

	return .

/proc/calculate_department_rank(var/mob/living/carbon/human/M)
	if(istype(M, /mob/living/carbon/human))
		if(M && M.client && M.CharRecords && M.job)
			var/oldrank = M.CharRecords.department_rank
			var/playtime = round(M.CharRecords.department_experience/3600, 0.1) // In hours.
			switch(playtime)
				if(0 to 4)
					M.CharRecords.department_rank = 1 //Intern--Lvl 1
				if(5 to 9)
					M.CharRecords.department_rank = 2 //Junior
				if(10 to 16)
					M.CharRecords.department_rank = 3 //Regular
				if(17 to 25)
					if(M.CharRecords.promoted == 1) //Promoted from Regular to Senior-capable.
						M.CharRecords.department_rank = 4 //Senior
						if(!M.CharRecords.promoted) //Not reached Senior yet.
							M.CharRecords.promoted = 1
							M.CharRecords.add_employeerecord("NanoTrasen", "Reaching Seniority Status within the company", 7, 0, 0, 500, 1)
				if(26 to 1000) // Yeah it stops here.
					if(M.CharRecords.promoted == 1)
						M.CharRecords.department_rank = 5 //Lead

/*					if(M.CharRecords.promoted == 1)
						M.CharRecords.department_rank = 5 //Lead
						if(M.CharRecords.recommendations.len)
							for(var/N in M.CharRecords.recommendations)
								if(N && N:name != "NanoTrasen") //If it hasn't been done yet, do so now.
									M.CharRecords.recommendations.Add(name = "NanoTrasen", recommendation = "Reaching seniority status within the company")
						else

							M.CharRecords.recommendations.Add(name = "NanoTrasen", recommendation = "Reaching seniority status within the company")
*/
			if(M.CharRecords.department_rank != oldrank) //Ranks changed)
				if(M.CharRecords.department_rank > oldrank)
					SendNTPDAMessage(M, "NT Administration", {"You have recieved a promotion. You are now a [get_department_rank_title(get_department(M.CharRecords.char_department, 1), M.CharRecords.department_rank)] [M.job]."})
					for(var/obj/item/weapon/card/id/id_card in M.contents)
						if(id_card.registered_name == M.real_name) //Extra verification
							M:set_id_info(id_card)
			return M.CharRecords.department_rank
	return 1


/proc/get_department_rank_title(var/department, var/rank, var/ishead = 0)
	if(department && rank)
		if(department == "Command" || ishead)
			if(rank == 4)
				return "Senior"
			else
				return
		switch(rank)
			if(0 to 1) //Intern
				switch(department)
					if("Civilian")
						return "Assistant"
					if("Security")
						return "Cadet"
					if("Medical")
						return "Assistant"
					if("Engineering")
						return "Assistant"
					else
						return "Intern"
			if(2) //Junior
				return "Junior"
			if(3) //Regular
				return null // No rank.
			if(4) //Senior
				return "Senior"
			if(5) //Lead
				switch(department)
					if("Civilian")
						return "Expert" //Different name because Lead is weird for civvies.
					else return "Lead"

/proc/SendNTPDAMessage(var/mob/living/carbon/M, var/sender, var/message)
	var/obj/item/device/pda/PDARec = null
	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner || P.toff || P.hidden)	continue
		if(P.owner == M.real_name)
			PDARec = P
			//Sender isn't faking as someone who exists
			if(!isnull(PDARec))
				var/obj/machinery/message_server/linkedServer
				if(GLOB.message_servers && GLOB.message_servers.len > 0)
					linkedServer = GLOB.message_servers[1]
				linkedServer.send_pda_message("[P.owner]", "[sender]","[message]")
				P.new_message("[sender]", "[sender]", "NanoTrasen", message)
				P.tnote.Add(list(list("sent" = 0, "owner" = "NanoTrasen", "job" = "[sender]", "message" = "[message]", "target" = "\ref[src]")))
				if (!P.message_silent)
					playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
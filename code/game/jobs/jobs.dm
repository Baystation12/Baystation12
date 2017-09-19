var/const/ENG               =(1<<0)
var/const/SEC               =(1<<1)
var/const/MED               =(1<<2)
var/const/SCI               =(1<<3)
var/const/CIV               =(1<<4)
var/const/COM               =(1<<5)
var/const/CRG               =(1<<6)
var/const/MSC               =(1<<7)
var/const/SRV               =(1<<8)
var/const/SUP               =(1<<9)
var/const/SPT               =(1<<10)

var/list/assistant_occupations = list(
)

var/list/command_positions = list(
)

var/list/engineering_positions = list(
)

var/list/medical_positions = list(
)

var/list/science_positions = list(
)

var/list/cargo_positions = list(
)

var/list/civilian_positions = list(
)


var/list/security_positions = list(
)

var/list/nonhuman_positions = list(
	"pAI"
)

var/list/service_positions = list(
)

var/list/supply_positions = list(
)

var/list/support_positions = list(
)


/proc/guest_jobbans(var/job)
	return (job in command_positions)

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles

/proc/calculate_department_rank(var/mob/living/carbon/human/M)
	if(istype(M, /mob/living/carbon/human))
		if(M && M.client && M.client.prefs && M.job)
			var/oldrank = M.client.prefs.department_rank
			var/playtime = round(M.client.prefs.dept_experience/3600, 0.1) // In hours.
			switch(playtime)
				if(0 to 4)
					M.client.prefs.department_rank = 1 //Intern--Lvl 1
				if(5 to 9)
					M.client.prefs.department_rank = 2 //Junior
				if(10 to 16)
					M.client.prefs.department_rank = 3 //Regular
				if(17 to 25)
					if(M.client.prefs.promoted == 1) //Promoted from Regular to Senior-capable.
						M.client.prefs.department_rank = 4 //Senior
				if(26 to 1000) // Yeah it stops here.
					if(M.client.prefs.promoted == 1)
						M.client.prefs.department_rank = 5 //Lead
						if(M.client.prefs.recommendations.len)
							for(var/N in M.client.prefs.recommendations)
								if(N && N:name != "NanoTrasen") //If it hasn't been done yet, do so now.
									M.client.prefs.recommendations.Add(name = "NanoTrasen", recommendation = "Reaching seniority status within the company")
						else
							M.client.prefs.recommendations.Add(name = "NanoTrasen", recommendation = "Reaching seniority status within the company")
			if(M.client.prefs.department_rank != oldrank) //Ranks changed)
				if(M.client.prefs.department_rank > oldrank)
					SendNTPDAMessage(M, "NT Administration", {"You have recieved a promotion for being with the company for a long time!
					You are now a [get_department_rank_title(M)] [M.job]."})
			return M.client.prefs.department_rank
	return 1


/proc/get_department_rank_title(var/department, var/rank, var/ishead = 0)
	if(department && rank)
		if(ishead)
			if(rank == 4)
				return "Senior"
			else
				return null
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

/mob/verb/ForcePaycheck()
	set name = "Force to get paid"

	calculate_paycheck(src, add = 1)

/proc/calculate_paycheck(var/mob/living/carbon/human/M, var/tax = 1, var/add = 0, var/roundend = 0) //Tax = if we should calculate taxes, add if we want to add the cash.
	if(M && istype(M) && M.client && M.client.prefs.char_department && M.job) //SO MANY CHECKS JEZUS ah well
		var/datum/job/job = job_master.GetJob(M.job)
		var/efficiencybonus = 4+(4*paychecks)
		var/rankbonus = job.base_pay/100*(100+(calculate_department_rank(M)*5))
		var/paycheck = round(rankbonus + (job.base_pay/100*efficiencybonus) * 4, 0.01)
		if(evacuation_controller.emergency_evacuation)
			paycheck = paycheck/100*80
		if(roundend)
			var/mins = round((round_duration_in_ticks % 36000) / 600)
			var/deduct = (paycheck/60)*(60 % mins)
			paycheck -= deduct
		// Paycheck  = base_pay (per job) * (department rank * increase percentage) * 4 (4 'working hours' per paycheck)
		if(tax)
			var/incometax = (paycheck / 100) * 14 //14%
			var/pensiontax
			if(M.client.prefs.permadeath == 1)
				pensiontax = (paycheck / 100) * 12
			else
				pensiontax = (paycheck / 100) * 41
			paycheck -= (incometax+pensiontax)
			paycheck = round(paycheck, 0.01)
			if(add)
				M.client.prefs.pension_balance += pensiontax
				M.client.prefs.bank_balance += paycheck
		return paycheck

/proc/SendNTPDAMessage(var/mob/living/carbon/M, var/sender, var/message)
	var/obj/item/device/pda/PDARec = null
	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner || P.toff || P.hidden)	continue
		if(P.owner == M.real_name)
			PDARec = P
			//Sender isn't faking as someone who exists
			if(!isnull(PDARec))
				var/obj/machinery/message_server/linkedServer
				if(message_servers && message_servers.len > 0)
					linkedServer = message_servers[1]
				linkedServer.send_pda_message("[P.owner]", "[sender]","[message]")
				P.new_message("[sender]", "[sender]", "NanoTrasen", message)
				P.tnote.Add(list(list("sent" = 0, "owner" = "NanoTrasen", "job" = "[sender]", "message" = "[message]", "target" = "\ref[src]")))
				if (!P.message_silent)
					playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
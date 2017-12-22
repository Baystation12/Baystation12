var/global/savefile/DeptRequests = new("data/ntrequests.sav")
var/global/list/pendingdeptrequests = list()

/datum/ntrequest
	var/requestid
	var/requesttype = "" //Demotion, Promotion, Raise pay, Cut pay, bonus and Record.
	var/requesttext = ""
	var/fromchar
	var/tochar
	var/ckey
	var/real_name
	var/score = 0 //Added to make sure score is saved.

/datum/ntrequest/New()
	requestid = rand(0, 1000) //Basically 1000 requests per time.

/datum/ntrequest/proc/make_request(var/obj/machinery/computer/department_manager/DM, var/requesttype2, var/mob/living/carbon/human/fchar, var/mob/living/carbon/human/tchar, var/requesttext2, var/score2)
	if(!DM)	return 0 //No can do.
	for(var/datum/ntrequest/Request in pendingdeptrequests)
		if(Request.requesttype == requesttype && requesttype == "promotion" || requesttype == "demotion" || requesttype == "bonus")
			return to_chat(usr, "Similar request already found in database, please await answer.")
		if(Request.requestid == requestid) //Also no duplicate IDs, just to be safe.
			requestid = rand(0, 1000) //So we reset and hope.
	//This is needed to properly register the variables, or so I found out after a painfully long period of debugging..
	fromchar = "[get_department_rank_title(get_department(fchar.CharRecords.char_department, 1), fchar.CharRecords.department_rank)] [fchar.job] [fchar.real_name]"
	tochar = "[get_department_rank_title(get_department(tchar.CharRecords.char_department, 1), tchar.CharRecords.department_rank)] [tchar.job] [tchar.real_name]"
	ckey = tchar.ckey
	real_name = tchar.real_name
	requesttext = requesttext2
	requesttype = requesttype2
	score = score2
	world << "ADDED: [DM], [requesttype2], [fchar], [tchar], [requesttext2]"
	pendingdeptrequests.Add(src) // "REQUEST|[requesttype], Sent by [fromchar:job] [fromchar:real_name], Sent to [tochar:job] [tochar:real_name] For [requesttext]"
	DM.save_requests()

/obj/machinery/computer/department_manager/proc/save_requests()
	if(!pendingdeptrequests)	pendingdeptrequests = list()
	DeptRequests["pendinglist"] << pendingdeptrequests
	return 1

/obj/machinery/computer/department_manager/proc/load_requests()
	var/newrequests = list()
	DeptRequests["pendinglist"] >> newrequests
	if(!pendingdeptrequests) //If list exsists, we carefully add it to prevent memory issues
		pendingdeptrequests = list()
	else
		pendingdeptrequests |= newrequests
	return 1
/obj/machinery/computer/department_manager
	var/savefile/DeptRequests

/obj/machinery/computer/department_manager/proc/save_requests()
	DeptRequests = new("data/ntrequests.sav")
	DeptRequests["pendinglist"] << pendingrequests

/obj/machinery/computer/department_manager/proc/load_requests()
	if(fexists("data/ntrequests.sav"))
		DeptRequests = new("data/ntrequests.sav")
		DeptRequests["pendinglist"] >> pendingrequests
//		for(var/datum/ntrequest/NTR in DeptRequests.dir)
//			pendingrequests.Add(NTR)
//			CHECK_TICK
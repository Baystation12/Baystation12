/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle console"
	shuttle_tag = "Engineering"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"
	location = 1 //Starts offstation.

/obj/machinery/computer/shuttle_control/engineering/New()
	offsite = locate(/area/shuttle/constructionsite/site)
	station = locate(/area/shuttle/constructionsite/station)
	..()
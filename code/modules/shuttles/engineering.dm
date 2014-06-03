/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	shuttle_tag = "Engineering"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"
	location = 1

/obj/machinery/computer/shuttle_control/engineering/New()
	offsite = locate(/area/shuttle/constructionsite/site)
	station = locate(/area/shuttle/constructionsite/station)
	..()
/obj/machinery/computer/shuttle_control/research
	name = "research shuttle console"
	shuttle_tag = "Research"
	req_access = list(access_research)
	circuit = "/obj/item/weapon/circuitboard/research_shuttle"

/obj/machinery/computer/shuttle_control/research/New()
	offsite = locate(/area/shuttle/research/outpost)
	station = locate(/area/shuttle/research/station)
	..()
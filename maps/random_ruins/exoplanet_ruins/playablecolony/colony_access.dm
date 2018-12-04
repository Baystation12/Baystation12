//ID Access//
/var/const/access_colony = 994
/datum/access/colony
	id = access_colony
	desc = "General Colony"
	region = ACCESS_REGION_NONE

/var/const/access_colony_doc = 995
/datum/access/colony_doc
	id = access_colony_doc
	desc = "Colony Medical"
	region = ACCESS_REGION_NONE

/var/const/access_colony_law = 996
/datum/access/colony_law
	id = access_colony_law
	desc = "Colony Guard"
	region = ACCESS_REGION_NONE

/var/const/access_colony_boss = 997
/datum/access/colony_boss
	id = access_colony_boss
	desc = "Colony Overseer"
	region = ACCESS_REGION_NONE

//ID Cards//
/obj/item/weapon/card/id/colony
	access = list(access_colony)

/obj/item/weapon/card/id/colony_doc
	access = list(access_colony, access_colony_doc)

/obj/item/weapon/card/id/colony_law
	access = list(access_colony, access_colony_law)

/obj/item/weapon/card/id/colony_boss
	access = list(access_colony, access_colony_doc, access_colony_law, access_colony_boss)

//Doors//
/obj/machinery/door/airlock/autoname/colony
	req_one_access = null
	req_access = list(access_colony)

/obj/machinery/door/airlock/autoname/engineering/colony
	req_one_access = null
	req_access = list(access_colony)

/obj/machinery/door/airlock/autoname/security/colony
	req_one_access = null
	req_access = list(access_colony_law)

/obj/machinery/door/airlock/autoname/medical/colony
	req_one_access = null
	req_access = list(access_colony_doc)

/obj/machinery/door/airlock/autoname/command/colony
	req_one_access = null
	req_access = list(access_colony_boss)

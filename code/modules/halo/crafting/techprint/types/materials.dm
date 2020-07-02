
/datum/techprint/duridium
	name = "Duridium Ore"
	desc = "Learn how to turn this tough ore into something useful."
	required_objs = list(/obj/item/weapon/ore/duridium = "duridium ore")

/datum/techprint/kemocite
	name = "Kemocite Ore"
	desc = "Learn how to turn this explosive ore into something useful."
	required_objs = list(/obj/item/weapon/ore/kemocite = "kemocite ore")

/datum/techprint/corundum
	name = "Corundum Ore"
	desc = "Learn how to turn this resistant ore into something useful."
	required_objs = list(/obj/item/weapon/ore/corundum = "corundum ore")

/datum/techprint/nanolaminate
	name = "Nanolaminate Alloy"
	desc = "Analyse this alien alloy to learn how to smelt it."
	hidden = TRUE
	required_materials = list("nanolaminate" = 5)
	tech_req_all = list(/datum/techprint/corundum)

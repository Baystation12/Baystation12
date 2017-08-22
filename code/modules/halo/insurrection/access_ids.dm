
/var/const/access_innie = 250
/datum/access/innie
	id = access_innie
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist"

/var/const/access_innie_boss = 251
/datum/access/innie_boss
	id = access_innie_boss
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Leader"

/obj/item/weapon/card/id/insurrectionist
	name = "Insurrection ID card"
	desc = "Someone disingenuously, identifies the holder as a member of the Insurrection."
	assignment = "Insurrectionist"
	access = list(access_innie)


/obj/item/weapon/card/id/insurrectionist
	name = "Insurrection ID card"
	desc = "Someone disingenuously, identifies the holder as a member of the Insurrection."
	assignment = "Insurrectionist"
	access = list(access_innie)

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

/var/const/access_innie_prowler = 252
/datum/access/innie_prowler
	id = access_innie_prowler
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Prowler"

/var/const/access_innie_asteroid = 668
/datum/access/innie_asteroid
	id = access_innie_asteroid
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Asteroid Base"

/var/const/access_innie_asteroid_boss = 667
/datum/access/innie_asteroid_boss
	id = access_innie_asteroid_boss
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Asteroid Base Command"

/var/const/access_innie_ship = 632
/datum/access/innie_ship
	id = access_innie_ship
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Ship"

/var/const/access_innie_ship_boss = 633
/datum/access/innie_ship_boss
	id = access_innie_ship_boss
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Insurrectionist Ship Command"


/var/const/access_soe = 856
/datum/access/soe
	id = access_soe
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Sons of Eridanus"


/var/const/access_soe_officer = 857
/datum/access/soe_officer
	id = access_soe_officer
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Sons of Eridanus Command"

/var/const/access_soe_captain = 858
/datum/access/soe_captain
	id = access_soe_captain
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "Sons of Eridanus Command"

/var/const/access_x52 = 772
/datum/access/x52
	id = access_x52
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "X52 Researcher"

/var/const/access_x52_rd = 773
/datum/access/x52_rd
	id = access_x52_rd
	access_type = ACCESS_TYPE_SYNDICATE
	desc = "X52 Research Director"

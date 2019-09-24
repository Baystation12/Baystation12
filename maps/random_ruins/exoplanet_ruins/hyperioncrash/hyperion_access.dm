/var/const/access_hyperion = "ACCESS_HYPERION" //996
/datum/access/hyperion
	id = access_hyperion
	desc = "IND Explorer"
	region = ACCESS_REGION_NONE

/var/const/access_hyperion_pathfinder = "ACCESS_HYPERION_PATHFINDER" //997
/datum/access/hyperion_pathfinder
	id = access_hyperion_pathfinder
	desc = "IND Expedition Leader"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/hyperion
	access = list(access_hyperion)

/obj/item/weapon/card/id/hyperion_pathfinder
	access = list(access_hyperion, access_hyperion_pathfinder)
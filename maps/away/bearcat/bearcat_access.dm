/var/const/access_bearcat = "ACCESS_BEARCAT" //998
/datum/access/bearcat
	id = access_bearcat
	desc = "FTU Crewman"
	region = ACCESS_REGION_NONE

/var/const/access_bearcat_captain = "ACCESS_BEARCAT_CAPTAIN" //999
/datum/access/bearcat_captain
	id = access_bearcat_captain
	desc = "FTU Captain"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/bearcat
	access = list(access_bearcat)

/obj/item/weapon/card/id/bearcat_captain
	access = list(access_bearcat, access_bearcat_captain)

/obj/machinery/door/airlock/autoname/bearcat

/obj/machinery/door/airlock/autoname/engineering/bearcat

/obj/machinery/door/airlock/autoname/command/bearcat

/obj/structure/closet/secure_closet/engineering_electrical/bearcat
	req_access = list(access_bearcat)

/obj/structure/closet/secure_closet/engineering_welding/bearcat
	req_access = list(access_bearcat)

/obj/structure/closet/secure_closet/freezer/fridge/bearcat
	req_access = list(access_bearcat)

/obj/structure/closet/secure_closet/freezer/meat/bearcat
	req_access = list(access_bearcat)

/obj/machinery/vending/engineering/bearcat
	req_access = list(access_bearcat)

/obj/machinery/vending/tool/bearcat
	req_access = list(access_bearcat)

/obj/machinery/suit_storage_unit/engineering/salvage/bearcat
	req_access = list(access_bearcat)

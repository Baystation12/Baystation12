/decl/hierarchy/mil_uniform
	name = "Master outfit hierarchy"
	hierarchy_type = /decl/hierarchy/mil_uniform
	var/branch = null
	var/departments = 0
	var/min_rank = 0

	var/pt_under = null
	var/pt_shoes = null

	var/utility_under = null
	var/utility_shoes = null
	var/utility_hat = null
	var/utility_extra = null

	var/service_under = null
	var/service_skirt = null
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_skirt = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

/decl/hierarchy/mil_uniform/ec
	name = "Master EC outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/ec
	branch = /datum/mil_branch/expeditionary_corps

	pt_under = /obj/item/clothing/under/solgov/pt/expeditionary
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/soft/solgov/expedition
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition, /obj/item/clothing/head/ushanka/solgov, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov, /obj/item/clothing/shoes/jackboots/unathi)

	service_under = /obj/item/clothing/under/solgov/utility/expeditionary
	service_skirt = /obj/item/clothing/under/solgov/service/expeditionary_skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/soft/solgov/expedition

	dress_under = /obj/item/clothing/under/solgov/mildress/expeditionary
	dress_skirt = /obj/item/clothing/under/solgov/mildress/expeditionary/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/expedition
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/dress/expedition
	dress_gloves = /obj/item/clothing/gloves/white

/decl/hierarchy/mil_uniform/fleet
	name = "Master fleet outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/fleet
	branch = /datum/mil_branch/fleet

	pt_under = /obj/item/clothing/under/solgov/pt/fleet
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/fleet
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/solgov/utility/fleet
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,/obj/item/clothing/head/soft/solgov/fleet)

	service_under = /obj/item/clothing/under/solgov/service/fleet
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt
	service_over = null
	service_shoes = /obj/item/clothing/shoes/dress/white
	service_hat = /obj/item/clothing/head/solgov/dress/fleet

	dress_under = /obj/item/clothing/under/solgov/service/fleet
	dress_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt
	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet
	dress_shoes = /obj/item/clothing/shoes/dress/white
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet
	dress_gloves = /obj/item/clothing/gloves/white

decl/hierarchy/mil_uniform/marine
	name = "Master marine outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/marine
	branch = /datum/mil_branch/marine_corps

	pt_under = /obj/item/clothing/under/solgov/pt/marine
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/marine
	utility_shoes = /obj/item/clothing/shoes/jungleboots
	utility_hat = /obj/item/clothing/head/solgov/utility/marine
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/marine/green, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/marine)

	service_under = /obj/item/clothing/under/solgov/service/marine
	service_skirt = /obj/item/clothing/under/solgov/service/marine/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/marine
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/solgov/service/marine
	service_extra = list(/obj/item/clothing/head/solgov/service/marine/garrison)

	dress_under = /obj/item/clothing/under/solgov/mildress/marine
	dress_skirt = /obj/item/clothing/under/solgov/mildress/marine/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/marine
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/dress/marine
	dress_gloves = /obj/item/clothing/gloves/white

decl/hierarchy/mil_uniform/civilian
	name = "Master civilian outfit"		//Basically just here for the rent-a-tux, ahem, I mean... dress uniform.
	hierarchy_type = /decl/hierarchy/mil_uniform/civilian
	branch = /datum/mil_branch/civilian

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_over = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_extra = list(/obj/item/clothing/accessory/wcoat)


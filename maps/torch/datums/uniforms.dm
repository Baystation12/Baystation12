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
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

/decl/hierarchy/mil_uniform/ec
	name = "Master EC outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/ec
	branch = /datum/mil_branch/expeditionary_corps

	pt_under = /obj/item/clothing/under/pt/expeditionary
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/utility/expeditionary
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/soft/sol/expedition
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition, /obj/item/clothing/head/ushanka/expedition)

	service_under = /obj/item/clothing/under/utility/expeditionary
	service_over = /obj/item/clothing/suit/storage/service/expeditionary
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/soft/sol/expedition

	dress_under = /obj/item/clothing/under/mildress/expeditionary
	dress_over = /obj/item/clothing/suit/dress/expedition
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/dress/expedition
	dress_gloves = /obj/item/clothing/gloves/white

/decl/hierarchy/mil_uniform/fleet
	name = "Master fleet outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/fleet
	branch = /datum/mil_branch/fleet

	pt_under = /obj/item/clothing/under/pt/fleet
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/utility/fleet
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/utility/fleet
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet, /obj/item/clothing/head/ushanka/fleet)

	service_under = /obj/item/clothing/under/service/fleet
	service_over = null
	service_shoes = /obj/item/clothing/shoes/dress/white
	service_hat = /obj/item/clothing/head/dress/fleet

	dress_under = /obj/item/clothing/under/service/fleet
	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet
	dress_shoes = /obj/item/clothing/shoes/dress/white
	dress_hat = /obj/item/clothing/head/dress/fleet
	dress_gloves = /obj/item/clothing/gloves/white

decl/hierarchy/mil_uniform/marine
	name = "Master marine outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/marine
	branch = /datum/mil_branch/marine_corps

	pt_under = /obj/item/clothing/under/pt/marine
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/utility/marine
	utility_shoes = /obj/item/clothing/shoes/jungleboots
	utility_hat = /obj/item/clothing/head/utility/marine
	utility_extra = list(/obj/item/clothing/head/ushanka/marine)

	service_under = /obj/item/clothing/under/service/marine
	service_over = /obj/item/clothing/suit/storage/service/marine
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/service/marine
	service_extra = list(/obj/item/clothing/head/service/marine/garrison)

	dress_under = /obj/item/clothing/under/mildress/marine
	dress_over = /obj/item/clothing/suit/dress/marine
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/dress/marine
	dress_gloves = /obj/item/clothing/gloves/white

decl/hierarchy/mil_uniform/civilian
	name = "Master civilian outfit"		//Basically just here for the rent-a-tux, ahem, I mean... dress uniform.
	hierarchy_type = /decl/hierarchy/mil_uniform/civilian
	branch = /datum/mil_branch/civilian

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_over = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_extra = list(/obj/item/clothing/accessory/wcoat)


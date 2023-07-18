/singleton/hierarchy/mil_uniform
	name = "Master outfit hierarchy"
	hierarchy_type = /singleton/hierarchy/mil_uniform
	var/list/branches = null
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

/singleton/hierarchy/mil_uniform/civilian
	name = "Master civilian outfit"
	hierarchy_type = /singleton/hierarchy/mil_uniform/civilian
	branches = /datum/mil_branch/civilian

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_shoes = list(\
		/obj/item/clothing/shoes/black, /obj/item/clothing/shoes/dress, /obj/item/clothing/shoes/dress/white, \
		/obj/item/clothing/shoes/laceup)
	dress_extra = list(/obj/item/clothing/accessory/waistcoat,\
	/obj/item/clothing/under/skirt_c/dress/black, /obj/item/clothing/under/skirt_c/dress/long/black,\
	/obj/item/clothing/under/skirt_c/dress/eggshell, /obj/item/clothing/under/skirt_c/dress/long/eggshell,\
	/obj/item/clothing/suit/storage/hooded/wintercoat)
/*
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/engineering,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet,
						 /obj/item/clothing/gloves/thick/duty/solgov/eng)
*/

/singleton/hierarchy/mil_uniform/nt
	name = "Master NT outfit"
	hierarchy_type = /singleton/hierarchy/mil_uniform/nt
	branches = /datum/mil_branch/employee

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_shoes = list(\
		/obj/item/clothing/shoes/black, /obj/item/clothing/shoes/dress, /obj/item/clothing/shoes/dress/white, \
		/obj/item/clothing/shoes/laceup)
	dress_extra = list(/obj/item/clothing/accessory/waistcoat,\
	/obj/item/clothing/under/skirt_c/dress/black, /obj/item/clothing/under/skirt_c/dress/long/black,\
	/obj/item/clothing/under/skirt_c/dress/eggshell, /obj/item/clothing/under/skirt_c/dress/long/eggshell)

/singleton/hierarchy/mil_uniform/contract
	name = "Master contract outfit"
	hierarchy_type = /singleton/hierarchy/mil_uniform/contract
	branches = /datum/mil_branch/contractor

	dress_under = /obj/item/clothing/under/rank/internalaffairs/plain
	dress_shoes = list(\
		/obj/item/clothing/shoes/black, /obj/item/clothing/shoes/dress, /obj/item/clothing/shoes/dress/white, \
		/obj/item/clothing/shoes/laceup)
	dress_extra = list(/obj/item/clothing/accessory/waistcoat,\
	/obj/item/clothing/under/skirt_c/dress/black, /obj/item/clothing/under/skirt_c/dress/long/black,\
	/obj/item/clothing/under/skirt_c/dress/eggshell, /obj/item/clothing/under/skirt_c/dress/long/eggshell)

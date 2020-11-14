/decl/hierarchy/mil_uniform
	var/utility_under_urban = null
	var/utility_under_tan = null
	var/utility_hat_urban = null
	var/utility_hat_tan = null

/decl/hierarchy/mil_uniform/marine_corps
	name = "Master marine corps outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/marine_corps
	branches = list(/datum/mil_branch/marine_corps)

	pt_under = /obj/item/clothing/under/solgov/pt/army
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/army
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/solgov/utility/army
	utility_hat_urban = /obj/item/clothing/head/solgov/utility/army/urban
	utility_hat_tan = /obj/item/clothing/head/solgov/utility/army/tan
	utility_extra = list(
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov
	)

	service_under = /obj/item/clothing/under/solgov/service/army
	service_skirt = /obj/item/clothing/under/solgov/service/army/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_under = /obj/item/clothing/under/solgov/mildress/army
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/dress/army
	dress_gloves = /obj/item/clothing/gloves/white

	dress_extra = list(/obj/item/clothing/head/beret/solgov)

/decl/hierarchy/mil_uniform/marine_corps/com //Can only be officers
	name = "Marine Corps command"
	departments = COM

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/command
	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/cmd
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov)

/decl/hierarchy/mil_uniform/marine_corps/com/seniorofficer
	name = "Marine Corps senior command"
	min_rank = 15

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/mil_uniform/marine_corps/eng
	name = "Marine Corps engineering"
	departments = ENG

	utility_under = /obj/item/clothing/under/solgov/utility/army/engineering
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/engineering
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/engineering
	utility_extra = list(
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/eng
	)

/decl/hierarchy/mil_uniform/marine_corps/eng/noncom
	name = "Marine Corps engineering NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/eng/officer
	name = "Marine Corps engineering CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/eng
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/eng/officer/com //Can only be officers
	name = "Marine Corps engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/marine_corps/eng/officer/com/seniorofficer
	name = "Marine Corps engineering senior command"
	min_rank = 15

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/mil_uniform/marine_corps/sec
	name = "Marine Corps security"
	departments = SEC

	utility_under = /obj/item/clothing/under/solgov/utility/army/security
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/security
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/security
	utility_extra = list(
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/sec,
		/obj/item/clothing/under/solgov/utility/army/security)

/decl/hierarchy/mil_uniform/marine_corps/sec/noncom
	name = "Marine Corps security NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison, /obj/item/clothing/head/solgov/service/army/campaign)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/sec/officer
	name = "Marine Corps security CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/sec
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/sec/officer/com //Can only be officers
	name = "Marine Corps security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/marine_corps/sec/officer/com/seniorofficer
	name = "Marine Corps security senior command"
	min_rank = 15

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/mil_uniform/marine_corps/med
	name = "Marine Corps medical"
	departments = MED

	utility_under = /obj/item/clothing/under/solgov/utility/army/medical
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/medical
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/medical
	utility_extra = list(
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/med
	)

/decl/hierarchy/mil_uniform/marine_corps/med/noncom
	name = "Marine Corps medical NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/med/officer
	name = "Marine Corps medical CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/med
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/med/officer/com //Can only be officers
	name = "Marine Corps medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/marine_corps/med/officer/com/seniorofficer
	name = "Marine Corps medical senior command"
	min_rank = 15

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/mil_uniform/marine_corps/sup
	name = "Marine Corps supply"
	departments = SUP

	utility_under = /obj/item/clothing/under/solgov/utility/army/supply
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/supply
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/supply
	utility_extra = list(
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/sup
	)

/decl/hierarchy/mil_uniform/marine_corps/sup/noncom
	name = "Marine Corps supply NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/sup/officer
	name = "Marine Corps supply CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/sup
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/sup/seniorofficer
	name = "Marine Corps supply senior command"
	min_rank = 15

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov
	)

	utility_under = /obj/item/clothing/under/solgov/utility/army/command

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/srv
	name = "Marine Corps service"
	departments = SRV

	utility_under = /obj/item/clothing/under/solgov/utility/army/service
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/service
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/service
	utility_extra = list(
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/svc
	)

/decl/hierarchy/mil_uniform/marine_corps/srv/noncom
	name = "Marine Corps service NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/srv/officer
	name = "Marine Corps service CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/svc
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/exp
	name = "Marine Corps exploration"
	departments = EXP

	utility_under = /obj/item/clothing/under/solgov/utility/army/exploration
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/exploration
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/exploration
	utility_extra = list(
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/exp
	)

/decl/hierarchy/mil_uniform/marine_corps/exp/noncom
	name = "Marine Corps exploration NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/exp/officer
	name = "Marine Corps exploration CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/exp
	)

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/spt
	name = "Marine Corps command support"
	departments = SPT

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/command

/decl/hierarchy/mil_uniform/marine_corps/spt/noncom
	name = "Marine Corps support NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/service/army
	service_over = /obj/item/clothing/suit/storage/solgov/service/army
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison, /obj/item/clothing/head/solgov/service/army/campaign)

	dress_over = /obj/item/clothing/suit/dress/solgov/army
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/marine_corps/spt/officer
	name = "Marine Corps command support CO"
	min_rank = 11

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/cmd
	)

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/command

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/marine_corps/spt/seniorofficer
	name = "Marine Corps senior command support"
	min_rank = 15

	utility_extra = list(
		/obj/item/clothing/under/solgov/utility/army/command,
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/head/ushanka/solgov/army,
		/obj/item/clothing/head/ushanka/solgov/army/green,
		/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
		/obj/item/clothing/head/soft/solgov,
		/obj/item/clothing/gloves/thick/duty/solgov/cmd
	)

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_under_urban = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_under_tan = /obj/item/clothing/under/solgov/utility/army/tan/command

	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command

	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/clothing/head/beret/solgov, /obj/item/weapon/material/sword/replica/officersword/armyofficer)

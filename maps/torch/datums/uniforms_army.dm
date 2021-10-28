/decl/hierarchy/mil_uniform/army/com //Can only be officers
	name = "Army command"
	departments = COM

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/command,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/eng
	name = "Army engineering"
	departments = ENG

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/engineering,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)
	utility_under = /obj/item/clothing/under/solgov/utility/army/engineering

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/engineering

/decl/hierarchy/mil_uniform/army/eng/officer
	name = "Army engineering CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/engineering,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/engineering/command
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/eng/officer/com //Can only be officers
	name = "Army engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/army/sec
	name = "Army security"
	departments = SEC

	utility_under = /obj/item/clothing/under/solgov/utility/army/security
	utility_extra = list(/obj/item/clothing/under/solgov/utility/army/tan/security,
						/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/security

/decl/hierarchy/mil_uniform/army/sec/officer
	name = "Army security CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/security,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/security/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/sec/officer/com //Can only be officers
	name = "Army security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/army/med
	name = "Army medical"
	departments = MED

	utility_under = /obj/item/clothing/under/solgov/utility/army/medical
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/medical,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/medical

/decl/hierarchy/mil_uniform/army/med/officer
	name = "Army medical CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/medical,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_over = /obj/item/clothing/suit/storage/solgov/service/army/medical/command
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/med/officer/com //Can only be officers
	name = "Army medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/army/sup
	name = "Army supply"
	departments = SUP

	utility_under = /obj/item/clothing/under/solgov/utility/army/supply
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/supply,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/supply

/decl/hierarchy/mil_uniform/army/sup/officer
	name = "Army supply CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/supply,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/srv
	name = "Army service"
	departments = SRV

	utility_under = /obj/item/clothing/under/solgov/utility/army/service
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/service,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/service

/decl/hierarchy/mil_uniform/army/srv/officer
	name = "Army service CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/service,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)


	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/exp
	name = "Army exploration"
	departments = EXP

	utility_under = /obj/item/clothing/under/solgov/utility/army/exploration
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/exploration,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/exploration

/decl/hierarchy/mil_uniform/army/exp/officer
	name = "Army exploration CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/exploration,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/spt
	name = "Army command support"
	departments = SPT

	utility_under = /obj/item/clothing/under/solgov/utility/army/command
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/command,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_over = /obj/item/clothing/suit/storage/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/spt/officer
	name = "Army command support CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/tan/command,
						/obj/item/clothing/head/solgov/utility/army/tan,
						/obj/item/clothing/gloves/thick)

	service_under = /obj/item/clothing/under/solgov/service/army/command
	service_skirt = /obj/item/clothing/under/solgov/service/army/command/skirt
	service_hat = /obj/item/clothing/head/solgov/service/army/command
	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_under = /obj/item/clothing/under/solgov/mildress/army/command
	dress_skirt = /obj/item/clothing/under/solgov/mildress/army/command/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/army/command
	dress_hat = /obj/item/clothing/head/solgov/dress/army/command
	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

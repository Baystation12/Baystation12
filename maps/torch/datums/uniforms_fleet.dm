/decl/hierarchy/mil_uniform/fleet/com //Can only be officers
	name = "Fleet command"
	departments = COM

	utility_under = /obj/item/clothing/under/utility/fleet/command
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)

	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/eng
	name = "Fleet engineering"
	departments = ENG

	utility_under = /obj/item/clothing/under/utility/fleet/engineering
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/engineering, /obj/item/clothing/head/ushanka/fleet)

/decl/hierarchy/mil_uniform/fleet/eng/officer
	name = "Fleet engineering CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/eng/officer/com //Can only be officers
	name = "Fleet engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/fleet/sec
	name = "Fleet security"
	departments = SEC

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/security, /obj/item/clothing/head/ushanka/fleet)
	utility_under = /obj/item/clothing/under/utility/fleet/security

/decl/hierarchy/mil_uniform/fleet/sec/officer
	name = "Fleet security CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/sec/officer/com //Can only be officers
	name = "Fleet security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/fleet/med
	name = "Fleet medical"
	departments = MED

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/medical, /obj/item/clothing/head/ushanka/fleet, /obj/item/clothing/head/utility/marine, /obj/item/clothing/under/utility/marine/medical, /obj/item/clothing/shoes/jungleboots)
	utility_under = /obj/item/clothing/under/utility/fleet/medical

/decl/hierarchy/mil_uniform/fleet/med/officer
	name = "Fleet medical CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/med/officer/com //Can only be officers
	name = "Fleet medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/fleet/sup
	name = "Fleet supply"
	departments = SUP

	utility_under = /obj/item/clothing/under/utility/fleet/supply
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/supply, /obj/item/clothing/head/ushanka/fleet)

/decl/hierarchy/mil_uniform/fleet/sup/officer
	name = "Fleet supply CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/srv
	name = "Fleet service"
	departments = SRV

	utility_under = /obj/item/clothing/under/utility/fleet/service
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/service, /obj/item/clothing/head/ushanka/fleet)

/decl/hierarchy/mil_uniform/fleet/srv/officer
	name = "Fleet service CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/srv
	name = "Fleet exploration"
	departments = EXP

	utility_under = /obj/item/clothing/under/utility/fleet/exploration
	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/exploration, /obj/item/clothing/head/ushanka/fleet)

/decl/hierarchy/mil_uniform/fleet/srv/officer
	name = "Fleet exploration CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/spt
	name = "Fleet command support"
	departments = SPT

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	utility_under = /obj/item/clothing/under/utility/fleet/command

	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer)

/decl/hierarchy/mil_uniform/fleet/spt/officer
	name = "Fleet command support CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/fleet/command, /obj/item/clothing/head/ushanka/fleet)
	utility_under = /obj/item/clothing/under/utility/fleet/command

	service_hat = /obj/item/clothing/head/dress/fleet/command

	dress_over = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	dress_hat = /obj/item/clothing/head/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword)
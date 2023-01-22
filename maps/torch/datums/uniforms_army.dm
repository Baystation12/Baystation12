/decl/hierarchy/mil_uniform/army/com //Can only be officers
	name = "Marine command"
	departments = COM

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/command,
						/obj/item/clothing/head/solgov/utility/army/urban,
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

/decl/hierarchy/mil_uniform/army/eng
	name = "Marine engineering"
	departments = ENG

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/engineering,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/engineering,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/engineering,
						/obj/item/clothing/gloves/thick)
	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/engineering


/decl/hierarchy/mil_uniform/army/eng/sword
	name = "Marine NCO sword engineering"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/eng/officer
	name = "Marine engineering CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/engineering,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/engineering/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/engineering/command,
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

/decl/hierarchy/mil_uniform/army/eng/officer/com //Can only be officers
	name = "Marine engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/army/sec
	name = "Marine security"
	departments = SEC

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/security
	utility_extra = list(/obj/item/clothing/under/solgov/utility/army/security,
						/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/suit/storage/solgov/utility/army/security,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/security,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/gloves/thick)

/decl/hierarchy/mil_uniform/army/sec/sword
	name = "Marine NCO sword security"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/sec/officer
	name = "Marine security CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/security,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/security/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/security/command,
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

/decl/hierarchy/mil_uniform/army/sec/officer/com //Can only be officers
	name = "Marine security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/army/med
	name = "Marine medical"
	departments = MED

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/medical
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/medical,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/medical,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/medical,
						/obj/item/clothing/gloves/thick)

/decl/hierarchy/mil_uniform/army/med/sword
	name = "Marine NCO sword medical"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/med/officer
	name = "Marine medical CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/medical,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/medical/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/medical/command,
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

/decl/hierarchy/mil_uniform/army/med/officer/com //Can only be officers
	name = "Marine medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/army/sup
	name = "Marine supply"
	departments = SUP

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/supply
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/supply,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/supply,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/supply,
						/obj/item/clothing/gloves/thick)

/decl/hierarchy/mil_uniform/army/sup/sword
	name = "Marine NCO sword supply"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/sup/officer
	name = "Marine supply CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/supply,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/suit/storage/solgov/utility/army/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/command,
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
	name = "Marine service"
	departments = SRV

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/service
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/service,
						/obj/item/clothing/suit/storage/solgov/utility/army/service,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/service,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/gloves/thick)

/decl/hierarchy/mil_uniform/army/srv/sword
	name = "Marine NCO sword service"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/srv/officer
	name = "Marine service CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/service,
						/obj/item/clothing/head/solgov/utility/army/urban,
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
	name = "Marine exploration"
	departments = EXP

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/exploration
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/exploration,
						/obj/item/clothing/suit/storage/solgov/utility/army/exploration,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/exploration,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/gloves/thick)


/decl/hierarchy/mil_uniform/army/exp/sword
	name = "Marine NCO sword exploration"
	min_rank = 4

	dress_extra = list(/obj/item/material/sword/replica/officersword/army)

/decl/hierarchy/mil_uniform/army/exp/officer
	name = "Marine exploration CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/exploration,
						/obj/item/clothing/head/solgov/utility/army/urban,
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
	name = "Marine command support"
	departments = SPT

	utility_under = /obj/item/clothing/under/solgov/utility/army/urban/command
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/command,
						/obj/item/clothing/suit/storage/solgov/utility/army/navy/command,
						/obj/item/clothing/head/solgov/utility/army/urban,
						/obj/item/clothing/gloves/thick)

	service_extra = list(/obj/item/clothing/head/solgov/service/army/garrison/command)

	dress_extra = list(/obj/item/material/sword/replica/officersword/armyofficer)

/decl/hierarchy/mil_uniform/army/spt/officer
	name = "Marine command support CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/ushanka/solgov/army/green,
						/obj/item/clothing/head/ushanka/solgov/army,
						/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army,
						/obj/item/clothing/under/solgov/utility/army/command,
						/obj/item/clothing/head/solgov/utility/army/urban,
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

// For alternative fleet uniform

/decl/hierarchy/mil_uniform
	var/pt_under_alt = null
	var/pt_shoes_alt = null

	var/utility_under_alt = null
	var/utility_shoes_alt = null
	var/utility_hat_alt = null
	var/utility_extra_alt = null

	var/service_under_alt = null
	var/service_skirt_alt = null
	var/service_over_alt = null
	var/service_shoes_alt = null
	var/service_hat_alt = null
	var/service_gloves_alt = null
	var/service_extra_alt = null

	var/dress_under_alt = null
	var/dress_skirt_alt = null
	var/dress_over_alt = null
	var/dress_shoes_alt = null
	var/dress_hat_alt = null
	var/dress_gloves_alt = null
	var/dress_extra_alt = null

// Expeditionary Fleet (overrides normal fleet)
/decl/hierarchy/mil_uniform/fleet
	name = "Master NTEF outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/fleet
	branches = list(/datum/mil_branch/fleet)

	pt_under = /obj/item/clothing/under/solgov/pt/fleet
	pt_shoes = /obj/item/clothing/shoes/black

	utility_under = /obj/item/clothing/under/solgov/utility/fleet
	utility_shoes = /obj/item/clothing/shoes/dutyboots
	utility_hat = /obj/item/clothing/head/solgov/utility/fleet/ntef
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,/obj/item/clothing/head/soft/solgov/fleet/ntef, /obj/item/clothing/shoes/jackboots/unathi)

	service_under = /obj/item/clothing/under/solgov/service/fleet
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt

	service_shoes = /obj/item/clothing/shoes/dress
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/garrison

	dress_under = /obj/item/clothing/under/solgov/service/fleet
	dress_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt
	dress_over = /obj/item/clothing/suit/dress/solgov/fleet/sailor
	dress_shoes = /obj/item/clothing/shoes/dress
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet
	dress_gloves = /obj/item/clothing/gloves/white

	dress_extra = list(/obj/item/clothing/accessory/solgov/ec_scarf, /obj/item/clothing/accessory/cloak/boh/dress)
	dress_extra_alt = list(/obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/com //Can only be officers
	name = "NTEF command"
	departments = COM

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command
	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/cmd,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/cmd,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/command,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/command)

	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/clothing/accessory/solgov/ec_scarf, /obj/item/clothing/accessory/cloak/boh/dress/command, /obj/item/weapon/material/sword/replica/officersword)

/decl/hierarchy/mil_uniform/fleet/com/seniorofficer
	name = "NTEF senior command"
	min_rank = 15

	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/com/capt //Can only be officers
	name = "NTEF captain"
	min_rank = 16
	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command

/decl/hierarchy/mil_uniform/fleet/com/flagofficer
	name = "NTEF flag command"
	min_rank = 17

	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/com/flagofficer/adm //Can only be officers
	name = "NTEF admiral"
	min_rank = 18

	utility_hat = /obj/item/clothing/head/soft/solgov/expedition/co

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command/adm
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/captain

/decl/hierarchy/mil_uniform/fleet/eng
	name = "NTEF engineering"
	departments = ENG
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/engineering
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/engineering,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/eng,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/eng,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet,
						 /obj/item/clothing/shoes/jackboots/unathi)


	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/engineering, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/eng/noncom
	name = "NTEF engineering NCO"
	min_rank = 4


	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/eng/snco
	name = "NTEF engineering SNCO"
	min_rank = 7

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/polopants,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet)

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/engineering, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/eng/officer
	name = "NTEF engineering CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/eng,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/eng,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/engineering, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/eng/officer/com //Can only be officers
	name = "NTEF engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/fleet/eng/officer/com/seniorofficer
	name = "NTEF engineering senior command"
	min_rank = 15

	service_under = /obj/item/clothing/under/solgov/service/fleet/command

	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/eng/officer/com/flagofficer
	name = "NTEF engineering flag command"
	min_rank = 17

	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer

/decl/hierarchy/mil_uniform/fleet/sec
	name = "NTEF security"
	departments = SEC

	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/security,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/sec,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/sec,
						 /obj/item/clothing/under/solgov/utility/fleet/security,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/security,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/security)

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/security, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sec/noncom
	name = "NTEF security NCO"
	min_rank = 4


	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/sec/snco
	name = "NTEF security SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/security, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sec/officer
	name = "NTEF security CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/sec,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/sec,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/security,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/security,
						 /obj/item/clothing/shoes/jackboots/unathi)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer

	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/security, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/sec/officer/com //Can only be officers
	name = "NTEF security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/fleet/sec/officer/com/seniorofficer
	name = "NTEF security senior command"
	min_rank = 15

	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/sec/officer/com/flagofficer
	name = "NTEF security flag command"
	min_rank = 17

	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer

/decl/hierarchy/mil_uniform/fleet/med
	name = "NTEF medical"
	departments = MED

	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/medical,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/under/solgov/utility/fleet/combat/medical,
						 /obj/item/clothing/gloves/thick/duty/solgov/med,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/med,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/medical,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/medical)

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/medical
	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/medical, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/med/noncom
	name = "NTEF medical NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/med/snco
	name = "NTEF medical SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/medical, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/med/officer
	name = "NTEF medical CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/med,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/med,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/medical,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/medical)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer

	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/medical, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/med/officer/com //Can only be officers
	name = "NTEF medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/fleet/med/officer/com/seniorofficer
	name = "NTEF medical senior command"
	min_rank = 15

	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/med/officer/com/flagofficer
	name = "NTEF medical flag command"
	min_rank = 17

	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command

/decl/hierarchy/mil_uniform/fleet/sup
	name = "NTEF supply"
	departments = SUP

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/supply
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/supply,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/sup,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/sup,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/supply,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/supply)

	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/supply, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sup/noncom
	name = "NTEF supply NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/sup/snco
	name = "NTEF supply SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/supply, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sup/officer
	name = "NTEF supply CO"
	min_rank = 11


	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/sup,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/sup,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/supply,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/supply)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer

	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/supply, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/sup/seniorofficer
	name = "NTEF supply senior command"
	min_rank = 15

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command, /obj/item/clothing/head/beret/solgov/fleet/command, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet, /obj/item/clothing/head/soft/solgov/fleet/ntef)
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command
	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/supply, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/sup/flagofficer
	name = "NTEF supply flag command"
	min_rank = 17

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command, /obj/item/clothing/head/beret/solgov/fleet/command, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet, /obj/item/clothing/head/soft/solgov/fleet/ntef)
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/flag

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/flag
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/supply, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/srv
	name = "NTEF service"
	departments = SRV

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/service
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/service,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/svc,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/svc,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/service,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/service)

	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/service, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/srv/noncom
	name = "NTEF service NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/srv/snco
	name = "NTEF service SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/service, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/srv/officer
	name = "NTEF service CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/svc,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/svc,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/service,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/service)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/service, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/exp
	name = "NTEF exploration"
	departments = EXP

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/exploration
	utility_extra = list(/obj/item/clothing/head/beret/solgov/fleet/exploration,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/under/solgov/utility/fleet/combat/exploration,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/exp,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/exploration,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/exploration)

	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/explorer, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/exp/noncom
	name = "NTEF exploration NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/exp/snco
	name = "NTEF exploration SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/explorer, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/exp/officer
	name = "NTEF exploration CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/exp,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/exploration,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/exploration)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/explorer, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/spt
	name = "NTEF command support"
	departments = SPT

	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command
	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/command/support, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/spt/noncom
	name = "NTEF support NCO"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/spt/snco
	name = "NTEF support SNCO"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/command/support, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/spt/officer
	name = "NTEF command support CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command, /obj/item/clothing/gloves/thick/duty/solgov/fingerless/cmd, /obj/item/clothing/head/beret/solgov/fleet/command, /obj/item/clothing/head/ushanka/solgov/fleet, /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet, /obj/item/clothing/head/soft/solgov/fleet/ntef, /obj/item/clothing/under/solgov/utility/fleet/polopants/command, /obj/item/clothing/suit/storage/jacket/solgov/fleet/command)
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/command/support, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/spt/seniorofficer
	name = "NTEF senior command support"
	min_rank = 15

	utility_extra_alt = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/command,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/command)
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/command/support, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/spt/flagofficer
	name = "NTEF flag command support"
	min_rank = 17

	utility_extra = list(/obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/command,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/command)
	utility_under = /obj/item/clothing/under/solgov/utility/fleet/command

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_under = /obj/item/clothing/under/solgov/service/fleet/command
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/command

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/command
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/command/support, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/sci
	name = "NTEF science"
	departments = SCI

	dress_extra = list(/obj/item/clothing/accessory/cloak/boh/explorer/science, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sci/senior
	name = "NTEF science senior"
	min_rank = 4

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet

/decl/hierarchy/mil_uniform/fleet/sci/chief
	name = "NTEF science chief"
	min_rank = 7

	service_hat = /obj/item/clothing/head/solgov/dress/fleet
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/snco

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword/pettyofficer, /obj/item/clothing/accessory/cloak/boh/explorer/science, /obj/item/clothing/head/beret/solgov/fleet/dress)

/decl/hierarchy/mil_uniform/fleet/sci/officer
	name = "NTEF science CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
						 /obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/exp,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/exploration,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/exploration)
	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer
	service_under = /obj/item/clothing/under/solgov/service/fleet/officer
	service_skirt = /obj/item/clothing/under/solgov/service/fleet/skirt/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/explorer, /obj/item/clothing/head/beret/solgov/fleet/dress/command)


	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/explorer/science, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/fleet/sci/officer/com //Can only be officers
	name = "NTEF science command"
	departments = SCI|COM

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/under/solgov/utility/fleet/officer/command,
						 /obj/item/clothing/head/beret/solgov/fleet/command,
						 /obj/item/clothing/head/ushanka/solgov/fleet,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet,
						 /obj/item/clothing/head/soft/solgov/fleet/ntef,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp,
						 /obj/item/clothing/gloves/thick/duty/solgov/fingerless/exp,
						 /obj/item/clothing/under/solgov/utility/fleet/polopants/exploration,
						 /obj/item/clothing/suit/storage/jacket/solgov/fleet/exploration)

	service_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	service_over = /obj/item/clothing/suit/storage/solgov/service/fleet/officer

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	dress_hat = /obj/item/clothing/head/solgov/dress/fleet/command
	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/explorer, /obj/item/clothing/head/beret/solgov/fleet/dress/command)


	dress_extra = list(/obj/item/weapon/material/sword/replica/officersword, /obj/item/clothing/accessory/cloak/boh/explorer/science, /obj/item/clothing/head/beret/solgov/fleet/dress/command)

/decl/hierarchy/mil_uniform/ec/com //Can only be officers
	name = "EC command"
	min_rank = 11
	departments = COM

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/command
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)

	service_under = /obj/item/clothing/under/utility/expeditionary/command
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/command

	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/eng
	name = "EC engineering"
	departments = ENG

	utility_under = /obj/item/clothing/under/utility/expeditionary/engineering
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/engineering, /obj/item/clothing/head/ushanka/expedition)

	service_under = /obj/item/clothing/under/utility/expeditionary/engineering
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/engineering

/decl/hierarchy/mil_uniform/ec/eng/officer
	name = "EC engineering CO"
	min_rank = 11

	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)
	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/eng/officer/com //Can only be officers
	name = "EC engineering command"
	departments = ENG|COM

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/engineering

	service_under = /obj/item/clothing/under/utility/expeditionary/officer/engineering
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/engineering/command

/decl/hierarchy/mil_uniform/ec/sec
	name = "EC security"
	departments = SEC

	utility_under = /obj/item/clothing/under/utility/expeditionary/security
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/security, /obj/item/clothing/head/ushanka/expedition)

	service_under = /obj/item/clothing/under/utility/expeditionary/security
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/security

/decl/hierarchy/mil_uniform/ec/sec/officer
	name = "EC security CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/security
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)
	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/sec/officer/com //Can only be officers
	name = "EC security command"
	departments = SEC|COM

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/security

	service_under = /obj/item/clothing/under/utility/expeditionary/officer/security
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/security/command

/decl/hierarchy/mil_uniform/ec/med
	name = "EC medical"
	departments = MED

	utility_under = /obj/item/clothing/under/utility/expeditionary/medical
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/medical, /obj/item/clothing/head/ushanka/expedition)

	service_under = /obj/item/clothing/under/utility/expeditionary/medical
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/medical

/decl/hierarchy/mil_uniform/ec/med/officer
	name = "EC medical CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/medical
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)
	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/med/officer/com //Can only be officers
	name = "EC medical command"
	departments = MED|COM

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/medical

	service_under = /obj/item/clothing/under/utility/expeditionary/officer/medical
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/medical/command

/decl/hierarchy/mil_uniform/ec/sup
	name = "EC supply"
	departments = SUP

	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/supply, /obj/item/clothing/head/ushanka/expedition)
	utility_under = /obj/item/clothing/under/utility/expeditionary/supply

	service_under = /obj/item/clothing/under/utility/expeditionary/supply
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/supply

/decl/hierarchy/mil_uniform/ec/sup/officer
	name = "EC supply CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/supply
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)
	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/srv
	name = "EC service"
	departments = SRV

	utility_under = /obj/item/clothing/under/utility/expeditionary/service

	service_under = /obj/item/clothing/under/utility/expeditionary/service

/decl/hierarchy/mil_uniform/ec/srv/officer
	name = "EC service CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/utility/expeditionary/officer/service
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)
	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

/decl/hierarchy/mil_uniform/ec/spt
	name = "EC command support"
	departments = SPT

	utility_under= /obj/item/clothing/under/utility/expeditionary/command
	utility_extra = list(/obj/item/clothing/head/beret/sol/expedition/command, /obj/item/clothing/head/ushanka/expedition)

	service_under= /obj/item/clothing/under/utility/expeditionary/command
	service_over = /obj/item/clothing/suit/storage/service/expeditionary/command

/decl/hierarchy/mil_uniform/ec/spt/officer
	name = "EC command support CO"
	min_rank = 11

	utility_under= /obj/item/clothing/under/utility/expeditionary/officer/command

	service_under= /obj/item/clothing/under/utility/expeditionary/officer/command

	dress_under = /obj/item/clothing/under/mildress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/mildress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/dress/expedition/command
	dress_hat = /obj/item/clothing/head/dress/expedition/command

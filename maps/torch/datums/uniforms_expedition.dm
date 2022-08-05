/decl/hierarchy/mil_uniform/ec/com //Can only be officers
	name = "EC command"
	min_rank = 11
	departments = COM

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/cmd)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/command
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/com/cdr //Can only be officers
	name = "EC senior command"
	min_rank = 15

	service_hat = /obj/item/clothing/head/solgov/service/expedition/senior_command

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command/cdr
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/senior_command

/decl/hierarchy/mil_uniform/ec/com/capt //Can only be officers
	name = "EC captain"
	min_rank = 16

	utility_hat = /obj/item/clothing/head/soft/solgov/expedition/co

	service_hat = /obj/item/clothing/head/solgov/service/expedition/captain

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command/capt
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/captain

/decl/hierarchy/mil_uniform/ec/com/adm //Can only be officers
	name = "EC admiral"
	min_rank = 18

	utility_hat = /obj/item/clothing/head/soft/solgov/expedition/co

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command/adm
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/captain

/decl/hierarchy/mil_uniform/ec/eng
	name = "EC engineering"
	departments = ENG

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/engineering
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/engineering,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/eng)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/engineering
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/engineering


/decl/hierarchy/mil_uniform/ec/eng/senior
	name = "EC engineering senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/eng/chief
	name = "EC engineering chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/eng/officer
	name = "EC engineering CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/engineering
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/engineering,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/eng)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/engineering
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/engineering
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/engineering
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/eng/officer/com //Can only be officers
	name = "EC engineering command"
	departments = ENG|COM

/decl/hierarchy/mil_uniform/ec/sec
	name = "EC security"
	departments = SEC

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/security
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/security,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/gloves/thick/duty/solgov/sec)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/security

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/security
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/security

/decl/hierarchy/mil_uniform/ec/sec/senior
	name = "EC security senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/sec/chief
	name = "EC security chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/sec/officer
	name = "EC security CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/security
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/security,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/sec)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/security
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/security
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/security
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/sec/officer/com //Can only be officers
	name = "EC security command"
	departments = SEC|COM

/decl/hierarchy/mil_uniform/ec/med
	name = "EC medical"
	departments = MED

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/medical,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/gloves/thick/duty/solgov/med)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/medical

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/medical
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/medical

/decl/hierarchy/mil_uniform/ec/med/senior
	name = "EC medical senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/med/chief
	name = "EC medical chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/med/officer
	name = "EC medical CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/medical,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/med)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/medical
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/medical
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/medical
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/med/officer/com //Can only be officers
	name = "EC medical command"
	departments = MED|COM

/decl/hierarchy/mil_uniform/ec/sup
	name = "EC supply"
	departments = SUP

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/supply,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/gloves/thick/duty/solgov/sup)
	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/supply

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/supply

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/supply
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/supply

/decl/hierarchy/mil_uniform/ec/sup/senior
	name = "EC supply senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/sup/chief
	name = "EC supply chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/sup/officer
	name = "EC supply CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/supply
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/supply,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/sup)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/service
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/supply
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/supply
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/srv
	name = "EC service"
	departments = SRV

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/service,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/gloves/thick/duty/solgov/svc)
	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/service

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/service

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/service
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/service

/decl/hierarchy/mil_uniform/ec/srv/senior
	name = "EC service senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/srv/chief
	name = "EC service chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/srv/officer
	name = "EC service CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/service
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/service,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/svc)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/service
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/service
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/service
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/exp
	name = "EC exploration"
	departments = EXP

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/exploration,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp)
	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/exploration

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/exploration
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/exploration

/decl/hierarchy/mil_uniform/ec/exp/senior
	name = "EC exploration senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/exp/chief
	name = "EC exploration chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/exp/officer
	name = "EC exploration CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/exploration
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/beret/solgov/expedition/exploration,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/exp)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/exploration
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/exploration
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/exploration
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/spt
	name = "EC command support"
	departments = SPT

	utility_under= /obj/item/clothing/under/solgov/utility/expeditionary/command
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/shoes/jackboots/unathi,
						 /obj/item/clothing/gloves/thick/duty/solgov/cmd)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt

/decl/hierarchy/mil_uniform/ec/spt/senior
	name = "EC command support senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/spt/chief
	name = "EC command support chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/spt/officer
	name = "EC command support CO"
	min_rank = 11

	utility_under= /obj/item/clothing/under/solgov/utility/expeditionary/officer/command

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/command
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/sci
	name = "EC science"
	departments = SCI

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/research
	utility_extra = list(/obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
						 /obj/item/clothing/gloves/thick/duty/solgov/sci)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/research

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/research
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/skirt/research

/decl/hierarchy/mil_uniform/ec/sci/senior
	name = "EC science senior"
	min_rank = 5

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/senior

/decl/hierarchy/mil_uniform/ec/sci/chief
	name = "EC science chief"
	min_rank = 7

	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/chief

/decl/hierarchy/mil_uniform/ec/sci/officer
	name = "EC science CO"
	min_rank = 11

	utility_under = /obj/item/clothing/under/solgov/utility/expeditionary/officer/research
	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
						 /obj/item/clothing/gloves/thick/duty/solgov/sci)

	service_over = /obj/item/clothing/suit/storage/solgov/service/expeditionary/command/research
	service_hat = /obj/item/clothing/head/solgov/service/expedition/command

	dress_under = /obj/item/clothing/under/solgov/dress/expeditionary/command/research
	dress_skirt = /obj/item/clothing/under/solgov/dress/expeditionary/command/skirt/research
	dress_over = /obj/item/clothing/suit/storage/solgov/dress/expedition/command
	dress_hat = /obj/item/clothing/head/solgov/service/expedition/command

/decl/hierarchy/mil_uniform/ec/sci/officer/com //Can only be officers
	name = "EC science command"
	departments = SCI|COM

	utility_extra = list(/obj/item/clothing/head/beret/solgov/expedition/command,
						 /obj/item/clothing/head/ushanka/solgov,
						 /obj/item/clothing/suit/storage/hooded/wintercoat/solgov,
						 /obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
						 /obj/item/clothing/suit/storage/toggle/labcoat/rd/ec,
						 /obj/item/clothing/gloves/thick/duty/solgov/sci)

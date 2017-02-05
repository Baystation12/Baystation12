/obj/item/weapon/storage/briefcase/uniform/torch/
	name = "uniform briefcase"
	desc = "A bulky briefcase containing uniform pieces."
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10

/obj/item/weapon/storage/briefcase/uniform/torch/New()
	..()
	slowdown_per_slot[slot_l_hand] = 3
	slowdown_per_slot[slot_r_hand] = 3

//Fleet
/obj/item/weapon/storage/briefcase/uniform/torch/fleet
	startswith = list(
		/obj/item/clothing/under/pt/fleet,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/dress/fleet,
		/obj/item/clothing/under/service/fleet,
		/obj/item/clothing/shoes/dress/white,
		/obj/item/clothing/suit/storage/toggle/dress/fleet,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/fleet/command
	startswith = list(
		/obj/item/clothing/under/pt/fleet,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/dress/fleet/command,
		/obj/item/clothing/under/service/fleet,
		/obj/item/clothing/shoes/dress/white,
		/obj/item/clothing/suit/storage/toggle/dress/fleet/command,
		/obj/item/weapon/melee/officersword,
		/obj/item/clothing/gloves/color/white
		)

//Marine
/obj/item/weapon/storage/briefcase/uniform/torch/marine
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine,
		/obj/item/clothing/under/service/marine,
		/obj/item/clothing/suit/storage/service/marine,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine,
		/obj/item/clothing/under/mildress/marine,
		/obj/item/clothing/suit/dress/marine,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/command
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine/command,
		/obj/item/clothing/under/service/marine/command,
		/obj/item/clothing/suit/storage/service/marine/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine/command,
		/obj/item/clothing/under/mildress/marine/command,
		/obj/item/clothing/suit/dress/marine/command,
		/obj/item/weapon/melee/officersword/marineofficer,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/medical
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine,
		/obj/item/clothing/under/service/marine,
		/obj/item/clothing/suit/storage/service/marine/medical,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine,
		/obj/item/clothing/under/mildress/marine,
		/obj/item/clothing/suit/dress/marine,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/medical/command
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine/command,
		/obj/item/clothing/under/service/marine/command,
		/obj/item/clothing/suit/storage/service/marine/medical/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine/command,
		/obj/item/clothing/under/mildress/marine/command,
		/obj/item/clothing/suit/dress/marine/command,
		/obj/item/weapon/melee/officersword/marineofficer,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/engineering
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine,
		/obj/item/clothing/under/service/marine,
		/obj/item/clothing/suit/storage/service/marine/engineering,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine,
		/obj/item/clothing/under/mildress/marine,
		/obj/item/clothing/suit/dress/marine,
		/obj/item/clothing/gloves/color/white
		)
/obj/item/weapon/storage/briefcase/uniform/torch/marine/engineering/command
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine/command,
		/obj/item/clothing/under/service/marine/command,
		/obj/item/clothing/suit/storage/service/marine/engineering/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine/command,
		/obj/item/clothing/under/mildress/marine/command,
		/obj/item/clothing/suit/dress/marine/command,
		/obj/item/weapon/melee/officersword/marineofficer,
		/obj/item/clothing/gloves/color/white
		)
/obj/item/weapon/storage/briefcase/uniform/torch/marine/security
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine,
		/obj/item/clothing/under/service/marine,
		/obj/item/clothing/suit/storage/service/marine/security,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine,
		/obj/item/clothing/under/mildress/marine,
		/obj/item/clothing/suit/dress/marine,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/security/command
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine/command,
		/obj/item/clothing/under/service/marine/command,
		/obj/item/clothing/suit/storage/service/marine/security/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine/command,
		/obj/item/clothing/under/mildress/marine/command,
		/obj/item/clothing/suit/dress/marine/command,
		/obj/item/weapon/melee/officersword/marineofficer,
		/obj/item/clothing/gloves/color/white
		)

/obj/item/weapon/storage/briefcase/uniform/torch/marine/supply
	startswith = list(
		/obj/item/clothing/under/pt/marine,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/service/marine,
		/obj/item/clothing/under/service/marine,
		/obj/item/clothing/suit/storage/service/marine/supply,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/head/dress/marine,
		/obj/item/clothing/under/mildress/marine,
		/obj/item/clothing/suit/dress/marine,
		/obj/item/clothing/gloves/color/white
		)

//Expeditionary Corps
/obj/item/weapon/storage/briefcase/uniform/torch/expedition
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary,
		/obj/item/clothing/head/dress/expedition,
		/obj/item/clothing/under/mildress/expeditionary,
		/obj/item/clothing/suit/dress/expedition,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/command
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/command,
		/obj/item/clothing/head/dress/expedition/command,
		/obj/item/clothing/under/mildress/expeditionary/command,
		/obj/item/clothing/suit/dress/expedition/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/medical
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/medical,
		/obj/item/clothing/head/dress/expedition,
		/obj/item/clothing/under/mildress/expeditionary,
		/obj/item/clothing/suit/dress/expedition,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/medical/command
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/medical/command,
		/obj/item/clothing/head/dress/expedition/command,
		/obj/item/clothing/under/mildress/expeditionary/command,
		/obj/item/clothing/suit/dress/expedition/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/engineering
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/engineering,
		/obj/item/clothing/head/dress/expedition,
		/obj/item/clothing/under/mildress/expeditionary,
		/obj/item/clothing/suit/dress/expedition,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/engineering/command
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/engineering/command,
		/obj/item/clothing/head/dress/expedition/command,
		/obj/item/clothing/under/mildress/expeditionary/command,
		/obj/item/clothing/suit/dress/expedition/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/security
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/security,
		/obj/item/clothing/head/dress/expedition,
		/obj/item/clothing/under/mildress/expeditionary,
		/obj/item/clothing/suit/dress/expedition,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/security/command
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/security/command,
		/obj/item/clothing/head/dress/expedition/command,
		/obj/item/clothing/under/mildress/expeditionary/command,
		/obj/item/clothing/suit/dress/expedition/command,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)

/obj/item/weapon/storage/briefcase/uniform/torch/expedition/supply
	startswith = list(
		/obj/item/clothing/under/pt/expeditionary,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/storage/service/expeditionary/supply,
		/obj/item/clothing/head/dress/expedition,
		/obj/item/clothing/under/mildress/expeditionary,
		/obj/item/clothing/suit/dress/expedition,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/gloves/color/white
	)
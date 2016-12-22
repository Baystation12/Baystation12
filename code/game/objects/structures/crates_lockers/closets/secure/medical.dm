/obj/structure/closet/secure_closet/medical1
	name = "medical equipment closet"
	desc = "Filled with medical junk."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical_equip)


	New()
		..()
		new /obj/item/weapon/storage/box/autoinjectors(src)
		new /obj/item/weapon/storage/box/syringes(src)
		new /obj/item/weapon/reagent_containers/dropper(src)
		new /obj/item/weapon/reagent_containers/dropper(src)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
		new /obj/random/firstaid(src)
		new /obj/item/weapon/storage/box/masks(src)
		new /obj/item/weapon/storage/box/gloves(src)
		return



/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_surgery)


	New()
		..()
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		return



/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_med(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/med(src)
		new /obj/item/clothing/under/rank/nursesuit (src)
		new /obj/item/clothing/head/nursehat (src)
		for(var/i = 1 to 2)
			switch(pick("blue", "green", "purple", "black", "navyblue"))
				if ("blue")
					new /obj/item/clothing/under/rank/medical/blue(src)
					new /obj/item/clothing/head/surgery/blue(src)
				if ("green")
					new /obj/item/clothing/under/rank/medical/green(src)
					new /obj/item/clothing/head/surgery/green(src)
				if ("purple")
					new /obj/item/clothing/under/rank/medical/purple(src)
					new /obj/item/clothing/head/surgery/purple(src)
				if ("black")
					new /obj/item/clothing/under/rank/medical/black(src)
					new /obj/item/clothing/head/surgery/black(src)
				if ("navyblue")
					new /obj/item/clothing/under/rank/medical/navyblue(src)
					new /obj/item/clothing/head/surgery/navyblue(src)
		new /obj/item/clothing/under/rank/medical(src)
		new /obj/item/clothing/under/rank/nurse(src)
		new /obj/item/clothing/under/rank/orderly(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat(src)
		new /obj/item/clothing/suit/storage/toggle/fr_jacket(src)
		new /obj/item/clothing/shoes/white(src)
//		new /obj/item/weapon/cartridge/medical(src)
		new /obj/item/device/radio/headset/headset_med(src)
		new /obj/item/taperoll/medical(src)
		new /obj/item/weapon/storage/belt/medical/emt(src)
		return

/obj/structure/closet/secure_closet/medical_torch
	name = "physician's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

/obj/structure/closet/secure_closet/medical_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/med(src)
	new /obj/item/clothing/under/sterile(src)
	new /obj/item/clothing/accessory/storage/white_vest(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/fr_jacket(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/medical(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/weapon/tank/emergency/oxygen/engi(src)
	new /obj/item/weapon/storage/box/autoinjectors(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/glasses/hud/health(src)
	return

/obj/structure/closet/secure_closet/medical_contractor
	name = "medical contractor's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

/obj/structure/closet/secure_closet/medical_contractor/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/med(src)
	new /obj/item/clothing/under/rank/orderly(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/medical(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/glasses/hud/health(src)
	return

/obj/structure/closet/secure_closet/medical_torchsenior
	name = "senior physician's locker"
	req_access = list(access_medical_equip)
	icon_state = "securesenmed1"
	icon_closed = "securesenmed"
	icon_locked = "securesenmed1"
	icon_opened = "securesenmedopen"
	icon_broken = "securesenmedbroken"
	icon_off = "securesenmedoff"

/obj/structure/closet/secure_closet/medical_torchsenior/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/med(src)
		switch(pick("blue", "green", "purple", "black", "navyblue"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
			if ("black")
				new /obj/item/clothing/under/rank/medical/black(src)
				new /obj/item/clothing/head/surgery/black(src)
			if ("navyblue")
				new /obj/item/clothing/under/rank/medical/navyblue(src)
				new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/under/sterile(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/surgicalapron(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/cmo(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/accessory/stethoscope(src)
	new /obj/item/device/flashlight/pen(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	return

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/paramedic/New()
    ..()
    new /obj/item/weapon/storage/box/autoinjectors(src)
    new /obj/item/weapon/storage/box/syringes(src)
    new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
    new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
    new /obj/item/weapon/storage/belt/medical/emt(src)
    new /obj/item/clothing/mask/gas(src)
    new /obj/item/clothing/suit/storage/toggle/fr_jacket(src)
    new /obj/item/clothing/suit/storage/toggle/labcoat(src)
    new /obj/item/device/radio/headset/headset_med(src)
    new /obj/item/weapon/cartridge/medical(src)
    new /obj/item/device/flashlight(src)
    new /obj/item/weapon/tank/emergency/oxygen/engi(src)
    new /obj/item/clothing/glasses/hud/health(src)
    new /obj/item/device/healthanalyzer(src)
    new /obj/item/device/radio/off(src)
    new /obj/random/medical(src)
    new /obj/item/weapon/crowbar(src)
    new /obj/item/weapon/extinguisher/mini(src)
    new /obj/item/weapon/storage/box/freezer(src)
    new /obj/item/clothing/accessory/storage/white_vest(src)

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_med(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/med(src)
		new /obj/item/clothing/suit/bio_suit/cmo(src)
		new /obj/item/clothing/head/bio_hood/cmo(src)
		new /obj/item/clothing/shoes/white(src)
		switch(pick("blue", "green", "purple", "black", "navyblue"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
			if ("black")
				new /obj/item/clothing/under/rank/medical/black(src)
				new /obj/item/clothing/head/surgery/black(src)
			if ("navyblue")
				new /obj/item/clothing/under/rank/medical/navyblue(src)
				new /obj/item/clothing/head/surgery/navyblue(src)
		new /obj/item/clothing/under/rank/chief_medical_officer(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
		new /obj/item/weapon/cartridge/cmo(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/clothing/shoes/brown	(src)
		new /obj/item/device/radio/headset/heads/cmo(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/hypospray(src)
		return


/obj/structure/closet/secure_closet/CMO_torch
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/CMO_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/med(src)
	new /obj/item/clothing/suit/bio_suit/cmo(src)
	new /obj/item/clothing/head/bio_hood/cmo(src)
	new /obj/item/clothing/shoes/white(src)
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
			new /obj/item/clothing/head/surgery/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
			new /obj/item/clothing/head/surgery/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
			new /obj/item/clothing/head/surgery/purple(src)
		if ("black")
			new /obj/item/clothing/under/rank/medical/black(src)
			new /obj/item/clothing/head/surgery/black(src)
		if ("navyblue")
			new /obj/item/clothing/under/rank/medical/navyblue(src)
			new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
	new /obj/item/weapon/cartridge/cmo(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/device/radio/headset/heads/cmo(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/reagent_containers/hypospray(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/accessory/stethoscope(src)
	new /obj/item/device/flashlight/pen(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/clothing/suit/storage/vest/solgov/command(src)
	new /obj/item/clothing/head/helmet/solgov/command(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/white(src)
	return


/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_chemistry)


	New()
		..()
		new /obj/item/weapon/storage/box/pillbottles(src)
		new /obj/item/weapon/storage/box/pillbottles(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/cryoxadone(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		new /obj/random/medical(src)
		return

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened


/obj/structure/closet/secure_closet/counselor
	name = "counselor's locker"
	req_access = list(access_psychiatrist,access_chapel_office)
	icon_state = "chaplainsecure1"
	icon_closed = "chaplainsecure"
	icon_locked = "chaplainsecure1"
	icon_opened = "chaplainsecureopen"
	icon_broken = "chaplainsecurebroken"
	icon_off = "chaplainsecureoff"

/obj/structure/closet/secure_closet/counselor/New()
	..()
	new /obj/item/clothing/under/rank/psych(src)
	new /obj/item/clothing/under/rank/psych/turtleneck(src)
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/deck/tarot(src)
	new /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater(src)
	new /obj/item/weapon/nullrod(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/stoxin(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/storage/pill_bottle/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/methylphenidate(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/white(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/camera(src)
	new /obj/item/toy/therapy_blue(src)
	return

/obj/structure/closet/secure_closet/virology
	name = "virologist's locker"
	icon_state = "secureviro1"
	icon_closed = "secureviro"
	icon_locked = "secureviro1"
	icon_opened = "secureviroopen"
	icon_broken = "securevirobroken"
	icon_off = "securevirooff"
	req_access = list(access_virology)


/obj/structure/closet/secure_closet/virology/New()
	..()
	new /obj/item/weapon/storage/box/autoinjectors(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/reagent_containers/dropper(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/weapon/storage/pill_bottle/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/syringe/antiviral(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
	new /obj/item/weapon/storage/box/masks(src)
	new /obj/item/weapon/storage/box/gloves(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/glasses/hud/health(src)
	return

/obj/structure/closet/secure_closet/psychiatry
	name = "Psychiatrist's locker"
	desc = "Everything you need to keep the lunatics at bay."
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"
	req_access = list(64)

/obj/structure/closet/secure_closet/psychiatry/New()
	..()
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/stoxin(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/storage/pill_bottle/citalopram(src)
	new /obj/item/weapon/storage/pill_bottle/methylphenidate(src)
	new /obj/item/weapon/storage/pill_bottle/paroxetine(src)
	new /obj/item/clothing/under/rank/psych/turtleneck(src)
	new /obj/item/clothing/under/rank/psych(src)
	return


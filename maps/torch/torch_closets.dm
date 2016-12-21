//Medical
/obj/structure/closet/wardrobe/medic_torch
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_torch/New()
	..()
	new /obj/item/clothing/under/sterile(src)
	new /obj/item/clothing/under/sterile(src)
	new /obj/item/clothing/under/rank/medical/blue(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/under/rank/medical/black(src)
	new /obj/item/clothing/under/rank/medical/navyblue(src)
	new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/black(src)
	new /obj/item/clothing/suit/surgicalapron(src)
	new /obj/item/clothing/suit/surgicalapron(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
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

/obj/structure/closet/secure_closet/medical3_contractor/New()
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

/obj/structure/closet/secure_closet/medical3/torch/medical_senior
	name = "senior physician's locker"
	req_access = list(access_medical_equip)
	icon_state = "securesenmed1"
	icon_closed = "securesenmed"
	icon_locked = "securesenmed1"
	icon_opened = "securesenmedopen"
	icon_broken = "securesenmedbroken"
	icon_off = "securesenmedoff"

/obj/structure/closet/secure_closet/medical3/torch/medical_senior/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/medic(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_med(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/med(src)
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
	new /obj/item/clothing/under/sterile(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/surgicalapron(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/cmo(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/clothing/accessory/stethoscope(src)
	new /obj/item/device/flashlight/pen(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
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

//Engineering
/obj/structure/closet/secure_closet/engineering_chief_torch
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

/obj/structure/closet/secure_closet/engineering_chief_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/blueprints(src)
	new /obj/item/clothing/head/hardhat/white(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/gloves/insulated(src)
	new /obj/item/weapon/cartridge/ce(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/flash(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/crowbar/brace_jack(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/glasses/welding/superior(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/clothing/suit/storage/vest/solgov/command(src)
	new /obj/item/clothing/head/helmet/solgov/command(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/yellow(src)
	return

/obj/structure/closet/secure_closet/engineering_torch
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/engineering_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
	new /obj/item/clothing/under/hazard(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/weapon/storage/belt/utility(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/cartridge/engineering(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/weapon/cartridge/atmos(src)
	new /obj/item/taperoll/atmos(src)
	return

/obj/structure/closet/secure_closet/engineering_contractor
	name = "engineering contractor's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/engineering_contractor/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/weapon/cartridge/engineering(src)
	new /obj/item/taperoll/engineering(src)
	return

/obj/structure/closet/secure_closet/engineering_senior
	name = "senior engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureseneng1"
	icon_closed = "secureseneng"
	icon_locked = "secureseneng1"
	icon_opened = "securesenengopen"
	icon_broken = "securesenengbroken"
	icon_off = "securesenengoff"

/obj/structure/closet/secure_closet/engineering_senior/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
	new /obj/item/clothing/under/hazard(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/weapon/storage/toolbox/mechanical(src)
	new /obj/item/weapon/storage/belt/utility(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/cartridge/engineering(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/weapon/cartridge/atmos(src)
	new /obj/item/taperoll/atmos(src)
	new /obj/item/clothing/glasses/welding/superior(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/cartridge/ce(src)
	new /obj/item/device/megaphone(src)
	return

/obj/structure/closet/secure_closet/atmos_torch
	name = "atmospherics equipment locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"

/obj/structure/closet/secure_closet/atmos_torch/New()
	..()
	new /obj/item/clothing/under/hazard(src)
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/weapon/tank/emergency/oxygen/double(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/cartridge/atmos(src)
	new /obj/item/taperoll/atmos(src)
	new /obj/item/device/analyzer(src)
	return

//Security
/obj/structure/closet/secure_closet/cos
	name = "chief of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

/obj/structure/closet/secure_closet/cos/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/suit/storage/vest/solgov/command(src)
	new /obj/item/clothing/head/helmet/solgov/command(src)
	new /obj/item/clothing/head/HoS/dermal(src)
	new /obj/item/weapon/cartridge/hos(src)
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/goggles(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/teargas(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/melee/baton/loaded(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/hailer(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/red(src)
	return

/obj/structure/closet/secure_closet/brigofficer
	name = "brig officer's locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/brigofficer/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/suit/storage/vest/solgov/security(src)
	new /obj/item/clothing/head/helmet/solgov/security(src)
	new /obj/item/weapon/cartridge/hos(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/goggles(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/teargas(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/melee/baton/loaded(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/hailer(src)
	new /obj/item/weapon/storage/box/holobadge(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/red(src)
	new /obj/item/weapon/hand_labeler(src)
	return

/obj/structure/closet/secure_closet/security_torch
	name = "master at arms' locker"
	req_access = list(access_brig)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/security_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/suit/storage/vest/solgov/security(src)
	new /obj/item/clothing/head/helmet/solgov/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/grenade/chem_grenade/teargas(src)
	new /obj/item/weapon/melee/baton/loaded(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/goggles(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/hailer(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	return

/obj/structure/closet/secure_closet/forensics
	name = "forensics officer's locker"
	req_access = list(access_forensics_lockers)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/forensics/New()
	..()
	new /obj/item/clothing/gloves/forensic(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/clothing/suit/armor/vest/detective(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/clothing/suit/armor/vest/solgov(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/storage/box/evidence(src)
	new /obj/item/weapon/storage/box/swabs(src)
	new /obj/item/weapon/storage/box/gloves(src)
	new /obj/item/weapon/storage/briefcase/crimekit(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/red(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/forensics/sample_kit/powder(src)
	new /obj/item/weapon/forensics/sample_kit(src)
	new /obj/item/device/uv_light(src)
	new /obj/item/weapon/reagent_containers/spray/luminol(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	return

/obj/structure/closet/secure_closet/guard
	name = "security guard's locker"
	req_access = list(access_research)
	icon_state = "guard1"
	icon_closed = "guard"
	icon_locked = "guard1"
	icon_opened = "guardopen"
	icon_broken = "guardbroken"
	icon_off = "guardoff"

/obj/structure/closet/secure_closet/guard/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/suit/armor/vest/nt(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/taperoll/research(src)
	new /obj/item/device/hailer(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/device/megaphone(src)
	return

//Science
/obj/structure/closet/secure_closet/scientist_torch
	name = "researcher's locker"
	req_one_access = list(access_research)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

/obj/structure/closet/secure_closet/scientist_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/toxins(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/science(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/signal/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/weapon/tank/emergency/oxygen/engi(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/camera(src)
	new /obj/item/taperoll/research(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/glasses/science(src)
	return

/obj/structure/closet/secure_closet/RD_torch
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

/obj/structure/closet/secure_closet/RD_torch/New()
	..()
	new /obj/item/clothing/suit/bio_suit/scientist(src)
	new /obj/item/clothing/head/bio_hood/scientist(src)
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/under/rank/research_director/rdalt(src)
	new /obj/item/clothing/under/rank/research_director/dress_rd(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/science(src)
	new /obj/item/weapon/cartridge/rd(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/weapon/tank/emergency/oxygen/engi(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/camera(src)
	new /obj/item/taperoll/research(src)
	new /obj/item/clothing/glasses/welding/superior(src)
	new /obj/item/clothing/suit/armor/vest/nt(src)
	return


/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch
	name = "xenoarchaeologist's locker"
	req_access = list(access_xenoarch)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/toxins(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/science(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/weapon/cartridge/signal/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/camera(src)
	new /obj/item/taperoll/research(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/device/radio(src)
	new /obj/item/device/flashlight/lantern(src)
	return


//Misc
/obj/structure/closet/secure_closet/CO
	name = "commanding officer's locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/CO/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/captain(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_cap(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/captain(src)
	new /obj/item/clothing/suit/storage/vest/solgov/command(src)
	new /obj/item/weapon/cartridge/captain(src)
	new /obj/item/clothing/head/helmet/solgov/command(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/storage/box/ids(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/blue(src)
	return

/obj/structure/closet/secure_closet/XO
	name = "executive officer's locker"
	req_access = list(access_hop)
	icon_state = "twosolsecure1"
	icon_closed = "twosolsecure"
	icon_locked = "twosolsecure1"
	icon_opened = "twosolsecureopen"
	icon_broken = "twosolsecurebroken"
	icon_off = "twosolsecureoff"

/obj/structure/closet/secure_closet/XO/New()
	..()
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/weapon/cartridge/hop(src)
	new /obj/item/clothing/suit/storage/vest/solgov/command(src)
	new /obj/item/clothing/head/helmet/solgov/command(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/accessory/holster/thigh(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/weapon/storage/box/ids(src)
	new /obj/item/weapon/storage/box/ids(src)
	new /obj/item/weapon/storage/box/PDAs(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/blue(src)
	return

/obj/structure/closet/secure_closet/decktech
	name = "deck technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

/obj/structure/closet/secure_closet/decktech/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/cartridge/quartermaster(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/accessory/storage/webbing_large(src)
	new /obj/item/weapon/storage/belt/utility/atmostech(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/yellow(src)
	new /obj/item/weapon/packageWrap(src)
	return

/obj/structure/closet/secure_closet/deckofficer
	name = "deck officer's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/deckofficer/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/cartridge/quartermaster(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/weapon/storage/belt/utility/full(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/yellow(src)
	new /obj/item/weapon/packageWrap(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/clothing/suit/armor/vest/solgov(src)
	return

/obj/structure/closet/secure_closet/hydroponics_torch //done so that it has no access reqs
	name = "hydroponics locker"
	req_access = list()
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"


/obj/structure/closet/secure_closet/hydroponics_torch/New()
	..()
	switch(rand(1,2))
		if(1)
			new /obj/item/clothing/suit/apron(src)
		if(2)
			new /obj/item/clothing/suit/apron/overalls(src)
	new /obj/item/weapon/storage/plants(src)
	new /obj/item/device/analyzer/plant_analyzer(src)
	new /obj/item/weapon/material/minihoe(src)
	new /obj/item/weapon/material/hatchet(src)
	new /obj/item/weapon/wirecutters/clippers(src)
	new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
	return



/obj/structure/closet/chefcloset_torch
	name = "chef's closet"
	desc = "It's a storage unit for foodservice equipment."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/chefcloset_torch/New()
	..()
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/clothing/suit/chef/classic(src)

/obj/structure/closet/jcloset_torch
	name = "custodial closet"
	desc = "It's a storage unit for janitorial equipment."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/jcloset_torch/New()
	..()
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/weapon/cartridge/janitor(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/weapon/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/weapon/soap/nanotrasen(src)

/obj/structure/closet/secure_closet/liaison
	name = "/improper NanoTrasen liaison's locker"
	req_access = list(access_lawyer)
	icon_state = "nanottwo1"
	icon_closed = "nanottwo"
	icon_locked = "nanottwo1"
	icon_opened = "nanottwoopen"
	icon_broken = "nanottwobroken"
	icon_off = "nanottwooff"

/obj/structure/closet/secure_closet/liaison/New()
	..()
	new /obj/item/device/flash(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/device/camera(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/storage/secure/briefcase(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/under/rank/internalaffairs(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	return

/obj/structure/closet/secure_closet/representative
	name = "/improper Sol Central Government representative's locker"
	req_access = list(access_lawyer)
	icon_state = "solsecure1"
	icon_closed = "solsecure"
	icon_locked = "solsecure1"
	icon_opened = "solsecureopen"
	icon_broken = "solsecurebroken"
	icon_off = "solsecureoff"

/obj/structure/closet/secure_closet/representative/New()
	..()
	new /obj/item/device/flash(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/device/camera(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/storage/secure/briefcase(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/under/rank/internalaffairs/plain(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs/plain(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	return

//equipment closets that everyone on the crew or in research can access, for storing things securely

/obj/structure/closet/secure_closet/crew
	name = "crew equipment locker"
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_broken = "solbroken"
	icon_off = "soloff"

/obj/structure/closet/secure_closet/crew/New()
	..()
	new /obj/item/device/radio(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/flashlight(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	return

/obj/structure/closet/secure_closet/research
	name = "research equipment locker"
	icon_state = "nanot1"
	icon_closed = "nanot"
	icon_locked = "nanot1"
	icon_opened = "nanotopen"
	icon_broken = "nanotbroken"
	icon_off = "nanotoff"

/obj/structure/closet/secure_closet/research/New()
	..()
	new /obj/item/device/radio(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/flashlight(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	return

/obj/structure/closet/excavation_torch
	name = "excavation equipment closet"
	desc = "It's a storage unit for excavation equipment."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/excavation_torch/New()
		..()
		new /obj/item/weapon/storage/belt/archaeology(src)
		new /obj/item/weapon/storage/excavation(src)
		new /obj/item/device/flashlight/lantern(src)
		new /obj/item/device/ano_scanner(src)
		new /obj/item/device/depth_scanner(src)
		new /obj/item/device/core_sampler(src)
		new /obj/item/device/gps(src)
		new /obj/item/device/beacon_locator(src)
		new /obj/item/device/radio/beacon(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/glasses/science(src)
		new /obj/item/weapon/pickaxe(src)
		new /obj/item/device/measuring_tape(src)
		new /obj/item/weapon/pickaxe/hand(src)
		new /obj/item/weapon/storage/bag/fossils(src)
		new /obj/item/weapon/hand_labeler(src)
		new /obj/item/taperoll/research(src)
		return
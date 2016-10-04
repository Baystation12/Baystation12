/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		if (prob(70))
			new /obj/item/clothing/accessory/storage/brown_vest(src)
		else
			new /obj/item/clothing/accessory/storage/webbing(src)
		new /obj/item/blueprints(src)
		new /obj/item/clothing/under/rank/chief_engineer(src)
		new /obj/item/clothing/head/hardhat/white(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/gloves/insulated(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/cartridge/ce(src)
		new /obj/item/device/radio/headset/heads/ce(src)
		new /obj/item/weapon/storage/toolbox/mechanical(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/flash(src)
		new /obj/item/taperoll/engineering(src)
		new /obj/item/weapon/crowbar/brace_jack(src)
		return


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



/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"


	New()
		..()
		new /obj/item/clothing/gloves/insulated(src)
		new /obj/item/clothing/gloves/insulated(src)
		new /obj/item/clothing/gloves/insulated(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)
		return



/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"


	New()
		..()
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/clothing/glasses/welding(src)
		return



/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		if (prob(70))
			new /obj/item/clothing/accessory/storage/brown_vest(src)
		else
			new /obj/item/clothing/accessory/storage/webbing(src)
		new /obj/item/weapon/storage/toolbox/mechanical(src)
		new /obj/item/device/radio/headset/headset_eng(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/weapon/cartridge/engineering(src)
		new /obj/item/taperoll/engineering(src)
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

/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		if (prob(70))
			new /obj/item/clothing/accessory/storage/brown_vest(src)
		else
			new /obj/item/clothing/accessory/storage/webbing(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/weapon/extinguisher(src)
		new /obj/item/device/radio/headset/headset_eng(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/weapon/cartridge/atmos(src)
		new /obj/item/taperoll/atmos(src)
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

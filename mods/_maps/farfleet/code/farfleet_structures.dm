	///////////////
	//GUNCABINETS//
	///////////////

/obj/structure/closet/secure_closet/guncabinet/farfleet
	name = "heavy armory cabinet"
	req_access = list(access_away_iccgn_droptroops)

/obj/structure/closet/secure_closet/guncabinet/farfleet/antitank/WillContain()
	return list(
		/obj/item/gun/magnetic/railgun  = 1,
		/obj/item/gun/energy/ionrifle/small/stupor = 2,
		/obj/item/rcd_ammo = 5
	)

/obj/structure/closet/secure_closet/guncabinet/farfleet/ballistics/WillContain()
	return list(
		/obj/item/ammo_magazine/rifle = 15,
		/obj/item/gun/projectile/automatic/assault_rifle/heltek = 3,
	)

/obj/structure/closet/secure_closet/guncabinet/farfleet/energy/WillContain()
	return list(
		/obj/item/gun/energy/laser/bonfire = 3,
		/obj/item/storage/box/fragshells = 3
	)

/obj/structure/closet/secure_closet/guncabinet/farfleet/utility/WillContain()
	return list(
		/obj/item/storage/box/teargas = 1,
		/obj/item/storage/box/frags = 1,
		/obj/item/storage/box/smokes = 2,
		/obj/item/storage/box/anti_photons = 1,
		/obj/item/plastique = 6
	)

	///////////
	//CLOSETS//
	///////////

/singleton/closet_appearance/secure_closet/farfleet
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_DARK_BLUE_GRAY,
		"stripe_vertical_right_full" = COLOR_DARK_BLUE_GRAY,
		"security" = COLOR_RED_LIGHT
	)

/singleton/closet_appearance/secure_closet/farfleet/two
	color = COLOR_DARK_BLUE_GRAY
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_RED_LIGHT ,
		"security" = COLOR_RED_LIGHT
	)

/obj/structure/closet/secure_closet/farfleet
	name = "pioneer locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet/two
	req_access = list(access_away_iccgn_droptroops)

/obj/structure/closet/secure_closet/farfleet/WillContain()
	return list(
		/obj/item/storage/belt/holster/security/tactical,
		/obj/item/melee/telebaton,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/gloves/thick/combat,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/balaclava,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/thigh,
		/obj/item/clothing/accessory/armor_plate/merc,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/storage/backpack/satchel/leather/black
	)


/obj/structure/closet/secure_closet/farfleet/sergeant
	name = "pioneer sergeant locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet/two
	req_access = list(access_away_iccgn_sergeant)

/obj/structure/closet/secure_closet/farfleet/sergeant/WillContain()
	return list(
		/obj/item/storage/belt/holster/security/tactical,
		/obj/item/melee/telebaton,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/gloves/thick/combat,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/device/megaphone,
		/obj/item/clothing/mask/balaclava,
		/obj/item/storage/fancy/smokable/cigar,
		/obj/item/flame/lighter/zippo/gunmetal,
		/obj/item/clothing/mask/gas/swat,
		/obj/item/clothing/gloves/wristwatch,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/thigh,
		/obj/item/clothing/accessory/armor_plate/merc,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/storage/backpack/satchel/leather/black
	)

/obj/structure/closet/secure_closet/farfleet/fleet
	name = "crew cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet
	req_access = list(access_away_iccgn)

/obj/structure/closet/secure_closet/farfleet/fleet/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/accessory/storage/black_drop,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/storage/backpack/satchel/leather/navy
	)

/obj/structure/closet/secure_closet/farfleet/fleet/engi
	name = "corps technician cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet
	req_access = list(access_away_iccgn)

/obj/structure/closet/secure_closet/farfleet/fleet/engi/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/belt/utility/full,
		/obj/item/device/multitool,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/head/hardhat/orange,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/storage/backpack/satchel/leather/navy
	)

/obj/structure/closet/secure_closet/farfleet/fleet/med
	name = "pioneer corpsman cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet
	req_access = list(access_away_iccgn)

/obj/structure/closet/secure_closet/farfleet/fleet/med/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/belt/medical,
		/obj/item/storage/firstaid/adv,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/gloves/latex/nitrile,
		/obj/item/clothing/under/rank/medical/scrubs/black,
		/obj/item/clothing/head/surgery/black,
		/obj/item/clothing/suit/storage/hazardvest/white,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/storage/backpack/satchel/leather/navy
	)

/obj/structure/closet/secure_closet/farfleet/fleet_cpt
	name = "captain cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet
	req_access = list(access_away_iccgn, access_away_iccgn_captain)

/obj/structure/closet/secure_closet/farfleet/fleet_cpt/WillContain()
	return list(
		/obj/item/melee/telebaton,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/device/megaphone,
		/obj/item/clothing/accessory/storage/black_drop,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/fancy/smokable/cigar,
		/obj/item/flame/lighter/zippo/gunmetal,
		/obj/item/gun/projectile/pistol/magnum_pistol,
		/obj/item/clothing/gloves/wristwatch/gold,
		/obj/item/clothing/under/iccgn/service_command,
		/obj/item/storage/backpack/satchel/leather/navy
	)

/obj/structure/closet/secure_closet/farfleet/css
	name = "CSS cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/farfleet
	req_access = list(access_away_iccgn, access_away_iccgn_captain)

/obj/structure/closet/secure_closet/farfleet/css/WillContain()
	return list(
		/obj/item/melee/telebaton,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/device/megaphone,
		/obj/item/clothing/accessory/storage/holster/armpit,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/fancy/smokable/cigar,
		/obj/item/flame/lighter/zippo/gunmetal,
		/obj/item/gun/projectile/pistol/bobcat,
		/obj/item/clothing/gloves/wristwatch/gold,
		/obj/item/clothing/under/iccgn/service,
		/obj/item/ammo_magazine/pistol/nullglass = 2,
		/obj/item/device/flash/advanced,
		/obj/item/implanter/psi = 2,
		/obj/item/storage/backpack/satchel/leather/black
	)

	////////
	//MISC//
	////////

/obj/machinery/computer/ship/sensors/farfleet
	construct_state = /singleton/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/sensors
	print_language = LANGUAGE_HUMAN_RUSSIAN

/obj/machinery/door/airlock/terran
	door_color = COLOR_DARK_BLUE_GRAY

/obj/machinery/door/airlock/glass/terran
	door_color = COLOR_DARK_BLUE_GRAY
	stripe_color = COLOR_NT_RED

/obj/machinery/door/airlock/multi_tile/terran
	door_color = COLOR_DARK_BLUE_GRAY
	stripe_color = COLOR_NT_RED

/obj/machinery/door/airlock/multi_tile/glass/terran
	door_color = COLOR_DARK_BLUE_GRAY
	stripe_color = COLOR_NT_RED

/* Voidsuit Storage Unit
 * ====
 */

/obj/machinery/suit_storage_unit/pioneer
	name = "pioneer corps voidsuit storage unit"
	suit= /obj/item/clothing/suit/space/void/pioneer
	helmet = /obj/item/clothing/head/helmet/space/void/pioneer
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	mask = /obj/item/clothing/mask/breath
	req_access = list(access_away_iccgn)
	islocked = 1

/obj/structure/sign/farfleetplaque
	name = "\improper Pioneer Corps Plaque"
	desc = "Пионерский Корпус, сформированный в 2306 году является авангардом Конфедерации. Пионерский корпус не входит в состав Флота ГКК, выполняет ряд миротворческих и гуманитарных функций. На этой табличке - первые страницы приказа о создании Пионерского Корпуса."
	icon = 'mods/_maps/farfleet/icons/iccg_flag.dmi'
	icon_state = "pioneer_plaque"

/obj/floor_decal/iccglogo
	icon = 'mods/_maps/farfleet/icons/GCC-floor.dmi'
	icon_state = "center"

/obj/floor_decal/iccglogo/center_left
	icon_state = "center_left"

/obj/floor_decal/iccglogo/center_right
	icon_state = "center_right"

/obj/floor_decal/iccglogo/top_center
	icon_state = "top_center"

/obj/floor_decal/iccglogo/top_left
	icon_state = "top_left"

/obj/floor_decal/iccglogo/top_right
	icon_state = "top_right"

/obj/floor_decal/iccglogo/bottom_center
	icon_state = "bottom_center"

/obj/floor_decal/iccglogo/bottom_left
	icon_state = "bottom_left"

/obj/floor_decal/iccglogo/bottom_right
	icon_state = "bottom_right"

/obj/floor_decal/iccglogo/corner
	icon_state = "gcc_corner"

/obj/structure/sign/iccg
	name = "\improper ICCG Seal"
	desc = "A sign which signifies who this vessel belongs to."
	icon = 'mods/_maps/farfleet/icons/iccg_flag.dmi'
	icon_state = "iccg_seal"

/obj/structure/sign/double/iccgflag
	name = "ICCG Flag"
	desc = "The flag of the Independent Colonial Confederation of Gilgamesh, a symbol of Motherland to many proud peoples."
	icon = 'mods/_maps/farfleet/icons/iccg_flag.dmi'

/obj/structure/sign/double/iccgflag/left
	icon_state = "GCCflag-left"

/obj/structure/sign/double/iccgflag/right
	icon_state = "GCCflag-right"

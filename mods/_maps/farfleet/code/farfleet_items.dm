
/* CARDS
 * ========
 */

/obj/item/card/id/farfleet/droptroops
	desc = "An identification card issued to ICCG crewmembers aboard the Farfleet Recon Craft."
	icon_state = "base"
	access = list(access_away_iccgn, access_away_iccgn_droptroops)

/obj/item/card/id/farfleet/droptroops/sergeant
	desc = "An identification card issued to ICCG crewmembers aboard the Farfleet Recon Craft."
	icon_state = "base"
	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant)

/obj/item/card/id/farfleet/fleet
	desc = "An identification card issued to ICCG crewmembers aboard the Farfleet Recon Craft."
	icon_state = "base"
	access = list(access_away_iccgn)

/obj/item/card/id/farfleet/fleet/captain
	desc = "An identification card issued to ICCG crewmembers aboard the Farfleet Recon Craft."
	icon_state = "base"
	access = list(access_away_iccgn, access_away_iccgn_captain)

/* CLOTHING
 * ========
 */


/obj/item/clothing/under/iccgn/service_command
	accessories = list(
		/obj/item/clothing/accessory/iccgn_patch/pioneer
	)

/obj/item/clothing/under/iccgn/utility
	accessories = list(
		/obj/item/clothing/accessory/iccgn_patch/pioneer
	)

/obj/item/clothing/under/iccgn/pt
	accessories = list(
		/obj/item/clothing/accessory/iccgn_patch/pioneer
	)

/obj/item/storage/belt/holster/security/tactical/farfleet/New()
	..()
	new /obj/item/gun/projectile/pistol/optimus(src)
	new /obj/item/ammo_magazine/pistol/double(src)
	new /obj/item/ammo_magazine/pistol/double(src)

/obj/item/storage/belt/holster/security/farfleet/iccgn_pawn/New()
	..()
	new /obj/item/gun/projectile/pistol/bobcat(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)


/* WEAPONARY - BALLISTICS
 * ========
 */

/obj/item/gun/projectile/automatic/assault_rifle/heltek
	name = "LA-700"
	desc = "HelTek LA-700 is a standart equipment of ICCG Space-assault Forces. Looks very similiar to STS-35."
	icon = 'mods/_maps/farfleet/icons/obj/iccg_rifle.dmi'
	icon_state = "iccg_rifle"

/obj/item/gun/projectile/automatic/assault_rifle/heltek/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "iccg_rifle"
		wielded_item_state = "arifle-wielded"
	else
		icon_state = "iccg_rifle-empty"
		wielded_item_state = "arifle-wielded-empty"

/obj/item/gun/projectile/automatic/mr735
	name = "MR-735"
	desc = "A cheap rifle for close quarters combat, with an auto-firing mode available. HelTek MR-735 is a standard rifle for ICCG Space-assault Forces, designed without a stock for easier storage and combat in closed spaces. Perfect weapon for some ship's crew."
	icon = 'mods/_maps/farfleet/icons/obj/mr735.dmi'
	icon_state = "nostockrifle"
	item_state = "nostockrifle"
	item_icons = list(
		slot_r_hand_str = 'mods/_maps/farfleet/icons/mob/righthand.dmi',
		slot_l_hand_str = 'mods/_maps/farfleet/icons/mob/lefthand.dmi',
		)
	wielded_item_state = "nostockrifle_wielded"
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = /obj/item/ammo_magazine/rifle
	bulk = GUN_BULK_RIFLE
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'

	//Assault rifle, burst fire degrades quicker than SMG, worse one-handing penalty, slightly increased move delay
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, one_hand_penalty=8,  burst_accuracy=null,                dispersion=null),
		list(mode_name="2-round bursts", burst=2,    fire_delay=null, one_hand_penalty=9,  burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="full auto",      burst=1,    fire_delay=1.7,    burst_delay=1.3,     one_hand_penalty=7,  burst_accuracy=list(0,-1,-1), dispersion=list(1.3, 1.5, 1.7, 1.9, 2.2), autofire_enabled=1)
		)

/obj/item/gun/projectile/automatic/mr735/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "nostockrifle"
		wielded_item_state = "nostockrifle-wielded"
	else
		icon_state = "nostockrifle-empty"
		wielded_item_state = "nostockrifle-wielded-empty"


/obj/item/gun/projectile/automatic/mbr
	name = "MBR"
	desc = "A shabby bullpup carbine. Despite its size, it looks a little uncomfortable, but it is robust. HelTek MBR is a standart equipment of ICCG Space-assault Forces, designed in a bullpup layout. Possesses autofire and is perfect for the ship's crew."
	icon = 'mods/_maps/farfleet/icons/obj/mbr_bullpup.dmi'
	icon_state = "mbr_bullpup"
	item_state = "mbr_bullpup"
	item_icons = list(
		slot_r_hand_str = 'mods/_maps/farfleet/icons/mob/righthand.dmi',
		slot_l_hand_str = 'mods/_maps/farfleet/icons/mob/lefthand.dmi',
		)
	wielded_item_state = "mbr_bullpup-wielded"
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = /obj/item/ammo_magazine/rifle
	bulk = GUN_BULK_RIFLE + 1
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'

	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, one_hand_penalty=8,  burst_accuracy=null,                dispersion=null),
		list(mode_name="2-round bursts", burst=2,    fire_delay=null, one_hand_penalty=9,  burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="full auto",      burst=1,    fire_delay=1.7,    burst_delay=1.3,     one_hand_penalty=7,  burst_accuracy=list(0,-1,-1), dispersion=list(1.3, 1.5, 1.7, 1.9, 2.2), autofire_enabled=1)
		)

/obj/item/gun/projectile/automatic/mbr/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "mbr_bullpup"
	else
		icon_state = "mbr_bullpup-empty"


/* WEAPONARY - ENERGY
 * ========
 */

/obj/item/gun/energy/laser/bonfire
	name = "Bonfire Carbine"
	desc = "Strange construction: laser carbine with underslung grenade launcher and very capable internal battery. HelTek Bonfire-75 is a weapon designed for suppressive fire in close quarters, where usage of ballistic weaponry will be uneffective or simply hazardous."
	icon = 'mods/_maps/farfleet/icons/obj/bonfire.dmi'
	icon_state = "bonfire"
	item_state = "bonfire"
	item_icons = list(
		slot_r_hand_str = 'mods/_maps/farfleet/icons/mob/righthand.dmi',
		slot_l_hand_str = 'mods/_maps/farfleet/icons/mob/lefthand.dmi',
		)
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 2
	fire_delay = 6
	burst_delay = 2
	max_shots = 30
	bulk = GUN_BULK_RIFLE
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4)
	matter = list(MATERIAL_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/smalllaser
	wielded_item_state = "bonfire-wielded"

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-ray bursts", burst=3, fire_delay=null, one_hand_penalty=1, burst_accuracy=list(0,0,-1,-1),       dispersion=list(0.0, 0.0, 0.5, 0.6)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null,  use_launcher=1,    one_hand_penalty=10, burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = 0
	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/energy/laser/bonfire/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/energy/laser/bonfire/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, /obj/item/grenade))
		launcher.load(tool, user)
		return TRUE
	return ..()

/obj/item/gun/energy/laser/bonfire/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/energy/laser/bonfire/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/energy/ionrifle/small/stupor
	name = "Stupor ion pistol"
	desc = "The HelTek Stupor-45 is a compact anti-drone weapon. Due to their small output of EMP, you need be marksman to disable human-sized synthetic. But it's still better, than nothing."
	icon = 'mods/_maps/farfleet/icons/obj/stupor.dmi'
	icon_state = "stupor"
	item_state = "stupor"
	item_icons = list(
		slot_r_hand_str = 'mods/_maps/farfleet/icons/mob/righthand.dmi',
		slot_l_hand_str = 'mods/_maps/farfleet/icons/mob/lefthand.dmi',
		)
	fire_delay = 40
	one_hand_penalty = 0
	charge_cost = 40
	max_shots = 5

// CSS Anti-psionics stuff

/obj/item/ammo_casing/pistol/nullglass
	desc = "A 10mm bullet casing with a nullglass coating."
	projectile_type = /obj/item/projectile/bullet/nullglass

/obj/item/ammo_casing/pistol/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_magazine/pistol/nullglass
	ammo_type = /obj/item/ammo_casing/pistol/nullglass

/* VOIDSUITS AND RIGS
 * ========
 */

/obj/item/clothing/head/helmet/space/void/pioneer
	name = "pioneer corps voidsuit helmet"
	desc = "A somewhat old-fashioned helmet in bright colors. On the forehead you can see the inscription PC ICCG. This one has radiation shielding."
	icon = 'mods/_maps/farfleet/icons/obj/obj_head.dmi'
	icon_state = "pioneer"
	item_state = "pioneer"
	item_icons = list(slot_head_str = 'mods/_maps/farfleet/icons/mob/onmob_head.dmi')
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/void/pioneer
	name = "pioneer corps voidsuit"
	desc = "A somewhat old-fashioned voidsuit in bright colors. On the shoulder you can see the inscription PC ICCG. This one has radiation shielding."
	icon = 'mods/_maps/farfleet/icons/obj/obj_suit.dmi'
	icon_state = "pioneer"
	item_state = "pioneer"
	item_icons = list(slot_wear_suit_str = 'mods/_maps/farfleet/icons/mob/onmob_suit.dmi')
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/briefcase/inflatable,/obj/item/rcd,/obj/item/rpd, /obj/item/gun)

/obj/item/clothing/suit/space/void/pioneer/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/pioneer
	boots = /obj/item/clothing/shoes/magboots
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/rig/pioneer
	name = "pioneer corps suit control module"
	desc = "A ridiculously bulky military hardsuit with PC-13AA inscription and a small ICCG crest on its control module. This suit's armor plates mostly replaced with anomaly and radiation shielding."
	suit_type = "heavy"
	icon_state = "gcc_rig"
	online_slowdown = 2 ///chunky
	offline_slowdown = 4
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)
	initial_modules = list(
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

	chest_type = /obj/item/clothing/suit/space/rig/pioneer
	helm_type =  /obj/item/clothing/head/helmet/space/rig/pioneer
	boot_type =  /obj/item/clothing/shoes/magboots/rig/pioneer
	glove_type = /obj/item/clothing/gloves/rig/pioneer

/obj/item/clothing/head/helmet/space/rig/pioneer
	light_overlay = "helmet_light_dual_alt"

/obj/item/clothing/suit/space/rig/pioneer
	breach_threshold = 40
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC)
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/melee/baton
	)

/obj/item/clothing/gloves/rig/pioneer
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/pioneer

/obj/item/rig/pioneer/sergeant
	name = "pioneer corps sergeant suit control module"
	desc = "A ridiculously bulky military hardsuit with PC-13AS inscription and a small ICCG crest on its control module. This suit's armor plates mostly replaced with anomaly and radiation shielding."
	suit_type = "heavy"

	initial_modules = list(
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/mounted/ballistic/minigun,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

/* MISC
 * ========
 */

/obj/item/paper/farfleet/turrets
	name = "About Turrets"
	info = {"<h1>По поводу турелей.</h1>
			<p>Вася, я не знаю, как ты настраивал эти чёртовы турели, но у них слетает проверка доступа каждый раз как весь экипаж уходит в криосон. Да, я знаю, что они не должны сбоить из-за того, что все спят, но вот они так делают. Наше счастье, что они просто начинают оглушающим лучом бить,а не летальным режимом.</p>
			<h1>ПЕРЕЗАГРУЗИ КОНТРОЛЛЕР ТУРЕЛЕЙ, КАК ПОЙДЁШЬ В АНГАР.</h1>
		"}

/obj/item/paper/farfleet/engines
	name = "Engines Usage"
	info = {"
		<div style="text-align: center;">
			<p>Я не буду сейчас долго расписывать как работает атмосфера на Гарибальди, которую гайцы ТОЧНО не утащили у клятых марсиан, но принцип работы примерно следующий:</p>
			<p>Основные маршевые двигатели - ионные. Да, не слишком быстро, но надёжно если после затухания реакции в токамаке сможете нормально его настроить. А газовые двигатели - УСКОРИТЕЛИ. Но летать на них постоянно не советую, углекислота не бесконечная.</p>
		</div>
		<p><i>Ченков В.П.</i></p>
	"}

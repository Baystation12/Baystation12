/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	laws = /datum/ai_laws/syndicate_override
	idcard = /obj/item/weapon/card/id/syndicate
	module = /obj/item/weapon/robot_module/syndicate
	silicon_radio = /obj/item/device/radio/borg/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/weapon/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/combat
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Combat"
	module = /obj/item/weapon/robot_module/security/combat
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/weapon/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/combat/nt
	laws = /datum/ai_laws/nanotrasen_aggressive
	idcard = /obj/item/weapon/card/id/centcom/ERT
	silicon_radio = /obj/item/device/radio/borg/ert

/mob/living/silicon/robot/flying/ascent
	lawupdate = 0
	scrambledcodes = 1
	speed = -2
	icon_state = "drone-ascent"
	cell =   /obj/item/weapon/cell/high //mantid
	laws =   /datum/ai_laws/ascent
	idcard = /obj/item/weapon/card/id/ascent
	module = /obj/item/weapon/robot_module/flying/ascent
	req_access = list(access_ascent)

/mob/living/silicon/robot/flying/ascent/Initialize()
	. = ..()
	if(istype(module) && hands)
		hands.icon_state = module.display_name

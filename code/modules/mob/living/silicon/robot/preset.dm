/mob/living/silicon/robot/syndicate
	lawupdate = FALSE
	scrambledcodes = TRUE
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	laws = /datum/ai_laws/syndicate_override
	idcard = /obj/item/card/id/syndicate
	module = /obj/item/robot_module/syndicate
	silicon_radio = /obj/item/device/radio/borg/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = FALSE

/mob/living/silicon/robot/combat
	lawupdate = FALSE
	scrambledcodes = TRUE
	modtype = "Combat"
	module = /obj/item/robot_module/security/combat
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = FALSE

/mob/living/silicon/robot/combat/nt
	laws = /datum/ai_laws/nanotrasen_aggressive
	idcard = /obj/item/card/id/centcom/ERT
	silicon_radio = /obj/item/device/radio/borg/ert

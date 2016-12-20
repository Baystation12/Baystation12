/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	lawpreset = /datum/ai_laws/syndicate_override
	idcard_type = /obj/item/weapon/card/id/syndicate
	spawn_module = /obj/item/weapon/robot_module/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell_type = /obj/item/weapon/cell/super
	pitch_toggle = 0


/mob/living/silicon/robot/combat
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Combat"
	spawn_module = /obj/item/weapon/robot_module/security/combat
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell_type = /obj/item/weapon/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/combat/nt
	lawpreset = /datum/ai_laws/nanotrasen_aggressive
	idcard_type = /obj/item/weapon/card/id/centcom/ERT
	key_type = /obj/item/device/encryptionkey/ert

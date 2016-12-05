/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	lawpreset = /datum/ai_laws/syndicate_override
	idcard_type = /obj/item/weapon/card/id/syndicate

/mob/living/silicon/robot/syndicate/New()
	if(!cell)
		cell = new /obj/item/weapon/cell/super(src)

	..()

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	laws = new lawpreset()
	overlays.Cut()
	init_id()
	new /obj/item/weapon/robot_module/syndicate(src)

	radio.keyslot = new /obj/item/device/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/combat
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Combat"

/mob/living/silicon/robot/combat/New()
	if(!cell)
		cell = new /obj/item/weapon/cell/super(src)

	..()

/mob/living/silicon/robot/combat/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	laws = new lawpreset()
	overlays.Cut()
	init_id()
	new /obj/item/weapon/robot_module/security/combat(src)

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/combat/nt
	lawpreset = /datum/ai_laws/nanotrasen_aggressive
	idcard_type = /obj/item/weapon/card/id/centcom/ERT

/mob/living/silicon/robot/combat/nt/init()
	..()
	radio.keyslot = new /obj/item/device/encryptionkey/ert(radio)
	radio.recalculateChannels()
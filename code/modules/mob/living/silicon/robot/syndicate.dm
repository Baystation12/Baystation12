/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	idcard_type = /obj/item/weapon/card/id/syndicate

/mob/living/silicon/robot/syndicate/New()
	if(!cell)
		cell = new /obj/item/weapon/cell(src)
		cell.maxcharge = 25000
		cell.charge = 25000

	..()

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	laws = new /datum/ai_laws/syndicate_override
	overlays.Cut()
	init_id()
	new /obj/item/weapon/robot_module/syndicate(src)

	radio.keyslot = new /obj/item/device/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

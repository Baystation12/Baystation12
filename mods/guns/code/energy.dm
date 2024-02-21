/obj/item/gun/energy/laser
	icon = 'mods/guns/icons/obj/laser_carbine.dmi'

/obj/item/gun/energy/retro
	name = "retro laser"
	icon = 'mods/guns/icons/obj/retro_laser.dmi'

/obj/item/gun/energy/lasercannon
	icon = 'mods/guns/icons/obj/laser_cannon.dmi'

/obj/item/gun/energy/xray
	icon = 'mods/guns/icons/obj/xray.dmi'

/obj/item/gun/energy/xray/pistol
	icon = 'mods/guns/icons/obj/xray_pistol.dmi'

/obj/item/gun/energy/sniperrifle
	icon = 'mods/guns/icons/obj/laser_sniper.dmi'

/obj/item/gun/energy/pulse_rifle
	wielded_item_state = "pulsecarbine-wielded"
	icon = 'mods/guns/icons/obj/pulse_rifle.dmi'
	item_icons = list(
		slot_r_hand_str = 'mods/guns/icons/mob/righthand_guns.dmi',
		slot_l_hand_str = 'mods/guns/icons/mob/lefthand_guns.dmi'
		)

/obj/item/gun/energy/pulse_rifle/carbine
	icon = 'mods/guns/icons/obj/pulse_carbine.dmi'
	wielded_item_state = null

/obj/item/gun/energy/pulse_rifle/pistol
	icon = 'mods/guns/icons/obj/pulse_pistol.dmi'
	wielded_item_state = null

/obj/item/gun/energy/ionrifle
	icon = 'mods/guns/icons/obj/ion_rifle.dmi'
	item_icons = list(
		slot_r_hand_str = 'mods/guns/icons/mob/righthand_guns.dmi',
		slot_l_hand_str = 'mods/guns/icons/mob/lefthand_guns.dmi'
		)

/obj/item/gun/energy/ionrifle/small
	wielded_item_state = null

/obj/item/gun/energy/ionrifle/small/sec
	desc = "The NT Mk72 EW Preston is a personal defense weapon designed to disable mechanical threats. This one clad in white frame."
	icon = 'mods/guns/icons/obj/ion_pistol_nt.dmi'

/obj/item/gun/energy/incendiary_laser
	icon = 'mods/guns/icons/obj/incendiary_laser.dmi'

/obj/item/gun/energy/taser
	icon = 'mods/guns/icons/obj/taser.dmi'

/obj/item/gun/energy/taser/carbine
	icon = 'mods/guns/icons/obj/taser_carbine.dmi'
	item_icons = list(
		slot_r_hand_str = 'mods/guns/icons/mob/righthand_guns.dmi',
		slot_l_hand_str = 'mods/guns/icons/mob/lefthand_guns.dmi'
		)

/obj/item/gun/energy/stunrevolver
	icon = 'mods/guns/icons/obj/stunrevolver.dmi'

/obj/item/gun/energy/stunrevolver/rifle
	icon = 'mods/guns/icons/obj/stunrifle.dmi'
	item_icons = list(
		slot_r_hand_str = 'mods/guns/icons/mob/righthand_guns.dmi',
		slot_l_hand_str = 'mods/guns/icons/mob/lefthand_guns.dmi',
		)

/obj/item/gun/energy/laser/secure
	icon = 'mods/guns/icons/obj/laser_carbine.dmi'
	req_access = list(list(access_brig, access_bridge))

/obj/item/gun/energy/confuseray/secure
	name = "disorientator"
	desc = "The W-T Mk. 6 Disorientator fitted with an NT1017 secure fire chip. It has a NanoTrasen logo on the grip."
	icon = 'mods/guns/icons/obj/confuseray_secure.dmi'
	icon_state = "confusesecure"
	req_access = list(list(access_brig, access_bridge))

/obj/item/gun/energy/stunrevolver/secure
	name = "smart service revolver"
	desc = "A&M X8 Tessub. Next level in personal security with three diffirent firing modes. This one is fitted with an NT1019 chip which allows remote authorization of weapon functionality. It has an NT emblem on the grip."
	icon = 'mods/guns/icons/obj/stunrevolver_secure.dmi'
	projectile_type = /obj/item/projectile/beam/stun
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energyrevolverstun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="energyrevolvershock"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, modifystate="energyrevolverkill")
		)
	req_access = list(list(access_brig, access_heads))

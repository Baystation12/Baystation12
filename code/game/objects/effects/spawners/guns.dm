/obj/random/lilgun
	name = "Random Light Weapon"
	desc = "This is a random sidearm."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"

/obj/random/lilgun/spawn_choices()
	return list(/obj/item/gun/projectile/pistol/sec,
				/obj/item/gun/energy/gun,
				/obj/item/gun/energy/stunrevolver,
				/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
				/obj/item/gun/energy/xray/pistol,
				/obj/item/gun/energy/pulse_rifle/pistol,
				/obj/item/gun/energy/plasmacutter,
				/obj/item/gun/energy/incendiary_laser,
				/obj/item/gun/projectile/automatic/machine_pistol,
				/obj/item/gun/projectile/pistol/military/alt,
				/obj/item/gun/projectile/pistol/holdout,
				/obj/item/gun/projectile/revolver,
				/obj/item/gun/projectile/revolver/medium,
				/obj/item/gun/energy/retro,
				/obj/item/gun/projectile/pistol/throwback,
				/obj/item/gun/energy/ionrifle/small
	)

/obj/random/biggun
	name = "Random Heavy Weapon"
	desc = "This is a random rifle."
	icon = 'icons/obj/guns/assault_rifle.dmi'
	icon_state = "arifle"

/obj/random/biggun/spawn_choices()
	return list(/obj/item/gun/energy/lasercannon,
				/obj/item/gun/energy/laser,
				/obj/item/gun/energy/captain,
				/obj/item/gun/energy/pulse_rifle,
				/obj/item/gun/energy/pulse_rifle/carbine,
				/obj/item/gun/energy/sniperrifle,
				/obj/item/gun/projectile/shotgun/doublebarrel,
				/obj/item/gun/energy/xray,
				/obj/item/gun/projectile/automatic/battlerifle,
				/obj/item/gun/projectile/sniper/semistrip,
				/obj/item/gun/projectile/sniper/garand,
				/obj/item/gun/projectile/automatic/assault_rifle,
				/obj/item/gun/projectile/automatic/sec_smg,
				/obj/item/gun/energy/crossbow/largecrossbow,
				/obj/item/gun/projectile/shotgun/pump/combat,
				/obj/item/gun/energy/ionrifle,
				/obj/item/gun/projectile/shotgun/pump
	)

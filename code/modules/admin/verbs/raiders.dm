var/global/vox_tick = 1

/mob/living/carbon/human/proc/equip_raider()

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
	R.set_frequency(SYND_FREQ)
	equip_to_slot_or_del(R, slot_l_ear)

	var/list/uniforms = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/pirate,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly
		)

	var/list/shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/shoes/laceup
		)

	var/list/glasses = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/thermal/eyepatch,
		/obj/item/clothing/glasses/thermal/monocle
		)

	var/list/helmets = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/hgpiratecap,
		/obj/item/clothing/head/flatcap
		)

	var/list/suits = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/suit/greatcoat,
		/obj/item/clothing/suit/leathercoat,
		/obj/item/clothing/suit/browncoat,
		/obj/item/clothing/suit/neocoat,
		/obj/item/clothing/suit/storage/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/hoodie
		)

	var/list/guns = list(
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser/retro,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/energy/mindflayer,
		/obj/item/weapon/gun/energy/toxgun,
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/silenced,
		/obj/item/weapon/gun/projectile/shotgun/pump,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/detective,
		/obj/item/weapon/gun/projectile/pistol
		)

	var/new_shoes =   pick(shoes)
	var/new_uniform = pick(uniforms)
	var/new_glasses = pick(glasses)
	var/new_helmet =  pick(helmets)
	var/new_suit =    pick(suits)
	var/new_gun =     pick(guns)

	equip_to_slot_or_del(new new_shoes(src),slot_shoes)
	equip_to_slot_or_del(new new_uniform(src),slot_w_uniform)
	equip_to_slot_or_del(new new_glasses(src),slot_glasses)
	equip_to_slot_or_del(new new_helmet(src),slot_head)
	equip_to_slot_or_del(new new_suit(src),slot_wear_suit)
	equip_to_slot_or_del(new new_gun(src),belt)

	return 1

/mob/living/carbon/human/proc/equip_vox_raider()

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
	R.set_frequency(SYND_FREQ)
	equip_to_slot_or_del(R, slot_l_ear)

	equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_robes(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(src), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/vox(src), slot_gloves) // AS ABOVE.
	equip_to_slot_or_del(new /obj/item/clothing/mask/breath(src), slot_wear_mask)

	switch(vox_tick)
		if(1) // Vox raider!
			equip_to_slot_or_del(new /obj/item/weapon/melee/baton/loaded(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/device/chameleon(src), slot_l_store)
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/carapace(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/carapace(src), slot_head)

			var/obj/item/weapon/gun/launcher/spikethrower/W = new(src)
			equip_to_slot_or_del(W, slot_r_hand)


		if(2) // Vox engineer!
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/storage/box/emps(src), slot_r_hand)
			equip_to_slot_or_del(new /obj/item/device/multitool(src), slot_l_hand)
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/pressure(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/pressure(src), slot_head)


		if(3) // Vox saboteur!
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/card/emag(src), slot_l_store)
			equip_to_slot_or_del(new /obj/item/weapon/gun/dartgun/vox/raider(src), slot_r_hand)
			equip_to_slot_or_del(new /obj/item/device/multitool(src), slot_l_hand)
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/stealth(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/stealth(src), slot_head)

		if(4) // Vox medic!
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt) // Who needs actual surgical tools?
			equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/circular_saw(src), slot_l_store)
			equip_to_slot_or_del(new /obj/item/weapon/gun/dartgun/vox/medical, slot_r_hand)
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/medic(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/medic(src), slot_head)

	equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(src), slot_back)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_r_store)

	var/obj/item/weapon/card/id/syndicate/C = new(src)
	C.name = "[real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(access_syndicate)
	C.assignment = "Trader"
	C.registered_name = real_name
	C.registered_user = src
	var/obj/item/weapon/storage/wallet/W = new(src)
	W.handle_item_insertion(C)
	spawn_money(rand(50,150)*10,W)
	equip_to_slot_or_del(W, slot_wear_id)
	vox_tick++
	if (vox_tick > 4) vox_tick = 1

	return 1

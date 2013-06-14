/mob/living/carbon/human/proc/equip_vox_raider()

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
	R.set_frequency(SYND_FREQ) //Same frequency as the syndicate team in Nuke mode.
	equip_to_slot_or_del(R, slot_ears)

	equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_robes(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(src), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves) // AS ABOVE.

	switch(rand(1,4)) // Come up with a better way of doing this - ticker of some sort maybe.
		if(1) // Vox raider!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/carapace(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/carapace(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/device/chameleon(src), slot_l_store)

			var/obj/item/weapon/crossbow/W = new(src)
			W.cell = new /obj/item/weapon/cell/crap(W)
			W.cell.charge = 500
			equip_to_slot_or_del(W, slot_r_hand)

		if(2) // Vox engineer!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/pressure(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/pressure(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/storage/box/emps(src), slot_l_store)

			equip_to_slot_or_del(new /obj/item/weapon/pickaxe/plasmacutter(src), slot_r_hand)

		if(3) // Vox saboteur!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/carapace(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/carapace(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/card/emag(src), slot_l_store)

			var/obj/item/weapon/storage/pneumatic/W = new(src)
			W.tank = new /obj/item/weapon/tank/nitrogen(W)
			equip_to_slot_or_del(W, slot_r_hand)

		if(4) // Vox medic!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/pressure(src), slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/pressure(src), slot_head)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt) // Who needs actual surgical tools?
			equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(src), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/hypospray(src), slot_l_store)

			equip_to_slot_or_del(new /obj/item/weapon/circular_saw(src), slot_l_hand)
			equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/toxin(src), slot_r_hand)

	equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), slot_wear_mask)
	equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(src), slot_back)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_r_store)

	var/obj/item/weapon/card/id/syndicate/W = new(src)
	W.name = "[real_name]'s Legitimate Human ID Card"
	W.icon_state = "id"
	W.access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage, access_syndicate)
	W.assignment = "Trader"
	W.registered_name = real_name
	equip_to_slot_or_del(W, slot_wear_id)

	return 1
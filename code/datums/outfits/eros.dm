/decl/hierarchy/outfit/eros_hap_leader
	name = "Snowflake Ops - Leader"
	uniform = /obj/item/clothing/under/ert
	l_ear = /obj/item/device/radio/headset/specops
	glasses = /obj/item/clothing/glasses/tacgoggles
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/weapon/storage/belt/book_hap_rifleman
	back = /obj/item/weapon/rig/ert/assetprotection/book_hap
	shoes = /obj/item/clothing/shoes/combat

	r_hand = /obj/item/weapon/gun/projectile/automatic/sts35

	l_pocket = /obj/item/weapon/plastique
	r_pocket = /obj/item/weapon/plastique

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "HAP Special Operations Leader"

/decl/hierarchy/outfit/eros_hap_leader/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/bandolier/book_hap/bando = new()
		if(uniform.can_attach_accessory(bando))
			uniform.attach_accessory(null, bando)
		else
			qdel(bando)


/decl/hierarchy/outfit/eros_hap_gunner
	name = "Snowflake Ops - Gunner"
	uniform = /obj/item/clothing/under/ert
	l_ear = /obj/item/device/radio/headset/specops
	glasses = /obj/item/clothing/glasses/tacgoggles
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/weapon/storage/belt/book_hap_gunner
	back = /obj/item/weapon/rig/ert/assetprotection/book_hap
	shoes = /obj/item/clothing/shoes/combat

	r_hand = /obj/item/weapon/gun/projectile/automatic/l6_saw

	l_pocket = /obj/item/weapon/plastique
	r_pocket = /obj/item/weapon/plastique

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "HAP Special Operations Gunner"

/decl/hierarchy/outfit/eros_hap_gunner/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/bandolier/book_hap/bando = new()
		if(uniform.can_attach_accessory(bando))
			uniform.attach_accessory(null, bando)
		else
			qdel(bando)


/decl/hierarchy/outfit/eros_hap_cubanpetesbabybrother
	name = "Snowflake Ops - Grenadier"
	uniform = /obj/item/clothing/under/ert
	l_ear = /obj/item/device/radio/headset/specops
	glasses = /obj/item/clothing/glasses/tacgoggles
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/weapon/storage/belt/book_hap_grenadier
	back = /obj/item/weapon/rig/ert/assetprotection/book_hap
	shoes = /obj/item/clothing/shoes/combat

	r_hand = /obj/item/weapon/gun/projectile/automatic/z8

	l_pocket = /obj/item/weapon/plastique
	r_pocket = /obj/item/weapon/plastique

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "HAP Special Operations Grenadier"

/decl/hierarchy/outfit/eros_hap_grenadier/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/bandolier/book_hap/bando = new()
		if(uniform.can_attach_accessory(bando))
			uniform.attach_accessory(null, bando)
		else
			qdel(bando)


/decl/hierarchy/outfit/eros_hap_spotter
	name = "Snowflake Ops - Spotter"
	uniform = /obj/item/clothing/under/ert
	l_ear = /obj/item/device/radio/headset/specops
	glasses = /obj/item/clothing/glasses/tacgoggles
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/weapon/storage/belt/book_hap_rifleman
	back = /obj/item/weapon/rig/ert/assetprotection/book_hap
	shoes = /obj/item/clothing/shoes/combat

	r_hand = /obj/item/weapon/gun/projectile/automatic/sts35

	l_pocket = /obj/item/weapon/plastique
	r_pocket = /obj/item/device/binoculars

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "HAP Special Operations Spotter"

/decl/hierarchy/outfit/eros_hap_leader/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/bandolier/book_hap/bando = new()
		if(uniform.can_attach_accessory(bando))
			uniform.attach_accessory(null, bando)
		else
			qdel(bando)


/decl/hierarchy/outfit/eros_hap_sniper
	name = "Snowflake Ops - Sniper"
	uniform = /obj/item/clothing/under/ert
	l_ear = /obj/item/device/radio/headset/specops
	r_ear = /obj/item/ammo_casing/a145
	glasses = /obj/item/clothing/glasses/tacgoggles
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/weapon/storage/belt/book_hap_sniper
	back = /obj/item/weapon/rig/ert/assetprotection/book_hap
	shoes = /obj/item/clothing/shoes/combat

	r_hand = /obj/item/weapon/gun/projectile/heavysniper

	l_pocket = /obj/item/ammo_casing/a145
	r_pocket = /obj/item/ammo_casing/a145

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "HAP Special Operations Sniper"

/decl/hierarchy/outfit/eros_hap_leader/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/bandolier/book_hap_sniper/sbando = new()
		if(uniform.can_attach_accessory(sbando))
			uniform.attach_accessory(null, sbando)
		else
			qdel(bando)

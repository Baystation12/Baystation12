

/decl/hierarchy/outfit/job/unsc_achlys/CO
	name = "Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/SL
	name = "Squad Leader"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/marine
	name = "Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/operative
	name = "Operative"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	r_pocket = /obj/item/weapon/paper/crumpled/orders
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/operative/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Marine"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/unsc_achlys/pilot
	name = "Pilot"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/prisoner
	name = "Prisoner"

	l_ear = null
	r_ear = /obj/item/device/flashlight/pen/bright
	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange
	pda_slot = null
	id = null
	id_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/prisoner/proc/equip_special(mob/living/carbon/human/H)
	if(prob(25))
		var/obj/item/weapon/L = new /obj/item/weapon/scalpel
		H.equip_to_slot_or_del(L,slot_r_hand)
	else if(prob(25))
		var/obj/item/weapon/melee/baton/I = new /obj/item/weapon/melee/baton/humbler
		H.equip_to_slot_or_del(I,slot_belt)
	else if(prob(25))
		var/obj/item/weapon/crowbar/G = new /obj/item/weapon/crowbar/red
		H.equip_to_slot_or_del(G,slot_r_hand)
	else if(prob(10))
		var/obj/item/device/flashlight/M = new /obj/item/device/flashlight/maglight
		H.equip_to_slot_or_del(M,slot_r_hand)
	else if(prob(10))
		var/obj/item/weapon/material/A = new /obj/item/weapon/material/knife
		H.equip_to_slot_or_del(A,slot_belt)
	else if(prob(10))
		var/obj/item/weapon/material/twohanded/N = new /obj/item/weapon/material/twohanded/baseballbat
		H.equip_to_slot_or_del(N,slot_r_hand)
	else if(prob(5))
		var/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/U = new /obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/police
		H.equip_to_slot_or_del(U,slot_back)
	else if(prob(5))
		var/obj/item/weapon/material/twohanded/T = new /obj/item/weapon/material/twohanded/spear
		H.equip_to_slot_or_del(T,slot_r_hand)
	else if(prob(5))
		var/obj/item/weapon/material/twohanded/S = new /obj/item/weapon/material/twohanded/fireaxe
		H.equip_to_slot_or_del(S,slot_r_hand)

/decl/hierarchy/outfit/job/unsc_achlys/prisoner/equip_base(mob/living/carbon/human/H)
	equip_special(H)
	. = ..()

/decl/hierarchy/outfit/job/unsc_achlys/sangheili
	name = "Sangheili Prisoner"

	l_ear = null
	uniform = null
	suit = null
	back = null
	gloves = null
	head = null
	id = null
	id_slot = null
	shoes = null
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

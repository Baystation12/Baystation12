//EQUIPMENT PAPERS//

/obj/item/equipment_paper
	name = "Equipment Requsition Paper"
	desc = "Place this into a requisition vendor to retrieve an item."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	w_class = ITEM_SIZE_SMALL
	var/uses = 1 //-1 for infinite
	var/mob/linked_mob = null
	var/req_faction = null
	var/list/items = list()
	var/list/items_by_name = list()

/obj/item/equipment_paper/Initialize()
	. = ..()
	populate_items_by_name()

/obj/item/equipment_paper/proc/populate_items_by_name()
	for(var/type in items)
		var/atom/movable/a = new type()
		items_by_name[a.name] = a.desc
		qdel(a)

/obj/item/equipment_paper/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[uses == -1 ? "Unlimited" : "[uses]" ] uses remain.\nItems requisitioned by this paper:</span>")
	for(var/item in items_by_name)
		to_chat(user,"[item]\n-----\n[items_by_name[item]]")

/obj/item/equipment_paper/proc/deplete_uses()
	if(uses > 0)
		uses--
	if(uses == 0)
		var/mob/living/m = loc
		if(istype(m))
			m.drop_from_inventory(src)
		qdel(src)

/obj/item/equipment_paper/proc/req_items(var/turf/req_at)
	for(var/path in items)
		new path (req_at)

//GENERAL EQUIPMENT REQS//
/obj/item/equipment_paper/plasnade
	name = "Type-1 Antipersonnel Grenade Requisition"
	req_faction = "Covenant"
	items = list(/obj/item/weapon/grenade/plasma)

/obj/item/equipment_paper/plasnade/small
	uses = 3

/obj/item/equipment_paper/plasnade/medium
	uses = 5

/obj/item/equipment_paper/plasnade/large
	uses = 7

/obj/item/equipment_paper/plasnade/infinite
	uses = -1

/obj/item/equipment_paper/spikenade
	name = "Spike Grenade Requisition"
	req_faction = "Covenant"
	items = list(/obj/item/weapon/grenade/frag/spike)

/obj/item/equipment_paper/spikenade/small
	uses = 3

/obj/item/equipment_paper/spikenade/medium
	uses = 5

/obj/item/equipment_paper/spikenade/large
	uses = 7

/obj/item/equipment_paper/spikenade/infinite
	uses = -1

/obj/item/equipment_paper/ammo_needler
	name = "Type-33 GML Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/needles)

/obj/item/equipment_paper/ammo_carbine
	name = "Type-51 Carbine Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/type51mag)

/obj/item/equipment_paper/ammo_needlerifle
	name = "Type-31 Needle Rifle Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/rifleneedlepack)

/obj/item/equipment_paper/ammo_concrifle
	name = "Type-50 DER/H Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/concussion_rifle)

/obj/item/equipment_paper/ammo_fuelrod
	name = "Type-33 LAAW Ammo Requisition"
	req_faction = "Covenant"
	uses = 5
	items = list(/obj/item/ammo_magazine/fuel_rod)

/obj/item/equipment_paper/ammo_spiker
	name = "Type-25 Spiker Carbine Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/spiker)

/obj/item/equipment_paper/ammo_mauler
	name = "Type-52 Mauler Ammo Requisition"
	req_faction = "Covenant"
	uses = -1
	items = list(/obj/item/ammo_magazine/mauler)

/obj/item/equipment_paper/ammo_brute_shot
	name = "Type-25 GL Ammo Requisition"
	req_faction = "Covenant"
	uses = 4
	items = list(/obj/item/weapon/grenade/brute_shot)

//EQUIPMENT BOXES//

/obj/item/weapon/storage/box/large/equipment_box
	name = "Equipment Box"
	desc = "Contains a preset set of equipment."
	w_class = ITEM_SIZE_GARGANTUAN
	max_storage_space = 50
	max_w_class = ITEM_SIZE_GARGANTUAN
	startswith = list()
	can_hold = list()

//YANMEE//

/obj/item/weapon/storage/box/large/equipment_box/yanmee_sharpshooter
	name = "Yanme'e Equipment - Sharpshooter"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol
	)

/obj/item/weapon/storage/box/large/equipment_box/yanmee_standard
	name = "Yanme'e Equipment - Standard"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/yanmee_assault
	name = "Yanme'e Equipment - Assault"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/yanmee_assault_plas
	name = "Yanme'e Equipment - Plasma Assault"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/small
	)

//UNGGOY//

/obj/item/weapon/storage/box/large/equipment_box/unggoy_standard
	name = "Unggoy Equipment - Standard"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/infinite
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/infinite
	)

/obj/item/weapon/storage/box/large/equipment_box/unggoy_assault
	name = "Unggoy Equipment - Assault"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/unggoy_assault_plas
	name = "Unggoy Equipment - Plasma Assault"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/unggoy_heavy
	name = "Unggoy Equipment - Heavy"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/fuel_rod,
	/obj/item/equipment_paper/ammo_fuelrod,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy,
	/obj/item/clothing/mask/rebreather/unggoy_heavy
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/fuel_rod,
	/obj/item/equipment_paper/ammo_fuelrod,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy,
	/obj/item/clothing/mask/rebreather/unggoy_heavy
	)

/obj/item/weapon/storage/box/large/equipment_box/unggoy_mg
	name = "Unggoy Equipment - Mounted Gunner"
	can_hold = list(\
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/weapon/gun/energy/plasmarepeater,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy,
	/obj/item/clothing/mask/rebreather/unggoy_heavy
	)
	startswith = list(\
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/weapon/gun/energy/plasmarepeater,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy,
	/obj/item/clothing/mask/rebreather/unggoy_heavy
	)

//KIGYAR//

/obj/item/weapon/storage/box/large/equipment_box/kigyar_sniper
	name = "Kig-Yar Equipment - Sniper"
	can_hold = list(\
	/obj/item/weapon/gun/energy/beam_rifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/beam_rifle,
	/obj/item/weapon/gun/energy/plasmapistol
	)

/obj/item/weapon/storage/box/large/equipment_box/kigyar_carbine_sharpshooter
	name = "Kig-Yar Equipment - Carbine Sharpshooter"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/weapon/gun/energy/plasmapistol
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/weapon/gun/energy/plasmapistol
	)

/obj/item/weapon/storage/box/large/equipment_box/kigyar_needle_sharpshooter
	name = "Kig-Yar Equipment - Needle Sharpshooter"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/type31needlerifle,
	/obj/item/equipment_paper/ammo_needlerifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/weapon/gun/energy/plasmapistol
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/type31needlerifle,
	/obj/item/equipment_paper/ammo_needlerifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small,
	/obj/item/weapon/gun/energy/plasmapistol
	)

/obj/item/weapon/storage/box/large/equipment_box/kigyar_standard
	name = "Kig-Yar Equipment - Standard"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/kigyar_assault
	name = "Kig-Yar Equipment - Assault"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)


//SANGHEILI//

/obj/item/weapon/storage/box/large/equipment_box/elite_sniper
	name = "Sangheili Equipment - Sniper"
	can_hold = list(\
	/obj/item/weapon/gun/energy/beam_rifle,
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/beam_rifle,
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_carbine_sharpshooter
	name = "Sangheili Equipment - Carbine Sharpshooter"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/equipment_paper/ammo_carbine,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_needle_sharpshooter
	name = "Sangheili Equipment - Needle Sharpshooter"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/type31needlerifle,
	/obj/item/equipment_paper/ammo_needlerifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/type31needlerifle,
	/obj/item/equipment_paper/ammo_needlerifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_standard
	name = "Sangheili Equipment - Standard"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_assault
	name = "Sangheili Equipment - Assault"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/equipment_paper/ammo_needler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_concussion_rifle
	name = "Sangheili Equipment - Concussion Rifle"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/concussion_rifle,
	/obj/item/equipment_paper/ammo_concrifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/concussion_rifle,
	/obj/item/equipment_paper/ammo_concrifle,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_heavy
	name = "Sangheili Equipment - Heavy"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/fuel_rod,
	/obj/item/equipment_paper/ammo_fuelrod,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/projectile/fuel_rod,
	/obj/item/equipment_paper/ammo_fuelrod,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/plasnade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/elite_lmg
	name = "Sangheili Equipment - LMG"
	can_hold = list(\
	/obj/item/weapon/gun/energy/plasmarepeater,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/equipment_paper/plasnade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/energy/plasmarepeater,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/equipment_paper/plasnade/medium
	)

//JIRALHANAE//
/obj/item/weapon/storage/box/large/equipment_box/brute_standard
	name = "Jiralhanae Equipment - Standard"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/spikenade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/equipment_paper/spikenade/medium
	)

/obj/item/weapon/storage/box/large/equipment_box/brute_assault
	name = "Jiralhanae Equipment - Assault"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/mauler,
	/obj/item/equipment_paper/ammo_mauler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/equipment_paper/spikenade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/mauler,
	/obj/item/equipment_paper/ammo_mauler,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/equipment_paper/spikenade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/brute_grenadier
	name = "Jiralhanae Equipment - Grenadier"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/gun/launcher/grenade/brute_shot,
	/obj/item/equipment_paper/ammo_brute_shot,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/spikenade/small
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/gun/launcher/grenade/brute_shot,
	/obj/item/equipment_paper/ammo_brute_shot,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/equipment_paper/spikenade/small
	)

/obj/item/weapon/storage/box/large/equipment_box/brute_mg
	name = "Jiralhanae Equipment - Mounted Gunner"
	can_hold = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/equipment_paper/spikenade/medium
	)
	startswith = list(\
	/obj/item/weapon/gun/projectile/spiker,
	/obj/item/equipment_paper/ammo_spiker,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/turret_deploy_kit/plasturret,
	/obj/item/equipment_paper/spikenade/medium
	)

/*
YANMEE:

Sharpshooter - Carbine / Needle Rifle + Plaspistol
Standard - Plaspistol, battlepack 3-4 plasnade req?
Assault - Needler, 2-4 plasnade req?

UNGGOY:
as above, but with two extra and sharpshoot removed
(replace battlepack with unlimited plasnade req)
Unggoy Heavy - Fuel Rod Cannon/Repeater + Plaspistol, 1-2 Plasnades.
Unggoy Mounted Gunner - Mounted Gun + Needler. 1 plasnade.

HIGHER SPECIES RANK:
previous w/ some changes on a per-species basis
Squad Leader - Comes with req papers for a variety of higher tier guns.

*/
//EQUIPMENT VENDORS//
//Like normal vendors but with a slight change to their on-click functionality//

/obj/machinery/vending/armory/equip_req
	name = "Equipment Requisition Vendor"
	desc = "Requisition an equipment pack from this, or insert an equipment requisition paper to provide a related item."
	var/vendor_faction = null
	var/list/prev_users = list()
	var/list/species_lock = list()

/obj/machinery/vending/armory/equip_req/allowed(var/mob/user)
	if(user in prev_users)
		return 0

	var/mob/living/carbon/human/h = user
	if(species_lock.len > 0 && istype(h))
		if(!(h.species.type in species_lock))
			return 0

	. = ..()

/obj/machinery/vending/armory/equip_req/attackby(var/obj/item/equipment_paper/A,var/mob/user)
	if(istype(A,/obj/item/weapon/storage/box/large/equipment_box))
		to_chat(user,"<span class = 'notice'>[src] rejects [A]</span>")
		return
	if(istype(A))
		if(A.req_faction != vendor_faction)
			to_chat(user,"<span class = 'notice'>[A] is not compatible with [src]</span>")
			return
		if(A.linked_mob != null && A.linked_mob != user)
			to_chat(user,"<span class = 'notice'>That requisition order is not linked to you and thus cannot be used.</span>")
		else
			A.linked_mob = user
			A.req_items(loc)
			A.deplete_uses()
			to_chat(user,"<span class = 'notice'>[src] recognises [A] and vends the assigned items.</span>")
	else
		return ..()

/obj/machinery/vending/armory/equip_req/proc/remove_prev_user(var/mob/user) //For admins to revert some people's purchases.
	prev_users -= user

/obj/machinery/vending/armory/equip_req/vend(var/datum/stored_items/vending_products/R, mob/user)
	. = ..()
	if(.)
		prev_users += user

/obj/machinery/vending/armory/equip_req/cov
	icon = 'code/modules/halo/covenant/structures_machines/covendor.dmi'
	icon_state ="covendor"
	icon_deny = "covendor-deny"

/obj/machinery/vending/armory/equip_req/cov/yanmee
	vendor_faction = "Covenant"
	species_lock = list(/datum/species/yanmee)
	products = list(\
	/obj/item/weapon/storage/box/large/equipment_box/yanmee_sharpshooter = 2,
	/obj/item/weapon/storage/box/large/equipment_box/yanmee_standard = 40,
	/obj/item/weapon/storage/box/large/equipment_box/yanmee_assault = 10,
	/obj/item/weapon/storage/box/large/equipment_box/yanmee_assault_plas = 2
	)

/obj/machinery/vending/armory/equip_req/cov/unggoy
	vendor_faction = "Covenant"
	species_lock = list(/datum/species/unggoy)
	products = list(\
	/obj/item/weapon/storage/box/large/equipment_box/unggoy_standard = 40,
	/obj/item/weapon/storage/box/large/equipment_box/unggoy_assault = 15,
	/obj/item/weapon/storage/box/large/equipment_box/unggoy_assault_plas = 5,
	/obj/item/weapon/storage/box/large/equipment_box/unggoy_heavy = 2,
	/obj/item/weapon/storage/box/large/equipment_box/unggoy_mg = 2
	)

/obj/machinery/vending/armory/equip_req/cov/kigyar
	vendor_faction = "Covenant"
	species_lock = list(/datum/species/kig_yar,/datum/species/kig_yar_skirmisher)
	products = list(\
	/obj/item/weapon/storage/box/large/equipment_box/kigyar_sniper = 3,
	/obj/item/weapon/storage/box/large/equipment_box/kigyar_carbine_sharpshooter = 2,
	/obj/item/weapon/storage/box/large/equipment_box/kigyar_needle_sharpshooter = 2,
	/obj/item/weapon/storage/box/large/equipment_box/kigyar_standard = 40,
	/obj/item/weapon/storage/box/large/equipment_box/kigyar_assault = 15
	)

/obj/machinery/vending/armory/equip_req/cov/sangheili
	vendor_faction = "Covenant"
	species_lock = list(/datum/species/sangheili)
	products = list(\
	/obj/item/weapon/storage/box/large/equipment_box/elite_sniper = 1,
	/obj/item/weapon/storage/box/large/equipment_box/elite_carbine_sharpshooter = 4,
	/obj/item/weapon/storage/box/large/equipment_box/elite_needle_sharpshooter = 4,
	/obj/item/weapon/storage/box/large/equipment_box/elite_standard = 40,
	/obj/item/weapon/storage/box/large/equipment_box/elite_assault = 10,
	/obj/item/weapon/storage/box/large/equipment_box/elite_concussion_rifle = 4,
	/obj/item/weapon/storage/box/large/equipment_box/elite_heavy = 2,
	/obj/item/weapon/storage/box/large/equipment_box/elite_lmg = 3
	)

/obj/machinery/vending/armory/equip_req/cov/jiralhanae
	vendor_faction = "Covenant"
	species_lock = list(/datum/species/brutes)
	products = list(\
	/obj/item/weapon/storage/box/large/equipment_box/brute_standard = 40,
	/obj/item/weapon/storage/box/large/equipment_box/brute_assault = 10,
	/obj/item/weapon/storage/box/large/equipment_box/brute_grenadier = 2,
	/obj/item/weapon/storage/box/large/equipment_box/brute_mg = 2
	)
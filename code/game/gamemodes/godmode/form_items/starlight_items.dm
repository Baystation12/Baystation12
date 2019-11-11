/obj/item/clothing/ring/aura_ring
	var/obj/aura/granted_aura

/obj/item/clothing/ring/aura_ring/equipped(var/mob/living/L, var/slot)
	..()
	if(granted_aura && slot == slot_gloves)
		L.add_aura(granted_aura)

/obj/item/clothing/ring/aura_ring/dropped(var/mob/living/L)
	..()
	if(granted_aura)
		L.remove_aura(granted_aura)

/obj/item/clothing/ring/aura_ring/Destroy()
	QDEL_NULL(granted_aura)
	. = ..()

/obj/item/clothing/ring/aura_ring/talisman_of_starborn
	name = "Talisman of the Starborn"
	desc = "This ring seems to shine with more light than is put on it."
	icon_state = "starring"

/obj/item/clothing/ring/aura_ring/talisman_of_starborn/New()
	..()
	granted_aura = new /obj/aura/starborn()

/obj/item/clothing/ring/aura_ring/talisman_of_blueforged
	name = "Talisman of the Blueforged"
	desc = "The gem on this ring is quite peculiar..."
	icon_state = "bluering"

/obj/item/clothing/ring/aura_ring/talisman_of_blueforged/New()
	..()
	granted_aura = new /obj/aura/blueforge_aura()

/obj/item/clothing/ring/aura_ring/talisman_of_shadowling
	name = "Talisman of the Shadowling"
	desc = "If you weren't looking at this, you probably wouldn't have noticed it."
	icon_state = "shadowring"

/obj/item/clothing/ring/aura_ring/talisman_of_shadowling/New()
	..()
	granted_aura = new /obj/aura/shadowling_aura()

/obj/item/clothing/suit/armor/sunsuit
	name = "knight's armor"
	desc = "Now, you can be the knight in shining armor you've always wanted to be. With complementary sun insignia."
	icon_state = "star_champion"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/head/helmet/sunhelm
	name = "knight's helm"
	desc = "It's a shiny metal helmet. It looks ripped straight out of the Dark Ages, actually."
	icon_state = "star_champion"
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/suit/armor/sunrobe
	name = "oracle's robe"
	desc = "The robes of a priest. One that praises the sun, apparently. Well, it certainly reflects light well."
	icon_state = "star_oracle"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/suit/armor/sunrobe/Initialize()
	. = ..()
	set_light(0.3, 0.1, 4, 2)

/obj/item/clothing/suit/space/shadowsuit
	name = "traitor's cloak"
	desc = "There is absolutely nothing visible through the fabric. The shadows stick to your skin when you touch it."
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	min_pressure_protection = 0
	icon_state = "star_traitor"

/obj/item/clothing/head/helmet/space/shadowhood
	name = "traitor's hood"
	desc = "No light can pierce this hood. It's unsettling."
	icon_state = "star_traitor"
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/weapon/material/knife/ritual/shadow
	name = "black death"
	desc = "An obsidian dagger. The singed remains of a green cloth are wrapped around the 'handle.'"
	force_divisor = 0.3
	var/charge = 5

/obj/item/weapon/material/knife/ritual/shadow/apply_hit_effect(var/mob/living/target, var/mob/living/user, var/hit_zone)
	. = ..()
	if(charge)
		if(target.getBruteLoss() > 15)
			var/datum/reagents/R = target.reagents
			if(!R)
				return
			R.add_reagent(/datum/reagent/toxin/bromide, 5)
			new /obj/effect/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "fire_goon")
			charge--
	else
		user.adjustFireLoss(5)
		if(prob(5))
			to_chat(user, "<span class='warning'>\The [src] appears to be out of power!</span>")
		new /obj/effect/temporary(get_turf(user),3, 'icons/effects/effects.dmi', "fire_goon")

/obj/item/weapon/gun/energy/staff/beacon
	name = "holy beacon"
	desc = "Look closely into its crystal; there's a miniature sun. Or maybe that's just some fancy LEDs. Either way, it looks thoroughly mystical."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "starstaff"
	self_recharge = 0
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/flash
	required_antag_type = MODE_GODCULTIST

/obj/item/weapon/material/sword/blazing
	name = "blazing blade"
	damtype = BURN
	icon_state = "fireblade"
	item_state = "fireblade"
	applies_material_colour = FALSE
	var/last_near_structure = 0
	var/mob/living/deity/linked

/obj/item/weapon/material/sword/blazing/Initialize(var/maploading, var/material, var/deity)
	. = ..()
	START_PROCESSING(SSobj, src)
	linked = deity

/obj/item/weapon/material/sword/blazing/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/material/sword/blazing/Process()
	if(!linked || last_near_structure + 10 SECONDS > world.time)
		return

	if(linked.near_structure(src,1))
		if(last_near_structure < world.time - 30 SECONDS)
			to_chat(loc, "<span class='notice'>\The [src] surges with power anew!</span>")
		last_near_structure = world.time
	else
		if(last_near_structure < world.time - 30 SECONDS) //If it has been at least 30 seconds.
			if(prob(5))
				to_chat(loc, "<span class='warning'>\The [src] begins to fade, its power dimming this far away from a shrine.</span>")
		else if(last_near_structure + 1800 < world.time)
			visible_message("<span class='warning'>\The [src] disintegrates into a pile of ash!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(src))
			qdel(src)

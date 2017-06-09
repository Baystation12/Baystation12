/obj/item/clothing/gloves/ring
	name = "ring"
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/clothing/rings.dmi'
	item_icons = null
	body_parts_covered = null
	gender = NEUTER
	species_restricted = list("exclude",SPECIES_DIONA)

/obj/item/clothing/gloves/ring/attackby(obj/item/weapon/W, mob/user)
	return

/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src].</span>","<span class='warning'>You get down on one knee, presenting \the [src].</span>")

/obj/item/clothing/gloves/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon_state = "cti-grad"

/obj/item/clothing/gloves/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon_state = "mariner-grad"

/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/gloves/ring/seal/secgen
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-secgen"

/obj/item/clothing/gloves/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-masonic"

/obj/item/clothing/gloves/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-signet"
	var/nameset = 0

/obj/item/clothing/gloves/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>The [src] has already been claimed!</span>")
		return

	nameset = 1
	to_chat(user, "<span class='notice'>You claim the [src] as your own!</span>")
	name = "[user]'s signet ring"
	desc = "A signet ring belonging to [user], for when you're too sophisticated to sign letters."


/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"
	var/material/material

/obj/item/clothing/gloves/ring/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/gloves/ring/material/get_material()
	return material

/obj/item/clothing/gloves/ring/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/gloves/ring/material/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/clothing/gloves/ring/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/gloves/ring/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/gloves/ring/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/gloves/ring/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/gloves/ring/material/bronze/New(var/newloc)
	..(newloc, "bronze")

/obj/item/clothing/gloves/ring/material/glass/New(var/newloc)
	..(newloc, "glass")

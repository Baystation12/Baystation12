/obj/item/clothing/accessory/bowtie/var/untied


/obj/item/clothing/accessory/bowtie/on_attached(obj/item/clothing/C, mob/user)
	..()
	parent.verbs += /obj/item/clothing/accessory/bowtie/verb/toggle_bowtie


/obj/item/clothing/accessory/bowtie/on_removed(mob/user)
	if (parent)
		parent.verbs -= /obj/item/clothing/accessory/bowtie/verb/toggle_bowtie
	..()


/obj/item/clothing/accessory/bowtie/verb/toggle_bowtie()
	set name = "Toggle Bowtie"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/bowtie/B = src
	if (!istype(B))
		B = locate() in src
		if (!B)
			return
	B.untied = !B.untied
	to_chat(usr, "You [B.untied ? "untie" : "tie"] your [B.name].")
	B.queue_icon_update()


/obj/item/clothing/accessory/bowtie/on_update_icon()
	icon_state = "[initial(icon_state)][untied?"_untied":""]"


/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon_state = "bowtie"


/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon_state = "bowtie_ugly"

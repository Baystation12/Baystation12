/obj/item/clothing/accessory/long
	icon_state = "longtie"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	color = "#123c5a"

/obj/item/clothing/accessory/red
	name = "red tie"
	color = "#800000"

/obj/item/clothing/accessory/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/red_long
	name = "red long tie"
	icon_state = "longtie"
	color = "#a02929"

/obj/item/clothing/accessory/black
	name = "black tie"
	color = "#ffffff"

/obj/item/clothing/accessory/yellow
	name = "yellow tie"
	icon_state = "longtie"
	color = "#c4c83d"

/obj/item/clothing/accessory/navy
	name = "navy tie"
	color = "#182e44"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/brown
	name = "brown tie"
	icon_state = "longtie"
	color = "#b18345"

/obj/item/clothing/accessory/nt
	name = "\improper NanoTrasen tie with a clip"
	desc = "A neosilk clip-on tie. This one has a clip on it that proudly bears 'NT' on it."
	icon_state = "ntcliptie"

//Bowties
/obj/item/clothing/accessory/bowtie
	var/icon_tied
/obj/item/clothing/accessory/bowtie/New()
	icon_tied = icon_tied || icon_state
	..()

/obj/item/clothing/accessory/bowtie/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/bowtie/verb/toggle

/obj/item/clothing/accessory/bowtie/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/bowtie/verb/toggle
	..()

/obj/item/clothing/accessory/bowtie/verb/toggle()
	set name = "Toggle Bowtie"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0

	var/obj/item/clothing/accessory/bowtie/H = null
	if (istype(src, /obj/item/clothing/accessory/bowtie))
		H = src
	else
		H = locate() in src

	if(H)
		H.do_toggle(usr)

/obj/item/clothing/accessory/bowtie/proc/do_toggle(user)
	if(icon_state == icon_tied)
		to_chat(usr, "You untie [src].")
	else
		to_chat(usr, "You tie [src].")

	update_icon()

/obj/item/clothing/accessory/bowtie/update_icon()
	if(icon_state == icon_tied)
		icon_state = "[icon_tied]_untied"
	else
		icon_state = icon_tied

/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon_state = "bowtie"

/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon_state = "bowtie_ugly"

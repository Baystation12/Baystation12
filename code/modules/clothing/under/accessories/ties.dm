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
	color = "#1e1e1e"

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

/obj/item/clothing/accessory/corptie
	name = "corporate tie"
	desc = "A green neosilk clip-on tie. This one has a clip on it that proudly bears a corporate logo."
	icon_state = "cliptie"

/obj/item/clothing/accessory/corptie/nanotrasen
	name = "\improper NanoTrasen tie"
	desc = "A red neosilk clip-on tie. This one has a clip on it that proudly bears the NanoTrasen logo."
	icon_state = "cliptie_nt"

/obj/item/clothing/accessory/corptie/heph
	name = "\improper Hephaestus Industries tie"
	desc = "A cyan neosilk clip-on tie. This one has a clip on it that proudly bears the Hephaestus Industries logo."
	icon_state = "cliptie_heph"

/obj/item/clothing/accessory/corptie/zeng
	name = "\improper Zeng-Hu tie"
	desc = "A gold neosilk clip-on tie. This one has a clip on it that proudly bears the Zeng-Hu Pharmaceuticals logo."
	icon_state = "cliptie_zeng"

//Bowties
/obj/item/clothing/accessory/bowtie
	var/tied = TRUE

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
	if(!istype(src)) // This verb is given to our holding clothing item and called on it, so src might not be the bowtie.
		for(var/obj/item/clothing/accessory/bowtie/tie in accessories)
			src = tie
			break
	if(!istype(src))
		return
	do_toggle(usr)

/obj/item/clothing/accessory/bowtie/proc/do_toggle(mob/user)
	user.visible_message("\The [user] [tied ? "un" : ""]ties \the [src].", "You [tied ? "un" : ""]tie \the [src].")
	tied = !tied
	update_icon()

/obj/item/clothing/accessory/bowtie/on_update_icon()
	if(tied)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_untied"

/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon_state = "bowtie"

/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon_state = "bowtie_ugly"

/obj/item/clothing/accessory/ftupin
	name = "\improper Free Trade Union pin"
	desc = "A pin denoting employment in the Free Trade Union, a trading company."
	icon_state = "ftupin"
	high_visibility = 1
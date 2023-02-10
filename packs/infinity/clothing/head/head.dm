/obj/item/clothing/head/soft/darkred
	name = "darkred cap"
	desc = "It's a peaked hat in a tasteless darkred color."
	icon = 'packs/infinity/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	icon_state = "darkred_cap"

/obj/item/clothing/head/kitty/tailless
	name = "tailless kitty ears"
	desc = "The fur feels.....a little bit realistic."
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	item_state = "kitty_tailless"

/obj/item/clothing/head/kitty/fake
	name = "fake kitty ears"
	desc = "The fur feels.....a bit too realistic."
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	item_state = "kitty_tailless"
	body_parts_covered = 0

/obj/item/clothing/head/kitty/fake/on_update_icon(var/mob/living/carbon/human/user)
	if(!istype(user)) return
	var/icon/ears = new/icon("icon" = 'packs/infinity/icons/mob/onmob/onmob_head.dmi', "icon_state" = "kitty")
	//ears.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)

	var/icon/earbit = new/icon("icon" = 'icons/mob/onmob/onmob_head.dmi', "icon_state" = "kittyinner")
	ears.Blend(earbit, ICON_OVERLAY)

/obj/item/clothing/head/helmet/marine
	name = "\improper combat helmet"
	desc = "A helmet with 'MARINE CORPS' printed on the back in red lettering."
	icon_state = "helmet_nt"

/obj/item/clothing/head/soft/scp_cap
	name = "SCP guard cap"
	desc = "A simple security dark grey cap.\nThis one has SCP tag, GGS's organization of NT asset protection."
	icon = 'packs/infinity/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	icon_state = "scp_cap"

/obj/item/clothing/head/christhat
	name = "christ's hat"
	desc = "Ho ho ho. Merrry X-mas! (if use it, will show/hide hair)."
	icon = 'packs/infinity/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	icon_state = "christ_hat"
	item_state = "christ_hat"
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD

	sprite_sheets = list(
		SPECIES_RESOMI = 'packs/infinity/icons/mob/species/resomi/onmob_head_resomi.dmi',
		//SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head_infinity.dmi', TODO: SIERRA PORT
		)

/obj/item/clothing/head/christhat/attack_self(mob/user)
	flags_inv ^= BLOCKHEADHAIR
	to_chat(user, "<span class='notice'>[src] will now [flags_inv & BLOCKHEADHAIR ? "hide" : "show"] hair.</span>")
	..()

/obj/item/clothing/head/anime_band
	name = "white hair band"
	desc = "Just a nice looking shoes."
	icon = 'packs/infinity/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	icon_state = "anime_white"
	item_state = "anime_white"

/obj/item/clothing/head/anime_band/blue
	name = "blue hair band"
	desc = "Just a nice looking dress."
	icon = 'packs/infinity/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'packs/infinity/icons/mob/onmob/onmob_head.dmi')
	icon_state = "anime_blue"
	item_state = "anime_blue"

/obj/item/clothing/head/hijab
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	body_parts_covered = HEAD

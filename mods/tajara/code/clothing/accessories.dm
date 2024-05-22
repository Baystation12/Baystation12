/obj/item/clothing/glasses/tajblind
	name = "embroidered veil"
	desc = "An classic Ahdominian made veil that allows the user to see while obscuring their eyes."
	icon_state = "tajblind"
	item_state = "tajblind"
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	prescription = 5
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/health/tajblind
	name = "lightweight veil"
	desc = "An classic Ahdominian made veil that allows the user to see while obscuring their eyes. This one has an installed medical HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajblind_med"
	item_state = "tajblind_med"
	off_state = "tajblind_med"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/science/tajblind
	name = "science veil"
	desc = "An classic Ahdominian made veil that allows the user to see while obscuring their eyes. This one has an in-built science HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajblind_sci"
	item_state = "tajblind_sci"
	prescription = 5
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/security/prot/sunglasses/tajblind
	name = "sleek veil"
	desc = "An classic Ahdominian made veil that allows the user to see while obscuring their eyes. This one has an in-built security HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajblind_sec"
	item_state = "tajblind_sec"
	prescription = 5
	body_parts_covered = EYES

/obj/item/clothing/glasses/meson/prescription/tajblind
	name = "industrial veil"
	desc = "An classic Ahdominian made veil that allows the user to see while obscuring their eyes. This one has installed mesons."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	off_state = "tajblind_meson"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/health/tajvisor
	name = "lightweight visor"
	desc = "A modern Ahdominian made visor that allows the user to see while obscuring their eyes. This one has an installed medical HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajvisor_med"
	item_state = "tajvisor_med"
	off_state = "tajvisor_med"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/science/tajvisor
	name = "lightweight visor"
	desc = "A modern Ahdominian made visor that allows the user to see while obscuring their eyes. This one has an installed science HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajvisor_sci"
	item_state = "tajvisor_sci"
	off_state = "tajvisor_sci"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/security/prot/sunglasses/tajvisor
	name = "sleek visor"
	desc = "A modern Ahdominian made visor that allows the user to see while obscuring their eyes. This one has an in-built security HUD."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajvisor_sec"
	item_state = "tajvisor_sec"
	prescription = 5
	body_parts_covered = EYES

/obj/item/clothing/glasses/meson/prescription/tajvisor
	name = "industrial visor"
	desc = "A modern Ahdominian made visor that allows the user to see while obscuring their eyes. This one has installed mesons."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajvisor_mes"
	item_state = "tajvisor_mes"
	off_state = "tajvisor_mes"
	body_parts_covered = EYES

/obj/item/clothing/glasses/meson/prescription/tajvisor/hybrid
	name = "engineering visor"
	desc = "A modern Ahdominian made visor that allows the user to see while obscuring their eyes. This one has installed as the mesons, and the add-on shielding module."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	icon_state = "tajvisor_mes"
	item_state = "tajvisor_mes"
	off_state = "tajvisor_mes"
	body_parts_covered = EYES
	var/mode = 1

/obj/item/clothing/glasses/meson/prescription/tajvisor/hybrid/attack_self(mob/user)
	if(!toggleable || user.incapacitated())
		return
	switch(mode)
		if(1)
			flash_protection = FLASH_PROTECTION_MAJOR
			tint = TINT_HEAVY
			to_chat(user, "You switch \the [src] to welding protection mode.")
			mode = 2
			active = TRUE
			return
		if(2)
			flash_protection = FLASH_PROTECTION_NONE
			vision_flags = SEE_TURFS
			tint = TINT_NONE
			to_chat(user, "You switch \the [src] to meson mode.")
			mode = 3
			active = TRUE
			user.update_inv_glasses()
			return
		if(3)
			vision_flags = null
			to_chat(user, "You switch off \the [src].")
			mode = 1
			active = FALSE
			user.update_inv_glasses()
			return

/obj/item/clothing/glasses/tajvisor
	name = "tajaran master visor object, not used"
	desc = "An Ahdominian made eyeguard."
	item_icons = list(slot_glasses_str = 'mods/tajara/icons/onmob_eyes.dmi')
	icon = 'mods/tajara/icons/obj_eyes.dmi'
	body_parts_covered = EYES

/obj/item/clothing/glasses/tajvisor/a
	name = "visor"
	icon_state = "tajvisor_a"
	item_state = "tajvisor_a"

/obj/item/clothing/glasses/tajvisor/b
	name = "visor"
	icon_state = "tajvisor_b"
	item_state = "tajvisor_b"

/obj/item/clothing/glasses/tajvisor/c
	name = "visor"
	icon_state = "tajvisor_c"
	item_state = "tajvisor_c"

/obj/item/clothing/glasses/tajvisor/d
	name = "visor"
	icon_state = "tajvisor_d"
	item_state = "tajvisor_d"

/obj/item/clothing/glasses/tajvisor/d
	name = "visor"
	icon_state = "tajvisor_d"
	item_state = "tajvisor_d"

/obj/item/clothing/glasses/tajvisor/e
	name = "visor"
	icon_state = "tajvisor_e"
	item_state = "tajvisor_e"

/obj/item/clothing/glasses/tajvisor/f
	name = "visor"
	icon_state = "tajvisor_f"
	item_state = "tajvisor_f"

/obj/item/clothing/glasses/tajvisor/g
	name = "visor"
	icon_state = "tajvisor_g"
	item_state = "tajvisor_g"


// Tajaran clothing
/datum/gear/passport/tajara
	display_name = "(Tajara) passport"
	path = /obj/item/passport/xeno/tajara
	whitelisted = list(SPECIES_TAJARA)
	flags = 0
	sort_category = "Xenowear"
	custom_setup_proc = TYPE_PROC_REF(/obj/item/passport, set_info)
	cost = 0

/obj/item/passport/xeno/tajara
	name = "\improper Tajaran passport"
	icon = 'maps/sierra/icons/obj/passports.dmi'
	icon_state = "passport_taj"
	desc = "A passport that apparently belongs to the Tajara."

// Pre-modified gloves

/datum/gear/gloves/dress/modified
	display_name = "modified gloves, dress"
	path = /obj/item/clothing/gloves/color/white/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_YEOSA)

/obj/item/clothing/under/taj_old_uniform
	desc = "A loose-fitting uniform with lots of pockets made of canvas or similar material, very comfortable. Widely used by tajaran revolutionaries during slave's uprising, remained as favored uniform for a short period of time after the uprising and now just a reminder of dark age or a reason for pride. There is a tailhole on the back of the pants!"
	name = "vintage uniform"
	worn_state = "taj_old_uniform"
	icon_state = "taj_old_uniform"
	item_state = "taj_old_uniform"
	icon = 'mods/tajara/icons/under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/tajara/icons/onmob_under.dmi')

/obj/item/clothing/under/taj_new_fatigues
	desc = "A tight-fitting union suit made of modern synthetic materials and features CCA markings, sleek. This uniform is one of the numerous variants, but the layout is somewhat similar. This one is provided by CCA Armed Forces for numerous PMC's when they sent over CCA control. There is a tailhole on the back of the pants!"
	name = "CCA fatigues"
	worn_state = "taj_new_fatigues"
	icon_state = "taj_new_fatigues"
	item_state = "taj_new_fatigues"
	icon = 'mods/tajara/icons/under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/tajara/icons/onmob_under.dmi')


/obj/item/clothing/accessory/scarf/tajaran
	name = "tua-tari scarf"
	desc = "A light and soft scarf, very long and wide. You also may rise it to hide your person..."
	icon = 'mods/tajara/icons/obj_accessories.dmi'
	icon_state = "tajneck"
	accessory_icons = list(slot_w_uniform_str = 'mods/tajara/icons/onmob_accessories.dmi', slot_wear_suit_str = 'mods/tajara/icons/onmob_accessories.dmi')
	item_icons = list(slot_wear_mask_str = 'mods/tajara/icons/onmob_accessories.dmi')
	body_parts_covered = 0
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	slot_flags = SLOT_MASK | SLOT_TIE
	var/lowered_icon_state = "tajneck"
	var/rised_icon_state = "tajmask"

/obj/item/clothing/accessory/scarf/tajaran/attack_self(mob/user)
	if(body_parts_covered >= FACE)
		body_parts_covered &= ~FACE
		icon_state = lowered_icon_state
		to_chat(user, SPAN_NOTICE("You lowered your scarf."))
	else
		body_parts_covered |= FACE
		icon_state = rised_icon_state
		to_chat(user, SPAN_NOTICE("You rised your scarf. Let's rrrobe someone!"))

/obj/item/clothing/accessory/amulet
	name = "talisman"
	desc = "A simple metal amulet with runes, according to the primitive beliefs of Tajara, able to protect them from evil spirits."
	icon_state = "taj_amulet"
	icon = 'mods/tajara/icons/obj_accessories.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_TIE

/* todo
Сделать, чтобы блокировало мелкое воздействие - чтение мыслей, слабое лечение. Сейчас оно высасывае псионику \
со своего тайла - можно контрить псиоников, удерживая.
/obj/item/clothing/accessory/amulet/disrupts_psionics()
	visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
	playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
	QDEL_IN(src, 0)
	return src
*/

/obj/item/clothing/accessory/amulet/medium
	name = "amulet"
	desc = "An expensive-looking amulet, interspersed with unknown crystals and runes, according to the primitive beliefs of Tajara, able to protect them from evil spirits."
	icon_state = "taj_amulet_2"

/* todo
/obj/item/clothing/accessory/amulet/medium/disrupts_psionics()
	if(prob(20))
		visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
		playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
		QDEL_IN(src, 0)
	return src
*/

/obj/item/clothing/accessory/amulet/strong
	name = "averter"
	desc = "Amulet of Tajara, created from the primordial stone according to their belief, able to protect according to their primitive religion from evil spirits and their servants. The runes on the amulet are etched with acid."
	icon_state = "taj_amulet_3"

/* todo
/obj/item/clothing/accessory/amulet/strong/disrupts_psionics()
	visible_message("<span class='rose'>The [src] radiated faint waves of heat and light, protecting the wearer from psionic influence...</span>")
	if(prob(0.01))
		visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
		playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
		QDEL_IN(src, 0)
	return src
*/



/* todo
Сделать, чтобы блокировало мелкое воздействие - чтение мыслей, слабое лечение. Сейчас оно высасывае псионику \
со своего тайла - можно контрить псиоников, удерживая.
/obj/item/clothing/accessory/amulet/disrupts_psionics()
	visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
	playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
	QDEL_IN(src, 0)
	return src
*/

/obj/item/clothing/accessory/amulet/medium
	name = "amulet"
	desc = "An expensive-looking amulet, interspersed with unknown crystals and runes, according to the primitive beliefs of Tajara, able to protect them from evil spirits."
	icon_state = "taj_amulet_2"

/obj/item/clothing/accessory/amulet/strong
	name = "averter"
	desc = "Amulet of Tajara, created from the primordial stone according to their belief, able to protect according to their primitive religion from evil spirits and their servants. The runes on the amulet are etched with acid."
	icon_state = "taj_amulet_3"


/datum/gear/head/zhan_scarf/neck
	display_name = "(Tajara) Tua-Tari scarf"
	path = /obj/item/clothing/accessory/scarf/tajaran
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/tajara
	display_name = "(Tajara) vintage uniform"
	path = /obj/item/clothing/under/taj_old_uniform
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/obj/item/clothing/suit/storage/taj_overcoat
	name = "vintage tajaran overcoat"
	desc = "A lengthy coat made of wooly, but sturdy and hydrophobic material. Designed mostly to protect against strong wind and other harsh weather conditions on Ahdomai, when having fur is not enough. There is a weird U-shape hole on the back of the coat for tail!"
	icon_state = "taj_overcoat"
	item_state = "taj_overcoat"
	icon = 'mods/tajara/icons/suit.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/tajara/icons/onmob_suit.dmi')
	species_restricted = list(SPECIES_TAJARA)

/datum/gear/uniform/tajara/taj_new_fatigues
	display_name = "(Tajara) CCA fatigues"
	path = /obj/item/clothing/under/taj_new_fatigues

/datum/gear/suit/tajara
	display_name = "(Tajara) vintage tajaran overcoat"
	path = /obj/item/clothing/suit/storage/taj_overcoat
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/shoes/tajara
	display_name = "(Tajara) vintage boots"
	path = /obj/item/clothing/shoes/taj_old_shoes
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/shoes/tajara/taj_new_shoes
	display_name = "(Tajara) military boots"
	path = /obj/item/clothing/shoes/taj_new_shoes

/datum/gear/shoes/tajara/taj_new_shoes_cut
	display_name = "(Tajara) toeless military  boots"
	path = /obj/item/clothing/shoes/taj_new_shoes_cut

/datum/gear/shoes/tajara/taj_old_shoes_cut
	display_name = "(Tajara) toeless vintage boots"
	path = /obj/item/clothing/shoes/taj_old_shoes_cut


/datum/gear/accessory/amulet
	display_name = "(Tajara) talisman selection"
	path = /obj/item/clothing/accessory/amulet
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	flags = GEAR_HAS_TYPE_SELECTION


//Taj clothing.

/obj/item/clothing/suit/xeno/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS

/obj/item/clothing/head/xeno/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/shoes/sandal/xeno/caligae
	name = "caligae"
	desc = "The standard Tajaran footwear loosly resembles the Roman Caligae. Made of leather and rubber, their unique design allows for improved traction and protection. They don't look like they would fit on anyone but a Tajara."
	icon_state = "caligae"
	item_state = "caligae"
	body_parts_covered = FEET|LEGS
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/sandal/xeno/caligae/white
	desc = "The standard Tajaran footwear loosly resembles the Roman Caligae. Made of leather and rubber, their unique design allows for improved traction and protection. They don't look like they would fit on anyone but a Tajara. /This one has a white covering."
	icon_state = "whitecaligae"
	item_state = "whitecaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/grey
	desc = "The standard Tajaran footwear loosly resembles the Roman Caligae. Made of leather and rubber, their unique design allows for improved traction and protection. They don't look like they would fit on anyone but a Tajara. /This one has a grey covering."
	icon_state = "greycaligae"
	item_state = "greycaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/black
	desc = "The standard Tajaran footwear loosly resembles the Roman Caligae. Made of leather and rubber, their unique design allows for improved traction and protection. They don't look like they would fit on anyone but a Tajara. /This one has a black covering."
	icon_state = "blackcaligae"
	item_state = "blackcaligae"

/obj/item/clothing/accessory/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	icon_state = "gruntcape"
	slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/accessory/shouldercape/grunt
	name = "modir cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "gruntcape" // Again, just in case it is changed.

/obj/item/clothing/accessory/shouldercape/officer
	name = "nraji cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon_state = "officercape"

/obj/item/clothing/accessory/shouldercape/command
	name = "hejun cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying positions within the Tajaran govenment. An ornate runed design has been woven into the fabric of it"
	icon_state = "commandcape"

/obj/item/clothing/accessory/shouldercape/general
	name = "ginajir cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care. This cape can only be found within the Tajaran elite."
	icon_state = "leadercape"



// Taj clothing
/datum/gear/eyes/medical/tajblind
	display_name = "(Tajara) veil, medical"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/medical/tajblind/New()
	return

/datum/gear/eyes/meson/tajblind
	display_name = "(Tajara) veil, industrial"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/meson/tajblind/New()
	return

/datum/gear/eyes/sciencegoggles_tajblind
	display_name = "(Tajara) veil, science "
	path = /obj/item/clothing/glasses/hud/science/tajblind
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/security/tajblind
	display_name = "(Tajara) veil, sleek"
	path = /obj/item/clothing/glasses/hud/security/prot/sunglasses/tajblind
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/security/tajblind/New()
	return

/datum/gear/eyes/visors
	display_name = "(Tajara) visor selection"
	path = /obj/item/clothing/glasses/tajvisor
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_TAJARA)
	cost = 1

/datum/gear/eyes/visors/New()
	..()
	var/visors = list()
	visors["visor type-A (Tajara)"] = /obj/item/clothing/glasses/tajvisor/a
	visors["visor type-B (Tajara)"] = /obj/item/clothing/glasses/tajvisor/b
	visors["visor type-C (Tajara)"] = /obj/item/clothing/glasses/tajvisor/c
	visors["visor type-D (Tajara)"] = /obj/item/clothing/glasses/tajvisor/d
	visors["visor type-E (Tajara)"] = /obj/item/clothing/glasses/tajvisor/e
	visors["visor type-F (Tajara)"] = /obj/item/clothing/glasses/tajvisor/f
	visors["visor type-G (Tajara)"] = /obj/item/clothing/glasses/tajvisor/g
	gear_tweaks += new/datum/gear_tweak/path(visors)

/datum/gear/eyes/sciencegoggles_tajvisor
	display_name = "(Tajara) visor, science "
	path = /obj/item/clothing/glasses/hud/science/tajvisor
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/medical/tajvisor
	display_name = "(Tajara) visor, medical"
	path = /obj/item/clothing/glasses/hud/health/tajvisor
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/medical/tajvisor/New()
	return

/datum/gear/eyes/security/tajvisor
	display_name = "(Tajara) visor, security"
	path = /obj/item/clothing/glasses/hud/security/prot/sunglasses/tajvisor
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/security/tajvisor/New()
	return

/datum/gear/eyes/meson/tajvisor
	display_name = "(Tajara) visor, industrial"
	path = /obj/item/clothing/glasses/meson/prescription/tajvisor
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1

/datum/gear/eyes/meson/tajvisor/New()
	return

/datum/gear/eyes/meson/tajvisor/hybr
	display_name = "(Tajara) visor, engineering"
	path = /obj/item/clothing/glasses/meson/prescription/tajvisor/hybrid
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 3

/datum/gear/shoes/caligae
	display_name = "(Tajara) caligae"
	path = /obj/item/clothing/shoes/sandal/xeno/caligae
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/shoes/caligae/New()
	..()
	var/caligae = list()
	caligae["no sock"] = /obj/item/clothing/shoes/sandal/xeno/caligae
	caligae["black sock"] = /obj/item/clothing/shoes/sandal/xeno/caligae/black
	caligae["grey sock"] = /obj/item/clothing/shoes/sandal/xeno/caligae/grey
	caligae["white sock"] = /obj/item/clothing/shoes/sandal/xeno/caligae/white
	gear_tweaks += new/datum/gear_tweak/path(caligae)

/datum/gear/head/zhan_scarf
	display_name = "(Tajara) Zhan headscarf"
	path = /obj/item/clothing/head/xeno/scarf
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/accessory/capes
	display_name = "(Tajara) shoulder capes"
	path = /obj/item/clothing/accessory/shouldercape
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/accessory/capes/New()
	..()
	var/capes = list()
	capes["simple cape"] = /obj/item/clothing/accessory/shouldercape/grunt
	capes["decorated cape"] = /obj/item/clothing/accessory/shouldercape/officer
	capes["government cape"] = /obj/item/clothing/accessory/shouldercape/command
	gear_tweaks += new/datum/gear_tweak/path(capes)

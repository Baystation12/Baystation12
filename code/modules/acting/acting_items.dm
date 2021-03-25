/obj/machinery/acting/wardrobe
	name = "wardrobe dispenser"
	desc = "A machine that dispenses holo-clothing for those in need."
	icon = 'icons/obj/vending.dmi'
	icon_state = "cart"
	anchored = TRUE
	density = TRUE
	var/active = 1

/obj/machinery/acting/wardrobe/attack_hand(var/mob/user as mob)
	user.show_message("You push a button and watch patiently as the machine begins to hum.")
	if(active)
		active = 0
		spawn(30)
			new /obj/item/storage/backpack/chameleon/sydie_kit(src.loc)
			src.visible_message("\The [src] beeps, dispensing a small box onto the floor.", "You hear a beeping sound followed by a thumping noise of some kind.")
			active = 1

/obj/machinery/acting/changer
	name = "Quickee's Plastic Surgeon"
	desc = "For when you need to be someone else right now."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"
	anchored = TRUE
	density = TRUE

/obj/machinery/acting/changer/attack_hand(var/mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.change_appearance(APPEARANCE_COMMON, TRUE, state = GLOB.z_state)
		var/getName = sanitize(input(H, "Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
		if(getName)
			H.real_name = getName
			H.SetName(getName)
			H.dna.real_name = getName
			if(H.mind)
				H.mind.name = H.name

/obj/machinery/acting/changer/mirror
	name = "Mirror of Many Faces"
	desc = "For when you need to be someone else right now."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror_broke"
	anchored = TRUE
	density = FALSE

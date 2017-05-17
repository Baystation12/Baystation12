/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "wcoat"

/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon_state = "suspenders"

/obj/item/clothing/accessory/nt_tunic
	name = "\improper NanoTrasen tunic"
	desc = "A fashionable tunic that NanoTrasen gives to its lab workers."
	icon_state = "nttunic"

/obj/item/clothing/accessory/nt_tunic/exec
	name = "\improper NanoTrasen executive tunic"
	icon_state = "nttunicblack"

/obj/item/clothing/accessory/dashiki
	name = "black dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is green and black."
	icon_state = "dashiki"

/obj/item/clothing/accessory/dashiki/red
	name = "red dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is red."
	icon_state = "dashikired"

/obj/item/clothing/accessory/dashiki/blue
	name = "blue dashiki"
	desc = "An ornately embroidered pullover garmant sporting a v-shaped collar. This one is blue."
	icon_state = "dashikiblue"

/obj/item/clothing/accessory/thawb
	name = "thawb"
	desc = "A white, ankle-length robe designed to be cool in hot climates."
	icon_state = "thawb"

/obj/item/clothing/accessory/sherwani
	name = "sherwani"
	desc = "A long, coat-like frock with fancy embroidery on the cuffs and collar."
	icon_state = "sherwani"

/obj/item/clothing/accessory/qipao
	name = "qipao"
	desc = "A tight-fitting blouse with intricate designs of flowers embroidered on it."
	icon_state = "qipao"

/obj/item/clothing/accessory/ubac
	name = "black ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is black."
	icon_state = "ubacblack"

/obj/item/clothing/accessory/ubac/tan
	name = "tan ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is tan."
	icon_state = "ubactan"

/obj/item/clothing/accessory/ubac/green
	name = "green ubac"
	desc = "A flexible, close-fitting shirt with camouflage sleeves designed to be worn under combat equipment. This one is green."
	icon_state = "ubacgreen"

/obj/item/clothing/accessory/toggleable
	var/icon_closed
/obj/item/clothing/accessory/toggleable/New()
	if(!icon_closed)
		icon_closed = icon_state
	..()

/obj/item/clothing/accessory/toggleable/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/toggleable/verb/toggle

/obj/item/clothing/accessory/toggleable/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/verb/toggle
	..()

/obj/item/clothing/accessory/toggleable/verb/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0

	var/obj/item/clothing/accessory/toggleable/H = null
	if (istype(src, /obj/item/clothing/accessory/toggleable))
		H = src
	else
		H = locate() in src

	if(H)
		H.do_toggle(usr)
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/accessory/toggleable/proc/do_toggle(user)
	if(icon_state == icon_closed)
		icon_state = "[icon_closed]_open"
		to_chat(usr, "You unbutton [src].")
	else
		icon_state = icon_closed
		to_chat(usr, "You button up [src].")

	update_clothing_icon()	//so our overlays update

/obj/item/clothing/accessory/toggleable/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"

/obj/item/clothing/accessory/toggleable/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"

/obj/item/clothing/accessory/toggleable/tan_jacket/New()
	..()
	do_toggle()

/obj/item/clothing/accessory/toggleable/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/toggleable/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/toggleable/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/toggleable/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/toggleable/nanotrasen_jacket
	name = "\improper NanoTrasen suit jacket"
	desc = "A jacket that NanoTrasen has its executives wear."
	icon_state = "nt_jacket"

/obj/item/clothing/accessory/toggleable/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/ties.dmi')

/obj/item/clothing/accessory/toggleable/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/toggleable/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/toggleable/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon_state = "zhongshan"

/obj/item/clothing/accessory/toggleable/hawaii/random/New()
	..()
	if(prob(50))
		icon_state = "hawaii2"
		icon_closed = "hawaii2"
	color = color_rotation(rand(-11,12)*15)

/obj/item/clothing/accessory/toggleable/flannel
	name = "flannel shirt"
	desc = "A comfy, plaid flannel shirt."
	icon_state = "flannel"
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/accessory/toggleable/flannel/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/toggleable/flannel/verb/tuck
	has_suit.verbs += /obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves

/obj/item/clothing/accessory/toggleable/flannel/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/flannel/verb/tuck
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves
	..()

/obj/item/clothing/accessory/toggleable/flannel/do_toggle(user)
	if(buttoned == 0)
		buttoned = 1
		to_chat(usr, "You button your [src].")
	else
		buttoned = 0
		to_chat(usr, "You unbutton [src].")
	update_icon()

/obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves()
	set name = "Roll Flannel Sleeves"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0

	var/obj/item/clothing/accessory/toggleable/flannel/H = null
	if (istype(src, /obj/item/clothing/accessory/toggleable))
		H = src
	else
		H = locate() in src

	if(H.rolled == 0)
		H.rolled = 1
		to_chat(usr, "You roll up the sleeves of your [H].")
	else
		H.rolled = 0
		to_chat(usr, "You roll down the sleeves of your [H].")
	H.update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/toggleable/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	var/obj/item/clothing/accessory/toggleable/flannel/H = null
	if (istype(src, /obj/item/clothing/accessory/toggleable))
		H = src
	else
		H = locate() in src

	if(H.tucked == 0)
		H.tucked = 1
		to_chat(usr, "You tuck in your [H].")
	else
		H.tucked = 0
		to_chat(usr, "You untuck your [H].")
	H.update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/toggleable/flannel/update_icon()
	icon_state = initial(icon_state)
	if(rolled)
		icon_state += "r"
	if(tucked)
		icon_state += "t"
	if(buttoned)
		icon_state += "b"
	update_clothing_icon()

/obj/item/clothing/accessory/tangzhuang
	name = "tangzhuang jacket"
	desc = "A traditional Chinese coat tied together with straight, symmetrical knots."
	icon_state = "tangzhuang"  //This was originally intended to have the ability to roll sleeves. I can't into code. Will be done later (hopefully.)

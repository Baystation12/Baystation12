
/obj/item/clothing/suit/storage/colonel
	name = "colonels jacket"
	desc = "An authentic jacket worn by an infamous colonel."
	icon_state = "eros_colonel"
	item_state = "eros_colonel"



//Flannels and their verbs
/obj/item/clothing/suit/storage/flannel
	name = "Flannel shirt"
	desc = "A comfy, grey flannel shirt.  Unleash your inner hipster."
	icon_state = "eros_flannel"
	item_state_slots = list(slot_r_hand_str = "black_labcoat", slot_l_hand_str = "black_labcoat")
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/suit/storage/flannel/verb/roll_sleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	if(rolled == 0)
		rolled = 1
		usr << "<span class='notice'>You roll up the sleeves of your [src].</span>"
	else
		rolled = 0
		usr << "<span class='notice'>You roll down the sleeves of your [src].</span>"
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(tucked == 0)
		tucked = 1
		usr << "<span class='notice'>You tuck in your your [src].</span>"
	else
		tucked = 0
		usr << "<span class='notice'>You untuck your [src].</span>"
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/button()
	set name = "Toggle Shirt Buttons"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(buttoned == 0)
		buttoned = 1
		usr << "<span class='notice'>You unbutton your [src].</span>"
	else
		buttoned = 0
		usr<<"<span class='notice'>You button your [src].</span>"
	update_icon()

/obj/item/clothing/suit/storage/flannel/update_icon()
	icon_state = initial(icon_state)
	if(rolled)
		icon_state += "r"
	if(tucked)
		icon_state += "t"
	if(buttoned)
		icon_state += "b"
	update_clothing_icon()

/obj/item/clothing/suit/storage/flannel/red
	desc = "A comfy, red flannel shirt.  Unleash your inner hipster."
	icon_state = "eros_flannel_red"
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/obj/item/clothing/suit/storage/flannel/aqua
	desc = "A comfy, aqua flannel shirt.  Unleash your inner hipster."
	icon_state = "eros_flannel_aqua"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")

/obj/item/clothing/suit/storage/flannel/brown
	desc = "A comfy, brown flannel shirt.  Unleash your inner hipster."
	icon_state = "eros_flannel_brown"
	item_state_slots = list(slot_r_hand_str = "johnny", slot_l_hand_str = "johnny")


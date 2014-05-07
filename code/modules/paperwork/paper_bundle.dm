/obj/item/weapon/paper_bundle
	name = "paper bundle"
	gender = PLURAL
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = 1.0
	throw_range = 2
	throw_speed = 1
	layer = 4
	pressure_resistance = 1
	attack_verb = list("bapped")
	var/amount = 0 //Amount of items clipped to the paper
	var/page = 0


/obj/item/weapon/paper_bundle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = W
		src.add_item(P.icon_state)
		user << "<span class='notice'>You add [(P.name == "paper") ? "the paper" : P.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>"
		user.drop_from_inventory(P)
		P.loc = src
		if(istype(user,/mob/living/carbon/human))
			user:update_inv_l_hand()
			user:update_inv_r_hand()
	add_fingerprint(usr)
	return


/obj/item/weapon/paper_bundle/verb/rename()
	set name = "Rename bundle"
	set category = "Object"
	set src in usr

	var/n_name = copytext(sanitize(input(usr, "What would you like to label the bundle?", "Bundle Labelling", null)  as text), 1, MAX_NAME_LEN)
	if((loc == usr && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "paper")]"
	add_fingerprint(usr)
	return


/obj/item/weapon/paper_bundle/verb/remove_all()
	set name = "Loose bundle"
	set category = "Object"
	set src in usr

	usr << "<span class='notice'>You loosen the bundle.</span>"
	for(var/obj/O in src)
		O.loc = usr.loc
	usr.drop_from_inventory(src)
	if(istype(usr,/mob/living/carbon/human))
		usr:update_inv_l_hand()
		usr:update_inv_r_hand()
	del(src)
	return


/obj/item/weapon/paper_bundle/proc/add_item(state)
	amount++
	var/image/img = image('icons/obj/bureaucracy.dmi', state)
	img.pixel_x -= min(1*amount, 2)
	img.pixel_y -= min(1*amount, 2)
	pixel_x = min(0.5*amount, 1)
	pixel_y = min(  1*amount, 2)
	underlays += img
	return
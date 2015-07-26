/obj/item/weapon/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	throwforce = 1
	w_class = 3
	throw_speed = 3
	throw_range = 7
	pressure_resistance = 10
	layer = OBJ_LAYER - 0.1
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = new/list()	//List of papers put in the bin for reference.


/obj/item/weapon/paper_bin/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					user << "<span class='notice'>You try to move your [temp.name], but cannot!</span>"
					return

				user << "<span class='notice'>You pick up the [src].</span>"
				user.put_in_hands(src)

	return

/obj/item/weapon/paper_bin/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			user << "<span class='notice'>You try to move your [temp.name], but cannot!</span>"
			return
	var/response = ""
	if(!papers.len > 0)
		response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/weapon/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new /obj/item/weapon/paper
				if(Holiday == "April Fool's Day")
					if(prob(30))
						P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
						P.rigged = 1
						P.updateinfolinks()
			else if (response == "Carbon-Copy")
				P = new /obj/item/weapon/paper/carbon

		P.loc = user.loc
		user.put_in_hands(P)
		user << "<span class='notice'>You take [P] out of the [src].</span>"
	else
		user << "<span class='notice'>[src] is empty!</span>"

	add_fingerprint(user)
	return


/obj/item/weapon/paper_bin/attackby(obj/item/weapon/paper/i as obj, mob/user as mob)
	if(!istype(i))
		return

	user.drop_item()
	i.loc = src
	user << "<span class='notice'>You put [i] in [src].</span>"
	papers.Add(i)
	amount++


/obj/item/weapon/paper_bin/examine(mob/user)
	if(get_dist(src, user) <= 1)
		if(amount)
			user << "<span class='notice'>There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin.</span>"
		else
			user << "<span class='notice'>There are no papers in the bin.</span>"
	return


/obj/item/weapon/paper_bin/update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"

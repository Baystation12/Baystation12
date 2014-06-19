/obj/item/clothing/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	item_color = "bluetie"
	flags = FPRINT | TABLEPASS
	slot_flags = 0
	w_class = 2.0
	var/obj/item/clothing/under/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.

/obj/item/clothing/tie/New()
	..()
	inv_overlay = image("icon" = 'icons/obj/clothing/ties_overlay.dmi', "icon_state" = "[item_color? "[item_color]" : "[icon_state]"]")

//when user attached an accessory to S
/obj/item/clothing/tie/proc/on_attached(obj/item/clothing/under/S, mob/user as mob)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.overlays += inv_overlay
	
	user << "<span class='notice'>You attach [src] to [has_suit].</span>"
	src.add_fingerprint(user)

/obj/item/clothing/tie/proc/on_removed(mob/user as mob)
	if(!has_suit)
		return
	has_suit.overlays -= inv_overlay
	has_suit = null
	usr.put_in_hands(src)
	src.add_fingerprint(user)

//default attackby behaviour
/obj/item/clothing/tie/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/tie/attack_hand(mob/user as mob)
	if(has_suit)
		has_suit.remove_accessory(user)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/tie/blue
	name = "blue tie"
	icon_state = "bluetie"
	item_color = "bluetie"

/obj/item/clothing/tie/red
	name = "red tie"
	icon_state = "redtie"
	item_color = "redtie"

/obj/item/clothing/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"
	item_color = "horribletie"

/obj/item/clothing/tie/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	item_color = "stethoscope"

/obj/item/clothing/tie/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == "help")
			var/body_part = parse_zone(user.zone_sel.selecting)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "pulse"
				var/sound_strength

				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					sound_strength = "hear a weak"
					switch(body_part)
						if("chest")
							if(M.oxyloss < 50)
								sound_strength = "hear a healthy"
							sound = "pulse and respiration"
						if("eyes","mouth")
							sound_strength = "cannot hear"
							sound = "anything"
						else
							sound_strength = "hear a weak"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)


//Medals
/obj/item/clothing/tie/medal
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"
	item_color = "bronze"

/obj/item/clothing/tie/medal/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is most basic award given by Nanotrasen. It is often awarded by a captain to a member of his crew."

/obj/item/clothing/tie/medal/bronze_heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/tie/medal/nobel_science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/tie/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"
	item_color = "silver"

/obj/item/clothing/tie/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/tie/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of Nanotrasen's commercial interests. Often awarded to security staff."

/obj/item/clothing/tie/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"
	item_color = "gold"

/obj/item/clothing/tie/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain to Nanotrasen, and their undisputable authority over their crew."

/obj/item/clothing/tie/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by CentComm. To recieve such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but commanders."

//Armbands
/obj/item/clothing/tie/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon_state = "red"
	item_color = "red"

/obj/item/clothing/tie/armband/cargo
	name = "cargo bay guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is brown."
	icon_state = "cargo"
	item_color = "cargo"

/obj/item/clothing/tie/armband/engine
	name = "engineering guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is orange with a reflective strip!"
	icon_state = "engie"
	item_color = "engie"

/obj/item/clothing/tie/armband/science
	name = "science guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is purple."
	icon_state = "rnd"
	item_color = "rnd"

/obj/item/clothing/tie/armband/hydro
	name = "hydroponics guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is green and blue."
	icon_state = "hydro"
	item_color = "hydro"

/obj/item/clothing/tie/armband/med
	name = "medical guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is white."
	icon_state = "med"
	item_color = "med"

/obj/item/clothing/tie/armband/medgreen
	name = "medical guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is white and green."
	icon_state = "medgreen"
	item_color = "medgreen"

//holsters
/obj/item/clothing/tie/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	item_color = "holster"
	var/obj/item/weapon/gun/holstered = null

//subtypes can override this to specify what can be holstered
/obj/item/clothing/tie/holster/proc/can_holster(obj/item/weapon/gun/W)
	return W.isHandgun()

/obj/item/clothing/tie/holster/proc/holster(obj/item/I, mob/user as mob)
	if(holstered)
		user << "\red There is already a [holstered] holstered here!"
		return
	
	if (!istype(I, /obj/item/weapon/gun))
		user << "\red Only guns can be holstered!"
		return
	
	var/obj/item/weapon/gun/W = I
	if (!can_holster(W))
		user << "\red This [W] won't fit in the [src]!"
		return
	
	holstered = W
	user.drop_from_inventory(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	user.visible_message("\blue [user] holsters the [holstered].", "You holster the [holstered].")

/obj/item/clothing/tie/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return
	
	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		user << "\red You need an empty hand to draw the [holstered]!"
	else
		if(user.a_intent == "hurt")
			usr.visible_message("\red [user] draws the [holstered], ready to shoot!", \
			"\red You draw the [holstered], ready to shoot!")
		else
			user.visible_message("\blue [user] draws the [holstered], pointing it at the ground.", \
			"\blue You draw the [holstered], pointing it at the ground.")
		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		holstered = null

/obj/item/clothing/tie/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return
	
	..(user)

/obj/item/clothing/tie/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/tie/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/tie/holster/examine()
	set src in view()
	..()
	if (holstered)
		usr << "A [holstered] is holstered here."
	else
		usr << "It is empty."

/obj/item/clothing/tie/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/tie/holster/verb/holster_verb

/obj/item/clothing/tie/holster/on_removed(mob/user as mob)
	has_suit.verbs -= /obj/item/clothing/tie/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/tie/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	
	var/obj/item/clothing/tie/holster/H = null
	if (istype(src, /obj/item/clothing/tie/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (S.hastie)
			H = S.hastie
	
	if (!H)
		usr << "/red Something is very wrong."

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "\blue You need your gun equiped to holster it."
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/tie/holster/armpit
	name = "shoulder holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"
	item_color = "holster"

/obj/item/clothing/tie/holster/waist
	name = "shoulder holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	item_color = "holster_low"

/obj/item/clothing/tie/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	item_color = "webbing"
	var/slots = 3
	var/obj/item/weapon/storage/internal/hold

/obj/item/clothing/tie/storage/New()
	..()
	hold = new/obj/item/weapon/storage/internal(src)
	hold.storage_slots = slots

/obj/item/clothing/tie/storage/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		hold.open(user)
		return
	
	if (hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/tie/storage/MouseDrop(obj/over_object as obj)
	if (has_suit)
		return
	
	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/tie/storage/attackby(obj/item/W as obj, mob/user as mob)
	hold.attackby(W, user)

/obj/item/clothing/tie/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/tie/storage/hear_talk(mob/M, var/msg)
	hold.hear_talk(M, msg)
	..()

/obj/item/clothing/tie/storage/attack_self(mob/user as mob)
	user << "<span class='notice'>You empty [src].</span>"
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/tie/storage/webbing
	name = "webbing"
	desc = "Strudy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	item_color = "webbing"

/obj/item/clothing/tie/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	item_color = "vest_black"
	slots = 5

/obj/item/clothing/tie/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	item_color = "vest_brown"
	slots = 5
/*
	Holobadges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on the badge with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/tie/holobadge

	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge"
	item_color = "holobadge"
	slot_flags = SLOT_BELT

	var/emagged = 0 //Emagging removes Sec check.
	var/stored_name = null

/obj/item/clothing/tie/holobadge/cord
	icon_state = "holobadge-cord"
	item_color = "holobadge-cord"
	slot_flags = SLOT_MASK

/obj/item/clothing/tie/holobadge/attack_self(mob/user as mob)
	if(!stored_name)
		user << "Waving around a badge before swiping an ID would be pretty pointless."
		return
	if(isliving(user))
		user.visible_message("\red [user] displays their NanoTrasen Internal Security Legal Authorization Badge.\nIt reads: [stored_name], NT Security.","\red You display your NanoTrasen Internal Security Legal Authorization Badge.\nIt reads: [stored_name], NT Security.")

/obj/item/clothing/tie/holobadge/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O, /obj/item/weapon/card/emag))
		if (emagged)
			user << "\red [src] is already cracked."
			return
		else
			emagged = 1
			user << "\red You swipe [O] and crack the holobadge security checks."
			return

	else if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_security in id_card.access || emagged)
			user << "You imprint your ID details onto the badge."
			stored_name = id_card.registered_name
			name = "holobadge ([stored_name])"
			desc = "This glowing blue badge marks [stored_name] as THE LAW."
		else
			user << "[src] rejects your insufficient access rights."
		return
	..()

/obj/item/clothing/tie/holobadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("\red [user] invades [M]'s personal space, thrusting [src] into their face insistently.","\red You invade [M]'s personal space, thrusting [src] into their face insistently. You are the law.")

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/tie/holobadge(src)
		new /obj/item/clothing/tie/holobadge(src)
		new /obj/item/clothing/tie/holobadge(src)
		new /obj/item/clothing/tie/holobadge(src)
		new /obj/item/clothing/tie/holobadge/cord(src)
		new /obj/item/clothing/tie/holobadge/cord(src)
		..()
		return

/obj/item/clothing/tie/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	item_color = "unathiharness2"
	slots = 2

/obj/item/clothing/tie/storage/knifeharness/New()
	..()
	hold.max_combined_w_class = 4
	hold.can_hold = list("/obj/item/weapon/hatchet/unathiknife",\
	"/obj/item/weapon/kitchen/utensil/knife",\
	"/obj/item/weapon/kitchen/utensil/pknife",\
	"/obj/item/weapon/kitchenknife",\
	"/obj/item/weapon/kitchenknife/ritual")
	
	new /obj/item/weapon/hatchet/unathiknife(hold)
	new /obj/item/weapon/hatchet/unathiknife(hold)

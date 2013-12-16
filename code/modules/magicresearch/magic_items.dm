/obj/item/magic_research/stone
	icon_state = "blankstone"
	name = "Unenchanted Stone"
	desc = "An inert stone."

/obj/item/magic_research/stone/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/match))
		user << "You imbue the stone with the match."
		new /obj/item/magic_research/stone/fire(user.loc)
		del(W)
		del(src)
	if(istype(W, /obj/item/weapon/reagent_containers/glass/bucket))
		user << "You imbue the stone with the bucket."
		new /obj/item/magic_research/stone/water(user.loc)
		del(W)
		del(src)
	if(istype(W, /obj/item/magic_research/canister/residue))
		user << "You imbue the stone with the vile magic inside of the canister."
		new /obj/item/magic_research/stone/residue(user.loc)
		del(W)
		del(src)

/obj/item/magic_research/
	icon = 'icons/obj/cult.dmi'
	name = "You shouldn't see this."
	icon_state = "placeholder"

/obj/item/magic_research/stone/fire
	icon_state = "firestone"
	name = "Fire Enchanted Stone"
	desc = "A stone enchanted with fire."
/obj/item/magic_research/stone/fire/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/magic_research/stone/water))
		user << "You infuse the two stones, creating a soul imbued stone."
		new /obj/item/magic_research/stone/soul(user.loc)
		del(W)
		del(src)

/obj/item/magic_research/stone/water
	icon_state = "waterstone"
	name = "Water Enchanted Stone"
	desc = "A stone enchanted with water."

/obj/item/magic_research/stone/soul
	icon_state = "soulstone"
	name = "Soul Enchanted Stone"
	desc = "A stone enchanted with soul magic."
/obj/item/magic_research/stone/soul/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/magic_research/stone/residue))
		user << "You infuse the two stones, creating a stone imbued with death itself."
		new /obj/item/magic_research/stone/death(user.loc)
		del(W)
		del(src)

/obj/item/magic_research/stone/residue
	icon_state = "residuestone"
	name = "Residue Enchanted Stone"
	desc = "A stone enchanted with dark residue."

/obj/item/magic_research/stone/death
	icon_state = "deathstone"
	name = "Death Enchanted Stone"
	desc = "A stone enchanted with very vile magic."

/obj/item/magic_research/theory
	var/discovered
	var/scrollname = "Unknown Object"
/obj/item/magic_research/theory/magic_wand
	icon_state = "scroll"
	name = "Magic Theroy"
	desc = "A magical theroy."
	scrollname = "Magic Wand"
/obj/item/magic_research/theory/construct
	icon_state = "scroll"
	name = "Magic Theroy"
	desc = "A magical theroy."
	scrollname = "Construct Shell"
/obj/item/magic_research/theory/spellbook
	icon_state = "scroll"
	name = "Magic Theroy"
	desc = "A magical theroy."
	scrollname = "Spellbook"
/obj/item/magic_research/theory/swearrod
	icon_state = "scroll"
	name = "Magic Theroy"
	desc = "A magical theroy."
	scrollname = "Swearing Rod"
/obj/item/magic_research/theory/soulstone
	icon_state = "scroll"
	name = "Magic Theroy"
	desc = "A magical theroy."
	scrollname = "Soul Stone"
/obj/item/magic_research/canister/residue
	icon_state = "magic_can_full_residue"
	name = "Residue Canister"
	desc = "A magical canister that can hold residue."
/obj/item/magic_research/swearrod
	icon_state = "swear-rod"
	name = "swearing rod"
	desc = "A rod that, when holding the rod, allows you to swear oaths you are unable to break."

/obj/item/magic_research/swearrod/attack_self(mob/user as mob)
	var/newoath = ""
	var/oathtext = copytext(sanitize(input(usr, "Please enter an oath you wish to swear.", "Oath Swearing", newoath)),1,MAX_MESSAGE_LEN)
	ticker.mode.traitors += user.mind
	user.mind.special_role = "oathbound"
	var/datum/objective/survive/oath = new
	oath.explanation_text = oathtext
	oath.owner = user.mind
	user.mind.objectives += oath
	user << "<B>You bind yourself to an oath.</B>"
	user.say("[oathtext]")
	var/obj_count = 1
	for(var/datum/objective/OBJ in user.mind.objectives)
		user << "<B>Oath #[obj_count]</B>: [OBJ.explanation_text]"
		obj_count++
/obj/item/magic_research/swearrod/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/magic_research/canister/residue))
		user << "You corrupt the rod with the residue, allowing it to remove oaths."
		del(W)
		new /obj/item/magic_research/swearrod/reverse(user.loc)
		del(src)
/obj/item/magic_research/swearrod/reverse
	name = "corrupted swearing rod"
	desc = "A corrupted Swearing Rod capable of removing oaths."

/obj/item/magic_research/swearrod/reverse/attack_self(mob/living/user as mob)
	user << "You feel a spike of pain as your oaths are removed."
	user.adjustBruteLoss(5)
	for(var/datum/objective/oaths in user.mind.objectives)
		del(oaths)

/obj/item/magic_research/magic_wand
	icon_state = "blankwand"
	name = "Magic Wand"
	desc = "A magic wand. Very magical. Use with caution."

/obj/item/magic_research/magic_wand/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/magic_research/stone/fire))
		new /obj/item/weapon/gun/energy/staff/animate(user.loc)
		user << "You imbue the wand with the stone."
		del(src)
	if(istype(W, /obj/item/magic_research/stone/residue))
		new /obj/item/weapon/gun/energy/staff/pain(user.loc)
		user << "You imbue the wand with the stone."
		del(src)
	if(istype(W, /obj/item/magic_research/stone/water))
		new /obj/item/weapon/gun/energy/staff/change(user.loc)
		user << "You imbue the wand with the stone."
		del(src)
	if(istype(W, /obj/item/magic_research/stone/death))
		new /obj/item/weapon/gun/energy/staff/death(user.loc)
		user << "You imbue the wand with the stone."
		del(src)
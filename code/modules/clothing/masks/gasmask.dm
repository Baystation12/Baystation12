/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "gas_alt"
	flags = MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	w_class = 3.0
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	var/list/filtered_gases = list("phoron", "sleeping_agent")
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out phoron but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 90, rad = 0)
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"

/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando Mask"
	icon_state = "death_commando_mask"
	item_state = "death_commando_mask"
	siemens_coefficient = 0.2

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "clown"
	item_state = "clown_hat"
	icon_action_button = "action_blank"
	action_button_name = "Honk!"
	var/spam_flag = 0

/obj/item/clothing/mask/gas/clown_hat/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"
/obj/item/clothing/mask/gas/clown_hat/attack_self()
	honk()

/obj/item/clothing/mask/gas/clown_hat/verb/honk()
	set category = null
	set name = "HONK"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(usr:wear_mask != src)
		usr << "\red The mask must be worn to use this feature!"
		return
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(usr)
		spawn(20)
			spam_flag = 0
	return

/obj/item/clothing/mask/gas/clown_hat/madman
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "joker"
	item_state = "joker"

/obj/item/clothing/mask/gas/clown_hat/rainbow
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "rainbow_clown"
	item_state = "rainbow_clown"
// ********************************************************************

// **** Security mask ****

/obj/item/clothing/mask/sechailer
	name = "Hailer mask"
	desc = "A Security mask with integrated 'Compli-o-nator 3000' device, plays over a dozen pre-recorded compliance phrases designed to get scumbags to stand still whilst you taze them. Do not tamper with the device."
	action_button_name = "HALT!"
	icon_state = "officermask"
	icon_action_button = "action_blank"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	var/cooldown = 0
	var/aggressiveness = 1

/obj/item/clothing/mask/sechailer/warden
	icon_state = "wardenmask"

/obj/item/clothing/mask/sechailer/hos
	icon_state = "hosmask"

/obj/item/clothing/mask/sechailer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "\blue You set the restrictor to the middle position."
				aggressiveness = 2
			if(2)
				user << "\blue You set the restrictor to the last position."
				aggressiveness = 3
			if(3)
				user << "\blue You set the restrictor to the first position."
				aggressiveness = 1
			if(4)
				user << "\red You adjust the restrictor but nothing happens, probably because its broken."
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(aggressiveness != 4)
			user << "\red You broke it!"
			aggressiveness = 4
	else
		..()

/obj/item/clothing/mask/sechailer/attack_self()
	halt()

/obj/item/clothing/mask/sechailer/verb/halt()
	set category = null
	set name = "HALT"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(usr:wear_mask != src)
		usr << "\red The mask must be worn to use this feature!"
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null


	if(cooldown < world.time - 35) // A cooldown, to stop people being jerks
		switch(aggressiveness)		// checks if the user has unlocked the restricted phrases
			if(1)
				phrase = rand(1,5)	// set the upper limit as the phrase above the first 'bad cop' phrase, the mask will only play 'nice' phrases
			if(2)
				phrase = rand(6,11)	// default setting, set upper limit to last 'bad cop' phrase. Mask will play good cop and bad cop phrases
			if(3)
				phrase = rand(12,18)	// user has unlocked all phrases, set upper limit to last phrase. The mask will play all phrases
			if(4)
				phrase = rand(1,18)	// user has broke the restrictor, it will now only play shitcurity phrases

		switch(phrase)	//sets the properties of the chosen phrase
			if(1)				// good cop
				phrase_text = "HALT! HALT! HALT! HALT!"
				playsound(src.loc, 'sound/voice/complionator/halt.ogg', 100, 0, 4)
			if(2)
				phrase_text = "Stop in the name of the Law."
				playsound(src.loc, 'sound/voice/complionator/bobby.ogg', 100, 0, 4)
			if(3)
				phrase_text = "Compliance is in your best interest."
				playsound(src.loc, 'sound/voice/complionator/compliance.ogg', 100, 0, 4)
			if(4)
				phrase_text = "Prepare for justice!"
				playsound(src.loc, 'sound/voice/complionator/justice.ogg', 100, 0, 4)
			if(5)
				phrase_text = "Running will only increase your sentence."
				playsound(src.loc, 'sound/voice/complionator/running.ogg', 100, 0, 4)
			if(6)				// bad cop
				phrase_text = "Don't move, Creep!"
				playsound(src.loc, 'sound/voice/complionator/dontmove.ogg', 100, 0, 4)
			if(7)
				phrase_text = "Down on the floor, Creep!"
				playsound(src.loc, 'sound/voice/complionator/floor.ogg', 100, 0, 4)
			if(8)
				phrase_text = "Dead or alive you're coming with me."
				playsound(src.loc, 'sound/voice/complionator/robocop.ogg', 100, 0, 4)
			if(9)
				phrase_text = "God made today for the crooks we could not catch yesterday."
				playsound(src.loc, 'sound/voice/complionator/god.ogg', 100, 0, 4)
			if(10)
				phrase_text = "Freeze, Scum Bag!"
				playsound(src.loc, 'sound/voice/complionator/freeze.ogg', 100, 0, 4)
			if(11)
				phrase_text = "Stop right there, criminal scum!"
				playsound(src.loc, 'sound/voice/complionator/imperial.ogg', 100, 0, 4)
			if(12)				// LA-PD
				phrase_text = "Stop or I'll bash you."
				playsound(src.loc, 'sound/voice/complionator/bash.ogg', 100, 0, 4)
			if(13)
				phrase_text = "Go ahead, make my day."
				playsound(src.loc, 'sound/voice/complionator/harry.ogg', 100, 0, 4)
			if(14)
				phrase_text = "Stop breaking the law, ass hole."
				playsound(src.loc, 'sound/voice/complionator/asshole.ogg', 100, 0, 4)
			if(15)
				phrase_text = "You have the right to shut the fuck up."
				playsound(src.loc, 'sound/voice/complionator/stfu.ogg', 100, 0, 4)
			if(16)
				phrase_text = "Shut up crime!"
				playsound(src.loc, 'sound/voice/complionator/shutup.ogg', 100, 0, 4)
			if(17)
				phrase_text = "Face the wrath of the golden bolt."
				playsound(src.loc, 'sound/voice/complionator/super.ogg', 100, 0, 4)
			if(18)
				phrase_text = "I am, the LAW!"
				playsound(src.loc, 'sound/voice/complionator/dredd.ogg', 100, 0, 4)

		usr.visible_message("[usr.name]'s Hailer Mask: <font color='red' size='3'><b>[phrase_text]</b></font>")
		cooldown = world.time



// ********************************************************************
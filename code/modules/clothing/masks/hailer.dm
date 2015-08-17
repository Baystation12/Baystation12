/obj/item/clothing/mask/hailer
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

/obj/item/clothing/mask/hailer/warden
	icon_state = "wardenmask"

/obj/item/clothing/mask/hailer/hos
	icon_state = "hosmask"

/obj/item/clothing/mask/hailer/attackby(obj/item/weapon/W as obj, mob/user as mob)
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

/obj/item/clothing/mask/hailer/attack_self()
	halt()

/obj/item/clothing/mask/hailer/verb/halt()
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

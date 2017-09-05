/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's description_info,
	description_fluff, and description_antag, and shows it in a new tab.

	In this file, some atom and mob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/


/atom/
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

//Override these if you need special behaviour for a specific type.
/atom/proc/get_description_info()
	if(description_info)
		return description_info
	return

/atom/proc/get_description_fluff()
	if(description_fluff)
		return description_fluff
	return

/atom/proc/get_description_antag()
	if(description_antag)
		return description_antag
	return

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

/* The examine panel itself */

/client/var/description_holders[0]

/client/proc/update_description_holders(atom/A, update_antag_info=0)
	description_holders["info"] = A.get_description_info()
	description_holders["fluff"] = A.get_description_fluff()
	description_holders["antag"] = (update_antag_info)? A.get_description_antag() : ""

	description_holders["name"] = "[A.name]"
	description_holders["icon"] = "\icon[A]"
	description_holders["desc"] = A.desc

/mob/Stat()
	. = ..()
	if(client && statpanel("Examine"))
		stat(null,"[client.description_holders["icon"]]    <font size='5'>[client.description_holders["name"]]</font>") //The name, written in big letters.
		stat(null,"[client.description_holders["desc"]]") //the default examine text.
		if(client.description_holders["info"])
			stat(null,"<font color='#084B8A'><b>[client.description_holders["info"]]</b></font>") //Blue, informative text.
		if(client.description_holders["fluff"])
			stat(null,"<font color='#298A08'><b>[client.description_holders["fluff"]]</b></font>") //Yellow, fluff-related text.
		if(client.description_holders["antag"])
			stat(null,"<font color='#8A0808'><b>[client.description_holders["antag"]]</b></font>") //Red, malicious antag-related text

//override examinate verb to update description holders when things are examined
/mob/examinate(atom/A as mob|obj|turf in view())
	if(..())
		return 1

	var/is_antag = ((mind && mind.special_role) || isghost(src)) //ghosts don't have minds
	if(client)
		client.update_description_holders(A, is_antag)

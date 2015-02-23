/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's description_info,
	description_fluff, and description_antag, and shows it in a new tab.

	In this file, some atom and mob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/


/atom/
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

/atom/examine(mob/user)
	..()
	user.description_holders["info"] = get_description_info()
	user.description_holders["fluff"] = get_description_fluff()
	if(user.mind && user.mind.special_role || isobserver(user)) //Runtime prevention, as ghosts don't have minds.
		user.description_holders["antag"] = get_description_antag()

	if(name) //This shouldn't be needed but I'm paranoid.
		user.description_holders["name"] = "[src.name]" //\icon[src]

	user.description_holders["icon"] = "\icon[src]"

	if(desc)
		user << desc
		user.description_holders["desc"] = src.desc
	else
		user.description_holders["desc"] = null //This is needed, or else if you examine one thing with a desc, then another without, the panel will retain the first examined's desc.

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

/mob/
	var/description_holders[0]

/mob/Stat()
	..()
	if(statpanel("Examine"))
		stat(null,"[description_holders["icon"]]    <font size='5'>[description_holders["name"]]</font>") //The name, written in big letters.
		stat(null,"[description_holders["desc"]]") //the default examine text.
		if(description_holders["info"])
			stat(null,"<font color='#084B8A'><b>[description_holders["info"]]</b></font>") //Blue, informative text.
		if(description_holders["fluff"])
			stat(null,"<font color='#298A08'><b>[description_holders["fluff"]]</b></font>") //Yellow, fluff-related text.
		if(description_holders["antag"])
			stat(null,"<font color='#8A0808'><b>[description_holders["antag"]]</b></font>") //Red, malicious antag-related text

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

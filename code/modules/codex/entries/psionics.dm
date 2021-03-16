/datum/codex_entry/cuchulain_foundation
	display_name = "Cuchulain Foundation"
	associated_strings = list("Cuchulain", "Foundation")
	associated_paths = list(
		/obj/item/storage/briefcase/foundation, 
		/obj/item/gun/projectile/revolver/foundation,
		/obj/item/card/id/foundation,
		/obj/item/card/id/foundation_civilian,
		/obj/item/clothing/suit/storage/toggle/labcoat/foundation,
		/obj/item/reagent_containers/food/drinks/glass2/coffeecup/foundation
	)
	lore_text = "The Cuchulain Foundation is a non-profit body based out of Neptune orbit. Their logo is \
	an upward-facing radio telescope dish, usually printed in green. They perform niche research on behalf \
	of private parties, the SGC, and their own interests. They are also the single largest psionic registration \
	and oversight body in human space, responsible for educating and training operants at no cost, even across \
	territorial and political lines. \
	<br><br> \
	The rest of the article is an indecipherable haze that slips out of your memory as soon as you \
	finish reading it, but you feel pretty satisfied and informed by the end."
	antag_text = "The Cuchulain Foundation is an anti-occult ERT-like body. They are equipped with \
	nullglass weapons that can disrupt or destroy psi-powers, and have their own moderately powerful \
	psionic abilities. They make heavy use of psionic influence to cloud and disrupt efforts at \
	researching or understanding them, and the depth and nature of their connections to political \
	bodies like the SCG are unclear."

/datum/codex_entry/psionics
	display_name = "Psionics"
	associated_strings = list("Psychic", "Psychic Powers", "Psi")
	associated_paths = list(
		/obj/item/book/manual/psionics,
		/obj/item/clothing/head/helmet/space/psi_amp,
		/obj/item/clothing/head/helmet/space/psi_amp/lesser
	)
	lore_text = "Psionics are a relatively new phenomenon theorized to be linked to long-term exposure \
	to deep, uninhabited space. A tiny, tiny subset of people exposed to such conditions can develop the \
	ability to perform small feats like levitating coins or removing a headache with nothing but their mind. \
	A decade of study has resulted in the SCG determining that these psionics, mild as they are, don't pose \
	an operational or health risk, but they do encourage operants to register with a psionic regulation body \
	like the Cuchulain Foundation. \
	<br><br> \
	However, psionics-enhancing implants, drugs and procedures are illegal in most human space, and \
	statistically seem to end in death for those foolish enough to make use of them. Being caught with a \
	cerebroenergetic enhancer, or the drug Three Eye, will net you a hefty prison sentence."
	mechanics_text = "Psionic operants have a brain icon on the bottom right of the HUD. They can click it to toggle \
	their powers, or examine it to see the details of how to invoke each power, as well as their mental state. Items \
	made of nullglass will stop the use of powers, and overuse of powers can cause lethal brain damage."
	antag_text = "Psionic amplifiers are illegal equipment, but can boost your psionics to massive levels at the cost \
	of occupying your hat slot permanently."
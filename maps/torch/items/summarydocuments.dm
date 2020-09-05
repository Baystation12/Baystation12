/obj/random/summarydocument
	name = "all summary documents"
	desc = "Don't use this. This may spawn one of any of the Summary Documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 11

/obj/random/summarydocument/spawn_choices()
	return typesof(/obj/item/document/generic)

/obj/random/summarydocument/scgr
	name = "scgr summary documents"
	desc = "This may spawn one of the SCGR Summary Documents."

/obj/random/summarydocument/scgr/spawn_choices()
	return subtypesof(/obj/item/documents/generic/scgr) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/sol
	name = "sol summary documents"
	desc = "This may spawn one of the Sol Summary Documents."

/obj/random/summarydocument/sol/spawn_choices()
	return subtypesof(/obj/item/documents/generic/sol) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/sup
	name = "sup summary documents"
	desc = "This may spawn one of the Sup Summary Documents."

/obj/random/summarydocument/sup/spawn_choices()
	return subtypesof(/obj/item/documents/generic/sup) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/eng
	name = "eng summary documents"
	desc = "This may spawn one of the Eng Summary Documents."

/obj/random/summarydocument/eng/spawn_choices()
	return subtypesof(/obj/item/documents/generic/eng) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/med
	name = "med summary documents"
	desc = "This may spawn one of the Med Summary Documents."

/obj/random/summarydocument/med/spawn_choices()
	return subtypesof(/obj/item/documents/generic/med) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/explo
	name = "explo summary documents"
	desc = "This may spawn one of the Explo Summary Documents."

/obj/random/summarydocument/explo/spawn_choices()
	return subtypesof(/obj/item/documents/generic/explo) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/sci
	name = "sci summary documents"
	desc = "This may spawn one of the Sci Summary Documents."

/obj/random/summarydocument/sci/spawn_choices()
	return subtypesof(/obj/item/documents/generic/sci) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/corp
	name = "corp summary documents"
	desc = "This may spawn one of the Corp Summary Documents."

/obj/random/summarydocument/corp/spawn_choices()
	return subtypesof(/obj/item/documents/generic/corp) + typesof(/obj/item/documents/generic/dept)

/obj/random/summarydocument/sec
	name = "sec summary documents"
	desc = "This may spawn one of the Sec Summary Documents."

/obj/random/summarydocument/sec/spawn_choices()
	return subtypesof(/obj/item/documents/generic/sec) + typesof(/obj/item/documents/generic/dept)
/*
 * Multipoint of the above
 */

/obj/random_multi/single_item/summarydocuments //god please don't use this
	name = "Multi Point - Summary Document"
	id = "Summary Document"
	item_path = /obj/random/summarydocument

/obj/random_multi/single_item/summarydocuments/scgr
	name = "Multi Point - Summary Document SCGR"
	id = "SCGR Summary Document"
	item_path = /obj/random/summarydocument/scgr

/obj/random_multi/single_item/summarydocuments/sol
	name = "Multi Point - Summary Document Sol"
	id = "Sol Summary Document"
	item_path = /obj/random/summarydocument/sol

/obj/random_multi/single_item/summarydocuments/sup
	name = "Multi Point - Summary Document Sup"
	id = "Sup Summary Document"
	item_path = /obj/random/summarydocument/sup

/obj/random_multi/single_item/summarydocuments/eng
	name = "Multi Point - Summary Document Eng"
	id = "Eng Summary Document"
	item_path = /obj/random/summarydocument/eng

/obj/random_multi/single_item/summarydocuments/med
	name = "Multi Point - Summary Document Med"
	id = "Med Summary Document"
	item_path = /obj/random/summarydocument/med

/obj/random_multi/single_item/summarydocuments/explo
	name = "Multi Point - Summary Document Explo"
	id = "Explo Summary Document"
	item_path = /obj/random/summarydocument/explo

/obj/random_multi/single_item/summarydocuments/sci
	name = "Multi Point - Summary Document Sci"
	id = "Sci Summary Document"
	item_path = /obj/random/summarydocument/sci

/obj/random_multi/single_item/summarydocuments/corp
	name = "Multi Point - Summary Document Corp"
	id = "Corp Summary Document"
	item_path = /obj/random/summarydocument/corp

/obj/random_multi/single_item/summarydocuments/sec
	name = "Multi Point - Summary Document Sec"
	id = "Sec Summary Document"
	item_path = /obj/random/summarydocument/sec

/*
 * Documents Start
 * Contains:
 * Department, /dept/ (generic, applicable to all dept)
 * Sol Central Government Representative, /scgr/
 * Sol, /sol/ (General Command or XO documents, intended for Bridge)
 * Support, /sup/ (Combined service and supply)
 * Engineering, /eng/
 * Medical, /med/
 * Exploration, /explo/
 * Science, /sci/
 * Corporation, /corp/ (Only spawns for the CL)
 * Security, /sec/
 */

/obj/item/documents/generic
	name = "properly summarizing document"
	desc = "An \"internal use only\" document, detailing methods on summarizing written information."
	icon_state = "docs_part"

/*
 * Department, /dept/ (generic, applicable to all dept)
 */

/obj/item/documents/generic/dept/notoffical
	name = "offical guides"
	desc = "Some \"internal use only\" reports on inter-departmental communications, reminding personnel that unless the document specifies it is from and issued by EXO or Expeditionary Command, it is not offical policy and should not be referenced as a definitive reasoning for any action."

/*
 * Sol Central Government Representative, /scgr/
 */

/obj/item/document/generic/scgr/skrelljokes
	name = "internal conversation record"
	desc = "A \"confidential\" discussion between several Sol Government Representatives, including some crass jokes on if Skrell being squished would burst like a water balloon or squish like a jam sandwich."

/obj/item/document/generic/scgr/spicypolitics
	name = "internal conversation record"
	desc = "A \"confidential\" discussion between several Sol Government Representatives, including some interesting political tidbits. Seems like most of them are going to be supporting more conservative, Sol-centric parties next election, voicing annoyance at having to deal with hissing lizards and warbling frogs."

/obj/item/document/generic/scgr/deskfires
	name = "important notice"
	desc = "A \"confidential\" notice issued to Sol Government Representatives, informing them of an office fire caused by improper cigarette ash management."

/obj/item/document/generic/scgr/boringreports
	name = "\improper Torch project status update #132"
	desc = "A \"confidential\" report containing nothing you'd like to read, featuring updates that you knew about three weeks ago."

/obj/item/document/generic/scgr/documentdamage
	name = "important notice"
	desc = "A \"confidential\" notice issued to Sol Government Representatives, informing them that many documents were damaged last week due to \"inappropriate sleep management\". It urges all diplomatic staff to self-monitor their sleeping schedule and to regulate their caffeine intake."

/obj/item/documents/generic/scgr/documentdisposal
	name = "proper document disposal"
	desc = "Some \"internal use only\" documents, showing several pictures of reconstructed shredded documents. It highlights that shredding is not acceptable for any documents that are above Confidental, going on to recommend incineration as a primary method."

/obj/item/documents/generic/scgr/yourjob
	name = "\improper SCG and you"
	desc = "Some \"confidential\" briefing documents, detailing the job of the SCGR in brief. It highlights they are a civilian, first and foremost, who functions as a general-purpose civil servant aboard the SEV Torch. They also should advise the Commanding Officer, assisting with bureaucratic affairs where required, and spearheading diplomatic negotations."

/obj/item/document/generic/scgr/perdiemdeny
	name = "per diem denials"
	desc = "An \"internal use only\" document, explaining what not to file per diem reimbursement requests on. It lists examples of many per diem requests SCG representatives have filed in the past that have been denied. Some of the more interesting ones include casino debts, a request for per diem to cover the increased tax on alcohol on a station, and one odd case involving a possum, engineering PPE, and two injuries."

/*
 * Sol, /sol/ (General Command or XO documents, intended for Bridge)
 */

/obj/item/documents/generic/sol/saluting
	name = "saluting etiquette"
	desc = "Some \"internal use only\" reports on the saluting habits of junior officers, specifically regarding the amount of cases where junior officers cause damage to objects and floor tiles by dropping items to salute their superiors."

/obj/item/documents/generic/sol/unathiwork
	name = "Sinta'unathi behavioral guide"
	desc = "An \"internal use only\" memo from a mid-level officer at Expeditionary Command containing common sinta'unathi behaviors that help explain some of their quirky behaviors. A bullet list contains various hints such as \"thumping the tail is a sign of itchiness\", \"unathi hiss when they are angry\", and \"letting you touch their tail is a sign of great trust\". The document seems very hastily-made and you're not sure you trust it fully."

/obj/item/document/generic/sol/blastpain
	name = "incident report"
	desc = "Some \"internal use only\" reports about the potential crush hazards of blast doors. It cites an incident regarding improperly conducted tests that resulted in animal cruelty charges."

/obj/item/document/generic/sol/concurrentmissions
	name = "risk assessment and officer's report"
	desc = "Some \"internal use only\" reports, containing a risk assessment and an officer's report. This one details the risks and likelihood of success of running concurrent shuttlecraft missions. The risk assessment states that the greatest risk comes from personnel being left behind or forgotten. The officer's report details several key points for successful, safe missions. It notes that accurate, well-communicated manifests are essential, with the parent vessel taking responsibility for coordination and pickups of shuttlecraft."

/obj/item/document/generic/sol/consecutivemissions
	name = "risk assessment and officer's report"
	desc = "Some \"internal use only\" reports, containing a risk assessment and an officer's report. This one details the risks and likelihood of success of running consecutive shuttlecraft missions. The risk assessment states that the greatest risk comes from equipment misappropriation with intent to use on other missions. The officer's report details several key points to take into account when forming expectations of consecutive missions. It notes that the more \"green\" or disorganized a team is, the higher the risk of mission failures after the first of the shift, citing lack of re-preparation time as a contributing factor."

/obj/item/documents/generic/sol/annoyingtheft
	name = "abuse of access to equipment memo"
	desc = "An \"internal use only\" memo sent from the Executive Officer for distribution to all personnel with access to to the bridge, reminding them that the access to the bridge officers' lockers is not to be abused, further reminding that everyone has equipment in their lockers they should use. It ends with a terse request to stop this abuse immediately."

/obj/item/documents/generic/sol/fraternizationissues
	name = "anti-fraternization memo"
	desc = "An \"internal use only\" memo sent from the Senior Enlisted Advisor to all infirmary staff informing them that, yes, inappropriate relationships are also forbidden for corpsmen and medical technicians. It highlights that further instances of fraternization can and will result in non-judical punishment and reminds all staff that the provision of medical care is their first priority."

/obj/item/documents/generic/sol/bunnybirdissues
	name = "bridge officer hallucination issues"
	desc = "An \"internal use only\" memo sent from the Chief Medical Officer to the Executive Officer detailing the need for downtime and recovery for bridge staff after numerous reports of certain bridge officers seeing \"giant space birds\" after too long at the helm, and reminding  them to be sent for psychological counseling at their earliest convenience."

/obj/item/documents/generic/sol/bunnytraining
	name = "bridge officer qualification status"
	desc = "An \"internal use only\" memo sent from the Commanding Officer to the heads of staff reminding them that bridge officers are qualified in communications and bridge operations and do not, in fact, double as naval infantry. They should not be deployed like such during minor security incidents, citing numerous reports of broken legs and feet being shot due to mishandling of weapons."

/obj/item/documents/generic/sol/comm
	name = "Zurich Common reminder"
	desc = "A memo that has seen better days. It's been crumpled up, dried in coffee and put back up by some vandals. From what's left, it reads: \"Speaking good Zurich Common is a must to be an excellent head of staff. Please exercise moderation with accents.\""

/obj/item/documents/generic/sol/punishments
	name = "disposition of offenses"
	desc = "A \"for official use only\" memorandum detailing an officer's options with regards to punishing uniformed servicemembers. In ascending order of severity, the officer can: take no action (after investigation), take administrative action, impose nonjudicial punishment, and court-martial the offender."

obj/item/documents/generic/sol/realitybreak
	name = "\improper Bluespace drive apparitions"
	desc = "An \"internal use only\" memo sent from Expeditionary Command, based on a document from Krri'gli Engineering. It states that any humanoid figures seen during a bluespace jump are incorporeal apparitions and no mind should be paid to them, even if they appear familiar. In addition, it notes the existence of a bluespace \"double\" that living crew may experience and strongly urges them not to touch said double, as tempting as it may be, citing many cases of irrecoverable catatonia in those who have."

/obj/item/documents/generic/sol/njprules
	name = "non-judicial punishments"
	desc = "A \"for official use only\" memorandum detailing options with regards to non-judicially punishing uniformed servicemembers. Such punishments include admonishment/reprimand, forfeiture of pay, restriction, extra duty, and reduction in rank. The punishments available and their severity depend on the rank of the accused and the imposing officer."

/*
 * Support, /sup/ (Combined service and supply)
 */

/obj/item/documents/generic/sup/skrellcookery
	name = "food for alien species memo"
	desc = "An \"internal use only\" memo sent from the Executive Officer on behalf of Expeditionary Command detailing how to provision meals for Skrell crew. The memo seems to be vaguely misinformed and claims that Skrell should only be given hallucinogenic mushrooms and toast."

/obj/item/documents/generic/sup/gasprovisioning
	name = "food for alien species memo"
	desc = "An \"internal use only\" memo sent from the Executive Officer on behalf of expeditionary command detailing how to provision meals for Giant Armored Serpentid staff. It implies quite heavily that cost is a concern, and they should not be given meat except in exceptional circumstances and should otherwise only be given cheap cabbage."

/obj/item/documents/generic/sup/shotgunblues
	name = "in defense of the bar"
	desc = "An \"internal use only\" memo sent from the Executive Officer on behalf of Expeditionary Command detailing that the service department does not need self-defense weapons, and any arguments to the contrary will be handled internally. A personal memo has been added; an underlined \"STOP ASKING US\" penned onto the page."

/obj/item/documents/generic/sup/officelocation
	name = "supply office location reminder"
	desc = "An \"internal use only\" memo issued to supply staff, reminding them that the supply office is to the aft of the hangar, not the fore, and that they should ensure they know the way to work."

/obj/item/documents/generic/sup/shipping
	name = "shipping report"
	desc = "Some \"internal use only\" reports about the recent items coming and going from Expeditionary Corps vessels, with 70% of the orders being filed as replacement chemical cartridges."

/obj/item/documents/generic/sup/shipping2
	name = "shipping report"
	desc = "Some \"internal use only\" reports about the recent items coming and going from Expeditionary Corps vessels, with 70% of the orders being filed as being nanoblood."

/obj/item/documents/generic/sup/wrongchute
	name = "research complaint"
	desc = "An \"internal use only\" memo written for the Research department, gently reminding the xenobiologists to use the correct chute for their monkeys. Underlined is a brief report on two deck technicians that had to be referred to medical due to psychological trauma."

/obj/item/documents/generic/sup/smoking
	name = "fuel safety report"
	desc = "An \"internal use only\" notice directed at hangar operations personnel reminding them not to smoke in the hangar or near flammable objects or atmospheric holding areas. It specifically references fuelling procedures and to take care and caution to avoid sources of ignition while engaged in any operation involving and engaging in the use of pressurized gasses. It notes that a contracted pilot was fired for not following these regulations, and proceeds to list other potential punishments for smoking. The firefighting guide at the bottom of the notice somewhat undermines the rest."

/obj/item/documents/generic/sup/floorlogs
	name = "regarding floor logs"
	desc = "Some \"internal use only\" reports requesting the service department to begin maintaining and using floor cleanliness logs to reflect the floor condition and the amount of foot traffic that can be expected. It notes that they should be entered every 15 minutes, and that \"light dirt\" is non-critical."

/obj/item/documents/generic/sup/tempchecks
	name = "regarding temp checks"
	desc = "Some \"internal use only\" reports requesting the service department to begin maintaining and using temperature verification logs. It asks to be entered at the start of every hour, with any issues to be clarified on a following page."

/obj/item/documents/generic/sup/personaldrinks
	name = "off-menu drinks"
	desc = "An \"internal use only\" memo, discussing various off-menu drinks and how to market them. It lists various amusing names, such as \"Gaia Slammer\", \"Spicy Water\", \"Prison Wine\", and \"Sheep Shaver\", but it doesn't tell you how to make them, for some reason."

/*
 * Engineering, /eng/
 */

/obj/item/documents/generic/eng/repairs
	name = "maintenance reports"
	desc = "Some \"confidential\" reports regarding the state of the SEV Torch. Of note are the rusty cistern, faulty disposal pipes, clogged sinks, and an under-sized atmospheric system."

/obj/item/documents/generic/eng/shieldsoff
	name = "shielding recommendations"
	desc = "Some \"internal use only\" reports suggesting atmospheric containment should be disabled on all Expeditionary Corps vessels."

/obj/item/documents/generic/eng/shieldson
	name = "shielding recommendations"
	desc = "Some \"internal use only\" reports suggesting atmospheric containment should be enabled on all Expeditionary Corps vessels."

/obj/item/documents/generic/eng/ladder
	name = "ladder pamphlet"
	desc = "An \"internal use only\" pamphlet explaining how to use a ladder and safety precautions. It has a little stylized 'days without ladder accidents' counter at the front of the pamphlet. Zero has been written into it, but never replaced."

/obj/item/documents/generic/eng/engineersbad
	name = "engineering safety notice"
	desc = "An \"internal use only\" memo sent from the Chief Engineer, complaining about a multitude of inept electricians wiring the TEGs into the main grid directly, resulting in blown fuses and shorted circuits across the rest of the ship. It ends with orders to send any further offenders offsite for retraining."

/obj/item/documents/generic/eng/coilguns
	name = "material abuse issues memo"
	desc = "An \"internal use only\" memo sent from the Chief Engineer to engineering staff reminding them that the magnetic coils in storage are for genuine repair and upgrade work only, and are not to be used for \"personal projects.\" A hefty warning is included, mandating NJP's and restricted duties if supplies continue to go missing."

/obj/item/documents/generic/eng/ealradio
	name = "radio damage complaint"
	desc = "An \"internal use only\" report on complaints of garbled static emitting from radios during shifts with IPC crew members onboard. The report further goes onto state that when inquiring about this to IPC crew members on the radio, their radios would emit the same noises instead of getting a clear answer from them."

/*
 * Medical, /med/
 */

/obj/item/documents/generic/med/donuts
	name = "medical cleanliness standards"
	desc = "Some \"confidential\" reports regarding instances of infirmary staff being treated with donuts, wiping their hands on their scrubs, and failing to follow cleanliness standards."

/obj/item/documents/generic/med/jackets
	name = "medical mistreatments"
	desc = "Some \"confidential\" reports that apparently led to the removal of the straightjacket on all Expeditionary Corps vessels. Inhumane but deemed necessary treatments were applied with the help of those."

/obj/item/documents/generic/med/ipccpr
	name = "\improper IPC CPR notice"
	desc = "An \"internal use only\" notice, reminding IPC medical staff that their inability to breathe may inhibit mouth to mouth resuscitation, but does not interfere with the capacity to perform chest compressions when attempting CPR."

/obj/item/documents/generic/med/chemlab
	name = "health and safety in the laboratory reminder"
	desc = "An \"internal use only\" memo sent from the Chief Medical Officer to chemistry lab staff reminding them that the chemistry lab is a volatile area and smoking is prohibited. Further, chemists should avoid leaving water near potassium-based solutions as this has been known to result in injury."

/obj/item/documents/generic/med/scrubswithranks
	name = "uniform guide reminder"
	desc = "An \"internal use only\" notice from the Senior Enlisted Advisor about which clothes are meant to be worn with ranks and which are not. Curiously, scrubs are mentioned often."

/obj/item/documents/generic/med/washyourdamnhands
	name = "sanitation reminder"
	desc = "An \"internal use only\" memo sent from the Chief Medical Officer to all infirmary staff reminding them to wash their hands before and after surgery. It concludes with a note stating that they should NOT have to be asking their staff to do this."

/obj/item/documents/generic/med/greytidevirus
	name = "power notice"
	desc = "An \"internal use only\" notice sent by a member of the engineering team stating that power must sometimes be shut down due to abnormalities in the power grid and that medical doesn't need to call them asking what happened. Especially after the announcement is made. Seriously."

/obj/item/documents/generic/med/traineebeards
	name = "grooming standards"
	desc = "An \"internal use only\" memo from the Senior Enlisted Advisor and the Chief Medical Officer reminding staff of the importance of grooming standards in the infirmary. The example of a recently-dismissed medical trainee that refused to trim his beard is used as a warning to all staff, and helpful pictures of proper hair are included."

/obj/item/documents/generic/med/spacies
	name = "space-adapted humans"
	desc = "An \"internal use only\" formal-looking report for the ship's medical staff by a prominent off-ship medical scholar noting the differences between baseline humans and the comparatively-rare space-adapted humans. It reads like something out of a boring thousand-page textbook, and you could probably learn more by simply talking to a space-adapted human."

/obj/item/documents/generic/med/madaboutfrat
	name = "sub-acute ward notice"
	desc = "An \"internal use only\", hastily hand-written note from a civilian doctor stating that \"The sub-acute ward is for NON-CRITICAL PATIENTS and not FLIRTING, YOU BUFFOONS!\" They appear to have smashed the point of their marker into the note on the exclamation point's dot, and a small tear is present."

/obj/item/documents/generic/med/bandages
	name = "helpful trainee reminder"
	desc = "An \"internal use only\" notice from the Chief Medical Officer that seems to radiate irritation, somehow. It notes that bleeding wounds should be \"BANDAGED IN THE FIELD\" and to \"HAVE A SECURE GRIP ON PATIENTS YOU ARE TRANSPORTING.\" It concludes with a warning that the next trainee found dragging a surgical dummy around by the leg will receive a \"STERN\" talking to."

/obj/item/documents/generic/med/organfab
	name = "organ recyclers"
	desc = "An \"internal use only\" notice intended to be posted near the various organ fabricators in the infirmary. It details how the fabricators are complex machines that have dedicated recyclers built in, allowing reprocessing of all organic or prosthetic organs into their respective fabricator. It ends by stating that the chronic underutliziation of the recycler function is a \"travesty\" and pleads to \"stop wasting perfectly good necrotic organs!\""

/*
 * Exploration, /explo/
 */

/obj/item/documents/generic/explo/incident
	name = "incident report"
	desc = "Some \"confidential\" reports about an incident caused by the exploration department. While it has many pages, the front cover summarizes it very tersely: explorers should not be firing the ballistic launcher in flammable atmospheres. Ignition and subsequent burning of the entire exoplanet may occur."

/obj/item/documents/generic/explo/incident2
	name = "incident report"
	desc = "Some \"confidential\" reports regarding airlock-related injuries in the previous month across all Expeditionary Corps vessels. That number seems rather high."

/obj/item/documents/generic/explo/incident3
	name = "incident report"
	desc = "Some \"confidential\" reports about an incident caused by an Expeditionary Corps officer's incompetence that nearly killed a person under their supervision. The apparent cause was an unsafe craft departure."

/obj/item/documents/generic/explo/confuseexplo
	name = "incident report"
	desc = "Some \"confidential\" reports regarding numerous newly-enlisted explorers being unaware of the Expeditionary Corps, its Mission, or what training they received. An officer has attached a note to the bottom, commenting on possible cryostasis injuries. It's been circled and has several question marks."

/obj/item/documents/generic/explo/colddeadhands
	name = "incident report"
	desc = "A \"confidential\" notice reminding exploration that the recovery of unnecessary equipment from the deceased during explorations is vehemently discouraged and that future cases will be punished by forfeiture of pay."

/obj/item/documents/generic/explo/pathfinderproblems
	name = "pathfinder protocol reminder"
	desc = "A \"confidential\" memo sent from the Executive Officer to the pathfinder reminding them that, yes, their pilot is there to fly the Charon, not them, and that, yes, they should ensure that the exploration shotgun is only used by trained personnel. The final bit is very tersely-written, advising them to stop explorers from looking directly into the barrel."

/obj/item/documents/generic/explo/hangarproc
	name = "don't force the fucking airlock"
	desc = "An \"internal use only\" memo written by the senior engineer with a string of strongly worded expletives seemingly redacted from the final text directed toward the pathfinder to follow proper hangar atmospheric containment procedure for the Charon."

/obj/item/documents/generic/explo/oldshuttle
	name = "shuttle replacement issues"
	desc = "An \"internal use only\", long winded rant riddled with spelling errors lamenting the loss of the \"Calypso,\" whatever that may be, claiming it to be a much better shuttle than the Charon. It further grieves the loss of the crew microwave."

/obj/item/documents/generic/explo/charonsafety
	name = "fuel safety report"
	desc = "Some \"internal use only\" reports about personnel smoking near the atmospherics holding area aboard the SEV Charon. The atmospherics holding area aboard the Charon is declared a no-smoking area, as indicated by the sign. Attached is a brief incident report with a contracted pilot. The report ends with large-font writing stating the next person found smoking near the fueling port will be demoted to sanitation tech for the rest of their deployment."

/obj/item/documents/generic/explo/survivors
	name = "interactions with survivors"
	desc = "Some \"internal use only\" reports discussing the process of dealing with survivors, off-ship personnel, or in-distress civilians. This one details three points that all explorers, Fleet servicemembers, or contractor personnel should attempt to follow when dealing with off-ship persons: First, treat them with the utmost respect at all times, as they are the ones who need aid. Second, do not directly order them around, unless they happen to be getting in the way of SCG objectives. Third, remind them of their rights - they are requiring aid and are to be treated with the best handling, but remind them that they are still on SCG property, and are subject to SCG law at all times."

/obj/item/documents/generic/explo/cigarettes
	name = "cigarettes with helmets"
	desc = "Some \"internal use only\" reports detailing the extreme hazards of attempting to smoke a cigarette while wearing a spaceproof helmet, citing many incidents of suffocation and subsequent death as well as pointing out the presence of a \"No Smoking\" sign onboard the Charon and the likely flammability of many exoplanets. It concludes with a recommendation to smoke only in designated breakrooms aboard the SEV Torch and not when wearing a helmet."

/obj/item/documents/generic/explo/documentplease
	name = "on documentation of sites"
	desc = "Some \"internal use only\" reports discussing missing information on an exoplanet based on a lack of samples from the exploration team. It discusses the importance of making sure away teams document and report on the exoplanet, particularly taking samples and scans of plant life, xenofauna, atmospheric information, and mineral samples."

/*
 * Science, /sci/
 */

/obj/item/documents/generic/sci/slimeincident
	name = "intra-department communications"
	desc = "Some \"confidential\" reports about an incident caused by a xenobiology containment breach, allowing a grey slime to escape into the vents and appear on the bridge. Fortunately, the slime was recently fed and only smiled pleasantly at the staff before being forcefully euthanized."

/obj/item/documents/generic/sci/annoyingtheft
	name = "abuse of access to tools memo"
	desc = "An \"internal use only\" memo sent from the Chief Science Officer to the pathfinder reminding them that the access to the Petrov is not to be abused, further asking that the pathfinder crack down on any explorers looting equipment from the Petrov for their \"missions\". It ends with a note that they have their own equipment that they should be using instead."

/obj/item/documents/generic/sci/toxinsfire
	name = "toxin development memo"
	desc = "Some of this memo has been burnt, but you can still read what's left. It reads: \"THE GLASS IS NOT UNBREAKABLE.\""

/obj/item/documents/generic/sci/progressbad
	name = "work recording reminder"
	desc = "An \"internal use only\" memo from the Chief Science Officer to research staff reminding them of the importance of actually documenting their findings. Some reports are attached highlighting numerous issues with data loss from projects after many scientists showed a tendency to forget their work after cryogenic sleep cycles."

/obj/item/documents/generic/sci/chat
	name = "chatroom log"
	desc = "Someone drew a big laughing face over this, but you can still read the contents. \"What do you guys want the most?\" \"I wish we had our own security sometimes.\""

/obj/item/document/generic/sci/petrov
	name = "\improper Petrov map"
	desc = "It's a portable map of the Petrov. Someone wrote over it in big letters: \"What the fuck is the Petrov?\", and it's now unusable."

/obj/item/documents/generic/sci/fuckingdoors
	name = "windoor guide"
	desc = "An \"internal use only\" visual guide for the proper operation of xenobiology containment doors. It features a hand-written note saying \"PAY ATTENTION TO THIS!\" in large letters."

/*
 * Corporation, /corp/ (Only spawns for the CL)
 */

/obj/item/documents/generic/corp/bodyarmourbad
	name = "\improper LPA recommendations"
	desc = "Some \"internal use only\" corporate documents, detailing that having loss prevention associates openly wear body armor and a smartgun is an extreme violation of trust between EXO and the SCG and will result in harsh penalties. It also notes that this issue will be brought up at every 3 months during contract renewal."

/obj/item/documents/generic/corp/stipendcut
	name = "corporate spending records"
	desc = "A \"confidential\" memo on the current usage of funds provided to SEV Torch corporate liaisons; apparently there's threats of a strike over a cut to the cost-of-living stipends by the head office."

/obj/item/documents/generic/corp/LPArenting
	name = "\improper LPA usage notice"
	desc = "A \"confidential\" notice to the corporate liaison aboard the SEV Torch that their security staff are for their use only, and renting them out as extra manpower to security is a gross violation of their contract."

/obj/item/documents/generic/corp/uniondues
	name = "union dues reminder"
	desc = "A \"confidential\" memo sent from the Union Representative to all members of the Union reminding them that their mandated union fee pay period is approaching, and they should ensure their 250 thaler is deposited with them before the end of the month."

/obj/item/documents/generic/corp/glueandtape
	name = "proper document disposal"
	desc = "Some \"internal use only\" corporate documents detailing the proper ways to dispose of top secret and classified documents. It highlights that burning is most applicable, and shows pictures of shredded documents reconstructed with glue and sticky tape with a red \"Fail\" written below."

/obj/item/documents/generic/corp/lpainfo
	name = "\improper LPA reminder"
	desc = "An \"internal use only\" corporate document informing corporate liasions of the loss prevention associate's job aboard the ship. It cites concerns about the misuse of the LPA and general mistrust towards them from the rest of the crew, and warns how these tensions will damage EXO's image if they keep acting in this manner. It reminds them that LPAs are from an established industry and should have experience in many aspects other than carrying a firearm. It specifies good observation skills, solid restraint, an understanding of escalation rules in regards to their position, and that their experience as an industry professional can be useful as an advisor to their tasked liasion."

/obj/item/documents/generic/corp/exointerest
	name = "\improper EXO and you"
	desc = "Some \"confidential\" corporate documents directed to the corporate liasion, informing them that their job is to represent EXO and its immediate interests, which are to ensure the SEV Torch is able to maintain the currently defined direction that is within the interests of EXO as a whole. "

/obj/item/documents/generic/corp/thequarterly
	name = "quarterly budget report"
	desc = "A \"confidential\" yet uninteresting report from the head office regarding budget plans announced two weeks ago."

/obj/item/documents/generic/corp/kiareport
	name = "deceased and missing staff reports"
	desc = "A \"confidential\" memo reminding corporate liaisons to report the details pertaining to the death, or missing status, of on-shift employees. It explains that doing this ensures formal procedures are followed, and the situation pertaining to the deceased/missing status will be referenced for ongoing and future employee training programs and payrolls."

/obj/item/documents/generic/corp/spellchecker
	name = "spellchecking and you"
	desc = "Some \"internal use only\" corporate memos reminding corporate liaisons to proofread reports. It details various reasons behind why correct spelling and punctuation help in making EXO and Expeditionary Command take your report seriously."

/obj/item/documents/generic/corp/assistants
	name = "misuse of delegated personnel"
	desc = "An \"internal use only\" corporate memo reminding corporate liaisons that just because the executive assistant is issued a firearm does not mean that they are expected to fulfill the same role as a loss prevention associate. It suggests using loss prevention associates to assist in tactical or physical affairs and executive assistants in bureaucratic or menial tasks."

/obj/item/documents/generic/corp/safetyfirst
	name = "contractor safety and you"
	desc = "An \"internal use only\" corporate document reminding corporate liaisons to report any unsafe behavior from contractors that they either see directly or is reported to them. It goes on to explain that ensuring the health and safety compliance of those under contract not only helps to keep up an image of security but ensures that the reputation of EXO as a whole is not tarnished due to a workplace accident."

/*
 * Security, /sec/
 */

/obj/item/documents/generic/sec/carrieroverkill
	name = "security medical report"
	desc = "An \"internal use only\" report shared with security by medical on various masters at arms, noting a very large amount of chafing in the chest region due to continuous patrols while wearing plate carriers without reason."

/obj/item/documents/generic/sec/pepperoveruse
	name = "inter-department complaint"
	desc = "An \"internal use only\" memo sent from the service department complaining about certain members of security taking peppers from the kitchen freezer with the intent to supply their own peppersprays. It notes that the supply department is perfectly capable of refilling peppersprays and security should not resort to stealing garnishes."

/obj/item/documents/generic/sec/pepperoveruse2
	name = "inter-department complaint"
	desc = "An \"internal use only\" memo sent from the supply department complaining about certain members of security repeatedly ordering replacement crates of pepperspray. It notes that further orders will be denied, and recommends that refills be acquired through Hydroponics."

/obj/item/documents/generic/sec/mre
	name = "counterfeit MRE warning"
	desc = "An \"internal use only\" warning  all masters at arms to watch out for counterfeit MREs being snuck inside vending machines. They reportedly contain crayons instead of actual food."

/obj/item/documents/generic/sec/laepuse
	name = "\improper LAEP-90 manual"
	desc = "An \"internal use only\" manual normally distributed to lower-ranking masters at arms demonstrating proper usage of the LAEP-90 and LAEP-90C smartguns. A page on how to authenticate the LAEP via a card swipe has been dog-eared, with the word \"MANDATORY\" having been written at the top."

/obj/item/documents/generic/sec/batoncqc
	name = "baton usage in CQC"
	desc = "An \"internal use only\" manual demonstrating the proper usage of a stun baton in a close quarters fight and the dangers of losing it in an engagement. A notice is included at the bottom that reminds security personnel to avoid putting too much force into their swings, lest they cause unneeded harm. It cites a study that shows that hard hits with the baton are actually less effective than light taps due to the electrodes not having as much skin contact."

/obj/item/documents/generic/sec/goddamnhelmets
	name = "angry PPE memo"
	desc = "An \"internal use only\" note written from a Chief of Security that has grown sick of seeing masters at arms walking around on code green in full personal protective equipment. It concludes with an angry promise to rip off the next gas mask they see. It's been underlined."

/obj/item/documents/generic/sec/burntout
	name = "proper flash usage"
	desc = "An \"internal use only\", hand-written note from a brig chief warning personnel not to overuse their hand flashes in order to prevent the bulb from burning out. They further note that a burnt-out flash is useless. A third party has written on this note that burnt-out flashes should instead be brought to robotics. They even underlined it and added exclamation marks for emphasis, wow."

/obj/item/documents/generic/sec/lolly
	name = "STOP STEALING CANDY FROM MED"
	desc = "Why the fuck do I have to write this to you all when the records say you're all SUPPOSEDLY legal adults? The lollipop jar in medical is for PATIENTS, not MASTERS AT ARMS. Those lollipops contain COLD MEDICINE INSTEAD OF SUGAR. STOP STEALING THEM!!! If you want candy so goddamn much GO TO A VENDING MACHINE. If I see one of you stealing candy from medical, you're being demoted to sanitation tech of maintenance for the rest of your miserable tour here. Clean up and be more professional next shift!"

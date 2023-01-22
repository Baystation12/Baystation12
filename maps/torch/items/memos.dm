//random memo spawners

/obj/random/memo_scgr
	name = "random scgr memo"
	desc = "This may spawn one of the SCGR Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_scgr/spawn_choices()
	return subtypesof(/obj/item/paper/memo/scgr) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_command
	name = "random command memo"
	desc = "This may spawn one of the Command Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_command/spawn_choices()
	return subtypesof(/obj/item/paper/memo/command) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_supply
	name = "random supply memo"
	desc = "This may spawn one of the Supply Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_supply/spawn_choices()
	return subtypesof(/obj/item/paper/memo/supply) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_engineering
	name = "random engineering memo"
	desc = "This may spawn one of the Engineering Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_engineering/spawn_choices()
	return subtypesof(/obj/item/paper/memo/engineering) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_medical
	name = "random medical memo"
	desc = "This may spawn one of the Medical Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_medical/spawn_choices()
	return subtypesof(/obj/item/paper/memo/medical) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_exploration
	name = "random exploration memo"
	desc = "This may spawn one of the Exploration Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_exploration/spawn_choices()
	return subtypesof(/obj/item/paper/memo/exploration) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_research
	name = "random research memo"
	desc = "This may spawn one of the Research Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_research/spawn_choices()
	return subtypesof(/obj/item/paper/memo/research) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_corporate
	name = "random corporate memo"
	desc = "This may spawn one of the Corporate Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_corporate/spawn_choices()
	return subtypesof(/obj/item/paper/memo/corporate) + subtypesof(/obj/item/paper/memo/generic)

/obj/random/memo_security
	name = "random security memo"
	desc = "This may spawn one of the Security Memos."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	spawn_nothing_percentage = 15

/obj/random/memo_security/spawn_choices()
	return subtypesof(/obj/item/paper/memo/security) + subtypesof(/obj/item/paper/memo/generic)



/obj/random_multi/single_item/memo_scgr
	name = "Multi Point - SCGR Memos"
	id = "SCGR Memos"
	item_path = /obj/random/memo_scgr

/obj/random_multi/single_item/memo_command
	name = "Multi Point - Command Memos"
	id = "Command Memos"
	item_path = /obj/random/memo_command

/obj/random_multi/single_item/memo_supply
	name = "Multi Point - Supply Memos"
	id = "Supply Memos"
	item_path = /obj/random/memo_supply

/obj/random_multi/single_item/memo_engineering
	name = "Multi Point - Engineering Memos"
	id = "Engineering Memos"
	item_path = /obj/random/memo_engineering

/obj/random_multi/single_item/memo_medical
	name = "Multi Point - Medical Memos"
	id = "Medical Memos"
	item_path = /obj/random/memo_medical

/obj/random_multi/single_item/memo_exploration
	name = "Multi Point - Exploration Memos"
	id = "Exploration Memos"
	item_path = /obj/random/memo_exploration

/obj/random_multi/single_item/memo_research
	name = "Multi Point - Research Memos"
	id = "Research Memos"
	item_path = /obj/random/memo_research

/obj/random_multi/single_item/memo_corporate
	name = "Multi Point - Corporate Memos"
	id = "Corporate Memos"
	item_path = /obj/random/memo_corporate

/obj/random_multi/single_item/memo_security
	name = "Multi Point - Security Memos"
	id = "Security Memos"
	item_path = /obj/random/memo_security



// base memo behavior

/obj/item/paper/memo
	name = "base memo"
	icon_state = "docs_part"
	readable = FALSE
	is_memo = TRUE

/obj/item/paper/memo/Initialize()
	. = ..()
	if (type == /obj/item/paper/memo)
		. = INITIALIZE_HINT_QDEL
		crash_with("base [type] instantiated erroneously")

/obj/item/paper/memo/set_content(text, title, parse_pencode)
	return

/obj/item/paper/memo/examine(mob/user, distance)
	. = ..()
	if (distance < 2)
		to_chat(user, SPAN_NOTICE(info))



// generic memos

/obj/item/paper/memo/generic/notoffical
	name = "offical guides"
	info = {"Some "internal use only" reports on inter-departmental communications, reminding personnel that unless the document specifies it is from and issued by EXO or Expeditionary Command, it is not offical policy and should not be referenced as a definitive reasoning for any action."}



// scgr memos

/obj/item/paper/memo/scgr/skrelljokes
	name = "internal conversation record"
	info = {"A "confidential" discussion between several Sol Government Representatives, including some crass jokes on if Skrell being squished would burst like a water balloon or squish like a jam sandwich."}

/obj/item/paper/memo/scgr/spicypolitics
	name = "internal conversation record"
	info = {"A "confidential" discussion between several Sol Government Representatives, including some interesting political tidbits. Seems like most of them are going to be supporting more conservative, Sol-centric parties next election, voicing annoyance at having to deal with hissing lizards and warbling frogs."}

/obj/item/paper/memo/scgr/deskfires
	name = "important notice"
	info = {"A "confidential" notice issued to Sol Government Representatives, informing them of an office fire caused by improper cigarette ash management."}

/obj/item/paper/memo/scgr/boringreports
	name = "\improper Torch project status update #132"
	info = {"A "confidential" report containing nothing you'd like to read, featuring updates that you knew about three weeks ago."}

/obj/item/paper/memo/scgr/documentdamage
	name = "important notice"
	info = {"A "confidential" notice issued to Sol Government Representatives, informing them that many documents were damaged last week due to "inappropriate sleep management". It urges all diplomatic staff to self-monitor their sleeping schedule and to regulate their caffeine intake."}

/obj/item/paper/memo/scgr/documentdisposal
	name = "proper document disposal"
	info = {"Some "internal use only" documents, showing several pictures of reconstructed shredded documents. It highlights that shredding is not acceptable for any documents that are above Confidental, going on to recommend incineration as a primary method."}

/obj/item/paper/memo/scgr/yourjob
	name = "\improper SCG and you"
	info = {"Some "confidential" briefing documents, detailing the job of the SCGR in brief. It highlights they are a civilian, first and foremost, who functions as a general-purpose civil servant aboard the SEV Torch. They also should advise the Commanding Officer, assisting with bureaucratic affairs where required, and spearheading diplomatic negotations."}

/obj/item/paper/memo/scgr/perdiemdeny
	name = "per diem denials"
	info = {"An "internal use only" document, explaining what not to file per diem reimbursement requests on. It lists examples of many per diem requests SCG representatives have filed in the past that have been denied. Some of the more interesting ones include casino debts, a request for per diem to cover the increased tax on alcohol on a station, and one odd case involving a possum, engineering PPE, and two injuries."}

/obj/item/paper/memo/scgr/execution
	name = "formal complaint"
	info = {"A confidential memo from Rear Admiral Lambert of the SFV Bismarck issuing a formal complaint on behalf of Fleet regarding the execution of SLT Kristen Rohtin aboard a Corps vessel. The tone is furious and suggests significant consequences for the Expeditionary Corps."}

/obj/item/paper/memo/scgr/floritstatement
	name = "undersecretary statement"
	info = {"A press release issued by the newly-appointed Undersecretary of Diplomatic Affairs, Isabel Florit. The statement assures the public that there will be "no repeats" of the mistakes carried out in recent months aboard the SEV Torch. It goes on to advocate the role of the Defense Forces in public affairs, and suggests that the Diplomatic Affairs office will be working closely with the SCG Fleet under Florit's leadership in the interest of preventing any further incidents."}

/obj/item/paper/memo/scgr/senateminutes
	name = "assembly floor proceedings"
	info = {"A copy of the minutes from the Sol Assembly hearing over an emergency bill giving the SCG Defense Forces jurisdiction over the Expeditionary Corps (and by extension, the SEV Torch). The debate is vicious and devolves into angry bickering at points. The bill appears to have gotten uncomfortably close to being passed."}


// command memos

/obj/item/paper/memo/command/saluting
	name = "saluting etiquette"
	info = {"Some "internal use only" reports on the saluting habits of junior officers, specifically regarding the amount of cases where junior officers cause damage to objects and floor tiles by dropping items to salute their superiors."}

/obj/item/paper/memo/command/unathiwork
	name = "Sinta'unathi behavioral guide"
	info = {"An "internal use only" memo from a mid-level officer at Expeditionary Command containing common sinta'unathi behaviors that help explain some of their quirky behaviors. A bullet list contains various hints such as "thumping the tail is a sign of itchiness", "unathi hiss when they are angry", and "letting you touch their tail is a sign of great trust". The document seems very hastily-made and you're not sure you trust it fully."}

/obj/item/paper/memo/command/blastpain
	name = "incident report"
	info = {"Some "internal use only" reports about the potential crush hazards of blast doors. It cites an incident regarding improperly conducted tests that resulted in animal cruelty charges."}

/obj/item/paper/memo/command/concurrentmissions
	name = "risk assessment and officer's report"
	info = {"Some "internal use only" reports, containing a risk assessment and an officer's report. This one details the risks and likelihood of success of running concurrent shuttlecraft missions. The risk assessment states that the greatest risk comes from personnel being left behind or forgotten. The officer's report details several key points for successful, safe missions. It notes that accurate, well-communicated manifests are essential, with the parent vessel taking responsibility for coordination and pickups of shuttlecraft."}

/obj/item/paper/memo/command/consecutivemissions
	name = "risk assessment and officer's report"
	info = {"Some "internal use only" reports, containing a risk assessment and an officer's report. This one details the risks and likelihood of success of running consecutive shuttlecraft missions. The risk assessment states that the greatest risk comes from equipment misappropriation with intent to use on other missions. The officer's report details several key points to take into account when forming expectations of consecutive missions. It notes that the more "green" or disorganized a team is, the higher the risk of mission failures after the first of the shift, citing lack of re-preparation time as a contributing factor."}

/obj/item/paper/memo/command/annoyingtheft
	name = "abuse of access to equipment memo"
	info = {"An "internal use only" memo sent from the Executive Officer for distribution to all personnel with access to to the bridge, reminding them that the access to the bridge officers' lockers is not to be abused, further reminding that everyone has equipment in their lockers they should use. It ends with a terse request to stop this abuse immediately."}

/obj/item/paper/memo/command/fraternizationissues
	name = "anti-fraternization memo"
	info = {"An "internal use only" memo sent from the Senior Enlisted Advisor to all infirmary staff informing them that, yes, inappropriate relationships are also forbidden for corpsmen and medical technicians. It highlights that further instances of fraternization can and will result in non-judical punishment and reminds all staff that the provision of medical care is their first priority."}

/obj/item/paper/memo/command/bunnybirdissues
	name = "bridge officer hallucination issues"
	info = {"An "internal use only" memo sent from the Chief Medical Officer to the Executive Officer detailing the need for downtime and recovery for bridge staff after numerous reports of certain bridge officers seeing "giant space birds" after too long at the helm, and reminding  them to be sent for psychological counseling at their earliest convenience."}

/obj/item/paper/memo/command/bunnytraining
	name = "bridge officer qualification status"
	info = {"An "internal use only" memo sent from the Commanding Officer to the heads of staff reminding them that bridge officers are qualified in communications and bridge operations and do not, in fact, double as naval infantry. They should not be deployed like such during minor security incidents, citing numerous reports of broken legs and feet being shot due to mishandling of weapons."}

/obj/item/paper/memo/command/comm
	name = "Zurich Common reminder"
	info = {"A memo that has seen better days. It's been crumpled up, dried in coffee and put back up by some vandals. From what's left, it reads: "Speaking good Zurich Common is a must to be an excellent head of staff. Please exercise moderation with accents.""}

/obj/item/paper/memo/command/punishments
	name = "disposition of offenses"
	info = {"A "for official use only" memorandum detailing an officer's options with regards to punishing uniformed servicemembers. In ascending order of severity, the officer can: take no action (after investigation), take administrative action, impose nonjudicial punishment, and court-martial the offender."}

/obj/item/paper/memo/command/realitybreak
	name = "\improper Bluespace drive apparitions"
	info = {"An "internal use only" memo sent from Expeditionary Command, based on a document from Krri'gli Engineering. It states that any humanoid figures seen during a bluespace jump are incorporeal apparitions and no mind should be paid to them, even if they appear familiar. In addition, it notes the existence of a bluespace "double" that living crew may experience and strongly urges them not to touch said double, as tempting as it may be, citing many cases of irrecoverable catatonia in those who have."}

/obj/item/paper/memo/command/njprules
	name = "non-judicial punishments"
	info = {"A "for official use only" memorandum detailing options with regards to non-judicially punishing uniformed servicemembers. Such punishments include admonishment/reprimand, forfeiture of pay, restriction, extra duty, and reduction in rank. The punishments available and their severity depend on the rank of the accused and the imposing officer."}

/obj/item/paper/memo/command/recall
	name = "order of recall"
	info = {"A notice from the Helios Board of Admiralty regarding the urgent return of the Torch to Mars - the Board has ordered debriefing and review regarding the diplomatic meetings with the Terran Pioneer Corps and the field execution of SLT Kristen Rohtin. The document stresses that the ship be wary of any vessels, Fleet or otherwise, masking their transponders."}

/obj/item/paper/memo/command/roguefleeties
	name = "rogue fleet movements"
	info = {"An "internal use only" memorandum sent from Expeditionary Command, detailing the last known locations and naval capacity of several rogue Fifth Fleet vessels, including the SFV Nathan Hale. The data available in the report is uncomfortably sparse."}

/obj/item/paper/memo/command/outpostreport1
	name = "E-14b outpost report"
	info = {"An "internal use only" memo detailing the status of the research outpost in the E-14b system. It states that construction is still underway, and suggests efforts would benefit from better communication between EC and Terran engineering personnel."}

/obj/item/paper/memo/command/outpostreport2
	name = "E-14b outpost report"
	info = {"An "internal use only" memo detailing the status of the research outpost in the E-14b system. It states that construction has been delayed due to a migration of native ambulatory fungus at the site, and requests that the EC begin looking into low-impact mushroom removal methods."}

/obj/item/paper/memo/command/evasiveflight
	name = "evasive flight maneuvers"
	info = {"A hastily-penned report detailing strategies for evading ship-to-ship laser fire and missile strikes in the event of another attack on the Torch. The author highly recommends the tactical use of space dust and other debris, citing the successful evasive action taken during the attack by the SFV Nathan Hale."}



// supply memos

/obj/item/paper/memo/supply/skrellcookery
	name = "food for alien species memo"
	info = {"An "internal use only" memo sent from the Executive Officer on behalf of Expeditionary Command detailing how to provision meals for Skrell crew. The memo seems to be vaguely misinformed and claims that Skrell should only be given hallucinogenic mushrooms and toast."}

/obj/item/paper/memo/supply/gasprovisioning
	name = "food for alien species memo"
	info = {"An "internal use only" memo sent from the Executive Officer on behalf of expeditionary command detailing how to provision meals for Giant Armored Serpentid staff. It implies quite heavily that cost is a concern, and they should not be given meat except in exceptional circumstances and should otherwise only be given cheap cabbage."}

/obj/item/paper/memo/supply/shotgunblues
	name = "in defense of the bar"
	info = {"An "internal use only" memo sent from the Executive Officer on behalf of Expeditionary Command detailing that the service department does not need self-defense weapons, and any arguments to the contrary will be handled internally. A personal memo has been added; an underlined "STOP ASKING US" penned onto the page."}

/obj/item/paper/memo/supply/officelocation
	name = "supply office location reminder"
	info = {"An "internal use only" memo issued to supply staff, reminding them that the supply office is to the aft of the hangar, not the fore, and that they should ensure they know the way to work."}

/obj/item/paper/memo/supply/shipping
	name = "shipping report"
	info = {"Some "internal use only" reports about the recent items coming and going from Expeditionary Corps vessels, with 70% of the orders being filed as replacement chemical cartridges."}

/obj/item/paper/memo/supply/shipping2
	name = "shipping report"
	info = {"Some "internal use only" reports about the recent items coming and going from Expeditionary Corps vessels, with 70% of the orders being filed as being nanoblood."}

/obj/item/paper/memo/supply/wrongchute
	name = "research complaint"
	info = {"An "internal use only" memo written for the Research department, gently reminding the xenobiologists to use the correct chute for their monkeys. Underlined is a brief report on two deck technicians that had to be referred to medical due to psychological trauma."}

/obj/item/paper/memo/supply/smoking
	name = "fuel safety report"
	info = {"An "internal use only" notice directed at hangar operations personnel reminding them not to smoke in the hangar or near flammable objects or atmospheric holding areas. It specifically references fuelling procedures and to take care and caution to avoid sources of ignition while engaged in any operation involving and engaging in the use of pressurized gasses. It notes that a contracted pilot was fired for not following these regulations, and proceeds to list other potential punishments for smoking. The firefighting guide at the bottom of the notice somewhat undermines the rest."}

/obj/item/paper/memo/supply/floorlogs
	name = "regarding floor logs"
	info = {"Some "internal use only" reports requesting the service department to begin maintaining and using floor cleanliness logs to reflect the floor condition and the amount of foot traffic that can be expected. It notes that they should be entered every 15 minutes, and that "light dirt" is non-critical."}

/obj/item/paper/memo/supply/tempchecks
	name = "regarding temp checks"
	info = {"Some "internal use only" reports requesting the service department to begin maintaining and using temperature verification logs. It asks to be entered at the start of every hour, with any issues to be clarified on a following page."}

/obj/item/paper/memo/supply/personaldrinks
	name = "off-menu drinks"
	info = {"An "internal use only" memo, discussing various off-menu drinks and how to market them. It lists various amusing names, such as "Gaia Slammer", "Spicy Water", "Prison Wine", and "Sheep Shaver", but it doesn't tell you how to make them, for some reason."}



// engineering memos

/obj/item/paper/memo/engineering/repairs
	name = "maintenance reports"
	info = {"Some "confidential" reports regarding the state of the SEV Torch. Of note are the rusty cistern, faulty disposal pipes, clogged sinks, and an under-sized atmospheric system."}

/obj/item/paper/memo/engineering/shieldsoff
	name = "shielding recommendations"
	info = {"Some "internal use only" reports suggesting atmospheric containment should be disabled on all Expeditionary Corps vessels."}

/obj/item/paper/memo/engineering/shieldson
	name = "shielding recommendations"
	info = {"Some "internal use only" reports suggesting atmospheric containment should be enabled on all Expeditionary Corps vessels."}

/obj/item/paper/memo/engineering/ladder
	name = "ladder pamphlet"
	info = {"An "internal use only" pamphlet explaining how to use a ladder and safety precautions. It has a little stylized 'days without ladder accidents' counter at the front of the pamphlet. Zero has been written into it, but never replaced."}

/obj/item/paper/memo/engineering/engineersbad
	name = "engineering safety notice"
	info = {"An "internal use only" memo sent from the Chief Engineer, complaining about a multitude of inept electricians wiring the TEGs into the main grid directly, resulting in blown fuses and shorted circuits across the rest of the ship. It ends with orders to send any further offenders offsite for retraining."}

/obj/item/paper/memo/engineering/coilguns
	name = "material abuse issues memo"
	info = {"An "internal use only" memo sent from the Chief Engineer to engineering staff reminding them that the magnetic coils in storage are for genuine repair and upgrade work only, and are not to be used for "personal projects." A hefty warning is included, mandating NJP's and restricted duties if supplies continue to go missing."}

/obj/item/paper/memo/engineering/ealradio
	name = "radio damage complaint"
	info = {"An "internal use only" report on complaints of garbled static emitting from radios during shifts with IPC crew members onboard. The report further goes onto state that when inquiring about this to IPC crew members on the radio, their radios would emit the same noises instead of getting a clear answer from them."}

/obj/item/paper/memo/engineering/hulldamage
	name = "damage control report"
	info = {"An "internal use only" report on damages to the hull following the attack by the SFV Nathan Hale. It suggests that the repairs currently in place are temporary at best, and that the Torch will need hefty drydock maintenance before its next deep space mission. The report goes on to recommend petitioning EXO for additional funding for maintenance and upkeep."}

/obj/item/paper/memo/engineering/tcommssabotage
	name = "damage control report"
	info = {"An "internal use only" report on damages to ship systems following the 5/14 sabotage incident. It suggests that the saboteur exploited a previously-unknown vulnerability in the ship's telecommunications systems to shut down long-range communications - the system will need a full inspection from DAIS management before it can be deemed properly secure again. How the saboteur discovered the exploit is still unknown."}

/obj/item/paper/memo/engineering/bsddamage
	name = "\improper Bluespace drive safety notice"
	info = {"A "confidential" memo from Krri'gli Engineering regarding the new Bluespace drive. It explains in very slow and simple language that this is a "Bluespace drive", a very expensive and volatile piece of machinery, and that you should not break this one or remove the exotic particle shielding. The author does not appear to have a very high opinion of human engineering or mental faculties."}


// medical memos

/obj/item/paper/memo/medical/donuts
	name = "medical cleanliness standards"
	info = {"Some "confidential" reports regarding instances of infirmary staff being treated with donuts, wiping their hands on their scrubs, and failing to follow cleanliness standards."}

/obj/item/paper/memo/medical/jackets
	name = "medical mistreatments"
	info = {"Some "confidential" reports that apparently led to the removal of the straightjacket on all Expeditionary Corps vessels. Inhumane but deemed necessary treatments were applied with the help of those."}

/obj/item/paper/memo/medical/ipccpr
	name = "\improper IPC CPR notice"
	info = {"An "internal use only" notice, reminding IPC medical staff that their inability to breathe may inhibit mouth to mouth resuscitation, but does not interfere with the capacity to perform chest compressions when attempting CPR."}

/obj/item/paper/memo/medical/chemlab
	name = "health and safety in the laboratory reminder"
	info = {"An "internal use only" memo sent from the Chief Medical Officer to chemistry lab staff reminding them that the chemistry lab is a volatile area and smoking is prohibited. Further, chemists should avoid leaving water near potassium-based solutions as this has been known to result in injury."}

/obj/item/paper/memo/medical/scrubswithranks
	name = "uniform guide reminder"
	info = {"An "internal use only" notice from the Senior Enlisted Advisor about which clothes are meant to be worn with ranks and which are not. Curiously, scrubs are mentioned often."}

/obj/item/paper/memo/medical/washyourdamnhands
	name = "sanitation reminder"
	info = {"An "internal use only" memo sent from the Chief Medical Officer to all infirmary staff reminding them to wash their hands before and after surgery. It concludes with a note stating that they should NOT have to be asking their staff to do this."}

/obj/item/paper/memo/medical/greytidevirus
	name = "power notice"
	info = {"An "internal use only" notice sent by a member of the engineering team stating that power must sometimes be shut down due to abnormalities in the power grid and that medical doesn't need to call them asking what happened. Especially after the announcement is made. Seriously."}

/obj/item/paper/memo/medical/traineebeards
	name = "grooming standards"
	info = {"An "internal use only" memo from the Senior Enlisted Advisor and the Chief Medical Officer reminding staff of the importance of grooming standards in the infirmary. The example of a recently-dismissed medical trainee that refused to trim his beard is used as a warning to all staff, and helpful pictures of proper hair are included."}

/obj/item/paper/memo/medical/spacies
	name = "space-adapted humans"
	info = {"An "internal use only" formal-looking report for the ship's medical staff by a prominent off-ship medical scholar noting the differences between baseline humans and the comparatively-rare space-adapted humans. It reads like something out of a boring thousand-page textbook, and you could probably learn more by simply talking to a space-adapted human."}

/obj/item/paper/memo/medical/madaboutfrat
	name = "sub-acute ward notice"
	info = {"An "internal use only", hastily hand-written note from a civilian doctor stating that "The sub-acute ward is for NON-CRITICAL PATIENTS and not FLIRTING, YOU BUFFOONS!" They appear to have smashed the point of their marker into the note on the exclamation point's dot, and a small tear is present."}

/obj/item/paper/memo/medical/bandages
	name = "helpful trainee reminder"
	info = {"An "internal use only" notice from the Chief Medical Officer that seems to radiate irritation, somehow. It notes that bleeding wounds should be "BANDAGED IN THE FIELD" and to "HAVE A SECURE GRIP ON PATIENTS YOU ARE TRANSPORTING." It concludes with a warning that the next trainee found dragging a surgical dummy around by the leg will receive a "STERN" talking to."}

/obj/item/paper/memo/medical/organfab
	name = "organ recyclers"
	info = {"An "internal use only" notice intended to be posted near the various organ fabricators in the infirmary. It details how the fabricators are complex machines that have dedicated recyclers built in, allowing reprocessing of all organic or prosthetic organs into their respective fabricator. It ends by stating that the chronic underutliziation of the recycler function is a "travesty" and pleads to "stop wasting perfectly good necrotic organs!""}



// exploration memos

/obj/item/paper/memo/exploration/incident
	name = "incident report"
	info = {"Some "confidential" reports about an incident caused by the exploration department. While it has many pages, the front cover summarizes it very tersely: explorers should not be firing the ballistic launcher in flammable atmospheres. Ignition and subsequent burning of the entire exoplanet may occur."}

/obj/item/paper/memo/exploration/incident2
	name = "incident report"
	info = {"Some "confidential" reports regarding airlock-related injuries in the previous month across all Expeditionary Corps vessels. That number seems rather high."}

/obj/item/paper/memo/exploration/incident3
	name = "incident report"
	info = {"Some "confidential" reports about an incident caused by an Expeditionary Corps officer's incompetence that nearly killed a person under their supervision. The apparent cause was an unsafe craft departure."}

/obj/item/paper/memo/exploration/confuseexplo
	name = "incident report"
	info = {"Some "confidential" reports regarding numerous newly-enlisted explorers being unaware of the Expeditionary Corps, its Mission, or what training they received. An officer has attached a note to the bottom, commenting on possible cryostasis injuries. It's been circled and has several question marks."}

/obj/item/paper/memo/exploration/colddeadhands
	name = "incident report"
	info = {"A "confidential" notice reminding exploration that the recovery of unnecessary equipment from the deceased during explorations is vehemently discouraged and that future cases will be punished by forfeiture of pay."}

/obj/item/paper/memo/exploration/pathfinderproblems
	name = "pathfinder protocol reminder"
	info = {"A "confidential" memo sent from the Executive Officer to the pathfinder reminding them that, yes, their pilot is there to fly the Charon, not them, and that, yes, they should ensure that the exploration shotgun is only used by trained personnel. The final bit is very tersely-written, advising them to stop explorers from looking directly into the barrel."}

/obj/item/paper/memo/exploration/hangarproc
	name = "don't force the fucking airlock"
	info = {"An "internal use only" memo written by the senior engineer with a string of strongly worded expletives seemingly redacted from the final text directed toward the pathfinder to follow proper hangar atmospheric containment procedure for the Charon."}

/obj/item/paper/memo/exploration/oldshuttle
	name = "shuttle replacement issues"
	info = {"An "internal use only", long winded rant riddled with spelling errors lamenting the loss of the "Calypso," whatever that may be, claiming it to be a much better shuttle than the Charon. It further grieves the loss of the crew microwave."}

/obj/item/paper/memo/exploration/charonsafety
	name = "fuel safety report"
	info = {"Some "internal use only" reports about personnel smoking near the atmospherics holding area aboard the SEV Charon. The atmospherics holding area aboard the Charon is declared a no-smoking area, as indicated by the sign. Attached is a brief incident report with a contracted pilot. The report ends with large-font writing stating the next person found smoking near the fueling port will be demoted to sanitation tech for the rest of their deployment."}

/obj/item/paper/memo/exploration/survivors
	name = "interactions with survivors"
	info = {"Some "internal use only" reports discussing the process of dealing with survivors, off-ship personnel, or in-distress civilians. This one details three points that all explorers, Fleet servicemembers, or contractor personnel should attempt to follow when dealing with off-ship persons: First, treat them with the utmost respect at all times, as they are the ones who need aid. Second, do not directly order them around, unless they happen to be getting in the way of SCG objectives. Third, remind them of their rights - they are requiring aid and are to be treated with the best handling, but remind them that they are still on SCG property, and are subject to SCG law at all times."}

/obj/item/paper/memo/exploration/cigarettes
	name = "cigarettes with helmets"
	info = {"Some "internal use only" reports detailing the extreme hazards of attempting to smoke a cigarette while wearing a spaceproof helmet, citing many incidents of suffocation and subsequent death as well as pointing out the presence of a "No Smoking" sign onboard the Charon and the likely flammability of many exoplanets. It concludes with a recommendation to smoke only in designated breakrooms aboard the SEV Torch and not when wearing a helmet."}

/obj/item/paper/memo/exploration/documentplease
	name = "on documentation of sites"
	info = {"Some "internal use only" reports discussing missing information on an exoplanet based on a lack of samples from the exploration team. It discusses the importance of making sure away teams document and report on the exoplanet, particularly taking samples and scans of plant life, xenofauna, atmospheric information, and mineral samples."}

/obj/item/paper/memo/exploration/pioneers
	name = "pioneers and you"
	info = {"An "internal use only" memo detailing proper ettiquette for explorers interacting with Terran Pioneer Corps personnel. It stresses very heavily that yes, most Terrans do speak ZAC; no, you should not share your funny Pan-Slavic impression; and no, you should ABSOLUTELY not ask if they know any war criminals."}


// research memos

/obj/item/paper/memo/research/slimeincident
	name = "intra-department communications"
	info = {"Some "confidential" reports about an incident caused by a xenobiology containment breach, allowing a grey slime to escape into the vents and appear on the bridge. Fortunately, the slime was recently fed and only smiled pleasantly at the staff before being forcefully euthanized."}

/obj/item/paper/memo/research/annoyingtheft
	name = "abuse of access to tools memo"
	info = {"An "internal use only" memo sent from the Chief Science Officer to the pathfinder reminding them that the access to the Petrov is not to be abused, further asking that the pathfinder crack down on any explorers looting equipment from the Petrov for their "missions". It ends with a note that they have their own equipment that they should be using instead."}

/obj/item/paper/memo/research/toxinsfire
	name = "toxin development memo"
	info = {"Some of this memo has been burnt, but you can still read what's left. It reads: "THE GLASS IS NOT UNBREAKABLE.""}

/obj/item/paper/memo/research/progressbad
	name = "work recording reminder"
	info = {"An "internal use only" memo from the Chief Science Officer to research staff reminding them of the importance of actually documenting their findings. Some reports are attached highlighting numerous issues with data loss from projects after many scientists showed a tendency to forget their work after cryogenic sleep cycles."}

/obj/item/paper/memo/research/chat
	name = "chatroom log"
	info = {"Someone drew a big laughing face over this, but you can still read the contents. "What do you guys want the most?" "I wish we had our own security sometimes.""}

/obj/item/paper/memo/research/petrov
	name = "\improper Petrov map"
	info = {"It's a portable map of the Petrov. Someone wrote over it in big letters: "What the fuck is the Petrov?", and it's now unusable."}

/obj/item/paper/memo/research/fuckingdoors
	name = "windoor guide"
	info = {"An "internal use only" visual guide for the proper operation of xenobiology containment doors. It features a hand-written note saying "PAY ATTENTION TO THIS!" in large letters."}



// corporate memos

/obj/item/paper/memo/corporate/stipendcut
	name = "corporate spending records"
	info = {"A "confidential" memo on the current usage of funds provided to SEV Torch corporate liaisons; apparently there's threats of a strike over a cut to the cost-of-living stipends by the head office."}

/obj/item/paper/memo/corporate/uniondues
	name = "union dues reminder"
	info = {"A "confidential" memo sent from the Union Representative to all members of the Union reminding them that their mandated union fee pay period is approaching, and they should ensure their 250 thaler is deposited with them before the end of the month."}

/obj/item/paper/memo/corporate/glueandtape
	name = "proper document disposal"
	info = {"Some "internal use only" corporate documents detailing the proper ways to dispose of top secret and classified documents. It highlights that burning is most applicable, and shows pictures of shredded documents reconstructed with glue and sticky tape with a red "Fail" written below."}

/obj/item/paper/memo/corporate/exointerest
	name = "\improper EXO and you"
	info = {"Some "confidential" corporate documents directed to the corporate liasion, informing them that their job is to represent EXO and its immediate interests, which are to ensure the SEV Torch is able to maintain the currently defined direction that is within the interests of EXO as a whole."}

/obj/item/paper/memo/corporate/thequarterly
	name = "quarterly budget report"
	info = {"A "confidential" yet uninteresting report from the head office regarding budget plans announced two weeks ago."}

/obj/item/paper/memo/corporate/kiareport
	name = "deceased and missing staff reports"
	info = {"A "confidential" memo reminding corporate liaisons to report the details pertaining to the death, or missing status, of on-shift employees. It explains that doing this ensures formal procedures are followed, and the situation pertaining to the deceased/missing status will be referenced for ongoing and future employee training programs and payrolls."}

/obj/item/paper/memo/corporate/spellchecker
	name = "spellchecking and you"
	info = {"Some "internal use only" corporate memos reminding corporate liaisons to proofread reports. It details various reasons behind why correct spelling and punctuation help in making EXO and Expeditionary Command take your report seriously."}

/obj/item/paper/memo/corporate/safetyfirst
	name = "contractor safety and you"
	info = {"An "internal use only" corporate document reminding corporate liaisons to report any unsafe behavior from contractors that they either see directly or is reported to them. It goes on to explain that ensuring the health and safety compliance of those under contract not only helps to keep up an image of security but ensures that the reputation of EXO as a whole is not tarnished due to a workplace accident."}



// security memos

/obj/item/paper/memo/security/carrieroverkill
	name = "security medical report"
	info = {"An "internal use only" report shared with security by medical on various masters at arms, noting a very large amount of chafing in the chest region due to continuous patrols while wearing plate carriers without reason."}

/obj/item/paper/memo/security/pepperoveruse
	name = "inter-department complaint"
	info = {"An "internal use only" memo sent from the service department complaining about certain members of security taking peppers from the kitchen freezer with the intent to supply their own peppersprays. It notes that the supply department is perfectly capable of refilling peppersprays and security should not resort to stealing garnishes."}

/obj/item/paper/memo/security/pepperoveruse2
	name = "inter-department complaint"
	info = {"An "internal use only" memo sent from the supply department complaining about certain members of security repeatedly ordering replacement crates of pepperspray. It notes that further orders will be denied, and recommends that refills be acquired through Hydroponics."}

/obj/item/paper/memo/security/mre
	name = "counterfeit MRE warning"
	info = {"An "internal use only" warning  all masters at arms to watch out for counterfeit MREs being snuck inside vending machines. They reportedly contain crayons instead of actual food."}

/obj/item/paper/memo/security/laepuse
	name = "\improper LAEP-90 manual"
	info = {"An "internal use only" manual normally distributed to lower-ranking masters at arms demonstrating proper usage of the LAEP-90 and LAEP-90C smartguns. A page on how to authenticate the LAEP via a card swipe has been dog-eared, with the word "MANDATORY" having been written at the top."}

/obj/item/paper/memo/security/batoncqc
	name = "baton usage in CQC"
	info = {"An "internal use only" manual demonstrating the proper usage of a stun baton in a close quarters fight and the dangers of losing it in an engagement. A notice is included at the bottom that reminds security personnel to avoid putting too much force into their swings, lest they cause unneeded harm. It cites a study that shows that hard hits with the baton are actually less effective than light taps due to the electrodes not having as much skin contact."}

/obj/item/paper/memo/security/goddamnhelmets
	name = "angry PPE memo"
	info = {"An "internal use only" note written from a Chief of Security that has grown sick of seeing masters at arms walking around on code green in full personal protective equipment. It concludes with an angry promise to rip off the next gas mask they see. It's been underlined."}

/obj/item/paper/memo/security/burntout
	name = "proper flash usage"
	info = {"An "internal use only", hand-written note from a brig chief warning personnel not to overuse their hand flashes in order to prevent the bulb from burning out. They further note that a burnt-out flash is useless. A third party has written on this note that burnt-out flashes should instead be brought to robotics. They even underlined it and added exclamation marks for emphasis, wow."}

/obj/item/paper/memo/security/lolly
	name = "STOP STEALING CANDY FROM MED"
	info = {"Why the fuck do I have to write this to you all when the records say you're all SUPPOSEDLY legal adults? The lollipop jar in medical is for PATIENTS, not MASTERS AT ARMS. Those lollipops contain COLD MEDICINE INSTEAD OF SUGAR. STOP STEALING THEM!!! If you want candy so goddamn much GO TO A VENDING MACHINE. If I see one of you stealing candy from medical, you're being demoted to sanitation tech of maintenance for the rest of your miserable tour here. Clean up and be more professional next shift!"}

/obj/item/paper/memo/security/chaplain
	name = "inter-department complaint"
	info = {"An inter-departmental memo from the Chaplain's office detailing their objection at length to the Torch permitting capital punishment within its walls. A diplomatic and scientifically oriented ship should have "no part in warfare"."}

/obj/item/paper/memo/security/extremism
	name = "anti-radicalization pamphlet"
	info = {"An "internal use only" document detailing strategies for identifying signs and risk factors for radicalization, created in light of perceived extremism in the SCGF. It discusses low self-esteem, stress, marginalization, repeat disciplinary issues, and excessive interest in weaponry."}

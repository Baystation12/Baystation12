/obj/item/paper/immediateorder
	name = "Emergency Order Notice"
	info = {"\
<center><strong><span style="color: red;">EMERGENCY ROUTING ORDERS</span></strong>
<strong>PRECEDENCE: FLASH</strong>
<h3>MARSCOM - HIGH COMMAND OFFICES</h3>
<img src="fleetlogo.png"/></center>
<p><tt><tt><strong>FROM:</strong> Rear Admiral Korubei Richter, Fifth Fleet<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Helios Project, Expeditionary Corps<br /></tt></tt></p>
<hr />
<p>Per incident and consequential orders, the SEV Torch has been ordered to return to sector <strong>S5</strong>, system <strong>E-14b</strong>, effective immediately.</p>
<p>Fifth Fleet Quick Reaction Forces are currently mobilising and conducting hot jumps to secure the route as necessary, however, mass factor dilations and general distance will delay reinforcements.</p>
<p>As such, while regular expeditionary and prospecting operations are not banned, present ship command personnel are asked to <strong>strongly enforce</strong> away team return times.</p>
<p>Retrieval of personnel left behind will be impossible due to on-going Fleet activity in the area of operations. Vessels will be unavailable for frivolous use.</p>
<p> ... </p>
<p>Escorting of supply and reinforcements will be handled by Fleet QRF rear-echelons.</p>
<hr/>
<p>&nbsp;<em>This paper has been stamped with the stamp of MARSCOM - HIGH COMMAND OFFICES.</em></p>
<hr/><center><img src="fleetlogo.png"/></center>
"}


/obj/item/folder/envelope/ndaorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DO NOT DISSEMINATE. FOR BRIDGE EYES ONLY.'"


/obj/item/folder/envelope/ndaorder/Initialize()
	. = ..()
	new /obj/item/paper/ndaorder (src)


/obj/item/paper/ndaorder
	name = "Order of Non-Disclosure"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Admiral William Henry Lau, Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Director Nazur Khalid, Solar Bureau of Public Information <br /><strong>SUBJECT:</strong> Non-Disclosure and Operational Security Notice<br /></tt></tt></p>
<hr />
<p>Good day, Torch.</p>
<p>This is an important advisory for members of the command staff aboard the vessel. With the discovery of a new, potentially hostile body - it is of the utmost importance that information be disseminated in a controlled, and calculated manner.</p>
<p>It is crucial to keep in mind that hysteria and fearmongering is still a valid concern for the masses of the Solar state. While this is not the first time that we have conducted first contact, contextually, this has been of the equivalance of first contacts with the Vox.</p>
<p>As such, in an effort to maintain operational security, as well as ensure that non-Solar actors do not gain access to the information and experience that you have gathered - the Bureau of Public Information has imposed a ship-wide C-Notice on exchange of verbal information relating to this incident.</p>
<p>We have authorised both independent, and government observers to board the Torch for information. All observers and/or journalists must have their identity and source of representation be verified by command or security.</p>
<p>Verification can be conducted via a fax to EXCOM, from a present Representative, or line officer, with the details of the individual involved, and their representative branch.</p>
<p>Those representing branches of the Solar Government can be given full details as needed. However, for independent civilian journalists and contracted observers, the information must be regulated. The guidelines to follow for them, are:</p>
<p>1. It may be disseminated that the encounter was hostile in nature.</p>
<p>2. It may be disseminated that the crew has suffered losses.</p>
<p>3. It may be disseminated that the hostiles in question are <strong>unconfirmed</strong> to be synthetic assimilators in origin. Ensure that you keep their disposition and details as vague as possible. Sentience is to not be confirmed, under any circumstances.</p>
<p>Any other extraneous facts can be confirmed via a present Representative, or a fax to EXCOM, per context.</p>
<p>Ensure that all those on the ship's manifest are briefed on the basic details entailed in this notice. They must not disseminate information outside of the guidelines to those not on the ship's manifest, and may not propagate it to those who are not representatives of the Solar Government. Breach of this notice's directives is punishable by <strong>Espionage</strong>, or <strong>Sedition</strong>, at the discretion of the attending <strong>Chief of Security</strong>.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the Admiral Henry Lau.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/cmoorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR CMO EYES.'"


/obj/item/folder/envelope/cmoorder/Initialize()
	. = ..()
	new /obj/item/paper/cmoorder (src)


/obj/item/paper/cmoorder
	name = "Notice of Care - Psychiatrics and Synthetics"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Commander Carom Andella, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> Notice of Care - Psychiatrics and Synthetics<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>This notice is for you to be aware of the repercussions of the situation that you, and your vessel has gone through.</p>
<p>As per information passed to us in the vague, and sparse burst transmissions - it is evident that the personnel of your vessel, Expeditionary, Fleet or Civilian, have clearly endured what is usually not expected of them.</p>
<p>Some may consider this to be reminiscent of the first contact involving the Vox, or even that of the Unathi. Hostile encounters are common, however, to the scale of involving deceased personnel while not unexpected, is unprecedented.</p>
<p>And so, at this time, the mental and physical care of your fellow officers and subordinates becomes ever more so crucial. As such, we have outlined a few guidelines with which to proceed, until your vessel reaches safe harbour.</p>
<p>1. Ensure that any crew that has been involved with the event is prioritised for psychiatric and physical care, with proper utilisation of your team.</p>
<p>2. The Fleet and Expeditionary branches are willing to offer emergency aid via long-range consultation as needed. Fleet hospital ships will be on stand-by on your route, in case transfers are required.</p>
<p>3. Ensure the integrity of your team, above all. Without a functioning medical department - the crew will fall apart.</p>
<p>4. Train your crew to identify common symptoms of depression and anxiety. Conduct sensitivity trainings and readiness evaluations for your personnel.
<p>With the potential involvement and compromise of synthetics, both human and non-human. It is essential that you correllate and co-operate with the Chief Engineer and roboticists of your vessel. Psychiatric evaluations of positronics are hence, <strong>mandatory</strong>.</p>
<p>Evaluations are to be forwarded to the Observatory for processing and review whenever possible.</p>
<p>In case of any queries or issues. Long range FTL communication bandwidth has been expanded for use by the Torch. Ensure no illness remains untreated.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/cosorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR COS EYES.'"


/obj/item/folder/envelope/cosorder/Initialize()
	. = ..()
	new /obj/item/paper/cosorder (src)


/obj/item/paper/cosorder
	name = "General Reminder - Security Guidelines"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Commander Liam Henshell, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> General Reminder - Security Guidelines<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>With your retreat from the affected sectors, and subsequent incidents that required to be handled. A few pointers are henceforth embolded in order to help you maintain authority aboard the SEV Torch.</p>
<p>1. Ensure to keep a check on increased rates of espionage attempts. With the muted state of the event, various non-Solar aligned actors will be looking to capitalise on this tragedy.</p>
<p>2. Ensure to keep a check on increased rates of sedition. Unrest and discontent amongst crew is common, especially after potentially catastrophic events of unknown origins. While the use of force is to be maintained and remains unchanged - attempt to be firm, but understanding.</p>
<p>3. Ensure to keep a check on your subordinates. The security crew is essential to the operations of the vessel. Fleet quick reaction forces will be on stand-by in case extra equipment is required.</p>
<p>4. In case of extreme breaches of the SCUJ (Sol Code of Uniform Justice), field court martials are <strong>henceforth encouraged</strong>. Permanant brigging and transfer of uniformed personnel may not be possible at all times.</p>
<p>5. Infractions caused by positronics (especially owned by the state), if any, must be scrutinised heavily. While damage to positronics is <strong>discouraged</strong>; psychiatric and mechanical evaluations of such units are to be conducted in co-operation with the <strong>Chief Medical Officer</strong> and <strong>Chief Engineer</strong>.
<p>6. Ensure security personnel attached to away-teams are equipped to handle synthetic threats.</p>
<p>It is important for you to assume an emergent state of distress if the need arises, until you reach your intended destination. Further guidelines and orders to follow beyond that point.</p>
<p>Crucially, your senior enlisted will be essential in these trying times. Try to keep them close.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/ceorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR CE EYES.'"


/obj/item/folder/envelope/ceorder/Initialize()
	. = ..()
	new /obj/item/paper/ceorder (src)


/obj/item/paper/ceorder
	name = "Emergency Orders - Electronic Warfare"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Commander Minnie Rosulia, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> Emergency Orders - Electronic Warfare<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>After scrutiny of available information, it has been determined that there is a major security risk of on-board ship systems. Reported compromises of electronic suites, and IT infrastructure is a serious matter.</p>
<p>As such, as the Chief Engineer of your vessel. You are <strong>strongly encouraged</strong> to conduct regular diagnostics and maintenance of automated drones, positronics and other on-board robotic systems.</p>
<p>Ensure that your roboticist is well versed with standard positronic biped platforms. As well as electronic security of said units.</p>
<p>Firmware update packages and security suites for NTNet and automated units will be sent via secure transmission from designated Fleet crafts, or via physical deliveries.</p>
<p>Ensure all SHA-512 encryption sets are well maintained, and kept up-to-date with provided, latest DAIS software specifications. Only accept update packages from verified parties.</p>
<p>Regular reports of psychiatric and physical evaluations of synthetic units is <strong>encouraged</strong>, in co-operation with the <strong>Chief Medical Officer</strong>. These reports must be sent to EXCOM when possible.</p>
<p>EXCOM has enacted a general order of caution, due to the high likelihood of electronic warfare from hostile parties. Any affected units must be isolated, and kept for research and evaluation.</p>
<p>In case of danger to the vessel, units affected by electronic warfare from unknown sources may be terminated per consideration from you, and the <strong>Chief of Security</strong>, or above.</p>
<p><strong>Release information only as needed. Leak of information without good reason is grounds for remediation. Contact EXCOM for any details.</strong></p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/exploorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR CSO/PATHFINDER EYES.'"


/obj/item/folder/envelope/exploorder/Initialize()
	. = ..()
	new /obj/item/paper/exploorder (src)


/obj/item/paper/exploorder
	name = "First Contact and Anomalies"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Lieutenant Vasco Espueza, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> First Contact and Anomalies<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>With the emergent need for a stronger solution to synthetic threats. It is <strong>authorised</strong> and <strong>highly encouraged</strong> to retain, study and utilise any anomalies exhibiting ionic properties.</p>
<p>Fleet cargo vessels will be authorised to carry anomalies from research sites, for studies aboard your vessel. Ensure a communique is sent to EXCOM for relay. Supply and logistics will be handled as needed.</p>
<p>Ensure that your research and exploration personnel are kept in top mental integrities at all times, as first contact procedures - especially hostile - are strongly draining on the psyche.</p>
<p>Regular evaluation of personnel is recommended, in co-operation with the <strong>Chief Medical Officer</strong>.
<p>Encounter with synthetic hostiles must now be treated with extreme precaution for the possibility of their presence being a matter of hostile actions beyond our scope of perception.</p><br />
<p>Security personnel attached to expeditions can be <strong>encouraged</strong>, however, the three directives of the Expeditionary Corps are still in effect.</p>
<p>As such, unneeded dispatching of non-exploration personnel will still be scrutinised heavily. Especially so with their needed presence on-board.</p>
<p>Any further first contact scenarios are to be taken with extreme caution while you are still in this region of space. Ensure no sentient alien presence breaches the vessel's integrity.</p>
<p>It is <strong>highly recommended</strong> to co-operate with the <strong>Chief Engineer</strong> to bolster integrity and security of electronic systems aboard the vessel. Any captured synthetic alien lifeform is <strong>recommended</strong> to be preserved, studied, and shipped off.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/dcorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR DC/XO EYES.'"


/obj/item/folder/envelope/dcorder/Initialize()
	. = ..()
	new /obj/item/paper/dcorder (src)


/obj/item/paper/dcorder
	name = "General Guidelines on Emergency Logistics"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Commander Vera Soo-Hyun, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> General guidelines on Emergency Logistics<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>This is with strong recommendation to follow appropriate validity and verification procedures when receiving and sending equipment and cargo.</p>
<p>Fleet cargo vessels will be operating in the area, and will be designated with the <strong>"FCV"</strong> temporary designations as a form of verification.</p>
<p>Your vessel's cargo pod will be re-programmed to link-up with any present <strong>"FCV"</strong> designated cargo vessels in the vicinity for regular resupply operations.</p>
<p>It is also <strong>strong encouraged</strong> to make use of direct communiques with EXCOM to relay requests for special cargo, as deemed necessary.</p>
<p>Cargo requests (in or out) from the <strong>Chief Engineer</strong>, <strong>Chief of Security</strong>, <strong>Chief Steward</strong> and <strong>Chief Science Officer</strong> are to be expected in high traffic.</p>
<p>Transfer for personnel (civilian or otherwise) is to be strongly verified by EXCOM or MARSCOM before granting entry. Docked civilian merchant vessels are to be checked and scrutinised heavily. A record must be made of such, and forwarded to EXCOM.</p>
<p>Prospecting and exploration operations are to be maintained. However, any away-team operations must be stringently timed, and return of such must be kept in mind. <strong>Retrieval of lost personnel will be impossible due to current circumstances.</strong></p>
<p>As such, while Standard Operating Procedures remain unchanged, and must still be followed - it is on the shoulders of the deck crew, or bridge crew to co-ordinate with away teams on their return times, whether verbally or via lodged flight plans.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/csorder
	desc = "A thick envelope. The Expeditionary Corps crest is stamped in the corner, along with 'DISSEMINATE AS NECESSARY. FOR CS/XO EYES.'"


/obj/item/folder/envelope/csorder/Initialize()
	. = ..()
	new /obj/item/paper/csorder (src)


/obj/item/paper/csorder
	name = "Notice - Crisis and Serenity"
	info = {"\
<center><h3>EXPEDITIONARY COMMAND - OBSERVATORY</h3>
<img src="eclogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Lieutenant Sam Nerehel, SCGEC Observatory<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory <br /><strong>SUBJECT:</strong> Notice - Crisis and Serenity<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>We are gravely disconcerted with your current situation. Operating a vessel's service crew under times of duress such as these can be challenging.</p>
<p>It is expected of you to ensure that proper burial and funerary services are being conducted by <strong>Medical</strong> and the <strong>Chaplains</strong>. The bodies must be preserved, and their names must be noted for posterity.</p>
<p>Upon return to safe harbour, a proper commemoration will be conducted. Ideally with your aid.</p>
<p>Coordinate with the <strong>Supply</strong> department in order to ensure you have a steady supply of proper rations and uplifting necessities.</p>
<p>It is suggested that you replenish lost food supplies with cheaper, and more ubiquitous insect protein for the duration of this retreat. While Fleet cargo vessels carry most basic necessities, emergency rationing must be considered.</p>
<p>The service department is crucial in the adequate maintenance and operation of the craft. Ensure that the standard is well maintained.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the SCGEC Observatory.</em></p>
<hr /><center><img src="eclogo.png" /></center>
"}


/obj/item/folder/envelope/clorder
	desc = "A thick envelope. The Expeditionary Corps Organisation crest is stamped in the corner, along with 'DO NOT DISSEMINATE. FOR CL EYES ONLY.'"


/obj/item/folder/envelope/clorder/Initialize()
	. = ..()
	new /obj/item/paper/clorder (src)


/obj/item/paper/clorder
	name = "Notice of Corporate Assets"
	info = {"\
<center><h3>EXPEDITIONARY CORPS ORGANISATION</h3>
<img src="exologo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Executive Dima Gorzarev, EXO Head Office<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>SUBJECT:</strong> Notice of Corporate Assets<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>We are currently aware of the situation surrounding your post. Considering the consequential events that are predicted to unfold, a few precautionary measures have been taken for your safety.</p>
<p>Primarily, requests for asset protection via a communique to <strong>EXO Head Offices</strong> will be prioritised. However, due to restrictions - corporate-aligned asset protection teams are unavailable.</p>
<p>Instead, Fleet asset protection units will be provided as necessary for your safety, should on-board security personnel prove to be inadequate.</p>
<p>In turn, it is expected of you to conduct a thorough review and interview of corporate entities aboard the vessel, and form a proper picture of the on-going incident as necessary.</p>
<p>For corporate personnel that were not directly involved, this is a good time to review their contractual obligations and offer changes in turn for variance in promised pay-out, due to the uncertain circumstances.</p>
<p>Contractors more in use for the vessel ensures proper functioning of the craft, and as such, it is upto the corporate liaision to ensure that contractors are loyal and abiding by the vessel's emergency procedures.</p>
<p>It is also important to note that EXO support in the form of personnel or equipment is currently slowed down heavily, and as such, your vessel will be relying on the Fleet, primarily.</p>
<p>Any pending transactions or hold-overs will be processed and reviewed when your vessel reaches E-14b.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the Expeditionry Corps Organisation.</em></p>
<hr /><center><img src="exologo.png" /></center>
"}


/obj/item/folder/envelope/cmdorder
	desc = "A thick envelope. The Sol Central Government crest is stamped in the corner, along with 'DO NOT DISSEMINATE. FOR SCGR/CO EYES ONLY.'"


/obj/item/folder/envelope/cmdorder/Initialize()
	. = ..()
	new /obj/item/paper/cmdorder (src)


/obj/item/paper/cmdorder
	name = "Guidelines on Emergency Reponsibilities"
	info = {"\
<center><h3>SOL CENTRAL GOVERNMENT</h3>
<img src="sollogo.png" /></center>
<p><tt><tt><strong>FROM:</strong> Director Francesca Del Rey, Bureau of Emergency Operations<br /><strong>TO:</strong> Expeditionary Corps Vessel #3, SEV Torch<br /><strong>CC:</strong> Admiral William Henry Lau, Observatory<br /><strong>SUBJECT:</strong> Guidelines of Emergency Reponsibilities<br /></tt></tt></p>
<hr />
<p>Good day.</p>
<p>Regarding the latest incident surrounding the SEV Torch. It is prudent that we tread extremely carefully.</p>
<p>With the potential of yet another hostile first contact, especially with synthetic assimilators capable of electronic warfare puts a majority of our services and systems at risk.</p>
<p>It also puts forth the dreadful question of hostilities outside of our scope of perception, including those that affected the Terran Commonwealth that came before us.</p>
<p>It is immensely prudent for your vessels to stay tightly run. While we are at a heightened alert, we do not wish to create distrust, and unrest in the greater part of the state. Considering current circumstances politically.</p>
<p>UMBRA protocols remain unchanged, and can be called as necessary. However a return to Sol is currently impossible due to distance, projected jump capabilities, and potential for further hostilities. As such, E-14b has been designated as your safe port.</p>
<p>Solar personnel aboard the joint GCC-SCG station will be informed to keep dissemination of information to non-Solar actors to a minimum.</p>
<p>Standard operation and cooperation of your crew is of the utmost importance. Fleet support is being provided as necessary. However, as detailed in various communiques - information security is to be maintained.</p>
<p>This further jeopardises expansion and colonisation efforts, as we try begin to go beyond the boundary of those that came before us.<p>
<p>Ensure regular interviews and personnel reviews to keep loyalty and performance consistent across the board. Once your vessel reaches E-14b, further instructions will be given, and regular expeditionary journeys will continue.</p>
<p>Funerary and aid services will be properly provided at that time.</p>
<hr />
<p>&nbsp;<em>This paper has been stamped with the insignia of the Sol Central Government.</em></p>
<hr /><center><img src="sollogo.png" /></center>
"}

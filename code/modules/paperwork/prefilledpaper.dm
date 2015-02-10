/datum/prefilledpaper
	var/name
	var/text

var/list/prefilledpapers = createprefilledpapers()

/proc/createprefilledpapers()
	var/list/allpapers = list()

	var/datum/prefilledpaper/prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Instructions"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Instructions:\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Make sure you have the right signatures and stamps:\[br\]
\[br\]
You will need the Heads' signature and stamp of where you want access to.\[br\]
If that area is highly secure, your own Head's signature and stamp is required as well as the reason for your demand.\[br\]
\[br\]
If you want to transfer to a new job, you need to get the signature and stamp of the Heads of your old and your new department.\[br\]
\[br\]
Please use the prepared forms provided in the blue folder.\[br\]
Pens have been provided to you with the standard issue PDA-device.\[br\]
\[br\]
Message the HoP's PDA if he is not present at his desk and doesn't respond to 145.9 calls.\[br\]
\[br\]
In the case of vacant positions, the signature required is to be replaced by one higher up in the chain of command.\[br\]
If several signatures would be from the same person, as they are mentioned several times in the form, please get them to fill out all the respective fields.\[br\]
Stamps in that matter are only required once.\[br\]
Those that do not have a stamp, because their position is not provided with one, are not required to stamp the form.\[br\]
\[br\]
\[br\]
Here are the respective department's accessible areas, sorted alphabetically, so that you may know who you will have to ask for their signature and stamp.\[br\]
Underlined areas require the Secure Access form.\[br\]
\[br\]
\[br\]
Captain:\[br\]
\[list\]\[*\]\[u\]Bridge\[/u\]\[*\]\[u\]ID computer\[/u\]\[*\]\[u\]AI Upload\[/u\]\[*\]\[u\]Teleporter\[/u\]\[*\]\[u\]EVA\[/u\]\[*\]\[u\]Personal Lockers\[/u\]\[*\]\[u\]Main Vault\[/u\]\[*\]\[u\]RC Announcements\[/u\]\[*\]\[u\]Keycode Authentication Device\[/u\]\[*\]\[u\]Telecommunications\[/u\]\[*\]\[u\]HoP's Office\[/u\]\[*\]\[u\]Captain's Office\[/u\]\[/list\]\[br\]
\[br\]
Chief Engineer:\[br\]
\[list\]\[*\]General Engineering Access\[*\]APCs\[*\]Maintenance\[*\]External Airlocks\[*\]\[u\]Technical Storage\[/u\]\[*\]Atmospherics\[*\]Construction Areas\[*\]Robotics\[*\]\[u\]Chief Engineer's Office\[/u\]\[/list\]\[br\]
\[br\]
Chief Medical Officer:\[br\]
\[list\]\[*\]General Medbay Access\[*\]Genetics Laboratory\[*\]Morgue\[*\]Chemistry Laboratory\[*\]\[u\]Virology\[/u\]\[*\]Surgery\[*\]\[u\]The CMO's office\[/u\]\[/list\]\[br\]
\[br\]
Head of Personnel:\[br\]
\[list\]\[*\]Kitchen\[*\]Bar\[*\]Hydroponics\[*\]Custodial Closet\[*\]Chapel Office\[*\]Crematorium\[*\]Library\[*\]Theatre\[*\]Law Office\[*\]Clown Access\[*\]Mime Access\[/list\]\[br\]
\[br\]
Head Of Security:\[br\]
\[list\]\[*\]General Security Access\[*\]\[u\]Brig Cells\[/u\]\[*\]\[u\]Armory\[/u\]\[*\]Detective's Office\[*\]Courtroom\[*\]\[u\]HoS' Office\[/u\]\[/list\]\[br\]
\[br\]
Quartermaster:\[br\]
\[list\]\[*\]Cargo Bay\[*\]Cargo Bot Delivery\[*\]Delivery Office\[*\]\[u\]Quartermaster's Office\[/u\]\[*\]Mining\[*\]\[u\]Mining Station EVA\[/u\]\[/list\]\[br\]
\[br\]
Research Director:\[br\]
\[list\]\[*\]General Science Access\[*\]Research Lab\[*\]\[u\]Toxins Storage\[/u\]\[*\]\[u\]Xenobiology Laboratory\[/u\]\[*\]\[u\]RD's Office\[/u\]\[/list\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Head Promotion"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Promotion To A Headposition\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, Captain \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Captain's name)\[/small\]\[br\]
hereby promote \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Promoted person)\[/small\]\[br\]
to be the new \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Position)\[/small\]\[br\]
\[br\]
\[br\]
Signature:\[br\]
\[field\]\[small\](Captain's signature)\[/small\]\[br\]
\[br\]
\[hr\]\[br\]
Stamp below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Job Transfer Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[b\]\[u\]\[i\]Job Transfer Form\[/b\]\[/u\]\[/i\]\[br\]
\[i\]\[b\]NanoTrasen Hypatia Station\[/b\]\[/i\]\[/center\]
\[hr\]
\[center\]Name: \[field\]\[br\]\[/center\]
\[center\]Rank: \[field\]\[br\]\[/center\]
\[hr\]
From department: \[field\]\[br\]
To department: \[field\]\[br\]
Requested Position: \[field\]\[br\]
\[hr\]
Reason(s): \[field\]\[br\]
Signature: \[field\]\[br\]
\[hr\]
\[center\]\[b\]Authorization\[/b\]\[br\]
Transferring department head: \[field\]\[br\]
Receiving department head: \[field\]\[br\]
Head of Personnel: \[field\]\[br\]\[br\]\[/center\]
If authorized, please sign above and stamp the document with the Department Stamp.\[br\]\[br\]
Guidelines that must be followed. If they are not followed, this form is void and illegal.\[br\]
\[list\]\[*\]All department heads must agree to the transfer before transfer can take place.
\[*\]If the transferred has been transferred for an invalid or illegal reason, this form is immediately void and unlawful.
\[*\]In the event a relevant head of staff retracts his or her approval for this transfer, this form is immediately void and unlawful.\[/list\]
\[br\]\[hr\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Extended Field of Work Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[b\]\[u\]\[i\]Extended Access Form\[/b\]\[/u\]\[/i\]\[br\]
\[i\]\[b\] NanoTrasen Hypatia Station \[/i\]\[/b\]\[/center\]
\[hr\]
\[center\]Name: \[field\]\[br\]\[/center\]
\[center\]Rank: \[field\]\[br\]\[/center\]
\[hr\]
Requested Access: \[field\]\[br\]
Reason(s): \[field\]\[br\]
Signature: \[field\]\[br\]
\[hr\]
\[center\]\[b\]Authorization\[/b\]\[br\]
Name: \[field\]\[br\]
Rank: \[field\]\[br\]\[br\]\[/center\]
If authorized, please sign here, \[field\], and stamp the document with the Department Stamp.\[br\]\[br\]
Guidelines that must be followed. If they are not followed, this form is void and illegal.\[br\]
\[list\]\[*\]The department in which the requester is requesting access must first be contacted, and the head of the department (acting or otherwise) must have been talked to and have authorized this request.\[*\]If any criminal activity is done with the help of this extra access, this form will be immediately void and unlawful.\[*\]If the chief of the affected department wishes this form void, this form is immediately void and unlawful.\[/list\]
\[br\]\[hr\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Extended Access Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[b\]\[u\]\[i\]Extended Access Form\[/b\]\[/u\]\[/i\]\[br\]
\[i\]\[b\] NanoTrasen Hypatia Station \[/i\]\[/b\]\[/center\]
\[hr\]
\[center\]Name: \[field\]\[br\]\[/center\]
\[center\]Rank: \[field\]\[br\]\[/center\]
\[hr\]
Requested Access: \[field\]\[br\]
Reason(s): \[field\]\[br\]
Signature: \[field\]\[br\]
\[hr\]
\[center\]\[b\]Authorization\[/b\]\[br\]
Name: \[field\]\[br\]
Rank: \[field\]\[br\]\[br\]\[/center\]
If authorized, please sign here, \[field\], and stamp the document with the Department Stamp.\[br\]\[br\]
Guidelines that must be followed. If they are not followed, this form is void and illegal.\[br\]
\[list\]\[*\]The department in which the requester is requesting access must first be contacted, and the head of the department (acting or otherwise) must have been talked to and have authorized this request.\[*\]If any criminal activity is done with the help of this extra access, this form will be immediately void and unlawful.\[*\]If the chief of the affected department wishes this form void, this form is immediately void and unlawful.\[/list\]
\[br\]\[hr\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Secure Access Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Secure Access Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\],\[br\]
request to gain access to \[i\]\[u\]\[field\]\[/u\]\[/i\]\[small\](Area)\[/small\],\[br\]
because \[i\]\[u\]\[field\]\[/u\]\[/i\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Area's head's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Emergency Access Grant"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Emergency Access Grant\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Captain or Head of Personnel's name)\[/small\],\[br\]
hereby grant \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Concerning person)\[/small\]\[br\]
the following access due to urgent, lawful circumstances: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Areas)\[/small\]\[br\]
\[br\]
\[br\]
Signature:\[br\]
\[field\]\[small\](Captain's signature)\[/small\]\[br\]
\[br\]
\[hr\]\[br\]
Stamp below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Personnel: Demotion Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[b\]\[u\]\[i\]Job Demotion Record\[/b\]\[/u\]\[/i\]\[br\]
\[i\]\[b\] NanoTrasen Hypatia Station \[/i\]\[/b\]\[/center\]
\[hr\]
\[center\]Name:\[field\]\[/center\]\[br\]
\[center\]Position:\[field\]\[/center\]\[br\]
\[hr\]
Terminated Employee: \[field\]\[br\]
Demoted from the assignment of: \[field\]\[br\]
Reason for Termination: \[field\]\[br\]
\[hr\]
\[center\]\[b\]Authorization\[/b\]\[br\]
Name: \[field\]\[br\]
Rank: \[field\]\[br\]\[br\]\[/center\]
If authorized, please sign here, \[field\], and stamp the document with the Department Stamp.\[br\]\[br\]
Guidelines that must be followed. If they are not followed, this form is void and illegal.\[br\]
\[list\]\[*\]The department in which the terminated has been terminated must first be contacted, and the chief (acting or otherwise) of the department must have been consulted and have authorized a termination.
\[*\]If the terminated has been removed from his or her position for an invalid or illegal reason, this form is immediately void and unlawful.
\[*\]In the event a relevant head of staff retracts his or her approval for this assignment termination, this form is immediately void and unlawful.\[/list\]
\[br\]\[hr\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Medical: Medical Supply Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Medical Supply Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\],\[br\]
request to acquire the following items from the Medbay staff: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Supplies/Equipment)\[/small\]\[br\]
The reasons are: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Chief Medical Officer's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Medical: Surgical Operation Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Surgical Operation Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\],\[br\]
request to be surgically treated by the Medbay staff: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Kind of operation)\[/small\]\[br\]
The reasons are: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Chief Medical Officer's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Medical: Genetical Enhancement Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Genetical Enhancement Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\],\[br\]
request to be genetically enhanced by the Medbay staff: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Kind of enhancement)\[/small\]\[br\]
The reasons are: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Captain's signature)\[/small\]\[br\]
\[field\]\[small\](Research Director's signature)\[/small\]\[br\]
\[field\]\[small\](Chief Medical Officer's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Medical: Borgification Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[u\]\[i\]\[large\] Cyborgification Request\[/center\]\[/large\]\[/u\]\[/i\]\[br\]
\[hr\]
\[br\]
Name of the Requester: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\]\[br\]
Department they are currently in:\[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Department Name)\[/small\]\[br\]
\[hr\]
\[center\]\[u\]\[b\]Requestors Statement\[/center\]\[/u\]\[/b\]\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\], request to be turned into a \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Kind of cyborg)\[/small\] by the Roboticist \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Roboticist's name)\[/small\]\[br\]
I am fully aware of the possible difficulties the procedure might bring with it and have been adequately counseled by the current Medical staff on board the station. I understand that once I am approved for this request, I am giving up all rights as a free being and will be bound to NanoTrasen via my Cybernetic laws. In no way will I hold NanoTrasen responsible if anything unexpected should occur during the surgical procedure. \[br\]
I understand that I cannot come back from this, and I am willing to pledge my servitude to NanoTrasen.\[br\]
\[hr\]
\[center\]\[u\]\[b\]Approved By:\[/center\]\[/u\]\[/b\]\[br\]
 \[field\]\[small\](Your signature)\[/small\]\[br\]
 \[field\]\[small\](Roboticist's signature)\[/small\]\[br\]
 \[field\]\[small\](Chief Medical Officer's signature)\[/small\]\[br\]
 \[field\]\[small\](Research Director's signature)\[/small\]\[br\]
 \[field\]\[small\](Captain's signature)\[/small\]\[br\]
\[small\] All signature fields must be filled out in order for this request to be made valid. A stamped and signed Central Command Fax must also be paper clipped to this request in order for it to be proper. \[/small\]
\[hr\]
Stamps of the required heads \[b\]\[u\]MUST\[/b\]\[/u\] go below this line. Any signature of a head that does not carry a stamp below this line will be considered forged.\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Chemistry: Controlled Pharmaceutical Request Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Controlled Pharmaceutical Request Form\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\], hereby request \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Quantity and name of pharmaceutical)\[/small\], which I know to be a controlled substance. I acknowledge that NanoTrasen, the Chemistry department, and this space station are not liable for any adverse effects that may result from use of this substance. In addition, I take full responsibility for the quantity requested and personally guarantee against its loss, theft, or misuse by any third party.\[br\]
\[br\]
Signed:\[br\]
\[field\]\[small\](Requesting party's signature)\[/small\]\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Chemist's signature)\[/small\]\[br\]
\[field\]\[small\](Chief Medical Officer's signature)\[/small\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Chemistry: Dangerous Substance Request Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Dangerous Substance Request Form\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\], hereby request \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Quantity and name of chemical(s) requested, and their form factor)\[/small\], which I know to be a potentially dangerous substance. I acknowledge that NanoTrasen, the Medical department, and this space station are not liable for any adverse effects that may result from use of this substance. In addition, I take full responsibility for the quantity requested and personally guarantee against its loss, theft, or misuse by any third party.\[br\]
\[br\]
Signed:\[br\]
\[field\]\[small\](Requesting party's signature)\[/small\]\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Chemist's signature)\[/small\]\[br\]
\[field\]\[small\](Head of Security's signature)\[/small\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Cargo: Autolathe Usage"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Autolathe-Item Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Your name)\[/small\],\[br\]
request to acquire the following items from the autolathe: \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Equipment)\[/small\].\[br\]
The reasons are: \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[field\]\[small\](Quartermaster's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Cargo: Autolathe Receipt"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Receipt\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Hereby it is confirmed that \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Name)\[/small\]'s ordered equipment has been handed to him/her and that he/she is now the rightful owner.\[br\]
Cargo Bay personnel wishes only the best for his/her future endeavours and would be honoured to be of assistance again.\[br\]
\[br\]
\[br\]
Approved:
\[field\]\[small\](Cargo Bay personnel's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamp below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Cargo: Order Receipt"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Receipt\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Cargo Bay personnel)\[/small\],
hereby confirm the arrival of \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Recipient)\[/small\]'s
ordered crates: \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Order)\[/small\].\[br\]
Cargo Bay personnel wishes only the best for his/her future endeavours and would be honoured to be of assistance again.\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Cargo Bay personnel's signature)\[/small\]\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Cargo: Acknowledgement of Receipt"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Acknowledgement of Receipt\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Your name)\[/small\],\[br\]
hereby confirm the arrival of my ordered equipment: \[u\]\[i\]\[field\]\[/u\]\[/i\]\[small\](Order, to be filled out by Cargo Bay personnel)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[field\]\[small\](Cargo Bay personnel's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamp below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Cargo: Crate Receipt"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Receipt\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Hereby it is confirmed that \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Name)\[/small\]'s ordered crates have been returned empty or filled with equipment without further use.\[br\]
Cargo Bay personnel wishes only the best for his/her future endeavours and would be honoured to be of assistance again.\[br\]
\[br\]
\[br\]
Approved:
\[field\]\[small\](Cargo Bay personnel's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamp below:\[br\]
\[br\]"}


	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Guide to Security"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[b\]\[u\]Security Basic Rules & Guidelines\[/b\]\[/u\]\[/center\]\[br\]
\[hr\]
\[br\]
\[center\]\[b\]Golden rule:\[/b\] Keep communications up at all times on the Security Channel and
report all movements, arrests and all security matters over the radio!\[/center\]\[br\]
\[hr\]\[br\]\[list\]
\[*\]\[b\]T\[/b\]alk first, stun second!\[br\]
\[*\]\[b\]A\[/b\]lways call for backup before attempting to confront a possibly dangerous criminal!\[br\]
\[*\]\[b\]C\[/b\]harge your weapons after every use/arrest!\[br\]
\[*\]\[b\]T\[/b\]ry to avoid using force - unless you are threatened!\[br\]
\[*\]\[b\]I\[/b\]nform the Warden when a criminal is wanted, Beepsky is a force to be reckoned with!\[br\]
\[*\]\[b\]C\[/b\]alm yourself and others under all circumstances, anger and fear show weakness!\[br\]
\[*\]\[b\]A\[/b\]lways lock every locker in Security and never leave weapons lying around!\[br\]
\[*\]\[b\]L\[/b\]et nobody enter the crime scene, apart from the detective!\[/list\]\[br\]
\[br\]
Be \[b\]T.A.C.T.I.C.A.L.\[/b\]!\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Injunction"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Injunction\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
The crew member \[u\]\[i\]\[field\]\[/i\]\[/u\] is hereby forbidden from \[u\]\[i\]\[field\]\[/i\]\[/u\].\[br\]
Should they be witnessed not satisfying this regulation, they will be breaking Space Law 107, which warrants a punishment of up to 10 minutes of incarceration. Repeated offenders may be receiving harsher punishments.\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Captain/Head of Personnel's signature)\[/small\]\[br\]
\[field\]\[small\](Head of Security's signature)\[/small\]\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Weaponry Request"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Weapon And Armor Request\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\],\[br\]
request to acquire the following items from the Armory: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Equipment)\[/small\]\[br\]
The reasons are: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Reasons)\[/small\].\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Warden's signature)\[/small\]\[br\]
\[field\]\[small\](Your head's signature)\[/small\]\[br\]
\[field\]\[small\](Your signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Carrying License"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Carrying License\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
\[\[field\]\]concealed\[br\]
\[\[field\]\]open\[br\]
\[br\]
Hereby it is confirmed that \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Name)\[/small\] has been deemed able and worthy of carrying the following the weaponry: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Species: \[\[field\]\]Human \[\[field\]\]Tajaran \[\[field\]\]Skrell \[\[field\]\]Soghun\[br\]
Gender: \[\[field\]\]Male \[\[field\]\]Female\[br\]
Fingerprint-ID: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
He/She has been notified that carrying the weapon without this permit is a violation of law 212 - Contraband.\[br\]
\[br\]
\[br\]
Approved:
\[field\]\[small\](Head of Security's signature)\[/small\]\[br\]
\[br\]
\[hr\]
\[br\]
Stamp below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Search Warrant"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[large\]\[center\]\[b\] Warrant for Search and Seizure \[/b]\[/large\]

\[i\]\[u\]NanoTrasen Hypatia Space Station\[/u\]\[/i\]\[/center\]
\[hr]
\[br]
\[i\]Official Requesting the Search:\[/i\] \[field\]

\[i\]Person(s)/area being searched:\[/i\] \[field\]

\[i\]Probable Cause for search:\[/i\] \[field\]

\[br\]
Officers of NanoTrasen's Hypatia Space Station are commanded to search the following personnel without unnecessary delay.
\[br\]
\[b\]Important\[/b\]: Any illegal items found upon the searched individual may be seized by the searching officer and the person being searched is to be arrested for any crimes linked to the item(s).
\[hr\]
\[br\]
\[u\]Head of Security Signature:\[/u\] \[field\]

\[u\]Captain/Head of Personnel:\[/u\] \[field\]
\[br]
\[small\]A Captain or Head of Personnel signature is required to make this warrant just and proper. Without this signature of approval alongside the Head of Security's signature, this warrant cannot be acted on.\[/small\]
\[br\]\[br\]
Note that a warrant is not required to obtain illegal items or objects that are in plain view, may cause danger to the station, or are found through a consented search."}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Arrest Warrant"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[center\]\[b\]\[u\]Warrant for Arrest\[/u\]\[/Large\]\[/center\]\[/b\]\[br\]
\[center\]\[i\]\[u\]NanoTrasen Hypatia Space Station\[/center\]\[/i\]\[/u\]
\[hr\]
\[center\]Official Requesting Arrest:\[field\]\[/center\]\[br\]
\[center\]Probable Cause for Arrest:\[field\]\[/center\]\[br\]
\[center\]\[i\]\[b\]Case Number:\[/i\]\[/b\]\[field\]\[/center\]
\[br\]
Officers of NanoTrasens Hypatia Space Station are commanded to arrest the following personnel and bring to the stations Brig without unnecessary delay. \[field\]\[small\]\[i\](name of person to be arrested)\[/small\]\[/i\]
\[br\]
They are accused of an offense or violation of the following laws of NanoTrasen:(Please write Yes to the crimes committed)\[br\]
\[center]Minor Crimes\[/center]
\[list\]\[*\]101\[field\]\[*\]102\[field\]\[*\]103\[field\]\[*\]104\[field\]\[*\]105\[field\]\[*\]106\[field\]\[*\]107\[field\]\[*\]108\[field\]\[*\]109\[field\]\[*\]110\[field\]\[*\]111\[field\]\[*\]112\[field\]\[*\]113\[field\]\[*\]114\[field\]\[*\]115\[field\]\[/list\]
\[hr\]
\[center\]Medium Crimes\[/center\]
\[list\]\[*\]201\[field\]\[*\]202\[field\]\[*\]203\[field\]\[*\]204\[field\]\[*\]205\[field\]\[*\]206\[field\]\[*\]207\[field\]\[*\]208\[field\]\[*\]209\[field\]\[*\]210\[field\]\[*\]211\[field\]\[*\]212\[field\]\[*\]213\[field\]\[*\]214\[field\]\[*\]215\[field\]\[*\]216\[field\]\[*\]217\[field\]\[*\]218\[field\]\[*\]219\[field\]\[*\]220\[field\]\[*\]221\[field\]\[/list\]
\[hr\]
\[center\]Major Crimes\[/center\]
\[list\]\[*\]301\[field\]\[*\]302\[field\]\[*\]303\[field\]\[*\]304\[field\]\[*\]305\[field\]\[*\]306\[field\]\[*\]307\[field\]\[*\]308\[field\]\[/list\]
\[hr\]
\[i\]Briefly describe the event causing the arrest:\[/i\]\[field\]
\[br]
\[u\]Head of Security Signature:\[/u\]\[field\]\[br\]
\[small\]A Head of Security Stamp of Approval is required to make this warrant just and proper. Without a stamp of approval, this warrant cannot be acted on.\[/small\]\[br\]
\[br\]
\[center\] Office Information\[/center\]
\[u\]Date:\[/u\]\[field\]
\[u\]Time:\[/u\]\[field\]
\[u\]Arresting Officer(s):\[/u\]\[field\]\[br\]
\[br\]
Note that a warrant is not required for a crime that was committed in Security's presence, search incident to a lawful arrest, if an illegal act/item is in plain view, emergencies/hot pursuit, or if to prevent danger to the station or crew."}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Investigation/Incident Report"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Investigation/Incident Report\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Fill in only what applies, otherwise write "N/A'
Lead Investigator: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Reporting Officer: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Occupation: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Case Number: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Parties Involved: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Date of Incident: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Type of Incident: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Lead Suspect: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Suspect in Custody: (Y/N) \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Case Status: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Details: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
\[br\]
\[hr\]
\[br\]
Lead Investigator/Reporting Officer's signature: \[field\]\[br\]
Head of Security's signature: \[field\]\[br\]
\[br\]
Note:  Under case status, one of the following should be filled in: Cleared by arrest, cleared by exceptional means, or cold. Cold is self-explanatory, cleared by arrest means that the suspect is in custody, and cleared by exceptional means is defined as 'We know who committed the crime, but for any reason we are not able to fully prove it' such as a witness refusing to come forward, the suspect is deceased, et cetera."}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Security: Emergency Armament"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Emergency Armament\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Hereby we authorize the general armament of all crewmembers in order to defend the crew and station.\[br\]
\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Warden's signature)\[/small\]\[br\]
\[field\]\[small\](Head of Security's signature)\[/small\]\[br\]
\[field\]\[small\](Captain's signature)\[/small\]\[br\]
\[br\]
\[hr\]\[br\]
Stamps below:\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Internal Affairs: Complaint"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Complaint\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Name: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Occupation: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Concerning person: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Above's occupation: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Time: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Reason for complaint: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Preferred action \[small\](Please tick)\[/small\]:\[br\]
\[\[field\]\]Mediation\[br\]
\[\[field\]\]Scolding\[br\]
\[\[field\]\]Fine/Paycut\[br\]
\[\[field\]\]Injunction\[br\]
\[\[field\]\]Demotion\[br\]
\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Internal Affairs: Investigation Report"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[large\]\[b\]\[center\]NANOTRASEN STATION: HYPATIA\[/b\]\[/center\]\[br\]\[/large\]
\[i\]\[center\]INTERNAL INVESTIGATION REPORT\[/i\]\[/center\]\[br\]
\[br\]
Type of Complaint: \[field\]\[br\]
Complainant: \[field\]\[br\]
Time of occurrence: \[field\]\[br\]
Location of occurrence: \[field\]\[br\]
Employee(s) involved: \[field\]\[br\]
\[br\]
Details of Complaint: \[field\]\[br\]
\[hr\]
How received: \[field\]\[br\]
Complaint investigated by: \[field\]\[br\]
Reviewed by: \[field\]\[br\]
\[br\]
Reviewer Comment: \[field\]\[br\]
\[br\]
Signature: \[field\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Botany: Controlled Substances Request form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Controlled Substances Request Form (Hydroponics)\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
I, \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Your name)\[/small\], hereby request \[u\]\[i\]\[field\]\[/i\]\[/u\]\[small\](Quantity and name of crop)\[/small\], which I know to be a controlled substance. I acknowledge that NanoTrasen, the Hydroponics department, and this space station are not liable for any adverse effects that may result from use of this substance. In addition, I take full responsibility for the quantity requested and personally guarantee against its loss, theft, or misuse by any third party.\[br\]
\[br\]
Signed:\[br\]
\[field\]\[small\](Requesting party's signature)\[/small\]\[br\]
\[br\]
Approved:\[br\]
\[field\]\[small\](Botanist's signature)\[/small\]\[br\]
\[field\]\[small\](Head of Security's signature)\[/small\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Botany: Unusual Substance Request Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Unusual Substance Request Form (Hydroponics)\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
Quantity and name of crop: \[field\]\[br\]
Requested by: \[field\]\[small\](Print name and job title)\[/small\]\[br\]
\[br\]
By signing this form I acknowledge that acquisition of the requested crop may take some time and is not guaranteed.\[br\]
\[br\]
Signed:\[br\]
\[field\]\[small\](Requesting party's signature)\[/small\]\[br\]
\[br\]
Approved by:\[br\]
\[field\]\[small\](Head of requesting party's department)\[/small\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Botany: Hydrophonics Container Request Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Hydroponics Container Request Form\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
Quantity: \[field\]\[br\]
Requested by: \[field\]\[small\](Print name and job title)\[/small\]\[br\]
\[br\]
In addition, I would like the following supplies:\[/br\]
\[field\]\[small\](Number and name of plant)\[/small\] seed packets, and (mark an X next to all that apply)\[/br\]
\[field\] 1 bucket\[br\]
\[field\] 1 mini-hoe\[br\]
\[field\] 1 plant bag\[br\]
\[field\] 1 hatchet\[br\]
\[field\] 5 bottles of nutrient solution: \[field\]\[small\](Optional - Requested solution; will receive EZ-Nutrient if left blank)\[/small\]\[br\]
\[field\] Other supplies: \[field\]\[small\](Specify)\[/small\]\[br\]
\[br\]
Signed:\[br\]
\[field\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "Botany: Hydrophonics Request Form"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[center\]\[large\]\[u\]Hydroponics Request Form\[/u\]\[/large\]\[/center\]\[br\]
\[br\]
\[br\]
Quantity and name of item: \[field\]\[br\]
Requested by: \[field\]\[small\](Print name and job title)\[/small\]\[br\]
Time of request: \[field\]
\[br\]
\[br\]
Signed:\[br\]
\[field\]\[br\]"}

	prefilledtemp = new /datum/prefilledpaper()
	prefilledtemp.name = "General: Report"
	allpapers.Add(prefilledtemp)
	prefilledtemp.text = {"\[Large\]\[u\]Report\[/u\]\[/Large\]\[br\]
\[br\]
\[br\]
Name: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Occupation: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Parties Involved: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Time of incident: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
Type of incident: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
Details: \[u\]\[i\]\[field\]\[/i\]\[/u\]\[br\]
\[br\]
\[br\]
\[hr\]
\[br\]
Signature: \[field\]\[br\]
\[br\]"}

	return allpapers
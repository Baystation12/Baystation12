/*
Program-based computers (similar to computer3 project, which this system replaces. It may, in future, be extended to other devices)


1. Basic information
Program based computers will allow you to do multiple things from single computer. Each computer will have programs, with more being downloadable from NTNet (stationwide wireless network)
if user has apropriate ID card access. It will be possible to hack the computer by using an emag on it - the emag will have to be completely new and will be consumed on use, but it will
lift ALL locks on ALL installed programs, and allow download of programs even if your ID doesn't have access to them. Computers will have hard drives that can store files.
Files can be programs (datum/computer_file/program/ subtype) or data files (datum/computer_file/data/ subtypes). Program for sending files will be available that will allow transfer via NTNet.
NTNet coverage will be limited to station's Z level, but better network card (=more expensive and higher power use) will allow usage everywhere. Hard drives will have limited capacity for files
which will be related to how good hard drive you buy when purchasing the laptop. For storing more files USB-style drives will be buildable with Protolathe in research.

2. Laptops
Laptops are vendable via vending machine similar to how original laptops worked. This vending machine will allow hardware selection (hardware will be described below). Laptops will be
quite expensive, basic cost being 1499$ + cost of any extra hardware. When purchased they will contain only basic software (text editor, game, etc.) but more will be downloadable via NTNet.

3. Laptop Hardware
Laptops will come with basic hardware installed, with upgrades being selectable when purchasing the laptop.
Hard Drive: Basic (20 GQ, free), Advanced (35 GQ, +199$), Super (60 GQ, +499$) One file (program or data file) equals 1GQ of capacity, regardless of file contents.
Network Card: Basic (NTNet on station Z levels, free), Advanced (NTNet on all Z levels, +399$)
Battery: Basic (about 10 minutes of charge, free), Advanced (about 20 minutes of charge, +199$), Super (about 30 minutes of charge, +399$)
Extras (those won't be installed by default)
ID Card Slot (required for HoP-style programs to work. Access for security record-style programs is read from ID of user [RFID?] without requiring this) - 99$
APC Wireless Relay (allows the computer to run from APC, including slow recharge) - 499$
Disk Drive (allows usage of data disks that store 10GQ of data, comes with FREE disk already inside!) - 199$
Nano Printer (allows the computer to store few pieces of paper and print text files on them [NOTE: Paper not included!]) - 199$ // HoP's best friend!

4. NTNet
NTNet is stationwide network that allows users to download programs needed for their work. It will be possible to send any files to other active computers using relevant program (NTN Transfer).
NTNet is under jurisdiction of both Engineering and Research. Engineering is responsible for any repairs if necessary and research is responsible for monitoring. It is similar to PDA messaging.
Operation requires functional "NTNet Relay" which is by default placed on tcommsat. If the relay is damaged NTNet will be offline until it is replaced. Multiple relays bring extra redundancy,
if one is destroyed the second will take over. If all relays are gone it stops working, simple as that. NTNet may be altered via administration console available to Research Director. It is
possible to enable/disable Software Downloading, P2P file transfers and Communication (IC version of IRC, PDA messages for more than two people)

5. Software
Software would almost exclusively use NanoUI modules. Few exceptions are text editor (uses similar screen as TCS IDE used for editing and classic HTML for previewing as Nano looks differently)
and similar programs which for some reason require HTML UI. Most software will be highly dependent on NTNet to work as laptops are not physically connected to the station's network.
What i plan to add:

Note: XXXXDB programs will use ingame_manuals to display basic help for players, similar to how books, etc. do

Basic - Software in this bundle is automagically preinstalled in every new computer
	NTN Transfer - Allows P2P transfer of files to other computers that run this.
	Configurator - Allows configuration of computer's hardware, basically status screen.
	File Browser - Allows you to browse all files stored on the computer. Allows renaming/deleting of files.
	TXT Editor - Allows you editing data files in text editor mode.
	NanoPrint - Allows you to operate NanoPrinter hardware to print text files.
	NTNRC Chat - NTNet Relay Chat client. Allows PDA-messaging style messaging for more than two users. Person which created the conversation is Host and has administrative privilegies (kicking, etc.)
	NTNet News - Allows reading news from newscaster network.

Engineering - Requires "Engineering" access on ID card (ie. CE, Atmostech, Engineer)
	Alarm Monitor - Allows monitoring alarms, same as the stationbound one.
	Power Monitor - Power monitoring computer, connects to sensors in same way as regular one does.
	Atmospheric Control - Allows access to the Atmospherics Monitor Console that operates air alarms. Requires extra access: "Atmospherics"
	RCON Remote Control Console - Allows access to the RCON Remote Control Console. Requires extra access: "Power Equipment"
	EngiDB - Allows accessing NTNet information repository for information about engineering-related things.

Medical - Requires "Medbay" access on ID card (ie. CMO, Doctor,..)
	Medical Records Uplink - Allows editing/reading of medical records. Printing requires NanoPrinter hardware.
	MediDB - Allows accessing NTNet information repository for information about medical procedures
	ChemDB - Requires extra access: "Chemistry" - Downloads basic information about recipes from NTNet

Research - Requires "Research and Development" access on ID card (ie. RD, Roboticist, etc.)
	Research Server Monitor - Allows monitoring of research levels on RnD servers. (read only)
	Robotics Monitor Console - Allows monitoring of robots and exosuits. Lockdown/Self-Destruct options are unavailable [balance reasons for malf/traitor AIs]. Requires extra access: "Robotics"
	NTNRC Administration Console - Allows administrative access to NTNRC. This includes bypassing any channel passwords and enabling "invisible" mode for spying on conversations. Requires extra access: "Research Director"
	NTNet Administration Console - Allows remote configuration of NTNet Relay - CAUTION: If NTNet is turned off it won't be possible to turn it on again from the computer, as operation requires NTNet to work! Requires extra access: "Research Director"

Security - Requires "Security" access on ID card (ie. HOS, Security officer, Detective)
	Security Records Uplink - Allows editing/reading of security records. Printing requires Nanoprinter hardware.
	LawDB - Allows accessing NTNet information repository for security information (corporate regulations)
	Camera Uplink - Allows viewing cameras around the station.

Command - Requires "Bridge" access on ID card (all heads)
	Alertcon Access - Allows changing of alert levels. Red requires activation from two computers with two IDs similar to how those wall mounted devices do.
	Employment Records Access - Allows reading of employment records. Printing requires NanoPrinter hardware.
	Communication Console - Allows sending emergency messages to Central.
	Emergency Shuttle Control Console - Allows calling/recalling the emergency shuttle.
	Shuttle Control Console - Allows control of various shuttles around the station (mining, research, engineering)

6. Security
Laptops will be password-lockable. If password is set a MD5 hash of it is stored and password is required every time you turn on the laptop.
Passwords may be decrypted by using special Decrypter (protolathable, RDs office starts with one) device that will slowly decrypt the password.
Decryption time would be length_of_password * 30 seconds, with maximum being 9 minutes (due to battery life limitations, which is 10+ min).
If decrypted the password is cleared, so you can keep using your favorite password without people ever actually revealing it (for meta prevention reasons mostly).
Emagged laptops will have option to enable "Safe Encryption". If safely encrypted laptop is decrypted it loses it's emag status and 50% of files is deleted (randomly selected).
*/
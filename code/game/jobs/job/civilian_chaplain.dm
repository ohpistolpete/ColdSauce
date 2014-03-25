//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_morgue, access_chapel_office, access_crematorium)

	//Pretty bible names
	var/global/list/biblenames =		list("Bible", "Koran", "Scrapbook", "Creeper", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon")

	//Bible iconstates
	var/global/list/biblestates =		list("bible", "koran", "scrapbook", "creeper", "white", "holylight", "athiest", "tome", "kingyellow", "ithaqua", "scientology", "melted", "necronomicon")

	//Bible itemstates
	var/global/list/bibleitemstates =	list("bible", "koran", "scrapbook", "syringe_kit", "syringe_kit", "syringe_kit", "syringe_kit", "syringe_kit", "kingyellow", "ithaqua", "scientology", "melted", "necronomicon")

	Topic(href, href_list)
		if(href_list["seticon"])
			var/iconi = text2num(href_list["seticon"])

			//Set biblespecific chapels
			switch(iconi)
				if(1)
					for(var/area/chapel/main/A in world)
						for(var/turf/T in A.contents)
							if(T.icon_state == "carpetsymbol")
								T.dir = 2
				if(2)
					for(var/area/chapel/main/A in world)
						for(var/turf/T in A.contents)
							if(T.icon_state == "carpetsymbol")
								T.dir = 4
				if(7)
					for(var/area/chapel/main/A in world)
						for(var/turf/T in A.contents)
							if(T.icon_state == "carpetsymbol")
								T.dir = 10

			var/biblename = biblenames[iconi]
			var/obj/item/weapon/storage/bible/B = locate(href_list["bible"])

			B.name = biblename
			B.icon_state = biblestates[iconi]
			B.item_state = bibleitemstates[iconi]

			usr.update_inv_l_hand(0) // Update inhand icon

			if(ticker)
				ticker.Bible_icon_state = B.icon_state
				ticker.Bible_item_state = B.item_state
				ticker.Bible_name = B.name
			feedback_set_details("religion_book","[biblename]")

			usr << browse(null, "window=editicon") // Close window

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0

		var/obj/item/weapon/storage/bible/B = new /obj/item/weapon/storage/bible/booze(H)
		H.equip_to_slot_or_del(B, slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/chaplain(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		spawn(0)
			var/religion_name = "Christianity"
			var/new_religion = copytext(sanitize(input(H, "You are the Chaplain. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name)),1,MAX_NAME_LEN)

			if (!new_religion)
				new_religion = religion_name

			switch(lowertext(new_religion))
				if("christianity")
					B.name = pick("The Holy Bible","The Dead Sea Scrolls")
				if("satanism")
					B.name = "The Unholy Bible"
				if("cthulu")
					B.name = "The Necronomicon"
				if("islam")
					B.name = "Quran"
				if("scientology")
					B.name = pick("The Biography of L. Ron Hubbard","Dianetics")
				if("chaos")
					B.name = "The Book of Lorgar"
				if("imperium")
					B.name = "Uplifting Primer"
				if("toolboxia")
					B.name = "Toolbox Manifesto"
				if("homosexuality")
					B.name = "Guys Gone Wild"
				if("lol", "wtf", "gay", "penis", "ass", "poo", "badmin", "shitmin", "deadmin", "cock", "cocks")
					B.name = pick("Woodys Got Wood: The Aftermath", "War of the Cocks", "Sweet Bro and Hella Jef: Expanded Edition")
					H.setBrainLoss(100) // starts off retarded as fuck
				if("science")
					B.name = pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition")
				else
					B.name = "The Holy Book of [new_religion]"
			feedback_set_details("religion_name","[new_religion]")

		spawn(1)
			var/deity_name = "Space Jesus"
			var/new_deity = copytext(sanitize(input(H, "Would you like to change your deity? Default is Space Jesus.", "Name change", deity_name)),1,MAX_NAME_LEN)

			if ((length(new_deity) == 0) || (new_deity == "Space Jesus") )
				new_deity = deity_name
			B.deity_name = new_deity

			var/dat = "<html><head><title>Pick Bible Style</title></head><body><center><h2>Pick a bible style</h2></center><table>"

			var/i
			for(i = 1, i < biblestates.len, i++)
				var/icon/bibleicon = icon('icons/obj/storage.dmi', biblestates[i])

				var/nicename = biblenames[i]
				H << browse_rsc(bibleicon, nicename)
				dat += {"<tr><td><img src="[nicename]"></td><td><a href="?src=\ref[src];seticon=[i];bible=\ref[B]">[nicename]</a></td></tr>"}

			dat += "</table></body></html>"

			H << browse(dat, "window=editicon;can_close=0;can_minimize=0;size=250x600")

			if(ticker)
				ticker.Bible_deity_name = B.deity_name
			feedback_set_details("religion_deity","[new_deity]")
		return 1
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  untitled.py
#  
#  Copyright 2019 Tomas <tomas@tomas-DELL>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

import requests # HTTPS requests
from datetime import datetime
from time import sleep
from threading import Thread # Threading
import threading
from queue import Queue # Queue to threading - https://stackoverflow.com/questions/19369724/the-right-way-to-limit-maximum-number-of-threads-running-at-once
import re # Regular expression operations
##from html.parser import HTMLParser

########################### Parameters ###########################
##################################################################
idRange = range(3049364,7000000) # Range of downloaded id's.
maximumThreads = 200 # Maximum numbe of threads. (Requests to server)
res = open("res_id_" + str(idRange[0]) + "_" + str(idRange[len(idRange)-1]) , "x") # File to store RES data.
crnNaceMapping = open("crnNaceMapping_id_" + str(idRange[0]) + "_" + str(idRange[len(idRange)-1]) ,"x") # File to store registration numbre / NACE mapping
logFile = open("download.log","a")# Log file
##################################################################


################### Download and write to file ###################
##################################################################
def requestServer(id, res, crnNaceMapping, logFile):
		try:
			response = requests.get("https://apl.czso.cz/irsw/detail.jsp?prajed_id=" + str(id))
		except:
			logFile.write(str(datetime.now()) + ";" + "Connection exception" + ";" + str(id) + "\n")
			return
		
		#responseCode = response.status_code
		#if responseCode != 200:
			#logFile.write(time.strftime("%Y-%m-%d %H:%M:%S", gmtime()) + ";" + str(responseCode) + ";" + str(id) + "\n")
			
		 
		responseText = response.text
		# print(responseText)
		registrationNumberStr = str(re.findall("<td width=\"200\">IČO:</td>\r\n\s+<td width=\"20\"></td>\r\n\s+<td width=\"400\" align=\"left\"><strong>\d\d\d\d\d\d\d\d</strong></td>", responseText))
			
		# IČO
		registrationNumber = str(re.findall("\d\d\d\d\d\d\d\d", registrationNumberStr))[2:][:-2]
		
		if registrationNumber:

			# Název
			nameStr = str(re.findall("<td width=\"200\">Obchodní firma/název:</td>\r\n          <td width=\"20\"></td>\r\n          <td width=\"400\" align=\"left\"><strong>[^\r\n]+", responseText))
			name = nameStr[129:][:-16]
			
			# Právní forma
			formStr = str(re.findall("Statistická právní forma:</a></td>\r\n          <td width=\"20\"></td>\r\n          <td width=\"400\" align=\"left\">\d\d\d", responseText))
			form = formStr[113:][:-2]
			
			# Datum vzniku
			creationDateStr = str(re.findall("Datum vzniku:</td>\r\n        <td width=\"20\"></td>\r\n        <td width=\"400\" align=\"left\">[^\r\n]+", responseText))
			creationDate = creationDateStr[93:][:-7]
			
			# Datum zániku
			dissolutionDateStr = str(re.findall("Datum zániku:</td>\r\n        <td width=\"20\"></td>\r\n        <td width=\"400\" align=\"left\">[^\r\n]+", responseText))			
			dissolutionDate = dissolutionDateStr[93:][:-7]
			if dissolutionDate == "&nbsp;":
				dissolutionDate = ""
			
			# Adresa
			adressStr = str(re.findall("Adresa:</td>\r\n        <td width=\"20\"></td>\r\n        <td width=\"400\" align=\"left\">[^\r\n]+", responseText))
			adress = adressStr[87:][:-7]
			
			# Základní územní jednotka
			administrativeDivisionStr = str(re.findall("Základní územní jednotka:</td>\r\n        <td width=\"20\"></td>\r\n        <td width=\"40\" align=\"left\">[^\r\n]+", responseText))
			administrativeDivision = administrativeDivisionStr[104:][:-7]
			
			# Kategorie počtu zaměstnanců
			employesCategoryStr = str(re.findall("Velikostní kat. dle počtu zam.</a>\r\n          </td>\r\n          <td class=\"cislo\">[^\r\n]+", responseText))
			employesCategory = employesCategoryStr[87:][:-7]
			
			# Institucionální sektor
			institutionalSectorStr = str(re.findall("Institucionální sektor: dle ESA2010</a>\r\n          </td>\r\n          <td class=\"cislo\">[^\r\n]+", responseText))
			institutionalSector = institutionalSectorStr[92:][:-7]
			
			# Nace
			naceStr = str(re.findall("Činnosti - dle CZ-NACE</a>\r\n            </td>\r\n            <td class=\"cislo\">[^\r\n]+", responseText))
			nace = naceStr[83:][:-7]
			naceList = [nace]
					
			naceStrList = re.findall("</tr>\r\n        \r\n          <tr>\r\n            <td>\r\n              \r\n            </td>\r\n            <td class=\"cislo\">[^\r\n]+", responseText)
			for naceStr in naceStrList:
				nace = naceStr[116:][:-5]
				naceList.append(nace)
			
			# Write results to file.
			res.write("\"" + str(id) + "\";\"" + registrationNumber + "\";\"" + name + "\";\""+ form + "\";\"" + creationDate + "\";\"" + dissolutionDate + "\";\"" + adress 
			+ "\";\"" + administrativeDivision + "\";\"" + employesCategory + "\";\"" + institutionalSector + "\"\n")
			
			for naceCode in naceList:
				crnNaceMapping.write(registrationNumber + ";" + naceCode + "\n")
			
			print(str(id) + "\t" + registrationNumber)
			return
##################################################################


############################## Main ##############################
##################################################################
for id in idRange:
	t = Thread(target=requestServer, args=(id, res, crnNaceMapping,logFile,))
	t.start()
	# print(threading.activeCount())
	while threading.activeCount() > maximumThreads:
		t.join()

print("Main thread terminated.")

#res.close()
#crnNaceMapping.close()
##################################################################

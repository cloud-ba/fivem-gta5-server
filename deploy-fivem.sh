#!/bin/bash
##############################################################
#####
#####   FiveM Roleplay Server
#####     Grand Theft Auto
#####      Deploy Script
#####
##############################################################
###############################
# Sudo Check
###############################
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi
##############################
###############################


# User Input
########################


########################



# Account Creation
########################
USERIN=fivemserver
read -p "Create User? [fivemserver]" USERIN
    adduser $USERIN
########################



# Varriables
########################

    SOFTWARE="/var/software"
        TFIVEM="$SOFTWARE/fivem"
            TSESX="$TFIVEM/sesx"
            TCCORE="$TFIVEM/citizenfx.core.server"
            TESMOD="$TFIVEM/essentialmode"


        MAIN=/home/"$USER"
    read -p "Default Directory? [/home/$USER]" MAIN
        mkdir $MAIN

    GAME="$MAIN/server-data"
        RESOURCES="$GAME/resources"

            ESMOD="$RESOURCES/essentialmode"
            ESEXT="$RESOURCES/[essential]"
            MODS="$RESOURCES/[mods]"
            VEHICLES="$RESOURCES/[vehicles]"
            MAPS="$RESOURCES/[maps]"
            ESX="$RESOURCES/[esx]"

            SESX="$RESOURCES/[sesx]"

    mysql_user="astronaut"
    mysql_password="iq5h0TjpM3xF"

# TEMP DIRECTORIES
        mkdir $SOFTWARE
        mkdir $TFIVEM
        mkdir $TCCORE
        mkdir $TESMOD

# Dependancies
########################
echo "Linux Software"
    sudo apt-get -y install unzip unrar mariadb-server apache2 phpmyadmin -y

echo "mySQL"
    mysql_secure_installation
#       -Answers-
#           Apache2
#           Yes
#           <PASSWORD>




# mySQL Database
###############################################
    mysql -e "CREATE DATABASE essentialmode;"
    mysql -e "CREATE USER 'astronaut'@'localhost' IDENTIFIED BY 'iq5h0TjpM3xF';"
    mysql -e "GRANT ALL PRIVILEGES ON essentialmode.* TO 'astronaut'@'iq5h0TjpM3xF';"
    mysql -e "q"
########################


## ---- FiveM ---- ##

echo "FiveM - Base"
    echo "Get Packages"
        wget -P "$TFIVEM" https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/1387-893803f3921511bed298a54e95a2ba7df5860f7c/fx.tar.xz

    echo "Extract Package"
        tar -xf "$TFIVEM"/fx.tar.xz --directory "$MAIN"/


echo "FiveM - CitizenFX"
#git clone https://github.com/citizenfx/cfx-server-data.git "$TFIVEM"/citizenfx/cfx-server-data
    git clone https://github.com/citizenfx/cfx-server-data.git "$GAME"

echo "CitizenFX Module Update"
    wget -P "$TCCORE" https://d.fivem.dev/CitizenFX.Core.Server.zip
    unzip "$TCCORE"/CitizenFX.Core.Server.zip -d "$TCCORE"/CCORE

    cp -r "$TCCORE"/CCORE/CitizenFX.Core.sym $MAIN/alpine/opt/cfx-server/citizen/clr2/lib/mono/4.5/CitizenFX.Core.sym
    cp -r "$TCCORE"/CCORE/CitizenFX.Core.Server.dll $MAIN/alpine/opt/cfx-server/citizen/clr2/lib/mono/4.5/CitizenFX.Core.Server.dll
    cp -r "$TCCORE"/CCORE/CitizenFX.Core.Server.sym $MAIN/alpine/opt/cfx-server/citizen/clr2/lib/mono/4.5/CitizenFX.Core.Server.sym

## ---- FiveM ---- ##





## ---- sESX ---- ##

echo "sESX"
    git clone https://github.com/schwim0341/sESX.git "$TSESX"

    cp -R "$TSESX"/[sesx] "$RESOURCES"

    cp "$TSESX"/sesx.sql "$SESX"/sesx.sql

    mv -r "$SESX"/async "$ESESXT"
    mv -r "$SESX"/es_admin2 "$ESESXT"
    mv -r "$SESX"/es_extended "$ESESXT"
    mv -r "$SESX"/esplugin_mysql "$ESESXT"

## ---- sESX ---- ##





## ---- Essential Mode ---- ##

echo "essentialmode"
# https://docs.essentialmode.com
    echo "Get Packages"
        wget -P "$TFIVEM" https://github.com/kanersps/essentialmode/archive/6.2.2.tar.gz
        tar -xf "$TFIVEM/6.2.2.tar.gz" -C "$TFIVEM/essentialmode"
    cp -R "$TFIVEM"/essentialmode/essentialmode-6.2.2 "$RESOURCES"/essentialmode
    #    mysql --user='hommer' --password='8gtw0JcpG3xW' fivem_data < [essential]/es_extended/es_extended.sql

## ---- Essential Mode ---- ##





## ---- ES Mods ---- ##

echo "mysql-async"
    git clone https://github.com/brouznouf/fivem-mysql-async.git "$ESEXT"/mysql-async

# Breaks Shit
#   echo "esplugin_mysql"
#       git clone https://github.com/kanersps/esplugin_mysql.git "$TFIVEM"/esplugin_mysql
#       cp -R "$TFIVEM"/esplugin_mysql "$SESX"


#   echo"async"
#       git clone https://github.com/ESX-Org/async.git "$TFIVEM"/async
#       cp -R "$TFIVEM"/async "$SESX"

## ---- ES Mods ---- ##


mkdir $MODS
mkdir $VEHICLES
mkdir $MAPS




## ---- Basics ---- ##

echo "ES Extended [ESX]"
# https://github.com/ESX-Org/es_extended

    echo "Git Packages"
        git clone https://github.com/ESX-Org/es_extended "$ESEXT"/es_extended
        git clone https://github.com/ESX-Org/esx_menu_default "$ESX"/[ui]/esx_menu_default
        git clone https://github.com/ESX-Org/esx_menu_dialog "$ESX"/[ui]/esx_menu_dialog
        git clone https://github.com/ESX-Org/esx_menu_list "$ESX"/[ui]/esx_menu_list

echo "CRON"
    git clone https://github.com/ESX-Org/cron "$MODS"/cron

echo "ESX - Addon Inventory"
    git clone https://github.com/ESX-Org/esx_addoninventory "$ESX"/esx_addoninventory

echo "ESX - Datastore"
    git clone https://github.com/ESX-Org/esx_datastore "$ESX"/esx_datastore

echo "ESX - Addon Account"
    git clone https://github.com/ESX-Org/esx_addonaccount "$ESX"/esx_addonaccount

echo "ESX - Instance"
    git clone https://github.com/ESX-Org/instance "$ESX"/instance

echo "ESX - Skinchanger"
    git clone https://github.com/ESX-Org/skinchanger "$MODS"/skinchanger

echo "ESX - Billing"
    git clone https://github.com/ESX-Org/esx_billing "$ESX"/esx_billing

echo "ESX - Service"
    git clone https://github.com/ESX-Org/esx_service "$ESX"/esx_service

echo "ESX - Status"
    git clone https://github.com/FXServer-ESX/fxserver-esx_status "$ESX"/esx_status

echo "ESX - Society"
    git clone https://github.com/ESX-Org/esx_society "$ESX"/esx_society

echo "ESX - Identity"
    git clone https://github.com/ESX-Org/esx_identity "$ESX"/esx_identity

echo "pNotify"
    git clone https://github.com/Nick78111/pNotify.git "$TFIVEM"/pNotify
    cp -R "$TFIVEM"/pNotify/pNotify "$MODS"

echo "ESX - Welcome"
    git clone https://github.com/ClownFishYTB/esx_welcome.git "$ESX"/esx_welcome

## ---- Basics ---- ##





## ---- Shops ---- ##

echo "ESX - Shops"
#       git clone https://github.com/ESX-Org/esx_shops "$ESX"/esx_shops

echo "Shops With Bars"
    git clone https://github.com/TheMrDeivid/ESX_shops_with_bars.git "$TFIVEM"/esx_shops_with_bars
    cp -R "$TFIVEM"/esx_shops_with_bars/esx_basicneeds "$ESX"/esx_basicneeds
    cp -R "$TFIVEM"/esx_shops_with_bars/esx_shops "$ESX"/esx_shops

echo "ESX - Basic Needs"
#   git clone https://github.com/ESX-Org/esx_basicneeds "$ESX"/esx_basicneeds

echo "ESX - Optional Needs"
   git clone https://github.com/FXServer-ESX/fxserver-esx_optionalneeds "$ESX"/esx_optionalneeds

echo "ESX - Weapon Shop"
    git clone https://github.com/ESX-Org/esx_weaponshop.git "$ESX"/esx_weaponshop

echo "ESX - Vehicle Shop"
    git clone https://github.com/ESX-Org/esx_vehicleshop "$ESX"/esx_vehicleshop

echo "ESX - Truckshop"
    git clone https://github.com/HumanTree92/esx_truckshop.git "$ESX"/esx_truckshop

echo "ESX - Aircrat Shop"
    git clone https://github.com/HumanTree92/esx_aircraftshop.git "$ESX"/esx_aircraftshop

echo "ESX - Boat Shop"
    git clone https://github.com/HumanTree92/esx_boatshop.git "$ESX"/esx_boatshop

echo "ESX - Clotheshop"
    git clone https://github.com/ESX-Org/esx_clotheshop "$ESX"/esx_clotheshop

echo "ESX - Accessories"
    git clone https://github.com/ESX-Org/esx_accessories "$ESX"/esx_accessories

echo "ESX - Barbershop"
    git clone https://github.com/ESX-Org/esx_barbershop "$ESX"/esx_barbershop

echo "ESX - Masks"
    git clone https://github.com/TakumiBR/fxserver-esx_mask.git "$ESX"/esx_masks

echo "ESX - Hospitals"
    git clone https://github.com/HumanTree92/esx_hospital.git "$ESX"/esx_hospital

echo "ESX - License Shop"
    git clone https://github.com/HumanTree92/esx_licenseshop.git "$ESX"/esx_licenseshop
    
echo "ESX - Dockshop"
    git clone https://github.com/ESX-PUBLIC/esx_dockshop.git "$ESX"/esx_dockshop

## ---- Shops ---- ##





## ---- Character Options ---- ##

echo "ESX - Skin"
    git clone https://github.com/ESX-Org/esx_skin "$ESX"/esx_skin

echo "ESX - Multi Characters"
# https://github.com/2nd-Life/esx_kashacters
    git clone https://github.com/KASHZIN/kashacters.git "$ESX"/esx_kashacters

## ---- Character Options ---- ##



## ----  Property ---- ##

echo "ESX - Property"
    git clone https://github.com/ESX-Org/esx_property "$ESX"/esx_property

echo "ESX - ATM"
    git clone https://github.com/ESX-Org/esx_atm "$ESX"/esx_atm

## ---- Property ---- ##



## ---- Garage Options ---- ##

echo "ESX - Garage"
    git clone https://github.com/FXServer-ESX/fxserver-esx_garage "$ESX"/esx_garage

echo "ESX - Advanced Garage"
    git clone https://github.com/HumanTree92/esx_advancedgarage.git "$ESX"/esx_advancedgarage

echo "ESX - Eden Garage"
    git clone https://github.com/snyx95/esx_eden_garage.git "$ESX"/esx_eden_garage

echo "ESX - JB Ededn Garage 2"
    git clone https://github.com/TanguyOrtegat/esx_jb_eden_garage2.git "$ESX"/esx_jb_eden_garage2

    touch "$ESX"/esx_jb_eden_garage2/esx_jb_eden_garage2.sql
        echo "use essentialmode;" >> "$ESX"/esx_jb_eden_garage2/esx_jb_eden_garage2.sql
        echo "ALTER TABLE `owned_vehicles` ADD INDEX `vehsowned` (`owner`);" >> "$ESX"/esx_jb_eden_garage2/esx_jb_eden_garage2.sql
        echo "ALTER TABLE `owned_vehicles` ADD `fourrieremecano` BOOLEAN NOT NULL DEFAULT FALSE;" >> "$ESX"/esx_jb_eden_garage2/esx_jb_eden_garage2.sql
        echo "ALTER TABLE `owned_vehicles` ADD `vehiclename` varchar(50) NOT NULL DEFAULT 'voiture';" >> "$ESX"/esx_jb_eden_garage2/esx_jb_eden_garage2.sql

echo "FT Libs"
    git clone https://github.com/FivemTools/ft_libs.git "$MODS"/ft_libs

## ---- Garage Options --- ##




## ---- Licenses ---- ##

echo "ESX - License"
    git clone https://github.com/ESX-Org/esx_license "$ESX"/esx_license

echo "ESX - DMV School"
    git clone https://github.com/ESX-Org/esx_dmvschool "$ESX"/esx_dmvschool
    echo "Set English"
        mv "$ESX"/esx_dmvschool/html/questions.js "$ESX"/esx_dmvschool/html/questions.js-orig
        mv "$ESX"/esx_dmvschool/html/questions_en.js "$ESX"/esx_dmvschool/html/questions.js

        mv "$ESX"/esx_dmvschool/html/ui.html "$ESX"/esx_dmvschool/html/ui.html-orig
        mv "$ESX"/esx_dmvschool/html/ui_en.html "$ESX"/esx_dmvschool/html/ui.html


## ---- Licenses ---- ##





## ---- Roleplay ---- ##

echo "ESX - Phone"
    git clone https://github.com/ESX-Org/esx_phone "$ESX"/esx_phone

        mv "$ESX"/esx_phone/html/scripts/app.js "$ESX"/esx_phone/html/scripts/app.js-orig
        mv "$ESX"/esx_phone/html/scripts/app_en.js "$ESX"/esx_phone/html/scripts/app.js

        mv "$ESX"/esx_phone/html/ui.html "$ESX"/esx_phone/html/ui.html-orig
        mv "$ESX"/esx_phone/html/ui_en.html "$ESX"/esx_phone/html/ui.html
#        mv [esx]/esx_phone/html/scripts/app.js [esx]/esx_phone/html/scripts/app.js-orig
#        mv [esx]/esx_phone/html/scripts/app_en.js [esx]/esx_phone/html/scripts/app.js

mv [esx]/esx_phone/html/ui.html [esx]/esx_phone/html/ui.html-orig
mv [esx]/esx_phone/html/ui_en.html [esx]/esx_phone/html/ui.html


echo "ESX - Show Commands"
    git clone https://github.com/Calibrateds/esx_showcommands.git "$TFIVEM"/showcommands
    cp -R "$TFIVEM"/showcommands/esx_showcommands "$ESX"/esx_showcommands

echo "ESX - Voice"
    git clone https://github.com/ESX-Org/esx_voice "$ESX"/esx_voice

echo "ESX - Animations"
    git clone https://github.com/ESX-Org/esx_animations "$ESX"/esx_animations

echo "ESX - Ladder HUD"
# config
# https://github.com/MarmotaGit/esx_ladderhud
    git clone https://github.com/MarmotaGit/esx_ladderhud.git "$ESX"/esx_ladderhud

echo "Crouch & Prone"
    git clone https://github.com/Bluethefurry/crouch-n-prone.git "$MODS"/crouch-n-prone
# C = Crouch
# LeftCtrl = Prone

echo "Crouch Alternative"
# https://forum.fivem.net/t/release-crouch-script-1-0-1-now-button-based/14742

echo "Out Of Character Chat"
    git clone https://github.com/fuzzymannerz/ooc.git "$MODS"/ooc

echo "PVP"
    git clone https://github.com/McLurch/esx_pvp.git "$ESX"/esx_pvp

## ---- Roleplay ---- ##



echo "ESX - Money Laundering"
echo "Going Postal"
     clone https://github.com/Krizfrost/-ESX--Money-Laundering.git "$ESX"/esx_moneylaundering

echo "ESX - Slot Machine"
    git clone https://github.com/EnVyyyyy/esx_slotmachine "$ESX"/esx_slotmachine

echo "ESX - Handcuffs"
    git clone https://github.com/scorpio686/esx_handcuffs.git "$ESX"/esx_handcuffs
#   mysql -u hommer --password='' essentialmode < [esx]/esx_handcuffs/esx_handcuffs.sql

echo "ESX - Coffee"
    git clone https://github.com/Thananyx/esx_coffee.git "$ESX"/esx_coffee
#  mysql -u hommer --password='' essentialmode < [esx]/esx_coffee/esx_coffees.sql

echo "ESX - Uni Show"
    git clone https://github.com/gregos1810/esx_unishow.git "$ESX"/esx_unishow

echo "ESX - Poolcleaner"
    git clone https://github.com/Cha0sNighT/esx_poolcleaner.git "$ESX"/esx_poolcleaner
#   mysql -u hommer --password='' essentialmode < [esx]/esx_poolcleaner/esx_poolcleaner.sql

echo "ESX - Pharmacy"
    git clone https://github.com/MRDIKORYTB/esx_pharmacy.git "$TFIVEM"/esx_pharmacy
    cp -R /var/software/fivem/esx_pharmacy/esx_pharmacy "$RESOURCES"/[esx]
#**    mysql -u hommer --password='' essentialmode < [esx]/esx_pharmacy/esx_pharmacy.sql

echo "ESX - Gardener"
    git clone https://github.com/Cha0sNighT/esx_gardener.git "$ESX"/esx_gardener
#   mysql -u hommer --password='' essentialmode < [esx]/esx_gardener/esx_gardener.sql

echo "ESX - Speed Radar"
    git clone https://github.com/Cha0sNighT/esx_speed_radar.git "$ESX"/esx_speed_radar
#*    mysql -u hommer --password='' essentialmode < [esx]/esx_speed_radar/peage_flash.sql
    mapping_speedradar
    esx_speedradar

echo "ESX - Brinks"
    git clone https://github.com/Cha0sNighT/esx_brinks.git "$ESX"/esx_brinks
#   mysql -u hommer --password='' essentialmode < [esx]/esx_brinks/esx_brinks.sql

echo "ESX - Lawyerjob"
    git clone https://github.com/ESX-PUBLIC/esx_lawyerjob.git "$ESX"/esx_lawyerjob
#***    mysql -u hommer --password='' essentialmode < [esx]/esx_lawyerjob/esx_laywerjob.sql

echo "All City - Medical"
    git clone https://github.com/AllCitySor/allcity_medical.git "$MODS"/allcity_medical

echo "MedSystem"
    git clone https://github.com/Kuzkay/MedSystem.git "$TFIVEM"/MedSystem
    cp -R "$TFIVEM"/MedSystem/medSystem "$MODS"/MedSystem



## ---- Jobs ---- ##

echo "ESX - Jobs"
    git clone https://github.com/ESX-Org/esx_jobs "$ESX"/esx_jobs

echo "ESX - Job Listing"
    git clone https://github.com/ESX-Org/esx_joblisting "$ESX"/esx_joblisting

echo "ESX - Jobs - Ambulance"
    git clone https://github.com/ESX-Org/esx_ambulancejob "$ESX"/esx_ambulancejob

echo "ESX - Jobs - Realestate Agent"
    git clone https://github.com/ESX-Org/esx_realestateagentjob "$ESX"/esx_realestateagentjob

echo "ESX - Jobs - Mechanic"
    git clone https://github.com/ESX-Org/esx_mechanicjob "$ESX"/esx_mechanicjob

echo "ESX - Jobs - Banker"
    git clone https://github.com/ESX-Org/esx_bankerjob "$ESX"/esx_bankerjob

echo "ESX - Jobs - Taxi"
    git clone https://github.com/ESX-Org/esx_taxijob "$ESX"/esx_taxijob

echo "ESX - Jobs - Police"
    git clone https://github.com/ESX-Org/esx_policejob "$ESX"/esx_policejob

echo "ESX - Jobs - Buglary"
    git clone https://github.com/TheIndra55/fivem-burglary.git "$TFIVEM"/burglary
    cp -R "$TFIVEM"/burglary/esx_burglary "$ESX"/esx_burglary

echo "ESX - Jobs - Advanced Fishing"
    git clone https://github.com/Kuzkay/esx_AdvancedFishing.git "$TFIVEM"/esx_AdvancedFishing
    cp -R "$TFIVEM"/esx_AdvancedFishing/esx_AdvancedFishing "$ESX"
    mv "$ESX"/esx_AdvancedFishing "$ESX"/esx_advancedfishing
    mv "$ESX/esx_advancedfishing/database items.sql" "$ESX/esx_advancedfishing/esx_advancedfishing.sql"

    echo "ESX - Turtle"
        git clone https://github.com/Oldarorn/esx_turtle.git "$ESX"/esx_turtle

echo "ESX - Jobs - Aircargo"
    git clone https://github.com/OFFICERBROWN23/Esx_Aircargojob.git "$TFIVEM"/esx_aircargojob
    cp -R "$TFIVEM"/esx_aircargojob/esx_aircargojob "$ESX"
echo "Addon-Aircraft-UH1calfire"
    git clone https://github.com/OFFICERBROWN23/Addon-Aircraft-UH1calfire.git "$TFIVEM"/cargoheli
    cp -R "$TFIVEM/cargoheli" "$VEHICLES/cargoheli"

echo "ESX - Jobs - Plastic Surgery"
    git clone https://github.com/HumanTree92/esx_plasticsurgery.git "$ESX"/esx_plasticsurgery

echo "ESX - Jobs - Mafia"
    git clone https://github.com/Thananyx/esx_mafiajob.git "$ESX"/esx_mafiajob

echo "ESX - Jobs - Gang"
#    git clone https://github.com/tracid56/esx_gangjob.git "$ESX"/esx_gangjob
#    echo ""
#    git clone https://github.com/Nowimps8/nw_bahamaMama.git [map-mods]/nw_bahamaMama

echo "ESX - Jobs - The Lost Mc"
    git clone https://github.com/Marvbell110/esx_thelostmcjob.git "$TFIVEM"/esx_thelostmcjob
    unzip "$TFIVEM"/esx_thelostmcjob/esx_thelostmcjob.zip -d "$TFIVEM"/esx_thelostmcjob/
    rm "$TFIVEM/esx_thelostmcjob/esx_thelostmcjob.zip"
    cp -R "$TFIVEM/esx_thelostmcjob/esx_thelostmcjob" "$ESX/esx_thelostmcjob"
    Echo "The Lost MC Garage"
        git clone https://github.com/EdGeMapping/MCGarage.git "$TFIVEM"/MCGarage
        cp -R "TFIVEM"/MCGargage/EdGe-MCGarage "$MAPS"/MCGarage

echo "ESX - Jobs - Hitman"
    git clone https://github.com/MikeyJY/esx_hitman.git "$TFIVEM"/hitman
    cp -R "$TFIVEM"/hitman/esx_hitman "$ESX"/esx_hitmanjob

echo "ESX - Jobs - FBI"
    git clone https://github.com/ESX-FRANCE/esx_fbi_job.git "$ESX"/esx_fbijob

echo "ESX - Jobs - Unicorn"
    git clone https://github.com/ESX-PUBLIC/esx_unicornjob.git "$ESX"/esx_unicornjob
echo "ESX - Strippers"
    git clone https://github.com/ThePyromaniac/esx_strippers.git "$ESX"/esx_strippers

echo "ESX - Jobs - Nightclub"
    git clone https://github.com/McLurch/esx_nightclub.git "$ESX"/esx_nightclubjob
echo "Map Fixes - bob74_ipl"
    git clone https://github.com/Bob74/bob74_ipl.git "$MAPS"/bob74_ipl
echo "Peds/NPCs"
    git clone https://github.com/SFL-Master/Peds.git "$MODS"/Peds

echo "ESX - Jobs - Airlines"
    git clone https://github.com/loko06320/esx_airlines.git "$ESX"/esx_airlines

echo "ESX - Jobs - Fire"
    git clone https://github.com/kheire007/esx_firejob.git "$TFIVEM"/esx_firejob
    cp -R "$TFIVEM"/esx_firejob/esx_firejob "$ESX"/esx_firejob

echo "ESX - Jobs - Army"
    git clone https://github.com/Thananyx/esx_armyjob.git "$ESX"/esx_armyjob


## ---- Jobs ---- ##





## -----  Fuel Options ----- ##
echo "Legacy Fuel"
    git clone https://github.com/InZidiuZ/LegacyFuel.git "$MODS"/LegacyFuel

echo "FRFuel"
    wget -P "$TFIVEM" https://ci.appveyor.com/api/buildjobs/47w8nvjo28mweul4/artifacts/frfuel_v2.0.0.zip
    unzip "$TFIVEM"/frfuel_v2.0.0.zip -d "$MODS"/FRFuel


## -----  Fuel Options ----- ##





## ---- Police Options ---- ##

echo "ESX - Off Duty"
    git clone https://github.com/qalle-fivem/esx_duty.git "$ESX"/esx_duty


echo "Radar Gun"
    git clone https://github.com/TerbSEC/Radargun.git "$MODS"/radargun



echo "ESX - KTackle"
    git clone https://github.com/FiveM-Dev-Sverige/esx_ktackle.git "$ESX"/esx_ktackle

echo "ESX - CopWeapon"
    git clone https://github.com/gregos1810/esx_copweapon.git "$ESX"/esx_copweapon

echo "ESX - Handcuffs"
    git clone https://github.com/scorpio686/esx_handcuffs.git "$ESX"/esx_handcuffs

## ---- Police Options ---- ##





## ---- Crimanal Options ---- ##

echo "ESX - Drugs"
    git clone https://github.com/ESX-Org/esx_drugs "$ESX"/esx_drugs

echo "ESX - Drug Effects"
    git clone https://github.com/McLurch/esx_drugeffects.git  "$ESX"/esx_drugeffects

echo "ESX - Planting"
    git clone https://github.com/MacieGx/esx_planting.git "$ESX"/esx_planting

echo "ESX - NPC Drug Sales"
    git clone https://github.com/ESX-PUBLIC/esx_npcdrugsales.git "$ESX"/esx_npcdrugsales

echo "ESX - Moneywash"
    git clone https://github.com/Xovos/esx_moneywash.git "$TFIVEM"/moneywash
    cp -R "$TFIVEM"/moneywash/esx_moneywash "$ESX"

echo "ESX - Holdup"
    git clone https://github.com/ESX-Org/esx_holdup "$ESX"/esx_holdup

echo "ESX - Advanced Holdup"
    git clone https://github.com/LuaDeldu/esx_advanced_holdup.git "$ESX"/esx_advanced_holdup

echo "ESX - Thief"
    git clone https://github.com/ESX-PUBLIC/esx_thief.git "$ESX"/esx_thief

echo "ESX - Bank Holdup"
    git clone https://github.com/Vanheden/esx_holdupbank.git "$ESX"/esx_holdupbank

echo "ESX - Drill"
    git clone https://github.com/Vanheden/esx_borrmaskin.git "$ESX"/esx_borrmaskin

    touch "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "use essentialmode;" >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "INSERT INTO `items` (`name`, `label`, `limit`) VALUES" >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "('drill', 'Borrmaskin', 1);" >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "INSERT INTO `shops` (store, item, price) VALUES" >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "('TwentyFourSeven','drill',1000)," >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "('RobsLiquor','drill',1000)," >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql
    echo "('LTDgasoline','drill',1000);" >> "$ESX"/esx_borrmaskin/esx_borrmaskin.sql



echo "ESX - Car Thief"
    git clone https://github.com/KlibrDM/esx_carthief.git "$ESX"/esx_carthief

## ---- Crimanal Options ---- ##





## ---- Security Options ---- ##

echo "ESX - Whitelist"
    git clone https://github.com/ESX-Org/esx_whitelist "$ESX"/esx_whitelist

echo "ESX - Whitelist Enhanced"
    git clone https://github.com/ESX-Org/esx_whitelistEnhanced "$ESX"/esx_whitelistEnhanced

echo "Server Password"
    git clone https://github.com/FAXES/ServerPassword.git "$MODS"/ServerPassword
#    nano "$MODS]/ServerPassword/server.lua

## ---- Security Options ---- ##





## ---- Interface Options ---- ##

echo "ESX - AIO Menu"
    git clone https://github.com/ArkSeyonet/esx_aiomenu.git "$ESX"/esx_aiomenu

echo "vMenu"
    mkdir "$TFIVEM"/vMenu
    wget -P "$TFIVEM"/vMenu https://github.com/TomGrobbe/vMenu/releases/download/v3.1.0/vMenu-v3.1.0.zip
    unzip "$TFIVEM"/vMenu/vMenu-v3.1.0.zip -d "$TFIVEM"/vMenu
    cp -R "$TFIVEM"/vMenu "$MODS"/vMenu
    cp "$MODS"/vMenu/config/permissions.cfg "$GAME"/permissions.cfg

echo "ESX - Hide Hud"
    git clone https://github.com/Caesar-TML/esx_hide_hud.git "$ESX"/esx_hide_hud

echo "ESX - Inventory HUD"
    git clone https://github.com/Trsak/esx_inventoryhud.git "$ESX"/esx_inventoryhud

echo "ESX - Inventory HUD - Trunk"
#git clone https://github.com/Trsak/esx_inventoryhud_trunk.git "$ESX"/esx_inventoryhud_trunk

echo "Naikzer HUD"
# NOT ESX Enabled
# Needs Customization
    git clone https://github.com/Naikzer/HUD-GTAVRP.git "$TFIVEM"/HUD-GTAVRP
    mkdir "$RESOURCES"/[naikzer]
    cp -R "$TFIVEM"/HUD-GTAVRP/hungerthirst $RESOURCES/[naikzer]
    cp -R "$TFIVEM"/HUD-GTAVRP/menu $RESOURCES/[naikzer]
    cp -R "$TFIVEM"/HUD-GTAVRP/skincreator $RESOURCES/[naikzer]
    cp -R "$TFIVEM"/HUD-GTAVRP/speedometer $RESOURCES/[naikzer]
    cp -R "$TFIVEM"/HUD-GTAVRP/target $RESOURCES/[naikzer]

## ---- Interface Options ---- ##





## ---- Vehicle Options ---- ##

echo "ESX - Los Santos Customs"
    git clone https://github.com/ESX-Org/esx_lscustom "$ESX"/esx_lscustom

echo "Car Wash"
    git clone https://github.com/ESX-PUBLIC/esx_carwash.git "$ESX"/esx_carwash

echo "CV Control"
    git clone https://github.com/AzoTe06/EN-Vehicle-Control-3.0.git "$TFIVEM"/VehicleControl
    cp -r "$TFIVEM"/VehicleControl/cv_control "$MODS"

echo "ESX - Cruise Control"
    git clone https://github.com/ESX-Org/esx_cruisecontrol.git "$ESX"/esx_cruisecontrol

echo "ESX - Locksystem"
    git clone https://github.com/ArkSeyonet/esx_locksystem.git "$ESX"/esx_locksystem

echo "VehicleTrustSystem"
# https://forum.fivem.net/t/release-vehicletrustsystem/674066
    git clone https://github.com/TheWolfBadger/VehicleTrustSystem.git "$MODS"/VehicleTrustSystem

echo "Sexy Speedometer"
# https://forum.fivem.net/t/release-sexyspeedometer-tacho-dashboard-elements-skins-fuel/39772
    git clone https://github.com/Bluethefurry/SexySpeedometer-FiveM.git "$MODS"/SexySpeedometer
    echo "Initial D"
        git clone https://github.com/Bluethefurry/initialdspeedo-fivem.git "$MODS"/SexySpeedometer/initiald
    git clone https://github.com/Bluethefurry/initialdspeedo-fivem.git "$TFIVEM"/initialdspeedo
    cp "$TFIVEM"/initialdspeedo/skins/* "$MODS"/SexySpeedometer/skins/
    cp "$TFIVEM"/initialdspeedo/stream/* "$MODS"/SexySpeedometer/stream/
#
# echo "Sexy Speedometer"
#       Add Lines to "$MODS"/SexySpeedometer/__resource.lua
#       "skins/initiald.lua",
#
#       ui_page('skins/initiald.html')
#       files({
#       'skins/initiald.html',
#       'skins/initiald.ogg'
#       })
#
#        nano "$MODS"/SexySpeedometer/__resource.lua

echo "ESX - Repair Kits"
    git clone https://github.com/condolent/esx_repairkit.git "$ESX"/esx_repairkit

echo "Realistic Vehicle Failure"
    git clone https://github.com/McLurch/RealisticVehicleFailure.git "$MODS"/RealisticVehicleFailure

echo "Salty Vehicle Blackout"
    git clone https://github.com/SaltyGrandpa/salty_vehicleblackout.git "$MODS"/salty_vehicleblackout

## ---- Vehicle Options ---- ##

echo "esx_scoreboard"
    git clone https://github.com/Stadus/Stadus_Scoreboard.git "$ESX"/esx_scoreboard

echo "seatbelts"
    git clone https://github.com/IndianaBonesUrMom/fivem-seatbelt.git "$TFIVEM"/seatbelts
    mv "$TFIVEM"/seatbelts/fivem-seatbelt "$TFIVEM"/seatbelts/seatbelt
    cp -R "$TFIVEM"/seatbelts/seatbelt "$RESOURCES"/[mods]
## ---- Admin ---- ##

echo "Admin Area"
    git clone https://github.com/FAXES/AdminArea.git "$MODS"/AdminArea

## ---- Admin ---- ##





## ---- Racing Options ---- ##

echo "Street Race"
    git clone https://github.com/bepo13/FiveM-StreetRaces.git "$TFIVEM"/fivem-streetrace
    cp -R "$TFIVEM"/fivem-streetrace/StreetRaces "$MODS"

## ---- Racing Options ---- ##





## ---- Allcity Options ---- ##

echo "Allcity Wallet"
    git clone https://github.com/AllCitySor/allcity_wallet.git "$TFIVEM"/allcity_wallet
    cp -R "$TFIVEM"/allcity_wallet/allcity_wallet "$MODS"/allcity_wallet

echo "All City HUD"
    git clone https://github.com/AllCitySor/allcity_hud.git "$TFIVEM"/allcity_hud
    mv "$ESEXT"/es_extended/html "$ESEXT"/es_extended/html-orig
    cp -R "$TFIVEM"/allcity_hud/html "$ESEXT"/es_extended/

## ---- Allcity Options ---- ##





## ---- Other ---- ##

echo "ESX - Diving"
#   SQL 'shops' name = store
    git clone https://github.com/ESX-PUBLIC/esx_diving.git "$ESX"/esx_diving

echo "Base Jumping"
    git clone https://github.com/BossManNz/BaseJumping.git "$MODS"/BaseJumping

echo "ESX - Hunting"
    git clone https://github.com/qalle-fivem/esx_hunting.git "$ESX"/esx_hunting

echo "Eden Animal"
    git clone https://github.com/ESX-PUBLIC/eden_animal.git "$MODS"/eden_animal

echo "Eden Accessories"
# Weapon Accessories
    git clone https://github.com/ESX-PUBLIC/eden_accesories.git "$MODS"/eden_accessories

## ---- Other ---- ##










## ---- Vehicles ---- ##

echo "wtf_redis"
    git clone
echo "wtf_supercharged"
    git clone https://github.com/wtf-fivem-mods/wtf_tesla_supercharger.git "$VEHICLES"/wtf_supercharged

echo "wtf_teslax"
    git clone https://github.com/wtf-fivem-mods/wtf_teslax.git "$VEHICLES"/wtf_teslax

echo "wtf_ev"
    git clone https://github.com/wtf-fivem-mods/wtf_ev "$VEHICLES"/wtf_ev



echo "Planes"
    git clone https://github.com/JPapss/-Release--Planes--and-Helicopter-s---Pack--10--Planes-and-Helicopter-s--.git "$VEHICLES"/air_pack-1

## ---- END Vehicles ---- ##





## ---- Chat ---- ##
echo "Civ Font Awesome"
    git clone https://github.com/Krizfrost/civfontawesome.git "$TFIVEM"/civfontawesome
    cp -R "$TFIVEM"/civfontawesome/esx_rpchat "$ESX"/esx_rpchat
    cp -R "$TFIVEM"/civfontawesome/chat-theme-civlifechat "MODS"/chat-theme-civlifechat

echo "[ESX] - RP Chat"
git clone git clone https://github.com/ESX-Org/esx_rpchat "$ESX"/esx_rpchat

echo "Custom Chat"
    git clone https://github.com/FiveM-Scripts/customchat.git "$MODS"/customchat
## ---- END Chat ---- ##





## ---- Computer Aided Dispatch ---- ##
echo "Open CAD"
    echo "Dependancies"
        apt-get install software-properties-common
        add-apt-repository ppa:ondrej/php
        apt-get update
        apt-get install php7.3
        apt-get install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml
        php -v
        a2enmod php7.3
    echo "Addon"
        git clone https://github.com/StormlightTech/OpenCAD-php.git /var/www/opencad

echo "Tabby"
    git clone https://github.com/AminYabut/tabby.git "$TFIVEM"/tabby
    cp -R "$TFIVEM"/tabby/tab "$RESOURCES"/[mods]



echo "MDT - InGame CAD"
    git clone https://github.com/Clatanii/MDT-CHAR.git "$TFIVEM"/mdt-char
    cp -R "$TFIVEM"/mdt-char/MDT "$MODS"/MDT


## ---- END Computer Aided Dispatch ---- ##





## ---- Administration Panels ---- ##

echo "Administration Panel"
    git clone https://github.com/CADOJRP/FiveM-AdministrationPanel.git "$TFIVEM"/adminpanel
cp -R "$TFIVEM"/adminpanel/fivem/staff "$RESOURCES"/[mods]
    cp -R "$TFIVEM"/adminpanel/web /var/www/html
    mv /var/www/html/web /var/www/html/adminpanel

echo "ESX Panel"
    git clone https://github.com/Jeffrey-Lang/esx_panel_controller.git "$ESX"/esx_panel_controller

#    mv [esx]/esx_society [esx]/esx_society-orig
    git clone https://github.com/Jeffrey-Lang/esx_society.git "$ESX"/esx_society-alt

    git clone https://github.com/Jeffrey-Lang/whitelistjobs-SG.git "$MODS"/whitelistjobs

#    mv [esx]/esx_vehicleshop [esx]/esx_vehicleshop-orig
    git clone https://github.com/Jeffrey-Lang/esx_vehicleshop.git"$ESX"//esx_vehicleshop-alt

    git clone https://github.com/Bluethefurry/EasyAdmin.git "$MODS"/EasyAdmin

    git clone https://github.com/Jeffrey-Lang/EasyAdmin-MySQL.git "$MODS"/EasyAdmin-Mysql

## ---- END Administration Panels ---- ##





## ---- Karma Crew Addons ---- ##

echo "Help Commands"
    git clone https://github.com/McLurch/kcc-help.git "$MODS"/kcc-help

echo "Loadingscreen"

## ---- END Karma Crew Addons ---- ##


echo "Tow Truck Mod"
git clone https://github.com/Asser90/asser-tow.git "$MODS"/asser_tow

echo "ESX - Vehicle Lock"
git clone https://github.com/ESX-PUBLIC/esx_vehiclelock.git "$ESX"/esx_vehiclelock

echo "ESX - Boilerplate"
git clone https://github.com/ESX-Org/esx_boilerplate.git [esx]/esx_boilerplate

echo "ESX - Gym"
git clone https://github.com/P4NDAzzGaming/esx_gym.git "$ESX"/esx_gym

echo "ESX - Clip"
git clone https://github.com/gregos1810/esx_clip.git "$ESX"/esx_clip

echo "ESX - Discord Bot"
git clone https://github.com/ElNelyo/esx_discord_bot.git "$ESX"/esx_discord_bot







## ---- FiveM Server Defaults ---- ##

echo "FiveM Server Defaults"
    git clone https://github.com/McLurch/fivem-server-default.git "$TFIVEM"/fivem-server-defaults
    cp "$TFIVEM"/fivem-server-defaults/server.cfg "$GAME"/server.cfg
    cp "$TFIVEM"/fivem-server-defaults/resources.cfg "$GAME"/resources.cfg
    cp "$TFIVEM"/fivem-server-defaults/resources-maps.cfg "$GAME"/resources-maps.cfg
    cp "$TFIVEM"/fivem-server-defaults/vmenu.cfg "$GAME"/vmenu.cfg
#       cp /var/software/fivem/fivem-server-default/vmenu.cfg /home/fivemserver/server-data/vmenu.cfg
    cp "$TFIVEM"/fivem-server-defaults/admin.cfg "$GAME"/admin.cfg

    mysql --user="$mysql_user" --password="$mysql_password" essentialmode < "$TFIVEM"/fivem-server-defaults/sql/working.sql

## ---- END FiveM Server Defaults ---- ##









## ---- Map Mods - Optional ---- ##

echo "Map Addons"
# https://github.com/HumanTree92/FiveM_CustomMapAddons
    git clone https://github.com/HumanTree92/FiveM_CustomMapAddons.git "$MAPS"/mapaddons

echo "Trevors House"
    git clone https://github.com/NexusRisen/Trevor-s-Log-House.git "$MAPS"/trevors-log-house

echo "Mansion Under The Bridge"
    git clone https://github.com/NexusRisen/Mansion-under-the-bridge.git "$MAPS"/mansion-under-the-bridge


echo "Beta Vegitation"
    git clone https://github.com/NexusRisen/Beta-Vegetation---Props.git "$MAPS"/beta-vegitation

echo "Border Wall"
    git clone https://github.com/NexusRisen/San-Andreas-Border-Wall.git "$MAPS"/border-wall

echo "Texas Speedway"
    git clone https://github.com/NexusRisen/NASCAR-Texas-Super-Speedway.git "$MAPS"/texas-superspeedway

echo "Race Wars"
    git clone https://github.com/NexusRisen/Race-Wars-2017.git "$MAPS"/race-wars-2017

echo "Dead Project"
    git clone https://github.com/NexusRisen/The-Dead-Among-Us-Project---Zombie-Maps.git "$MAPS"/dead-amoung-us

echo "Car Atelier"
    git clone https://github.com/NexusRisen/Car-Atelier.git "$MAPS"/car-atelier

echo "Bayside"
    git clone https://github.com/NexusRisen/Bayside.git "$MAPS"/bayside

echo "Vinewood"
    git clone https://github.com/NexusRisen/Vinewood-Hills-Alive.git "$MAPS"/vinewood-alive

echo "Grapeseed"
    git clone https://github.com/NexusRisen/Grapeseed-Alive.git "$MAPS"/grapeseed-alive

echo "Sand Shores - Train Station"
    git clone https://github.com/NexusRisen/Sandy-Shores-Train-Station.git "$MAPS"/sandy-train

echo "Sandy Shores - Airfield"
    git clone https://github.com/NexusRisen/Modern-Sandy-Shores-Airfield.git "$MAPS"/sandy-airfield

echo "Sandy Shores - Alive"
    git clone https://github.com/NexusRisen/Sandy-Shores-Alive.git "$MAPS"/sandy-alive

echo "Police Station & Safehouse"
    git clone https://github.com/NexusRisen/Extended-Police-Station-and-Luxury-Safehouse-2.0.git "$MAPS"/LSPD

echo "Fort Zancudo"
    git clone https://github.com/NexusRisen/Fort-Zancudo-Top-Secret-Project.git "$MAPS"/fort-zancudo

echo "Sand Shores - Enhanced"
    git clone https://github.com/NexusRisen/Sandy-Shores-Enhancement.git "$MAPS"/sandy-enhanced

echo "Vespucci Beach"
    git clone https://github.com/NexusRisen/Vespucci-Beach-Enhanced---Huge-Rock-Formation.git "$MAPS"/vespucci-beach

echo "US - Canada Border"
    git clone https://github.com/NexusRisen/US-Canada-Border-Checkpoint.git "$MAPS"/us-canada

echo "Gov Mansion"
    git clone https://github.com/NexusRisen/Governor-s-Mansion.git "$MAPS"/mansion-governor

echo "Music Producer's Mansion"
    git clone https://github.com/NexusRisen/Music-Producer-s-Mansion.git "$MAPS"/mansion-music

echo "Huge Villa"
    git clone https://github.com/NexusRisen/Huge-villa---Ultra-detailed.git "$MAPS"/huge-villa

echo "Michael Garage"
    git clone https://github.com/NexusRisen/Michael-Garage.git "$MAPS"/garage-michael

echo "Marlow Valley Airport Safehouse"
    git clone https://github.com/NexusRisen/Marlowe-Valley-Safehouse-Airport.git "$MAPS"/marlowe-fort

echo "Railhouse"
    git clone https://github.com/NexusRisen/Railhouse.git "$MAPS"/railhouse

## ---- Map Mods - Optional ---- ##








#nano $RESOURCES/[mods]/AdminArea
# [mods]/allcity_wallet
#nano $RESOURCES/[mods]/async
#nano $RESOURCES/[mods]/BaseJumping
# $RESOURCES/[mods]/cron
# [mods]/crouch-n-prone


#nano $RESOURCES/[mods]/ft_libs
#nano $RESOURCES/[mods]/instance
#nano $RESOURCES/[mods]/mysql-async
#nano $RESOURCES/[mods]/pNotify
#nano $RESOURCES/[mods]/ServerPassword/server.lua
#nano $RESOURCES/[mods]/SexySpeedometer
#nano $RESOURCES/[mods]/VehicleTrustSystem
#nano $RESOURCES/[mods]/vMenu
#nano $RESOURCES/[essential]/es_admin2
# [essential]/esplugin_mysql












# Run Script
##################################
    touch "$GAME"/start-fivem
    chmod +x "$GAME"/start-fivem
    echo '#!/bin/bash' >> "$GAME"/start-fivem
    echo 'screen -S fivem' >> "$GAME"/start-fivem
    echo "cd $GAME" >> "$GAME"/start-fivem
    echo 'bash ../run.sh +exec server.cfg' >> "$GAME"/start-fivem
###################################


# Start Server
####################################
    screen -r fivem
    bash "$GAME"/run.sh +exec server.cfg

##############################################################
#####
##### END - FiveM
#####
##############################################################

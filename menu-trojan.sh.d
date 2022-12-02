#!/bin/bash
# (C) Copyright 2021-2022
# ==================================================================
# Name        : VPN Script Quick Installation Script
# Base        : WildyDev21
# Mod By      : Manternet
# ==================================================================

# // Export Color & Information
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export BLUE='\033[0;34m';
export LIGHT='\033[0;37m';
export NC='\033[0m';
export BG='\e[30;5;47m'

# // Export Banner Status Information
export ERROR="${LIGHT}[${RED} ERROR ${LIGHT}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";

# // Exporting maklumat rangkaian
source /root/ip-detail.txt;
export IP_NYA="$IP";

# // Getting
export IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $IP_NYA )
if [[ $IP_NYA = $IZIN ]]; then > /dev/null 2>&1;
     SKIP=true;
     clear
else
     echo -e "";
     echo -e " ${ERROR} PERMISION DENIED";
     rm -f setup.sh;
  exit 0;
fi

# // SC EXP
export DAY=$(date -d +1day +%Y-%m-%d)
export EXP=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $IP_NYA | awk '{print $3}')
export EXP1=$(echo $EXP | curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $IP_NYA | awk '{print $3}')
 if [[ $EXP1 < $DAY ]]; then > /dev/null 2>&1;
   echo -e "";
   echo -e " ${ERROR} YOUR SCRIPT EXPIRED";
   exit 0
   rm -rf ssh-vpn.sh
 else
   SKIP=true;
fi

clear;
echo -e "";
echo -e "${BLUE}┌────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC}${BG}               ⇱ TROJAN WS & GRPC ⇲             ${BLUE}│${NC}";
echo -e "${BLUE}└────────────────────────────────────────────────┘${NC}";
echo -e "${BLUE}┌────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${LIGHT}  [${GREEN}01${LIGHT}] ${RED}•${LIGHT} CREATE USER TROJAN ACCOUNT";
echo -e "${BLUE}│${LIGHT}  [${GREEN}02${LIGHT}] ${RED}•${LIGHT} DELETE USER TROJAN ACCOUNT";
echo -e "${BLUE}│${LIGHT}  [${GREEN}03${LIGHT}] ${RED}•${LIGHT} RENEW  USER TROJAN ACCOUNT";
echo -e "${BLUE}│${LIGHT}  [${GREEN}04${LIGHT}] ${RED}•${LIGHT} CHECK  USER TROJAN ACCOUNT";
echo -e "${BLUE}│${LIGHT}  [${GREEN}05${LIGHT}] ${RED}•${LIGHT} TRIAL  USER TROJAN ACCOUNT";
echo -e "${BLUE}│${NC}"
echo -e "${BLUE}│${LIGHT}  [${RED}00${LIGHT}] ${RED}• BACK TO MENU${LIGHT}";
echo -e "${BLUE}└────────────────────────────────────────────────┘${NC}";
echo -e "${BLUE}──────────────────────────────────────────────────${NC}${LIGHT}";
echo -e"";
echo -e -n " Select menu [${GREEN} 0 - 5 ${LIGHT}] = "; read x
if [[ $x = 1 ]]; then
 addtrojan
 elif [[ $x = 2 ]]; then
 deltrojan
 elif [[ $x = 3 ]]; then
 renewtrojan
 elif [[ $x = 4 ]]; then
 cektrojan
 elif [[ $x = 5 ]]; then
 trialtrojan
 elif [[ $x = 0 ]]; then
 menu
 else
   echo -e " PLEASE ENTER THE CORRECT NUMBER"
 sleep 1
  menu-trojan
 fi

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
export LIGHT='\033[0;37m';
export YELLOW='\033[0;33m';
export NC='\033[0m';

# // Export Banner Status Information
export ERROR="[${RED} ERROR \e[37m]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";

# // Exporting maklumat rangkaian
source /root/ip-detail.txt;
export IP_NYA="$IP";

# // Getting                                                                                                        
export IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $IP_NYA )    
if [[ $IP_NYA = $IZIN ]]; then                                                                                      
     SKIP=true;                                                                                                     
     clear
else                                                                                                                
     echo -e "${ERROR} PERMISION DENIED";                                                                           
     rm -f addtrojan;                                                                                               
  exit 0;                                                                                                           
fi

# // Add
export none="$(cat ~/log-install.txt | grep -w "XRAY VLESS WS NTLS" | cut -d: -f2|sed 's/ //g')";
export xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS WS TLS" | cut -d: -f2|sed 's/ //g')";

# // User
read -rp "USERNAME = " -e user
export user="$(echo ${user} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $user == "" ]]; then
    clear;
    echo "";
    echo -e "PLEASE INPUT USERNAME ${ERROR}";
    exit 1;
fi

# // Check User
if [[ "$( cat /usr/local/etc/xray/user.txt | grep -w ${user})" == "" ]]; then
    Do=Nothing;
else
    clear;
    echo -e "";
    echo -e " USERNAME [ \e[31m$user\e[37m ] ALREADY USE ";
    exit 1;
fi

# // Date && Bug
read -p "EXPIRED [ DAYS ] = " masaaktif
read -p "SNI [ BUG ] = " sni
read -p "SUBDOMAIN [ WILCD ] = PRESS [ ENTER ] IF ONLY USING HOSTS = " sub

# // Domain && Uuid
export domain=$(cat /usr/local/etc/xray/domain);
export dom=$sub$domain
export uuid=$(uuidgen);

# // Date && Exp
export hariini=`date -d "0 days" +"%Y-%m-%d"`
export exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
export exp1=`date -d "$masaaktif days" +"%d-%m-%Y"`

# // TR WS TLS
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/tls.json

# // TR WS NTLS
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/none.json

# // TR GRPC
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/grpc.json

echo -e "TR $user $exp" >> /usr/local/etc/xray/user.txt;

# // Link
export trojanlink0="trojan://${uuid}@${dom}:${xtls}?sni=$sni#$user"
export trojanlink1="trojan://${uuid}@${dom}:$xtls?type=ws&security=tls&path=/trojan-ws&sni=${sni}#${user}";
export trojanlink2="trojan://${uuid}@${dom}:$none?host=${sni}&security=none&type=ws&path=/trojan-none#${user}";
export trojanlink3="trojan://${uuid}@$dom:${xtls}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=${sni}#${user}";

systemctl restart xray@tls.service
systemctl restart xray@none.service
systemctl restart xray@grpc.service

clear;
echo -e "=====-XRAY-TROJAN/WS&TCP&GRPC-=====";
echo -e "REMARKS   = ${user}";
echo -e "MYIP      = ${IP_NYA}";
echo -e "SUBDOMAIN = ${dom}";
echo -e "PORT TLS  = ${xtls}";
echo -e "PORT NONE = ${none}";
echo -e "PASSWORD  = ${uuid}";
echo -e "===================================";
echo -e "TROJAN TCP TLS LINK";
echo -e " ${trojanlink0} ";
echo -e "";
echo -e "===================================";
echo -e "TROJAN WS TLS LINK";
echo -e " ${trojanlink1} ";
echo -e "";
echo -e "===================================";
echo -e "TROJAN WS LINK";
echo -e " ${trojanlink2} ";
echo -e "";
echo -e "===================================";
echo -e "TROJAN GRPC TLS LINK";
echo -e " ${trojanlink3} ";
echo -e "";
echo -e "===================================";
echo -e "EXPIRED   = $exp1";
echo -e "";
echo -e -n "PRESS [ \e[32mENTER\e[37m ] TO MENU "; read  menu                                 
menu

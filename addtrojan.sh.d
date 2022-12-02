#!/bin/bash
# (C) Copyright 2021-2022
# ==================================================================
# Name        : VPN Script Quick Installation Script
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
echo -e "=====-XRAY-TROJAN/WS&TCP&GRPC-=====
     REMARKS   = ${user}
     MYIP      = ${IP_NYA}
     SUBDOMAIN = ${dom}
     PORT TLS  = ${xtls}
     PORT NONE = ${none}
     PASSWORD  = ${uuid}
   ===================================
     TROJAN TCP TLS LINK
     ${trojanlink0}

   ===================================
     TROJAN WS TLS LINK
     ${trojanlink1} 

   ===================================
     TROJAN WS LINK
     ${trojanlink2}

   ===================================
     TROJAN GRPC TLS LINK
     ${trojanlink3}

   ===================================
     EXPIRED   = $exp1
";
echo -e -n "PRESS [ \e[32mENTER\e[37m ] TO MENU "; read  menu                                 
menu

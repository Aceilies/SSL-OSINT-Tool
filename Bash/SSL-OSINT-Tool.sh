#!/bin/bash

echo "   ___|     ___|    |            _ \     ___|   _ _|    \  |  __ __|      __ __|                   | ";
echo " \___ \   \___ \    |           |   |  \___ \     |      \ |     |           |      _ \     _ \    | ";
echo "       |        |   |           |   |        |    |    |\  |     |           |     (   |   (   |   | ";
echo " _____/   _____/   _____|      \___/   _____/   ___|  _| \_|    _|          _|    \___/   \___/   _| ";
echo '  ____     __    ___  ____  _      ____    ___  _____
 /    |   /  ]  /  _]|    || |    |    |  /  _]/ ___/
|  o  |  /  /  /  [_  |  | | |     |  |  /  [_(   \_ 
|     | /  /  |    _] |  | | |___  |  | |    _]\__  |
|  _  |/   \_ |   [_  |  | |     | |  | |   [_ /  \ |
|  |  |\     ||     | |  | |     | |  | |     |\    |
|__|__| \____||_____||____||_____||____||_____| \___|'
echo ""

duplicates="false"

# Check if jq is installed
if ! command -v jq &> /dev/null
then
  echo "jq not found, installing..."
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install jq # Debian/Ubuntu
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install jq # CentOS/RHEL
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install jq # Fedora
  elif [ -x "$(command -v brew)" ]; then
    brew install jq # MacOS
  else
    echo "Error: jq is not found and cannot be installed on this system. Please manually install jq and rerun the script."
    exit 1
  fi
fi

# Parse command line arguments
while getopts ":u:d:h:" opt; do
  case $opt in
    u)
      url="$OPTARG"
      ;;
    d)
      duplicates="$OPTARG"
      ;;
    :)
      echo "Usage: $0 [-u url] [-d duplicates]"
      echo "Options:"
      echo "  -u url        URL to check at crt.sh"
      echo "  -d duplicates Show duplicated records (true/false)"
      exit 0
      ;;
  esac
done

if [ -z "$url" ]; then
  read -p "Enter url to check at crt.sh: " url
fi

echo "Checking $url at crt.sh"
echo ""

output=$(curl --silent --location "https://crt.sh/?q=$url&output=json&exclude=expired" \
--header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:101.0) Gecko/20100101 Firefox/101.0')

echo "common_name, issuer_ca_id, not_before, not_after" | tr ',' '\t' | column -t

if [ "$duplicates" = "false" ]; then
  echo $output | jq -r '.[] | [.common_name, .issuer_ca_id, .not_before, .not_after] | @tsv' | sort -u -k1,1 | column -t
else
  echo $output | jq -r '.[] | [.common_name, .issuer_ca_id, .not_before, .not_after] | @tsv' | column -t
fi

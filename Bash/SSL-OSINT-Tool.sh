#!/bin/bash


echo "   ___|     ___|    |            _ \     ___|   _ _|    \  |  __ __|      __ __|                   | ";
echo " \___ \   \___ \    |           |   |  \___ \     |      \ |     |           |      _ \     _ \    | ";
echo "       |        |   |           |   |        |    |    |\  |     |           |     (   |   (   |   | ";
echo " _____/   _____/   _____|      \___/   _____/   ___|  _| \_|    _|          _|    \___/   \___/   _| ";
echo "  


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
while getopts ":u:" opt; do
  case $opt in
    u)
      url="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "You can use -u switch instead example ./script.sh -u example.com"

if [ -z "$url" ]; then
  read -p "Enter url to check at crt.sh: " url
fi

echo "   ___|     ___|    |            _ \     ___|   _ _|    \  |  __ __|      __ __|                   | ";
echo " \___ \   \___ \    |           |   |  \___ \     |      \ |     |           |      _ \     _ \    | ";
echo "       |        |   |           |   |        |    |    |\  |     |           |     (   |   (   |   | ";
echo " _____/   _____/   _____|      \___/   _____/   ___|  _| \_|    _|          _|    \___/   \___/   _| ";
echo "  


echo '  ____     __    ___  ____  _      ____    ___  _____
 /    |   /  ]  /  _]|    || |    |    |  /  _]/ ___/
|  o  |  /  /  /  [_  |  | | |     |  |  /  [_(   \_ 
|     | /  /  |    _] |  | | |___  |  | |    _]\__  |
|  _  |/   \_ |   [_  |  | |     | |  | |   [_ /  \ |
|  |  |\     ||     | |  | |     | |  | |     |\    |
|__|__| \____||_____||____||_____||____||_____| \___|
                                                     '

echo "Checking $url at crt.sh"

output=$(curl --location "https://crt.sh/?q=$url&output=json&exclude=expired" \
--header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:101.0) Gecko/20100101 Firefox/101.0')

echo "$output" | jq -r '.[].common_name' | column -t

#!/bin/bash


echo '  ____     __    ___  ____  _      ____    ___  _____
 /    |   /  ]  /  _]|    || |    |    |  /  _]/ ___/
|  o  |  /  /  /  [_  |  | | |     |  |  /  [_(   \_ 
|     | /  /  |    _] |  | | |___  |  | |    _]\__  |
|  _  |/   \_ |   [_  |  | |     | |  | |   [_ /  \ |
|  |  |\     ||     | |  | |     | |  | |     |\    |
|__|__| \____||_____||____||_____||____||_____| \___|
                                                     '


# Check if jq is installed
if ! command -v jq &> /dev/null
then
  echo "jq not found, installing..."
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install jq
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install jq
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install jq
  else
    echo "jq not found and cannot be installed on this system"
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

echo "Checking $url at crt.sh"

output=$(curl --location "https://crt.sh/?q=$url&output=json&exclude=expired" \
--header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:101.0) Gecko/20100101 Firefox/101.0')

echo "$output" | jq -r '.[].name' | column -t

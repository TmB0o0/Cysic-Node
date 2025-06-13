#!/bin/bash

# Очистка экрана
clear

# Цвета
WHITE='\033[1;37m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

# Название screen-сессии
SESSION_NAME="cysic_node"

# Путь до скрипта
SCRIPT_PATH="$(readlink -f "$0" 2>/dev/null || realpath "$0")"

# Логотип
show_logo() {
  local logo=(
    "${CYAN}+-----------------------------------------------------------------------------------------------------------+${RESET}"
    "${CYAN}|${YELLOW}  ##  ###  #######  ######   #######  #######  #######  ######   #######  ##  ##   #######  ######         ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  ### ###  ##   ##  ##  ##   ##       ##         ###    ##  ##     ###    ##  ##   ##       ##  ##         ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  #######  ##   ##  ##  ##   ##       #######    ###    ##  ##     ###    ## ##    ##       ##  ##         ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  ## ####  ##  ###  ### ###  #######       ##    ###    #######    ###    #######  #######  #######        ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  ##  ###  ##  ###  ### ###  ###      ###  ##    ###    ### ###    ###    ##  ###  ###      ### ###        ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  ##  ###  ##  ###  ### ###  # #      ###  ##    ###    ### ###    ###    ##  ###  # #      ### ###        ${CYAN}|${RESET}"
    "${CYAN}|${YELLOW}  ##  ###  #######  #######  #######  #######    ###    ### ###  #######  ##  ###  #######  #######        ${CYAN}|${RESET}"
    "${CYAN}+-----------------------------------------------------------------------------------------------------------+${RESET}"
    "${CYAN}|                                                                                                           |${RESET}"
    "${CYAN}|  🔗 ${GREEN}Follow us on Twitter:${RESET} \033[4;34mhttps://x.com/TmBO0o\033[0m 🐦                                                    ${CYAN}|${RESET}"
    "${CYAN}|  💻 ${GREEN}GitHub Repository:${RESET} \033[4;34mhttps://github.com/TmB0o0\033[0m 📁                                                  ${CYAN}|${RESET}"
    "${CYAN}|  📖 ${GREEN}GitBook Guide:${RESET} \033[4;34mhttps://tmb.gitbook.io/nodeguidebook/\033[0m 📚                                          ${CYAN}|${RESET}"
    "${CYAN}+-----------------------------------------------------------------------------------------------------------+${RESET}"
  )

  for line in "${logo[@]}"; do
    echo -e "$line"
    sleep 0.03
  done
}

# Установка ноды
install_node() {
  echo -e "\n${WHITE}╔════════════════════════════════════════════╗${RESET}"
  echo -e "${WHITE}║             INSTALL CYSIC NODE             ║${RESET}"
  echo -e "${WHITE}╚════════════════════════════════════════════╝${RESET}"
  
  read -p $'\nEnter your reward address (starts with 0x): ' REWARD_ADDRESS
  if [[ "$REWARD_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo -e "${GREEN}Installing node with address: $REWARD_ADDRESS${RESET}"
    curl -sL https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/setup_linux.sh -o ~/setup_linux.sh
    bash ~/setup_linux.sh "$REWARD_ADDRESS"
    
    echo -e "${YELLOW}Launching node in screen session: $SESSION_NAME${RESET}"
    screen -dmS "$SESSION_NAME" bash -c 'cd ~/cysic-verifier && bash start.sh'
    echo -e "${GREEN}Node launched in screen session.${RESET}"
  else
    echo -e "${RED}Invalid address. It should start with 0x and be 42 characters long.${RESET}"
  fi
}

# Удаление ноды и скрипта
remove_node() {
  echo -e "\n${WHITE}╔════════════════════════════════════════════╗${RESET}"
  echo -e "${WHITE}║             REMOVE CYSIC NODE              ║${RESET}"
  echo -e "${WHITE}╚════════════════════════════════════════════╝${RESET}"
  
  echo -e "${YELLOW}Stopping screen session (if exists)...${RESET}"
  screen -S "$SESSION_NAME" -X quit 2>/dev/null

  echo -e "${YELLOW}Removing node files and this script...${RESET}"
  rm -rf ~/cysic-verifier ~/setup_linux.sh
  echo -e "${GREEN}Node removed.${RESET}"

  echo -e "${RED}Deleting this script: $SCRIPT_PATH${RESET}"
  rm -f "$SCRIPT_PATH"
  echo -e "${GREEN}Script deleted. Goodbye!${RESET}"
  exit 0
}

# Перезапуск ноды
restart_node() {
  echo -e "\n${WHITE}╔════════════════════════════════════════════╗${RESET}"
  echo -e "${WHITE}║             RESTART CYSIC NODE             ║${RESET}"
  echo -e "${WHITE}╚════════════════════════════════════════════╝${RESET}"
  
  echo -e "${YELLOW}Restarting node in screen session...${RESET}"
  screen -S "$SESSION_NAME" -X quit 2>/dev/null
  sleep 2
  screen -dmS "$SESSION_NAME" bash -c 'cd ~/cysic-verifier && bash start.sh'
  echo -e "${GREEN}Node restarted in screen session: $SESSION_NAME${RESET}"
}

# Логи ноды
view_logs() {
  echo -e "\n${WHITE}╔════════════════════════════════════════════╗${RESET}"
  echo -e "${WHITE}║               CYSIC NODE LOGS              ║${RESET}"
  echo -e "${WHITE}╚════════════════════════════════════════════╝${RESET}"

  if screen -list | grep -q "$SESSION_NAME"; then
    echo -e "${CYAN}Attaching to screen session: $SESSION_NAME${RESET}"
    echo -e "${YELLOW}Press Ctrl+A then D to detach.${RESET}"
    sleep 2
    screen -r "$SESSION_NAME"
  else
    echo -e "${RED}No running screen session found. Start the node first.${RESET}"
  fi
}

# Главное меню
main_menu() {
  while true; do
    clear
    show_logo

    echo -e "\n${WHITE}╔════════════════════════════════════════════╗${RESET}"
    echo -e "${WHITE}║         CYSIC NODE MANAGEMENT MENU         ║${RESET}"
    echo -e "${WHITE}╚════════════════════════════════════════════╝${RESET}"
    echo -e "${CYAN}1.${RESET} Install node"
    echo -e "${CYAN}2.${RESET} Remove node and delete script"
    echo -e "${CYAN}3.${RESET} Restart node"
    echo -e "${CYAN}4.${RESET} View logs (attach to screen)"
    echo -e "${CYAN}5.${RESET} Exit"
    echo -ne "\n${WHITE}Choose an option (1-5): ${RESET}"
    read choice

    case $choice in
      1) install_node ;;
      2) remove_node ;;
      3) restart_node ;;
      4) view_logs ;;
      5) echo -e "${GREEN}Goodbye!${RESET}"; exit 0 ;;
      *) echo -e "${RED}Invalid option. Please enter 1-5.${RESET}" ;;
    esac

    echo -ne "\n${WHITE}Press any key to return to menu...${RESET}"
    read -n 1 -s
  done
}

# Проверка screen
if ! command -v screen &>/dev/null; then
  echo -e "${RED}Error: 'screen' is not installed. Installing...${RESET}"
  sudo apt update && sudo apt install screen -y
fi

# Запуск
main_menu

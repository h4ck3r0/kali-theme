sudo apt install figlet
gem install lolcat
clear

banner() {

 figlet -f mono12 "kali-TH" | lolcat
 echo""
 echo -e "\e[1;31m  [\e[32m√\e[31m] \e[1;91m by \e[1;36mRaj Aryan \e[93m/ \e[100;92 Youtube=H4Ck3R\e[0m"

                  }
wr () {
           
                               printf "\033[1;91m Invalid input!!!\n"
                               selection
                               }
                               1line() {
                                        sudo apt update 
                                        sudo apt upgrade
                                        sudo apt install zsh
                                        sudo apt install ruby
                                        sudo apt install wget
                                        sudo apt install curl
                                        cd ~/kali-theme ; bash os.sh 
                                        
                                       }
                                       2line() {
                                                sudo chsh -s zsh
                                                cd ~/kali-theme ; bash os.sh
                                                cd ~/Kali-theme/.object
                                                bash  .1.sh
                                                 
                                               }
                                               3line() {
                                                       sudo chsh -s zsh 
                                                       cd ~/kali-theme ; bash os.sh
                                                       cd ~/Kali-theme/.object
                                                       bash .2.sh
                                                       }


selection () {
                                            cd ~/kali-theme
                                            echo -e -n "\e[1;96m Choose\e[1;96m Option : \e[0m"
                                            read a
                                            case $a in
                                            1) 1line ;;
                                            2) 2line ;;
                                            3) 3line ;;
                                            4) exit ;;
                                            *) wr ;;

                                            esac 
                                            }

  menu () {
                                  banner
                                  printf "\n\033[1;91m[\033[0m1\033[1;91m]\033[1;92m Necessary Setup \n"
                                  printf "\033[1;91m[\033[0m2\033[1;91m]\033[1;92m Zsh Theme\n"
                                  printf "\033[1;91m[\033[0m3\033[1;91m]\033[1;92m Highlight & Suggestion\n"
                                  printf "\033[1;91m[\033[0m4\033[1;91m]\033[1;92m Exit\n\n\n"
                                  
                                  selection
                                  }
                  menu



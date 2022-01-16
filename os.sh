sudo apt install toilet 
sudo apt install figlet
gem install lolcat
clear

banner() {

 figlet -f mono12 "kali-TH" | lolcat
 echo""
 echo -e "\e[1;31m  [\e[32m√\e[31m] \e[1;91m by \e[1;36mRaj Aryan \e[93m/ \e[100;92m Youtube/H4Ck3R\e[0m"

                  }
wr () {
           
                               printf "\033[1;91m Invalid input!!!\n"
                               selection
                               }
                               1line() {
                                        sudo apt update 
                                        sudo apt install zsh
                                        sudo apt install ruby
                                        sudo apt install wget
                                        sudo apt install curl
                                        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                                        cd ~/kali-theme ; bash os.sh 
                                        
                                       }
                                       2line() {
                                                sudo chsh -s zsh
                                                cd ~/kali-theme/.object ; bash .1.sh
                                                cd ~/kali-theme ; bash os.sh
                                               }
                                               3line() {
                                                       sudo chsh -s zsh 
                                                       cd ~/kali-theme/.object ; bash .2.sh                                                      
                                                       cd ~/kali-theme ; bash os.sh
                                                       
                                                         }
                                                          4line() {
                                                                  rm -r ~/.zshrc
                                                                  cd ~/kali-Theme/.object
                                                                  cp  -r .zshrc ~/.zshrc
                                                                  cd ~/kali-theme ; bash os.sh
                                                                  }
                                                                  5line() {                                                                  
                                                                            rm -rf ~/kali-theme
                                                                            cd
                                                                            git clone https://github.com/h4ck3r0/kali-theme
                                                                            cd ~/kali-theme ; bash os.sh
       
                                                                  
    selection () {
                                           
                                            echo -e -n "\e[1;96m Choose\e[1;96m Option : \e[0m"
                                            cd ~/kali-theme
                                            read a
                                            case $a in
                                            1) 1line ;;
                                            2) 2line ;;
                                            3) 3line ;;
                                            4) 4line ;;
                                            5) 5line  ;;
                                            6) exit ;;
                                            *) wr ;;

                                            esac 
                                            }

  menu () {
                                  banner
                                  printf "\n\033[1;91m[\033[0m1\033[1;91m]\033[1;92m Necessary Setup \n"
                                  printf "\033[1;91m[\033[0m2\033[1;91m]\033[1;92m Zsh Theme\n"
                                  printf "\033[1;91m[\033[0m3\033[1;91m]\033[1;92m Highlight & Suggestion\n"
                                  printf "\033[1;91m[\033[0m4\033[1;91m]\033[1;92m Reset Theme\n"
                                  printf "\033[1;91m[\033[0m5\033[1;91m]\033[1;92m Update\n"
                                  printf "\033[1;91m[\033[0m6\033[1;91m]\033[1;92m Exit\n\n\n"
                                  
                                  selection
                                  }
                  menu



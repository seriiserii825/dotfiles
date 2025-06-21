function setUser(){
  export HOST_UID=$(id -u)
  export HOST_GID=$(id -g)
  echo "HOST_UID=${HOST_UID}" > .env
  echo "HOST_GID=${HOST_GID}" >> .env
}

function checkIfInDockerDir(){
  current_dir=$(pwd)
  if [[ ! -f docker-compose.yaml ]]; then
    echo "${tmagenta}Not in a Docker directory. Please run this command in the directory containing docker-compose.yaml.${treset}"
    # check if is file front-page.php
    if [[ ! -f style.css ]]; then
      sleep 10
      echo "${tmagenta}Not in wp theme directory. Please run this command in the directory containing style.css.${treset}"
      exit 1
    fi
    cd ../../../
    if [[ ! -f docker-compose.yaml ]]; then
      sleep 10
      echo "${tmagenta}Not in a Docker directory. Please run this command in the directory containing docker-compose.yaml.${treset}"
      exit 1
    else
      echo "${tgreen}Found docker-compose.yaml in $(pwd)${treset}"
      echo "${tblue}Running command in $(pwd)${treset}"
      cd "$current_dir"
    fi
  fi
}

function wup(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Starting Docker containers...${treset}"
  sudo systemctl start docker && sleep 2 && sudo docker-compose up -d && docker ps
  echo "${tgreen}Docker containers started.${treset}"
}

function wdown(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Stopping Docker containers...${treset}"
  sudo docker-compose down --remove-orphans
  echo "${tgreen}Docker containers stopped.${treset}"
}

function wbuild(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Building Docker containers...${treset}"
  sudo docker-compose up --build -d && docker ps
  echo "${tgreen}Docker containers built.${treset}"
}

function wrebuild(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Building Docker containers...${treset}"
  sudo docker-compose down --remove-orphans
  sudo docker-compose up --build -d && docker ps
  echo "${tgreen}Docker containers built.${treset}"
}

function wrestart(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Restarting Docker containers...${treset}"
  sudo docker-compose down && sudo docker-compose up -d && docker ps
  echo "${tgreen}Docker containers restarted.${treset}"
}

function wps(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Listing Docker containers...${treset}"
  sudo docker-compose ps
}

function wlist(){
  setUser
  checkIfInDockerDir
  echo "${tblue}Listing all Docker containers...${treset}"
  docker ps -a
}


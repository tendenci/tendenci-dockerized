# Docker Tendenci

Docker file and docker-compose file to launch a tendenci instance.


## Installation

Install docker and git in your system

```bash
git clone https://github.com/jucajuca/docker-tendenci
``````

## Usage

Rename the .env.sample file to .env 
Edit the .env file and adjust your settings

```bash
docker build -t "Tendenci" .
docker-compose up -d
``````

Do not forget the dot at the end of docker build

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


Based on : https://github.com/frenchbeard/docker-tendenci

## License
[MIT](https://choosealicense.com/licenses/mit/)

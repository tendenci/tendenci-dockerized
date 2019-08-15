# Important

Even if this docker image is available, I would **not recommend using tendenci** for your association. There are many reason for this

- It will take still a considerable amount of time to set up the basics
- The software base is huge and there are few maintainers (one)
- It is bloated with many functions that are not relevant anymore (google+)
- It is [not gdpr compliant](https://github.com/tendenci/tendenci/issues/777  "not gdpr compliant")
- See also [this letter](https://github.com/goetzk/tendenci-community/blob/master/community-engagement.rst "this letter")

You can try it on your own. Or you can look at better association managers:

- http://hitobito.com/en
- https://www.admidio.org/download.php?language=en

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


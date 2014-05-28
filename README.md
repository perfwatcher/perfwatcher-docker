Simple [Perfwatcher](http://perfwatcher.org/) in docker
============================

Requirements
------------

*Docker*
* `All OS` : <https://www.docker.io/gettingstarted/#h_installation>
* `For Debian 7` : <http://doduck.com/docker-install-on-debian-7/>


Getting Perfwatcher's Docker files
----------------------------------
* `From GitHub` : git clone -b perfwatcher-docker https://github.com/perfwatcher/perfwatcher.git perfwatcher-docker



Building
--------
* `cd perfwatcher-docker`
* `docker.io  build -t perfwatcher  .`


Running
-------
* `docker.io run -p 8081:80 -d perfwatcher`


Browsing
--------
* Open your favorite browser <http://127.0.0.1:8081/perfwatcher/>



Connect Perfwatcher container through SSH
-----------------------------------------
* Get container NAME with  `docker.io ps`
* Get container IP with `docker.io inspect <NAME>|grep IPAddress
* ssh -i id_dsa root@<IPAddress>






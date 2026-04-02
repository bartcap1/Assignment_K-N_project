
---

## Cel

- przygotowanie kompletnego środowiska CI/CD
- symulacja całego procesu w kontenerach dockera (ponieważ nie masz mozliwości używania maszyn wirtualnych)
- zadania z * są dodatkowe, ale mile widziane
- w przypadku problemów z pobieraniem, rozważyć wyłączenie Security w Zscaller ❗
	- problem z pobraniem jenkins.war -> pobrano go bezpośrednio z przeglądarki i przeniesiono do lokalizacji infra
	- problemy z instalacją pluginów jenkins -> skopiowanie certyfikatów firmowych do kontenera i `update-ca-trust`  (.gitignore) ❗
## Przebieg

1. Utworzenie publicznego repozytorium na GitHubie (notatki, kod devops, kod aplikacji) ✅
	- należy wygenerować parę kluczy ssh: `ssh-keygen -t ed25519 -C "k-n-project_key"`'
	- następnie kopia klucza publicznego do githuba
	- klonowanie repozytorium z githuba do folderu lokalnego z plikami: `git clone <link>`

2. Utworzenie sieci docker ✅
	- `docker network create k-n-project` lub z poziomu docker-compose

3. Uruchomienie kontenera rockylinux dla Jenkins, Nexus, Test, Prod ✅
	1. Obraz: `rockylinux/rockylinux:9`
		- `docker pull rockylinux/rockylinux:9`
	2. Przygotowanie dockerfile ze zdefiniowaną instalacją narzędzi z jego poziomu (dockerfile napisany w taki sposób jak wywoływanie poleceń z konsoli)
		- należy rozpisać konfigurację wszystkich serwisów w dockerfile, następnie uruchomić je w sieci
		- bonus od siebie: dobrze sprawdzi się to jako infrastruktura docker-compose

4. Nexus ✅
	1. Pobranie paczki z oficjalnego źródła
		- ` https://download.sonatype.com/nexus/3/nexus-3.90.2-02-linux-x86_64.tar.gz`
	2. Uruchomienie nexusa
		- nexus to aplikacja napisana w javie
		- z tego względu w kontenerze potrzebna jest instalacja JVM
	3. uruchomienie nexusa jako serwis*
		- nexus uruchomiony za pomocą ENTRYPOINT, jako proces głwóny, czyli serwis
	4. ustawienie hasła dla usera
		- ręcznie w GUI 
	5. stworzenie dedykowanego repo dla artefaktów
		- ręcznie w GUI - Settings -> Repositories -> Create R -> maven2 hosted
		- Layput policy: strict; Content Disposition: inline; Deployment policy: allow redeploy

5. Test ✅
	1. Pobranie i instalacja JAVA 21 i Tomcat 10
		- wszystko z poziomu Dockerfile
	2. uruchomienie aplikacji jako serwis*
		- aplikacja nie jest serwisem - to tomcat jest serwisem, a aplikacja działa w nim jako część serwisu

6. Prod ✅
	1. Pobranie i instalacja JAVA 21 i Tomcat 10
		- wszystko z poziomu Dockerfile
	2. uruchomienie aplikacji jako serwis*
		- aplikacja nie jest serwisem - to tomcat jest serwisem, a aplikacja działa w nim jako część serwisu

7. Jenkins
	1. Pobranie i instalacja JAVA 21 i git ✅
		- z poziomu dockerfile
		- rockylinux zawiera java 17 - w docerfile `RUN alternatives`
	2. Instalacja Docker CLI ✅
		- z poziomu dockerfile
	3. Ustawienie JENKINS_HOME ✅
		- z poziomu dockerfile
		- wskazuje na katalog domowy z konfiguracją, pluginami i jobami
	4. Zmapowanie docker.sock [/var/run/docker.sock:/var/run/docker.sock] wiedzieć dlaczego/ po co? ✅
		- mapowanie docker.sock można zrozumieć manualnie volume mountem, albo w docker-compose
		- jenkins używa docker cli do komunikacji przez socket z dockerem hosta - po to mapowanie
		- dzięki temu pipeline Jenkins może obsługiwać działania w kontenerach dockera na hoście
	5. Dodać mvn w toolach
		- maven jest instalowany w obrazie - jeśli potrzebujesz go mieć w obrazie✅
		- dodawanie w UI Jenkinsa - maven 3.9 ✅
	6. Utworzenie secret file dla setting.xml (connection do nexusa) ✅
		- utworzenie lokalne pliku settings.xml - zawierającego credentials do połaczenia z nexusem 
		- dodanie go w GUI Jenkinsa w Credentials - text file
	7. Przygotować Jenkinsfile, który zrealizuje wszystkie kroki CI/CD
		- Jenkinsfile umieszczony w repozytorium
		- Z repozytorium połączonego z Jenkinsem, Jenkinsfile trafia do joba

8. Continous Integration; Continous Delivery; Continous Deployment - w Jenkinsfile!
	1. Tworzysz dwa branche:
		1. branch feature - build + test
		2. branch main - b + t + deploy na test + opcjonalnie deploy na prod
		3. Deploy realizujesz za pomocą ssh i ansible!!!!!!
	2. Integrujesz repo z pipeline - commit do repo trigeruje pipeline*
	3. Instalacja pluginu Pipeline: Stage View Plugin -> ręcznie w GUI Jenkinsa ✅
	4. Utworzenie użytkownika "dev", który będzie miał uprawnienia tylko do wyświetlania i użytkowania admin, który będzie miał prawa admina -> ręcznie w GUI Jenkinsa ✅
		- Security -> Authorization -> Matrix-based security -> dev (Overall read + Job read)
	5. Dodać permanentny kontener jenkins agent z 2 workerami i zmniejsz liczbę workerów na jenkinsie do 0
		- Problem z secretem, status 403 forbidden❗

9. Przygotować playbook ansible za pomocą którego można zdeployować zbudowany artefakt na środowisko + inventory (chodzi o poznanie technologii)
10. SonarQube i analiza kodu*
11. Narzędzie do zbierania logów*
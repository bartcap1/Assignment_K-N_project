
---

## Cel

- przygotowanie kompletnego środowiska CI/CD
- symulacja całego procesu w kontenerach dockera (ponieważ nie masz mozliwości używania maszyn wirtualnych)
- zadania z * są dodatkowe, ale mile widziane
- w przypadku problemów z pobieraniem, rozważyć wyłączenie Security w Zscaller ❗
## Przebieg

1. Utworzenie publicznego repozytorium na GitHubie (notatki, kod devops, kod aplikacji) ✅
	- należy wygenerować parę kluczy ssh: `ssh-keygen -t ed25519 -C "k-n-project_key"`'
	- następnie kopia klucza publicznego do githuba
	- klonowanie repozytorium z githuba do folderu lokalnego z plikami: `git clone <link>`
2. Utworzenie sieci docker ✅
	- `docker network create k-n-project`
3. Uruchomienie kontenera rockylinux dla Jenkins, Nexus, Test, Prod
	1. Obraz: `rockylinux/rockylinux:9`
	2. Przygotowanie dockerfile ze zdefiniowaną instalacją narzędzi z jego poziomu (dockerfile napisany w taki sposób jak wywoływanie poleceń z konsoli)
		- chodzi o komendy `RUN` 
4. Nexus
	1. Pobranie paczki z oficjalnego źródła
	2. Uruchomienie nexusa
	3. uruchomienie nexusa jako serwis*
	4. ustawienie hasła dla usera
	5. stworzenie dedykowanego repo dla artefaktów
5. Test
	1. Pobranie i instalacja JAVA 21 i Tomcat 10
	2. uruchomienie aplikacji jako serwis*
6. Prod
	1. Pobranie i instalacja JAVA 21 i Tomcat 10
	2. uruchomienie aplikacji jako serwis*
7. Jenkins
	1. Pobranie i instalacja JAVA 21 i git
	2. Instalacja Docker CLI
	3. Ustawienie JENKINS_HOME
	4. Zmapowanie docker.soc [/var/run/docker.sock:/var/run/docker.sock] wiedzieć dlaczego/ po co?
	5. Dodać mvn w toolach
	6. Utworzenie secret file dla setting.xml (connection do nexusa)
	7. Przygotować Jenkinsfile, który zrealizuje wszystkie kroki CI/CD
8. Continous Integration; Continous Delivery; Continous Deployment
	1. Tworzysz dwa branche:
		1. branch feature - build + test
		2. branch main - b + t + deploy na test + opcjonalnie deploy na prod
		3. Deploy realizujesz za pomocą ssh i ansible!!!!!!
	2. Integrujesz repo z pipeline - commit do repo trigeruje pipeline*
	3. Instalacja pluginu Pipelin: Stage View Plugin
	4. Utworzenie użytkownika "dev", który będzie miał uprawnienia tylko do wyświetlania i użytkowania admin, który będzie miał prawa admina
	5. Dodać permanentny kontener jenkins agent z 2 workerami i zmniejsz liczbę workerów na jenkinsie do 0
9. Przygotować playbook ansible za pomocą którego można zdeployować zbudowany artefakt na środowisko + inventory (chodzi o poznanie technologii)
10. SonarQube i analiza kodu* -> 
11. Narzędzie do zbierania logów* -> chodzi o wybranie narzędzia?
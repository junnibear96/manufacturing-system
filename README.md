# tp_manufacturing_execution_system

JSP로 만든 TP 포트폴리오(단일 페이지) 템플릿입니다.

## 파일 구조

- `src/main/webapp/index.jsp`: 메인 페이지
- `src/main/webapp/company.jsp`: TP 회사 소개 페이지
- `src/main/webapp/assets/styles.css`: 스타일
- `src/main/webapp/assets/app.js`: 내비게이션/코드 복사 등 JS
- `src/main/webapp/partials/*.jspf`: 헤더/푸터 include
- `src/main/webapp/WEB-INF/web.xml`: welcome-file 및 UTF-8 인코딩 필터

## 실행(로컬)

이 프로젝트는 JSP(포트폴리오/회사소개) + Spring Boot 미니 API를 포함합니다.

### 사전 준비물

- JDK 21 설치 (Windows 기준: `java` 명령이 PATH에서 실행되어야 함)
- (권장) Tomcat 9.x

#### Windows에서 JDK 21 빠른 설치(권장: Microsoft Build of OpenJDK)

- 설치: `winget install -e --id Microsoft.OpenJDK.21`
- 설치 후 `java -version`이 안 되면(새 터미널에서도 안 되면)
	- `./scripts/setup-openjdk21.ps1` 실행해서 `JAVA_HOME`/PATH를 잡을 수 있습니다.

## Step by step (Oracle DB 기준)

1) JSP 화면(정적) 확인

- `/TP/` (welcome: `index.jsp`)
- `/TP/company.jsp`

2) Spring MVC 화면 확인 (Controller → Model → JSP)

- `/TP/app/portfolio`
- `/TP/app/company`

3) API 확인 (Oracle DB 필요)

- `/TP/api/health`
- `/TP/api/sample?q=hello`

4) Oracle 접속 정보 설정

- `TP_ORACLE_URL`, `TP_ORACLE_USER`, `TP_ORACLE_PASS` 설정

### 방법 A) Tomcat에 그대로 배포

1. Tomcat 설치
2. Tomcat의 `webapps/TP` 폴더를 만들고, 아래 경로의 내용을 그대로 복사
	- `src/main/webapp/*` → `webapps/TP/`
3. Tomcat 실행 후 접속
	- `http://localhost:8080/TP/`

#### API 확인

- `GET http://localhost:8080/TP/api/health`
- `GET http://localhost:8080/TP/api/sample?q=hello`

### 방법 B) IDE(예: IntelliJ/Eclipse)에서 Web Facet/Server 설정

`src/main/webapp`을 Web Resource Root로 지정해 배포하면 됩니다.

## 빌드(WAR)

Maven이 설치되어 있지 않아도 Maven Wrapper로 빌드할 수 있습니다.

- Windows: `./mvnw.cmd clean test package`

### 로컬 실행(embedded Tomcat)

JDK만 설치되어 있으면 Tomcat 설치 없이도 실행 가능합니다.

- `./mvnw.cmd -DskipTests spring-boot:run`

접속:

- `http://localhost:8080/app/portfolio`
- `http://localhost:8080/api/health`

빌드 산출물:

- `target/TP.war`

Tomcat `webapps`에 `TP.war`를 올리면 컨텍스트 경로는 `/TP`가 됩니다.

외부 Tomcat 배포용 빌드(권장):

- `./mvnw.cmd -Pexternal-tomcat clean package`

## Oracle 설정

환경변수로 Oracle 접속 정보를 주입합니다.

- `TP_ORACLE_URL` (예: `jdbc:oracle:thin:@//localhost:1521/XEPDB1`)
- `TP_ORACLE_USER` (예: `system`)
- `TP_ORACLE_PASS` (예: `oracletest`)

Oracle이 없거나 접속이 안 되더라도 앱은 기동되며, `/api/health`에서 `db.connected=false`로 표시됩니다.

## MVC 데이터(Oracle에서 읽기)

포트폴리오/회사소개 화면(`/app/portfolio`, `/app/company`)은 Oracle 테이블에서 데이터를 읽습니다.
기존 경로(`/mvc/portfolio`, `/mvc/company`)는 `/app/*`로 리다이렉트됩니다.

처음 세팅 시에는 아래 SQL을 Oracle에 실행하세요.

- 스키마 생성: [scripts/oracle-init.sql](scripts/oracle-init.sql)
- 샘플 데이터: [scripts/oracle-seed.sql](scripts/oracle-seed.sql)

테이블이 아직 없으면, 앱은 기동은 되지만 MVC 데이터는 임시(fallback) 값으로 표시됩니다.

### 로컬에서만 비밀번호 관리

- 예시 파일: `.env.example`
- 실제 값은 `.env`에 두고 git에 올리지 않습니다(이미 `.gitignore`에 포함).
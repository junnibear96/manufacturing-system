<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Portfolio</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <main id="content" class="container" role="main">
            <section class="hero" id="about" aria-label="소개">
              <div class="hero-grid">
                <div class="card card-strong">
                  <div class="kicker">
                    <span class="badge">Spring MVC</span>
                    <span class="small">JSP View Rendering · Model 전달</span>
                  </div>
                  <h1>
                    <spring:message code="app.portfolio.title" text="지원용 포트폴리오 (MVC 버전)" />
                  </h1>
                  <p>
                    <spring:message code="app.portfolio.desc"
                      text="이 페이지는 Spring MVC Controller에서 Model 데이터를 받아 JSTL로 렌더링합니다. (DB 없이도 화면 구조/템플릿/데이터 바인딩을 먼저 완성하는 흐름)" />
                  </p>
                  <p class="small">
                    <spring:message code="app.login.serverTime" arguments="${now}" text="서버 시간: ${now}" />
                  </p>
                </div>

                <aside class="card" aria-label="요약">
                  <h2 style="margin-top:0;">
                    <spring:message code="app.portfolio.summary.title" text="요약" />
                  </h2>
                  <div class="keyval">
                    <div class="key">
                      <spring:message code="app.portfolio.summary.view" text="화면" />
                    </div>
                    <div class="value">JSP + JSTL</div>
                  </div>
                  <div class="keyval">
                    <div class="key">
                      <spring:message code="app.portfolio.summary.mvc" text="MVC" />
                    </div>
                    <div class="value">Spring Controller → Model → View</div>
                  </div>
                  <div class="keyval">
                    <div class="key">
                      <spring:message code="app.portfolio.summary.db" text="DB" />
                    </div>
                    <div class="value">Oracle</div>
                  </div>
                </aside>
              </div>
            </section>

            <section class="section" id="skills" aria-label="필요 기술">
              <div class="card">
                <h2>
                  <spring:message code="app.portfolio.skills" text="기술 스택" />
                </h2>
                <div class="chips" role="list" aria-label="기술 목록">
                  <c:forEach var="s" items="${skills}">
                    <span class="chip" role="listitem">${s}</span>
                  </c:forEach>
                </div>
              </div>
            </section>

            <section class="section" id="projects" aria-label="프로젝트">
              <div class="card">
                <h2>
                  <spring:message code="app.portfolio.projects" text="프로젝트 경험" />
                </h2>
                <p class="small">
                  <spring:message code="app.portfolio.projects.desc" text="(샘플 데이터) 실제 프로젝트 정보로 교체하세요." />
                </p>
                <div class="cards" style="margin-top:12px;">
                  <c:forEach var="p" items="${projects}">
                    <div class="card">
                      <h3>${p.title}</h3>
                      <div class="meta">Stack: ${p.stack}</div>
                      <ul class="list">
                        <c:forEach var="h" items="${p.highlights}">
                          <li>${h}</li>
                        </c:forEach>
                      </ul>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </section>

            <section class="section" id="contact" aria-label="연락처">
              <div class="card">
                <h2>
                  <spring:message code="app.portfolio.contact" text="연락처 / 링크" />
                </h2>
                <div class="grid-2" style="margin-top:12px;">
                  <div class="card">
                    <h3>
                      <spring:message code="common.contact" text="연락처" />
                    </h3>
                    <ul class="list">
                      <li>Email: your.email@example.com</li>
                      <li>Phone: 010-0000-0000</li>
                    </ul>
                  </div>
                  <div class="card">
                    <h3>
                      <spring:message code="common.links" text="링크" />
                    </h3>
                    <ul class="list">
                      <li><a href="#">GitHub</a></li>
                      <li><a href="#">Blog</a></li>
                    </ul>
                  </div>
                </div>
              </div>
            </section>
          </main>

          <%@ include file="/WEB-INF/jsp/include/footer.jspf" %>
            <script src="${pageContext.request.contextPath}/assets/app.js" defer></script>
      </body>

      </html>

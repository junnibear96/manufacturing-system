<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

    <!doctype html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Login</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
    </head>

    <body>
      <main id="content" class="container" role="main">
        <section class="hero" aria-label="Login">
          <div class="hero-grid">
            <div class="card card-strong">
              <div class="kicker">
                <span class="badge">Internal Web</span>
                <span class="small">Login · Role-based</span>
              </div>
              <h1>
                <spring:message code="app.login.title" text="로그인" />
              </h1>
              <p>
                <spring:message code="app.login.subtitle" text="그룹사 공통 웹 / 생산 시스템 기능은 로그인 후 이용 가능합니다." />
              </p>
              <p class="small">
                <spring:message code="app.login.serverTime" arguments="${now}" text="서버 시간: ${now}" />
              </p>

              <% if (request.getAttribute("error") !=null || request.getParameter("error") !=null) { %>
                <p class="small" style="color: rgba(255,255,255,0.86);">
                  <spring:message code="app.login.error" text="아이디 또는 비밀번호가 올바르지 않습니다." />
                </p>
                <% } %>

                  <form method="post" action="${pageContext.request.contextPath}/app/login" class="card"
                    style="margin-top:12px;">
                    <div class="keyval">
                      <div class="key">
                        <spring:message code="app.login.username" text="Username" />
                      </div>
                      <div class="value"><input name="username" autocomplete="username"
                          style="width:100%; padding:10px; border-radius:12px; border:1px solid rgba(255,255,255,0.14); background: rgba(255,255,255,0.04); color: inherit;" />
                      </div>
                    </div>
                    <div class="keyval">
                      <div class="key">
                        <spring:message code="app.login.password" text="Password" />
                      </div>
                      <div class="value"><input type="password" name="password" autocomplete="current-password"
                          style="width:100%; padding:10px; border-radius:12px; border:1px solid rgba(255,255,255,0.14); background: rgba(255,255,255,0.04); color: inherit;" />
                      </div>
                    </div>
                    <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:12px;">
                      <button class="btn" type="submit">
                        <spring:message code="app.login.btn" text="로그인" />
                      </button>
                    </div>
                    <p class="small" style="margin-top:12px;">
                      <spring:message code="app.login.account" text="기본 계정(자동 생성): admin / admin123!" />
                    </p>
                  </form>
                  <script>
                    // Auto-fill for testing
                    window.addEventListener('load', function () {
                      setTimeout(function () {
                        var inputs = document.querySelectorAll('input');
                        if (inputs.length >= 2) {
                          inputs[0].value = 'admin';
                          inputs[1].value = 'admin123!';
                          // Optional: Auto-click for faster testing, but maybe user wants to see it filled?
                          // User asked: "document.querySelector('button').click();"
                          document.querySelector('button').click();
                        }
                      }, 500); // Small delay to ensure render
                    });
                  </script>
            </div>

            <aside class="card" aria-label="Help">
              <h2 style="margin-top:0;">
                <spring:message code="app.login.guide.title" text="안내" />
              </h2>
              <ul class="list">
                <li>
                  <spring:message code="app.login.guide.role" text="ROLE 기반 접근 제어: /admin/* 는 ADMIN만 접근" />
                </li>
                <li>
                  <spring:message code="app.login.guide.pw" text="비밀번호는 BCrypt 해시로 저장" />
                </li>
                <li>
                  <spring:message code="app.login.guide.table" text="테이블 생성: scripts/oracle-init.sql" />
                </li>
              </ul>
            </aside>
          </div>
        </section>
      </main>
    </body>

    </html>

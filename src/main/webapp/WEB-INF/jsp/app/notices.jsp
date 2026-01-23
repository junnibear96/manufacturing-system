<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="app.notice.title" text="공지사항" /> - TP
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <main class="container" role="main">
            <section class="hero" aria-label="Notices">
              <div class="hero-grid">
                <div class="card card-strong">
                  <div class="kicker">
                    <span class="badge">Oracle</span>
                    <span class="small">notice</span>
                  </div>
                  <h1>
                    <spring:message code="app.notice.title" text="공지사항" />
                  </h1>

                  <ul class="list">
                    <c:forEach items="${notices}" var="n">
                      <li>
                        <a href="${pageContext.request.contextPath}/app/notices/${n.noticeId}">
                          <c:out value="${n.title}" />
                        </a>
                        <div class="small">${n.createdAt}</div>
                      </li>
                    </c:forEach>
                  </ul>
                </div>

                <aside class="card" aria-label="Admin">
                  <h2 style="margin-top:0;">
                    <spring:message code="app.company.header.admin" text="Admin" />
                  </h2>
                  <c:if test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                    <p><a class="btn" href="${pageContext.request.contextPath}/admin/notices/new">
                        <spring:message code="app.notice.btn.new" text="+ New Notice" />
                      </a></p>
                  </c:if>
                  <p class="small">
                    <spring:message code="app.notice.msg.admin_only" text="공지 등록은 ROLE_ADMIN만 가능합니다." />
                  </p>
                </aside>
              </div>
            </section>
          </main>
      </body>

      </html>

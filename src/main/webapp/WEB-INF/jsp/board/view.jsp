<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Board Post</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <main class="container" role="main">
            <section class="hero" aria-label="Board Post">
              <div class="card card-strong">
                <div class="kicker">
                  <span class="badge">
                    <spring:message code="app.board.label" text="Board" />
                  </span>
                  <span class="small">
                    <c:out value="${post.createdAt}" />
                  </span>
                </div>
                <h1 style="margin-bottom:10px;">
                  <c:out value="${post.title}" />
                </h1>
                <p style="white-space:pre-wrap; line-height:1.7;">
                  <c:out value="${post.body}" />
                </p>
                <p class="small" style="margin-top:16px;"><a href="${pageContext.request.contextPath}/app/board">
                    <spring:message code="app.board.list" text="← 목록" />
                  </a></p>
              </div>
            </section>
          </main>
      </body>

      </html>

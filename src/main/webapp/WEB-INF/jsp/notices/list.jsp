<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
      <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>
            <spring:message code="notice.page.title" /> - TP MES
          </title>
          <link rel="stylesheet" href="/assets/css/common-dashboard.css">
        </head>

        <body>
          <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

            <div class="container">
              <div class="page-header">
                <h1 class="page-title">📢
                  <spring:message code="notice.list.title" text="공지사항" />
                </h1>
                <sec:authorize access="hasRole('ADMIN')">
                  <a href="/admin/notices/new" class="btn-primary">+
                    <spring:message code="notice.new" text="새 공지 작성" />
                  </a>
                </sec:authorize>
              </div>

              <div class="card">
                <c:choose>
                  <c:when test="${empty notices}">
                    <p class="empty-state">
                      <spring:message code="notice.empty" />
                    </p>
                  </c:when>
                  <c:otherwise>
                    <table class="table-modern">
                      <thead>
                        <tr>
                          <th>
                            <spring:message code="notice.title" text="제목" />
                          </th>
                          <th style="width: 160px; text-align: center;">
                            <spring:message code="notice.date" text="작성일" />
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach items="${notices}" var="notice">
                          <tr>
                            <td>
                              <a href="/notices/${notice.noticeId}">
                                ${notice.title}
                              </a>
                            </td>
                            <td style="text-align: center; color: #718096;">
                              ${notice.createdAt}
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
        </body>

        </html>

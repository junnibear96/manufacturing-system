<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!DOCTYPE html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
          <spring:message code="production.processes.title" text="공정 관리" />
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/factory-modern.css" rel="stylesheet">
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <div class="container">
            <div class="page-header">
              <h1>⚙️
                <spring:message code="production.processes.header" text="제조 공정" />
              </h1>
              <p class="subtitle">전체 생산 라인의 제조 공정 단계를 관리합니다</p>
            </div>

            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>
                      <spring:message code="production.process.code" text="공정 코드" />
                    </th>
                    <th>
                      <spring:message code="production.process.name" text="공정명" />
                    </th>
                    <th>상태</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${processes}" var="p">
                    <tr>
                      <td>${p.processId}</td>
                      <td><code>${p.processCode}</code></td>
                      <td><strong>${p.processName}</strong></td>
                      <td><span class="badge badge-active">Active</span></td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty processes}">
                    <tr>
                      <td colspan="4" class="empty-state">
                        <p>등록된 공정이 없습니다.</p>
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>

          <%@ include file="../include/footer.jspf" %>
      </body>

      </html>
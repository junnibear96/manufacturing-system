<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!DOCTYPE html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
          <spring:message code="production.stats.title" text="생산 통계" />
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/factory-modern.css" rel="stylesheet">
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <div class="container">
            <div class="page-header">
              <h1>📊
                <spring:message code="production.stats.title" text="생산 통계" />
              </h1>
              <p class="subtitle">일별 및 월별 생산 실적 통계를 확인합니다</p>
            </div>

            <div class="filter-row"
              style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; align-items: start;">

              <!-- Daily Stats Card -->
              <div class="table-container">
                <div
                  style="padding: 20px; border-bottom: 1px solid rgba(0,0,0,0.05); background: rgba(255,255,255,0.5);">
                  <h3 style="margin: 0; color: #4a5568;">
                    <spring:message code="production.stats.recent14" text="최근 14일 현황" />
                  </h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>
                        <spring:message code="common.day" text="날짜" />
                      </th>
                      <th>
                        <spring:message code="production.stats.plan" text="계획" />
                      </th>
                      <th>
                        <spring:message code="production.results.good" text="양품" />
                      </th>
                      <th>
                        <spring:message code="production.results.ng" text="불량" />
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${daily}" var="d">
                      <tr>
                        <td>${d.bucket}</td>
                        <td><strong>${d.qtyPlan}</strong></td>
                        <td style="color: #48bb78;">${d.qtyGood}</td>
                        <td style="color: #e53e3e;">${d.qtyNg}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- Monthly Stats Card -->
              <div class="table-container">
                <div
                  style="padding: 20px; border-bottom: 1px solid rgba(0,0,0,0.05); background: rgba(255,255,255,0.5);">
                  <h3 style="margin: 0; color: #4a5568;">
                    <spring:message code="production.stats.monthly" text="월간 통계 (올해)" />
                  </h3>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>
                        <spring:message code="common.month" text="월" />
                      </th>
                      <th>
                        <spring:message code="production.stats.plan" text="계획" />
                      </th>
                      <th>
                        <spring:message code="production.results.good" text="양품" />
                      </th>
                      <th>
                        <spring:message code="production.results.ng" text="불량" />
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${monthly}" var="m">
                      <tr>
                        <td>${m.bucket}</td>
                        <td><strong>${m.qtyPlan}</strong></td>
                        <td style="color: #48bb78;">${m.qtyGood}</td>
                        <td style="color: #e53e3e;">${m.qtyNg}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>

            </div>
          </div>

          <%@ include file="../include/footer.jspf" %>
      </body>

      </html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>
            <spring:message code="production.results.title" text="생산 실적" />
          </title>
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
          <link href="${pageContext.request.contextPath}/assets/factory-modern.css" rel="stylesheet">
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
          <style>
            .summary-grid {
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
              gap: 20px;
              margin-bottom: 30px;
            }

            .stat-card {
              background: white;
              border-radius: 12px;
              padding: 20px;
              box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
              display: flex;
              flex-direction: column;
              border: 1px solid rgba(0, 0, 0, 0.05);
            }

            .stat-label {
              font-size: 13px;
              color: #718096;
              font-weight: 600;
              text-transform: uppercase;
              letter-spacing: 0.5px;
            }

            .stat-value {
              font-size: 28px;
              font-weight: 800;
              color: #2d3748;
              margin-top: 8px;
            }

            .stat-desc {
              font-size: 12px;
              color: #a0aec0;
              margin-top: 4px;
            }

            .text-success {
              color: #48bb78 !important;
            }

            .text-danger {
              color: #e53e3e !important;
            }

            /* Filter Toolbar */
            .filter-toolbar {
              display: flex;
              gap: 12px;
              margin-bottom: 20px;
              flex-wrap: wrap;
              background: white;
              padding: 16px;
              border-radius: 12px;
              border: 1px solid rgba(0, 0, 0, 0.05);
              align-items: center;
            }

            .filter-input {
              padding: 8px 12px;
              border: 1px solid #e2e8f0;
              border-radius: 6px;
              font-size: 14px;
              min-width: 150px;
            }

            .badge-status {
              padding: 4px 8px;
              border-radius: 4px;
              font-size: 11px;
              font-weight: 700;
            }

            .badge-danger {
              background: #fee2e2;
              color: #e53e3e;
            }

            .badge-success {
              background: #f0fff4;
              color: #38a169;
            }
          </style>
        </head>

        <body>
          <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

            <div class="container">
              <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <h1>📦
                    <spring:message code="production.results.header" text="생산 실적" />
                  </h1>
                  <p class="subtitle">실시간 생산 현황 및 실적 이력을 조회합니다</p>
                </div>

                <c:if test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                  <a href="${pageContext.request.contextPath}/admin/production/results/new" class="btn btn-primary">
                    +
                    <spring:message code="production.results.new" text="실적 등록" />
                  </a>
                </c:if>
              </div>

              <!-- Summary Cards (Today) -->
              <div class="summary-grid">
                <div class="stat-card">
                  <span class="stat-label">오늘 총 생산량</span>
                  <span class="stat-value">${summaryTotal} <small
                      style="font-size:14px; color:#a0aec0;">ea</small></span>
                  <span class="stat-desc">Today's Total Production</span>
                </div>
                <div class="stat-card">
                  <span class="stat-label">양품 수량</span>
                  <span class="stat-value text-success">${summaryGood} <small style="font-size:14px;">ea</small></span>
                  <span class="stat-desc">Quality OK</span>
                </div>
                <div class="stat-card">
                  <span class="stat-label">불량 수량</span>
                  <span class="stat-value text-danger">${summaryNg} <small style="font-size:14px;">ea</small></span>
                  <span class="stat-desc">Quality NG</span>
                </div>
                <div class="stat-card">
                  <span class="stat-label">오늘 불량률</span>
                  <span class="stat-value ${summaryDefectRate > 5.0 ? 'text-danger' : 'text-success'}">
                    <fmt:formatNumber value="${summaryDefectRate}" maxFractionDigits="1" />%
                  </span>
                  <span class="stat-desc">Target: < 2.0%</span>
                </div>
              </div>

              <!-- Filter Toolbar -->
              <div class="filter-toolbar">
                <span style="font-weight: 600; color: #4a5568; margin-right: 8px;">🔍 검색:</span>

                <!-- Date Range Filter -->
                <div style="display:flex; align-items:center; gap:4px;">
                  <input type="date" id="filterDateStart" class="filter-input" placeholder="Start Date"
                    onchange="filterTable()" style="width: 140px;">
                  <span style="color:#a0aec0;">~</span>
                  <input type="date" id="filterDateEnd" class="filter-input" placeholder="End Date"
                    onchange="filterTable()" style="width: 140px;">
                </div>

                <input type="text" id="filterItem" class="filter-input" placeholder="품목 코드 (예: M-01)"
                  onkeyup="filterTable()">
                <input type="text" id="filterEquip" class="filter-input" placeholder="설비명" onkeyup="filterTable()">
                <div style="margin-left: auto;">
                  <button class="btn" onclick="resetFilters()" style="padding: 6px 12px; font-size: 13px;">필터
                    초기화</button>
                </div>
              </div>

              <div class="table-container">
                <table id="resultsTable">
                  <thead>
                    <tr>
                      <th>
                        <spring:message code="production.results.date" text="작업일자" />
                      </th>
                      <th>
                        <spring:message code="production.results.item" text="품목" />
                      </th>
                      <th>
                        <spring:message code="production.results.good" text="양품" />
                      </th>
                      <th>
                        <spring:message code="production.results.ng" text="불량" />
                      </th>
                      <th>불량률</th>
                      <th>
                        <spring:message code="production.results.equip" text="설비" />
                      </th>
                      <th>
                        <spring:message code="common.created" text="등록일시" />
                      </th>
                      <c:if test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                        <th style="text-align: center;">
                          <spring:message code="common.action" text="관리" />
                        </th>
                      </c:if>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${results}" var="r">
                      <c:set var="total" value="${r.qtyGood + r.qtyNg}" />
                      <c:set var="rate" value="${total > 0 ? r.qtyNg * 100.0 / total : 0}" />

                      <tr class="data-row">
                        <td class="col-date">${r.workDate}</td>
                        <td class="col-item"><strong>${r.itemCode}</strong></td>
                        <td style="color: #48bb78;">${r.qtyGood}</td>
                        <td style="color: #e53e3e; font-weight: bold;">${r.qtyNg}</td>
                        <td>
                          <c:choose>
                            <c:when test="${rate > 5.0}">
                              <span class="badge-status badge-danger">
                                <fmt:formatNumber value="${rate}" maxFractionDigits="1" />%
                              </span>
                            </c:when>
                            <c:when test="${rate > 0}">
                              <span style="font-size: 13px; color: #4a5568;">
                                <fmt:formatNumber value="${rate}" maxFractionDigits="1" />%
                              </span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge-status badge-success">0%</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td class="col-equip">${r.equipmentName}</td>
                        <td style="color: #718096; font-size: 12px;">${r.createdAt}</td>
                        <c:if test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                          <td style="text-align: center; white-space: nowrap;">
                            <a href="${pageContext.request.contextPath}/admin/production/results/${r.resultId}/edit"
                              class="btn"
                              style="padding: 4px 8px; background: transparent; color: #4299e1; border: 1px solid #e2e8f0; font-size: 11px; margin-right:4px;">
                              ✏️
                            </a>
                            <form method="post"
                              action="${pageContext.request.contextPath}/admin/production/results/delete"
                              style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                              <input type="hidden" name="resultId" value="${r.resultId}" />
                              <button type="submit" class="btn"
                                style="padding: 4px 8px; background: transparent; color: #a0aec0; border: 1px solid #e2e8f0; font-size: 11px;">
                                ❌
                              </button>
                            </form>
                          </td>
                        </c:if>
                      </tr>
                    </c:forEach>
                    <c:if test="${empty results}">
                      <tr id="emptyRow">
                        <td
                          colspan="${(sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')) ? 8 : 7}"
                          class="empty-state">
                          <p>등록된 생산 실적이 없습니다.</p>
                        </td>
                      </tr>
                    </c:if>
                  </tbody>
                </table>
              </div>

            </div>

            <%@ include file="../include/footer.jspf" %>

              <script>
                function filterTable() {
                  const dateStart = document.getElementById('filterDateStart').value;
                  const dateEnd = document.getElementById('filterDateEnd').value;
                  const itemVal = document.getElementById('filterItem').value.toLowerCase();
                  const equipVal = document.getElementById('filterEquip').value.toLowerCase();

                  const rows = document.querySelectorAll('.data-row');

                  rows.forEach(row => {
                    const dateText = row.querySelector('.col-date').textContent; // 'YYYY-MM-DD' expecting
                    const itemText = row.querySelector('.col-item').textContent.toLowerCase();
                    const equipText = row.querySelector('.col-equip').textContent.toLowerCase();

                    // Date Range Check
                    let matchDate = true;
                    if (dateStart && dateText < dateStart) matchDate = false;
                    if (dateEnd && dateText > dateEnd) matchDate = false;

                    const matchItem = !itemVal || itemText.includes(itemVal);
                    const matchEquip = !equipVal || equipText.includes(equipVal);

                    if (matchDate && matchItem && matchEquip) {
                      row.style.display = '';
                    } else {
                      row.style.display = 'none';
                    }
                  });
                }

                function resetFilters() {
                  document.getElementById('filterDateStart').value = '';
                  document.getElementById('filterDateEnd').value = '';
                  document.getElementById('filterItem').value = '';
                  document.getElementById('filterEquip').value = '';
                  filterTable();
                }
              </script>
        </body>

        </html>
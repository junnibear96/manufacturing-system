<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!DOCTYPE html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
          <c:choose>
            <c:when test="${mode == 'edit'}">
              <spring:message code="admin.production.result.edit" text="생산 실적 수정" />
            </c:when>
            <c:otherwise>
              <spring:message code="admin.production.result.form" text="생산 실적 등록" />
            </c:otherwise>
          </c:choose>
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/factory-modern.css" rel="stylesheet">
        <style>
          .form-container {
            max-width: 600px;
            margin: 0 auto;
          }

          .form-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: fadeIn 0.5s ease-out forwards;
          }

          .form-group {
            margin-bottom: 24px;
          }

          .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #4a5568;
            font-size: 14px;
          }

          .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            font-family: inherit;
          }

          .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
          }

          .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
          }

          .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
          }

          .btn-secondary:hover {
            background: #cbd5e0;
            transform: translateY(-2px);
          }

          .hint-text {
            font-size: 13px;
            color: #718096;
            margin-top: 6px;
          }
        </style>
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <div class="container">
            <div class="form-container">

              <div class="page-header" style="text-align: center; margin-bottom: 30px;">
                <h1>
                  <c:choose>
                    <c:when test="${mode == 'edit'}">
                      ✏️
                      <spring:message code="admin.production.result.edit" text="생산 실적 수정" />
                    </c:when>
                    <c:otherwise>
                      📝
                      <spring:message code="admin.production.result.form" text="생산 실적 등록" />
                    </c:otherwise>
                  </c:choose>
                </h1>
                <p class="subtitle">새로운 생산 데이터를 시스템에 기록하거나 수정합니다</p>
              </div>

              <div class="form-card">
                <c:set var="actionUrl" value="${pageContext.request.contextPath}/admin/production/results/new" />
                <c:if test="${mode == 'edit'}">
                  <c:set var="actionUrl"
                    value="${pageContext.request.contextPath}/admin/production/results/${resultId}/edit" />
                </c:if>

                <form method="post" action="${actionUrl}">

                  <div class="form-group">
                    <label class="form-label">
                      <spring:message code="production.results.date" text="작업 일자" />
                    </label>
                    <input type="date" name="workDate" value="<c:out value='${workDate}' />" class="form-control"
                      required />
                  </div>

                  <div class="form-group">
                    <label class="form-label">
                      <spring:message code="production.results.item" text="품목 코드" />
                    </label>
                    <select name="itemCode" class="form-control" required>
                      <option value="">
                        <spring:message code="common.select" text="선택하세요" />
                      </option>
                      <c:forEach items="${items}" var="i">
                        <option value="${i.itemCode}" <c:if test="${i.itemCode == itemCode}">selected</c:if>>
                          <c:out value="${i.itemCode}" /> (
                          <c:out value="${i.itemName}" />)
                        </option>
                      </c:forEach>
                    </select>
                  </div>

                  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                      <label class="form-label">
                        <spring:message code="production.results.good" text="양품 수량" />
                        <span style="color: #48bb78;">(Good)</span>
                      </label>
                      <input type="number" name="qtyGood" value="<c:out value='${qtyGood}' />" class="form-control"
                        min="0" required />
                    </div>

                    <div class="form-group">
                      <label class="form-label">
                        <spring:message code="production.results.ng" text="불량 수량" />
                        <span style="color: #e53e3e;">(NG)</span>
                      </label>
                      <input type="number" name="qtyNg" value="<c:out value='${qtyNg}' />" class="form-control" min="0"
                        required />
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="form-label">
                      <spring:message code="production.results.equip" text="설비 (선택사항)" />
                    </label>
                    <select name="equipmentId" class="form-control">
                      <option value="">
                        <spring:message code="common.none" text="(선택 안함)" />
                      </option>
                      <c:forEach items="${equipmentList}" var="e">
                        <option value="${e.equipmentId}" <c:if test="${e.equipmentId == equipmentId}">selected
                          </c:if>>
                          <c:out value="${e.equipmentCode}" /> ·
                          <c:out value="${e.equipmentName}" />
                        </option>
                      </c:forEach>
                    </select>
                    <p class="hint-text">특정 설비에서 수행된 작업인 경우 선택하세요.</p>
                  </div>

                  <div class="form-actions">
                    <button class="btn btn-primary" type="submit" style="flex: 2;">
                      <c:choose>
                        <c:when test="${mode == 'edit'}">
                          💾 수정 완료
                        </c:when>
                        <c:otherwise>
                          ✅ 등록하기
                        </c:otherwise>
                      </c:choose>
                    </button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/production/results"
                      style="flex: 1; justify-content: center;">
                      취소
                    </a>
                  </div>

                </form>
              </div>

            </div>
          </div>

          <%@ include file="../include/footer.jspf" %>
      </body>

      </html>
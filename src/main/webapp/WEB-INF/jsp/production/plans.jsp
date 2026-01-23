<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
      <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>
            <spring:message code="production.plans.title" text="생산 계획 - TP MES" />
          </title>
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
          <link href="/assets/factory-modern.css" rel="stylesheet">
          <style>
            .stat-card {
              background: rgba(255, 255, 255, 0.95);
              backdrop-filter: blur(20px);
              border-radius: 16px;
              padding: 24px;
              box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
              border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .stat-card .label {
              color: #718096;
              font-size: 14px;
              font-weight: 600;
              margin-bottom: 8px;
              text-transform: uppercase;
              letter-spacing: 0.5px;
            }

            .stat-card .value {
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              -webkit-background-clip: text;
              -webkit-text-fill-color: transparent;
              font-size: 36px;
              font-weight: 800;
              line-height: 1;
            }
          </style>
        </head>

        <body>
          <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

            <div class="container">
              <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <h1>📋
                    <spring:message code="production.plans.header" text="생산 계획" />
                  </h1>
                  <p class="subtitle" style="margin-top: 8px;">
                    <spring:message code="production.plans.subtitle" text="일별 생산 계획 관리 및 조회" />
                  </p>
                </div>
                <div class="action-buttons" style="margin-bottom: 0;">
                  <sec:authorize access="hasAnyRole('MANAGER', 'ADMIN')">
                    <a href="${pageContext.request.contextPath}/production/plans/new" class="btn btn-primary">
                      +
                      <spring:message code="production.plans.new" text="새 계획 등록" />
                    </a>
                  </sec:authorize>
                </div>
              </div>

              <!-- Stats Summary (Optional enhancement) -->
              <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 32px;">
                <div class="stat-card">
                  <div class="label">
                    <spring:message code="production.plans.total" text="총 계획 건수" />
                  </div>
                  <div class="value">${plans.size()}</div>
                </div>
                <!-- Add more stats if available in the future -->
              </div>

              <div class="filter-card">
                <div class="table-container">
                  <c:choose>
                    <c:when test="${empty plans}">
                      <div class="empty-state" style="padding: 60px 20px;">
                        <p style="margin-bottom: 0;">
                          <spring:message code="production.plans.empty" text="등록된 생산 계획이 없습니다." />
                        </p>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <table>
                        <thead>
                          <tr>
                            <th>
                              <spring:message code="production.plans.id" text="계획 ID" />
                            </th>
                            <th>
                              <spring:message code="production.plans.date" text="계획 일자" />
                            </th>
                            <th>
                              <spring:message code="production.plans.item" text="품목 코드" />
                            </th>
                            <th style="text-align: right;">
                              <spring:message code="production.plans.qty" text="계획 수량" />
                            </th>
                            <th>
                              <spring:message code="common.created" text="생성일시" />
                            </th>
                            <sec:authorize access="hasRole('ADMIN')">
                              <th style="text-align: center;">
                                <spring:message code="common.action" text="관리" />
                              </th>
                            </sec:authorize>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach items="${plans}" var="plan">
                            <tr>
                              <td><span style="font-weight: 600; color: #4a5568;">#${plan.planId}</span></td>
                              <td>
                                <div style="display: flex; align-items: center;">
                                  <span style="margin-right: 8px;">📅</span>
                                  ${plan.planDate}
                                </div>
                              </td>
                              <td>
                                <span class="badge" style="background: #ebf4ff; color: #4299e1;">
                                  ${plan.itemCode}
                                </span>
                              </td>
                              <td style="text-align: right; font-weight: 700;">
                                ${plan.qtyPlan}
                              </td>
                              <td style="color: #718096; font-size: 14px;">
                                ${plan.createdAt}
                              </td>
                              <sec:authorize access="hasRole('ADMIN')">
                                <td style="text-align: center;">
                                  <form method="post"
                                    action="${pageContext.request.contextPath}/production/plans/delete"
                                    style="display: inline;" onsubmit="return confirm('<spring:message code="
                                    production.plans.delete.confirm" text="이 계획을 삭제하시겠습니까?" />');">
                                  <input type="hidden" name="planId" value="${plan.planId}" />
                                  <button type="submit" class="btn btn-sm"
                                    style="background: #fff5f5; color: #e53e3e; border: 1px solid #fed7d7;">
                                    <spring:message code="common.delete" text="삭제" />
                                  </button>
                                  </form>
                                </td>
                              </sec:authorize>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>

            <%@ include file="../include/footer.jspf" %>
        </body>

        </html>

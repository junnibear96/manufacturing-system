<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>생산 계획 수정 - TP MES</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
            </head>

            <body>
                <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header"
                            style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h1>📋
                                    <spring:message code="production.plans.edit" text="계획 수정" />
                                </h1>
                                <p class="subtitle" style="margin-top: 8px;">생산 계획을 수정합니다</p>
                            </div>
                            <div class="action-buttons" style="margin-bottom: 0;">
                                <a href="${pageContext.request.contextPath}/production/plans" class="btn btn-secondary"
                                    style="background: #f1f5f9; color: #475569;">
                                    ←
                                    <spring:message code="common.cancel" text="취소" />
                                </a>
                            </div>
                        </div>

                        <div class="filter-card" style="max-width: 600px; margin: 0 auto;">
                            <form method="post"
                                action="${pageContext.request.contextPath}/production/plans/${plan.planId}/edit">
                                <div style="display: grid; gap: 24px;">

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="production.plans.date" text="계획 일자" />
                                            <span style="color: #e53e3e;">*</span>
                                        </label>
                                        <input type="date" name="planDate" value="${plan.planDate}" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="production.plans.item" text="품목 코드" />
                                            <span style="color: #e53e3e;">*</span>
                                        </label>
                                        <select name="itemCode" required>
                                            <option value="">품목을 선택하세요</option>
                                            <c:forEach items="${items}" var="item">
                                                <option value="${item.itemCode}" ${item.itemCode eq plan.itemCode
                                                    ? 'selected' : '' }>
                                                    ${item.itemName} (${item.itemCode}) - 재고: ${item.currentQuantity}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="production.plans.qty" text="계획 수량" />
                                            <span style="color: #e53e3e;">*</span>
                                        </label>
                                        <input type="number" name="qtyPlan" value="${plan.qtyPlan}" min="1" required>
                                    </div>

                                </div>

                                <div
                                    style="margin-top: 32px; padding-top: 24px; border-top: 1px solid #edf2f7; text-align: right;">
                                    <button type="submit" class="btn btn-primary"
                                        style="padding: 16px 48px; font-size: 16px;">
                                        <spring:message code="common.save" text="저장" />
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>
            </body>

            </html>
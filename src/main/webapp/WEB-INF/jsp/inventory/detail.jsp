<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${item.itemName} -
                        <spring:message code="inventory.detail.title" text="재고 상세" /> - TP MES
                    </title>
                    <style>
                        body {
                            font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            margin: 0;
                            padding: 20px;
                            min-height: 100vh;
                        }

                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                        }

                        .header {
                            background: white;
                            padding: 24px 32px;
                            border-radius: 16px;
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                            margin-bottom: 24px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .header h1 {
                            margin: 0;
                            color: #2d3748;
                            font-size: 28px;
                            font-weight: 700;
                        }

                        .btn {
                            padding: 10px 20px;
                            border-radius: 8px;
                            text-decoration: none;
                            font-weight: 600;
                            transition: all 0.3s;
                            border: none;
                            cursor: pointer;
                            font-size: 14px;
                        }

                        .btn-primary {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }

                        .btn-secondary {
                            background: #e2e8f0;
                            color: #2d3748;
                        }

                        .card {
                            background: white;
                            border-radius: 16px;
                            padding: 28px;
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                            margin-bottom: 24px;
                        }

                        .card h2 {
                            margin: 0 0 20px 0;
                            color: #2d3748;
                            font-size: 20px;
                            font-weight: 700;
                        }

                        .detail-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                            gap: 20px;
                        }

                        .detail-item {
                            padding: 16px;
                            background: #f7fafc;
                            border-radius: 12px;
                        }

                        .detail-label {
                            color: #718096;
                            font-size: 13px;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            margin-bottom: 8px;
                        }

                        .detail-value {
                            color: #2d3748;
                            font-size: 20px;
                            font-weight: 700;
                        }

                        .badge {
                            display: inline-block;
                            padding: 6px 14px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 700;
                        }

                        .badge-low {
                            background: #fed7d7;
                            color: #c53030;
                        }

                        .badge-ok {
                            background: #c6f6d5;
                            color: #2f855a;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        thead {
                            background: #f7fafc;
                        }

                        th {
                            padding: 12px 16px;
                            text-align: left;
                            font-weight: 600;
                            color: #2d3748;
                            font-size: 13px;
                        }

                        td {
                            padding: 12px 16px;
                            border-top: 1px solid #e2e8f0;
                        }

                        tbody tr:hover {
                            background: #f7fafc;
                        }

                        .transaction-type {
                            display: inline-block;
                            padding: 4px 10px;
                            border-radius: 12px;
                            font-size: 11px;
                            font-weight: 700;
                        }

                        .type-in {
                            background: #c6f6d5;
                            color: #2f855a;
                        }

                        .type-out {
                            background: #fed7d7;
                            color: #c53030;
                        }

                        .type-adjust {
                            background: #feebc8;
                            color: #c05621;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 40px;
                            color: #a0aec0;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <div class="header">
                            <h1>📦 ${item.itemName}</h1>
                            <div style="display: flex; gap: 12px;">
                                <a href="/inventory/list" class="btn btn-secondary">
                                    <spring:message code="common.list" text="목록으로" />
                                </a>
                                <a href="/inventory" class="btn btn-secondary">
                                    <spring:message code="inventory.management" text="재고관리" />
                                </a>
                            </div>
                        </div>

                        <!-- Item Details -->
                        <div class="card">
                            <h2>
                                <spring:message code="inventory.detail.info" text="품목 정보" />
                            </h2>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.code" text="품목코드" />
                                    </div>
                                    <div class="detail-value"
                                        style="font-family: 'Courier New', monospace; color: #667eea;">
                                        ${item.itemCode}
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.type" text="품목타입" />
                                    </div>
                                    <div class="detail-value" style="font-size: 16px;">
                                        <c:choose>
                                            <c:when test="${item.itemType == 'RAW_MATERIAL'}">
                                                <spring:message code="inventory.type.raw" text="원자재" />
                                            </c:when>
                                            <c:when test="${item.itemType == 'COMPONENT'}">
                                                <spring:message code="inventory.type.component" text="부품" />
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="inventory.type.finished" text="완제품" />
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.category" text="카테고리" />
                                    </div>
                                    <div class="detail-value" style="font-size: 16px;">${item.category}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.currentQty" text="현재 재고" />
                                    </div>
                                    <div class="detail-value">
                                        ${item.currentQuantity} ${item.unit}
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.minQty" text="최소 재고" />
                                    </div>
                                    <div class="detail-value" style="font-size: 16px;">
                                        ${item.minQuantity} ${item.unit}
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.status" text="재고 상태" />
                                    </div>
                                    <div class="detail-value" style="font-size: 14px;">
                                        <c:choose>
                                            <c:when test="${item.currentQuantity < item.minQuantity}">
                                                <span class="badge badge-low">
                                                    <spring:message code="inventory.status.low" text="재고 부족" />
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-ok">
                                                    <spring:message code="inventory.status.ok" text="정상" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.price" text="단가" />
                                    </div>
                                    <div class="detail-value">
                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0" />원
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.totalValue" text="총 재고 가치" />
                                    </div>
                                    <div class="detail-value" style="color: #48bb78;">
                                        <fmt:formatNumber value="${item.currentQuantity * item.unitPrice}"
                                            pattern="#,##0" />원
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">
                                        <spring:message code="inventory.location" text="보관 위치" />
                                    </div>
                                    <div class="detail-value" style="font-size: 16px;">
                                        ${item.warehouseLocation}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Transaction History -->
                        <div class="card">
                            <h2>📋
                                <spring:message code="inventory.history.title" text="거래 내역" />
                            </h2>
                            <c:choose>
                                <c:when test="${not empty transactions}">
                                    <div style="overflow-x: auto;">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>
                                                        <spring:message code="inventory.history.date" text="일시" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.type" text="유형" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.qty" text="수량" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.reason" text="사유" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.ref" text="참조번호" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.user" text="처리자" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="inventory.history.notes" text="비고" />
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${transactions}" var="trans">
                                                    <tr>
                                                        <td>
                                                            ${trans.transactionDate}
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${trans.transactionType == 'IN'}">
                                                                    <span class="transaction-type type-in">
                                                                        <spring:message code="inventory.action.in"
                                                                            text="입고" />
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${trans.transactionType == 'OUT'}">
                                                                    <span class="transaction-type type-out">
                                                                        <spring:message code="inventory.action.out"
                                                                            text="출고" />
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="transaction-type type-adjust">
                                                                        <spring:message code="inventory.action.adjust"
                                                                            text="조정" />
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <strong>
                                                                <c:choose>
                                                                    <c:when test="${trans.transactionType == 'OUT'}">
                                                                        -${trans.quantity}
                                                                    </c:when>
                                                                    <c:when test="${trans.transactionType == 'IN'}">
                                                                        +${trans.quantity}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${trans.quantity}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </strong> ${item.unit}
                                                        </td>
                                                        <td>${trans.transactionReason}</td>
                                                        <td>${trans.referenceNo}</td>
                                                        <td>${trans.performedBy}</td>
                                                        <td>${trans.notes}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <p>
                                            <spring:message code="inventory.history.empty" text="거래 내역이 없습니다" />
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </body>

                </html>

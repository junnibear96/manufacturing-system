<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.line.list.title" text="생산라인 관리 - TP MES" />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
                <style>
                    .container {
                        max-width: 1600px;
                    }

                    .filter-row {
                        grid-template-columns: 1fr 1fr auto;

                        /* Responsive Design */
                        @media (max-width: 768px) {
                            body {
                                padding: 12px;
                            }

                            .page-header {
                                padding: 20px;
                            }

                            .page-header h1 {
                                font-size: 22px;
                            }

                            table {
                                font-size: 13px;
                                display: block;
                                overflow-x: auto;
                            }

                            .filter-form {
                                flex-direction: column;
                            }

                            .btn {
                                width: 100%;
                            }
                        }

                        @media (max-width: 480px) {
                            .page-header h1 {
                                font-size: 20px;
                            }

                            table {
                                font-size: 12px;
                            }
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header">
                            <h1>⚙️
                                <spring:message code="factory.line.management" text="생산라인 관리" />
                            </h1>
                            <p class="subtitle">실시간 생산 현황을 모니터링하고 관리합니다</p>
                        </div>

                        <c:if test="${not empty message}">
                            <div
                                style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white; padding: 16px 20px; border-radius: 12px; margin-bottom: 24px;">
                                ${message}
                            </div>
                        </c:if>

                        <div class="filter-card">
                            <form method="get" action="/factory/lines" id="filterForm">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label>🏭
                                            <spring:message code="factory.plant" text="공장" />
                                        </label>
                                        <select name="factory" id="factorySelect">
                                            <option value="">전체 공장</option>
                                            <c:forEach items="${factories}" var="fac">
                                                <option value="${fac.factoryId}" ${selectedFactory==fac.factoryId
                                                    ? 'selected' : '' }>
                                                    ${fac.factoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>📊
                                            <spring:message code="factory.status" text="운영 상태" />
                                        </label>
                                        <select name="status" id="statusSelect">
                                            <option value="">전체 상태</option>
                                            <option value="RUNNING" ${selectedStatus=='RUNNING' ? 'selected' : '' }>가동 중
                                            </option>
                                            <option value="STOPPED" ${selectedStatus=='STOPPED' ? 'selected' : '' }>정지
                                            </option>
                                            <option value="IDLE" ${selectedStatus=='IDLE' ? 'selected' : '' }>대기
                                            </option>
                                            <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE' ? 'selected'
                                                : '' }>
                                                점검</option>
                                            <option value="ERROR" ${selectedStatus=='ERROR' ? 'selected' : '' }>오류
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <button type="submit" class="btn btn-primary">
                                            <spring:message code="common.filter.apply" text="필터 적용" />
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div style="display: flex; justify-content: flex-end; margin-bottom: 16px;">
                            <a href="/factory/lines/new" class="btn btn-primary">
                                ➕
                                <spring:message code="factory.line.new" text="신규 라인 등록" />
                            </a>
                        </div>

                        <div class="table-container">
                            <c:choose>
                                <c:when test="${empty lines}">
                                    <div style="text-align: center; padding: 60px; color: #718096;">
                                        <p>등록된 생산라인이 없습니다</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <spring:message code="factory.line.id" text="라인 ID" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.line.name" text="라인명" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.line.type" text="유형" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.status" text="상태" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.workers" text="인원 (현재/표준)" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.capacity" text="최대 생산능력" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.utilization" text="가동률" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.shift" text="작업교대" />
                                                </th>
                                                <th>
                                                    <spring:message code="common.action" text="작업" />
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${lines}" var="line">
                                                <tr>
                                                    <td><code
                                                            style="background: #edf2f7; padding: 4px 8px; border-radius: 6px;">${line.lineId}</code>
                                                    </td>
                                                    <td>
                                                        <strong>${line.lineName}</strong>
                                                        <br><small style="color: #718096;">${line.lineCode}</small>
                                                    </td>
                                                    <td>${line.lineType}</td>
                                                    <td>
                                                        <span class="badge badge-${line.status.toLowerCase()}">
                                                            ${line.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <strong
                                                            style="color: ${line.currentWorkers == line.standardWorkers ? '#48bb78' : '#ed8936'};">
                                                            ${line.currentWorkers}
                                                        </strong> / ${line.standardWorkers}명
                                                    </td>
                                                    <td>${line.maxCapacity} 개/일</td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 8px;">
                                                            <div class="progress-bar">
                                                                <div class="progress-fill"
                                                                    style="width: ${line.utilizationRate}%;"></div>
                                                            </div>
                                                            <strong>${line.utilizationRate}%</strong>
                                                        </div>
                                                    </td>
                                                    <td>${line.shiftPattern}</td>
                                                    <td>
                                                        <form method="post"
                                                            action="/factory/lines/${line.lineId}/status"
                                                            style="display: inline;">
                                                            <select name="status" onchange="this.form.submit()"
                                                                style="padding: 4px 8px; border-radius: 6px;">
                                                                <option value="">상태 변경</option>
                                                                <option value="RUNNING">가동</option>
                                                                <option value="STOPPED">정지</option>
                                                                <option value="MAINTENANCE">점검</option>
                                                            </select>
                                                            <input type="hidden" name="isOperating" value="true">
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="summary-box">
                            총 <strong>${lines.size()}</strong>개의 생산라인이 조회되었습니다
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>

                        <script>
                            document.getElementById('factorySelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('statusSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });
                        </script>
            </body>

            </html>

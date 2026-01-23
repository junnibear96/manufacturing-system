<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.list.title" text="공장 관리 - TP MES" />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
                <style>
                    .filter-row {
                        grid-template-columns: 1fr 1fr 1fr auto;
                    }

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
                </style>
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header">
                            <h1>🏭
                                <spring:message code="factory.list.header" text="공장 관리" />
                            </h1>
                            <p class="subtitle">
                                <spring:message code="factory.list.subtitle" text="사업장 내 생산 기능별 구역을 관리합니다" />
                            </p>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="message">
                                ✓ ${message}
                            </div>
                        </c:if>

                        <div class="filter-card">
                            <form method="get" action="/factory/factories" id="filterForm">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label>📍
                                            <spring:message code="factory.plant" text="사업장" />
                                        </label>
                                        <select name="plant" id="plantSelect">
                                            <option value="">전체 사업장</option>
                                            <c:forEach items="${plants}" var="p">
                                                <option value="${p.plantId}" ${selectedPlant==p.plantId ? 'selected'
                                                    : '' }>
                                                    ${p.plantName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>🏭
                                            <spring:message code="factory.type" text="공장 유형" />
                                        </label>
                                        <select name="type" id="typeSelect">
                                            <option value="">전체 유형</option>
                                            <option value="ASSEMBLY" ${selectedType=='ASSEMBLY' ? 'selected' : '' }>조립
                                            </option>
                                            <option value="PROCESSING" ${selectedType=='PROCESSING' ? 'selected' : '' }>
                                                가공
                                            </option>
                                            <option value="PACKAGING" ${selectedType=='PACKAGING' ? 'selected' : '' }>포장
                                            </option>
                                            <option value="TESTING" ${selectedType=='TESTING' ? 'selected' : '' }>검사
                                            </option>
                                            <option value="LOGISTICS" ${selectedType=='LOGISTICS' ? 'selected' : '' }>물류
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>📊
                                            <spring:message code="factory.status" text="운영 상태" />
                                        </label>
                                        <select name="status" id="statusSelect">
                                            <option value="">전체 상태</option>
                                            <option value="ACTIVE" ${selectedStatus=='ACTIVE' ? 'selected' : '' }>정상 가동
                                            </option>
                                            <option value="IDLE" ${selectedStatus=='IDLE' ? 'selected' : '' }>휴지
                                            </option>
                                            <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE' ? 'selected'
                                                : '' }>
                                                점검</option>
                                            <option value="SHUTDOWN" ${selectedStatus=='SHUTDOWN' ? 'selected' : '' }>폐쇄
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

                        <div class="action-buttons">
                            <a href="/factory/factories/new" class="btn btn-primary">
                                ➕
                                <spring:message code="factory.new" text="신규 공장 등록" />
                            </a>
                        </div>

                        <div class="table-container">
                            <c:choose>
                                <c:when test="${empty factories}">
                                    <div class="empty-state">
                                        <p style="font-size: 18px; margin-bottom: 16px;">📭</p>
                                        <p>등록된 공장이 없습니다</p>
                                        <a href="/factory/factories/new" class="btn btn-primary"
                                            style="margin-top: 20px;">
                                            첫 공장 등록하기
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <spring:message code="factory.id" text="공장 ID" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.name" text="공장명" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.plant" text="사업장" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.type" text="유형" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.productCategory" text="품목군" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.area" text="면적" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.utilization" text="목표 가동률" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.status" text="상태" />
                                                </th>
                                                <th>
                                                    <spring:message code="common.action" text="작업" />
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${factories}" var="factory">
                                                <tr>
                                                    <td>
                                                        <code
                                                            style="background: #edf2f7; padding: 4px 8px; border-radius: 6px;">
                                            ${factory.factoryId}
                                        </code>
                                                    </td>
                                                    <td>
                                                        <a href="/factory/factories/${factory.factoryId}"
                                                            style="color: #667eea; font-weight: 600; text-decoration: none;">
                                                            ${factory.factoryName}
                                                        </a>
                                                        <c:if test="${not empty factory.factoryNameEn}">
                                                            <br><small
                                                                style="color: #718096;">${factory.factoryNameEn}</small>
                                                        </c:if>
                                                    </td>
                                                    <td>${factory.plantId}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${factory.factoryType == 'ASSEMBLY'}">조립
                                                            </c:when>
                                                            <c:when test="${factory.factoryType == 'PROCESSING'}">가공
                                                            </c:when>
                                                            <c:when test="${factory.factoryType == 'PACKAGING'}">포장
                                                            </c:when>
                                                            <c:when test="${factory.factoryType == 'TESTING'}">검사
                                                            </c:when>
                                                            <c:when test="${factory.factoryType == 'LOGISTICS'}">물류
                                                            </c:when>
                                                            <c:otherwise>${factory.factoryType}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${factory.productCategory}</td>
                                                    <td>${factory.area} m²</td>
                                                    <td>
                                                        <strong
                                                            style="color: #667eea;">${factory.targetUtilizationRate}%</strong>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-${factory.status.toLowerCase()}">
                                                            ${factory.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="/factory/factories/${factory.factoryId}"
                                                            style="color: #667eea;">
                                                            상세보기
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="summary-box">
                            총 <strong>${factories.size()}</strong>개의 공장이 조회되었습니다
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>

                        <script>
                            // 필터 자동 제출
                            document.getElementById('plantSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('typeSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('statusSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });
                        </script>
            </body>

            </html>

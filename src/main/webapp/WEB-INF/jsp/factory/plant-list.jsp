<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.plant.list.title" text="사업장 목록 " />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
                <style>
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
                        <!-- Page Header -->
                        <div class="page-header">
                            <h1>📍
                                <spring:message code="factory.plant.management" text="사업장 관리" />
                            </h1>
                            <p class="subtitle">
                                <spring:message code="factory.plant.subtitle" text="법인 및 지역별 생산 거점을 관리합니다" />
                            </p>
                        </div>

                        <!-- Success Message -->
                        <c:if test="${not empty message}">
                            <div class="message">
                                ${message}
                            </div>
                        </c:if>

                        <!-- Filter Card -->
                        <div class="filter-card">
                            <form method="get" action="/factory/plants" id="filterForm">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label>🏢
                                            <spring:message code="factory.plant.type" text="사업장 유형" />
                                        </label>
                                        <select name="type" id="typeSelect">
                                            <option value="">
                                                <spring:message code="factory.plant.type.all" text="전체 유형" />
                                            </option>
                                            <option value="MAIN_FACTORY" ${selectedType=='MAIN_FACTORY' ? 'selected'
                                                : '' }>
                                                <spring:message code="factory.plant.type.main" text="본사 공장" />
                                            </option>
                                            <option value="BRANCH_FACTORY" ${selectedType=='BRANCH_FACTORY' ? 'selected'
                                                : '' }>
                                                <spring:message code="factory.plant.type.branch" text="지사 공장" />
                                            </option>
                                            <option value="WAREHOUSE" ${selectedType=='WAREHOUSE' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.type.warehouse" text="물류 창고" />
                                            </option>
                                            <option value="R&D_CENTER" ${selectedType=='R&D_CENTER' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.type.rnd" text="연구개발센터" />
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>📊
                                            <spring:message code="factory.plant.status" text="운영 상태" />
                                        </label>
                                        <select name="status" id="statusSelect">
                                            <option value="">
                                                <spring:message code="factory.plant.status.all" text="전체 상태" />
                                            </option>
                                            <option value="ACTIVE" ${selectedStatus=='ACTIVE' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.active" text="정상 가동" />
                                            </option>
                                            <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE' ? 'selected'
                                                : '' }>
                                                <spring:message code="factory.plant.status.maintenance" text="점검 중" />
                                            </option>
                                            <option value="SUSPENDED" ${selectedStatus=='SUSPENDED' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.suspended" text="일시중지" />
                                            </option>
                                            <option value="CLOSED" ${selectedStatus=='CLOSED' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.closed" text="폐쇄" />
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

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="/factory/plants/new" class="btn btn-primary">➕
                                <spring:message code="factory.plant.new" text="신규 사업장 등록" />
                            </a>
                        </div>

                        <!-- Table Container -->
                        <div class="table-container">
                            <c:choose>
                                <c:when test="${empty plants}">
                                    <div class="empty-state">
                                        <p>
                                            <spring:message code="factory.plant.empty" text="등록된 사업장이 없습니다" />
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <spring:message code="factory.plant.id" text="사업장 ID" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.plant.name" text="사업장명" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.plant.type" text="유형" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.plant.location" text="위치" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.plant.area" text="면적" />
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
                                            <c:forEach items="${plants}" var="plant">
                                                <tr>
                                                    <td>
                                                        <code>${plant.plantId}</code>
                                                    </td>
                                                    <td>
                                                        <a href="/factory/plants/${plant.plantId}"
                                                            style="color: #667eea; font-weight: 600; text-decoration: none;">
                                                            ${plant.plantName}
                                                        </a>
                                                    </td>
                                                    <td>${plant.plantType}</td>
                                                    <td>${plant.address}</td>
                                                    <td>${plant.totalArea} m²</td>
                                                    <td>
                                                        <span
                                                            class="badge badge-${plant.status == 'ACTIVE' ? 'active' : 'maintenance'}">
                                                            ${plant.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="/factory/plants/${plant.plantId}"
                                                            style="color: #667eea;">
                                                            <spring:message code="common.view_detail" text="상세보기" />
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Summary -->
                        <div class="summary-box">
                            <spring:message code="common.total" text="총" /> <strong>${plants.size()}</strong>
                            <spring:message code="factory.plant.summary" text="개의 사업장이 조회되었습니다" />
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>

                        <script>
                            document.getElementById('typeSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('statusSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });
                        </script>
            </body>

            </html>

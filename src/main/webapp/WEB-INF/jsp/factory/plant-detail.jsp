<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.plant.detail.title" text="사업장 상세 - TP MES" />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header"
                            style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h1>🏢
                                    <c:out value="${plant.plantName}" />
                                </h1>
                                <p class="subtitle" style="margin-top: 8px;">
                                    <spring:message code="factory.plant.detail.subtitle" text="사업장 상세 정보 및 수정" />
                                </p>
                            </div>
                            <div class="action-buttons" style="margin-bottom: 0;">
                                <a href="/factory/plants" class="btn btn-secondary"
                                    style="background: #f1f5f9; color: #475569;">
                                    ←
                                    <spring:message code="common.list" text="목록으로" />
                                </a>
                            </div>
                        </div>

                        <!-- Edit Form -->
                        <div class="filter-card" style="max-width: 900px; margin: 0 auto;">
                            <form action="/factory/plants/${plant.plantId}" method="post">
                                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px;">

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.id" text="사업장 ID" />
                                        </label>
                                        <input type="text" value="${plant.plantId}" readonly
                                            style="background: #f1f5f9; color: #64748b; cursor: not-allowed;">
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.name" text="사업장명" />
                                        </label>
                                        <input type="text" name="plantName" value="${plant.plantName}" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.nameEn" text="영문 사업장명" />
                                        </label>
                                        <input type="text" name="plantNameEn" value="${plant.plantNameEn}">
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.phone" text="전화번호" />
                                        </label>
                                        <input type="text" name="phone" value="${plant.phone}">
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.type" text="유형" />
                                        </label>
                                        <select name="plantType">
                                            <option value="MAIN_FACTORY" ${plant.plantType=='MAIN_FACTORY' ? 'selected'
                                                : '' }>
                                                <spring:message code="factory.plant.type.main" text="본사 공장" />
                                            </option>
                                            <option value="BRANCH_FACTORY" ${plant.plantType=='BRANCH_FACTORY'
                                                ? 'selected' : '' }>
                                                <spring:message code="factory.plant.type.branch" text="지사 공장" />
                                            </option>
                                            <option value="WAREHOUSE" ${plant.plantType=='WAREHOUSE' ? 'selected' : ''
                                                }>
                                                <spring:message code="factory.plant.type.warehouse" text="물류 창고" />
                                            </option>
                                            <option value="R&D_CENTER" ${plant.plantType=='R&D_CENTER' ? 'selected' : ''
                                                }>
                                                <spring:message code="factory.plant.type.rnd" text="연구개발센터" />
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.status" text="상태" />
                                        </label>
                                        <select name="status">
                                            <option value="ACTIVE" ${plant.status=='ACTIVE' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.active" text="정상 가동" />
                                            </option>
                                            <option value="MAINTENANCE" ${plant.status=='MAINTENANCE' ? 'selected' : ''
                                                }>
                                                <spring:message code="factory.plant.status.maintenance" text="점검 중" />
                                            </option>
                                            <option value="SUSPENDED" ${plant.status=='SUSPENDED' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.suspended" text="일시중지" />
                                            </option>
                                            <option value="CLOSED" ${plant.status=='CLOSED' ? 'selected' : '' }>
                                                <spring:message code="factory.plant.status.closed" text="폐쇄" />
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group" style="grid-column: 1 / -1;">
                                        <label>
                                            <spring:message code="factory.plant.label.address" text="주소" />
                                        </label>
                                        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 12px;">
                                            <input type="text" name="address" value="${plant.address}"
                                                placeholder="<spring:message code='factory.plant.label.address.default' text='기본 주소' />">
                                            <input type="text" name="addressDetail" value="${plant.addressDetail}"
                                                placeholder="<spring:message code='factory.plant.label.address.detail' text='상세 주소' />">
                                        </div>
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.postal" text="우편번호" />
                                        </label>
                                        <input type="text" name="postalCode" value="${plant.postalCode}">
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.area" text="총 면적 (m²)" />
                                        </label>
                                        <input type="number" step="0.01" name="totalArea" value="${plant.totalArea}">
                                    </div>

                                    <div class="filter-group">
                                        <label>
                                            <spring:message code="factory.plant.label.established" text="설립일" />
                                        </label>
                                        <input type="date" name="establishedDate" value="${plant.establishedDate}">
                                    </div>

                                </div>

                                <div
                                    style="margin-top: 32px; padding-top: 24px; border-top: 1px solid #edf2f7; text-align: right;">
                                    <button type="submit" class="btn btn-primary"
                                        style="padding: 16px 48px; font-size: 16px;">
                                        <spring:message code="common.edit" text="수정하기" />
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Related Factories -->
                        <div style="margin-top: 48px; max-width: 900px; margin-left: auto; margin-right: auto;">
                            <!-- Removed page-header class to avoid default borders/backgrounds -->
                            <div style="margin-bottom: 20px;">
                                <h2
                                    style="font-size: 20px; font-weight: 700; color: white; margin: 0; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                    🏭
                                    <spring:message code="factory.plant.related.title" text="소속 공장" /> (
                                    <c:out value="${factories.size()}" />)
                                </h2>
                            </div>

                            <div class="table-container">
                                <c:choose>
                                    <c:when test="${empty factories}">
                                        <div class="empty-state" style="padding: 60px 20px;">
                                            <p style="margin-bottom: 0;">
                                                <spring:message code="factory.plant.related.empty"
                                                    text="등록된 공장이 없습니다" />
                                            </p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>
                                                        <spring:message code="factory.table.plantName" text="공장명" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="factory.plant.label.type" text="유형" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="factory.plant.label.status" text="상태" />
                                                    </th>
                                                    <th>
                                                        <spring:message code="dashboard.card.production.title"
                                                            text="제품군" />
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${factories}" var="factory">
                                                    <tr>
                                                        <td>${factory.factoryId}</td>
                                                        <td><a href="/factory/factories/${factory.factoryId}"
                                                                style="color: #667eea; font-weight: 600;">${factory.factoryName}</a>
                                                        </td>
                                                        <td>${factory.factoryType}</td>
                                                        <td>
                                                            <span
                                                                class="badge badge-${factory.status == 'ACTIVE' ? 'active' : 'maintenance'}">
                                                                ${factory.status}
                                                            </span>
                                                        </td>
                                                        <td>${factory.productCategory}</td>
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

                        <c:if test="${not empty message}">
                            <script>
                                alert("${message}");
                            </script>
                        </c:if>
            </body>

            </html>

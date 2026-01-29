<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.detail.title" text="공장 상세 " />
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
                                <h1>🏭
                                    <c:out value="${factory.factoryName}" />
                                </h1>
                                <p class="subtitle" style="margin-top: 8px;">공장 상세 정보 및 생산 라인 관리</p>
                            </div>
                            <div class="action-buttons" style="margin-bottom: 0;">
                                <a href="/factory/factories" class="btn btn-secondary"
                                    style="background: #f1f5f9; color: #475569;">
                                    ←
                                    <spring:message code="common.list" text="목록으로" />
                                </a>
                            </div>
                        </div>

                        <!-- Edit Form -->
                        <div class="filter-card" style="max-width: 900px; margin: 0 auto;">
                            <form action="/factory/factories/${factory.factoryId}" method="post">
                                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px;">

                                    <div class="filter-group">
                                        <label>공장 ID</label>
                                        <input type="text" value="${factory.factoryId}" readonly
                                            style="background: #f1f5f9; color: #64748b; cursor: not-allowed;">
                                    </div>

                                    <div class="filter-group">
                                        <label>소속 사업장 ID</label>
                                        <input type="text" value="${factory.plantId}" readonly
                                            style="background: #f1f5f9; color: #64748b; cursor: not-allowed;">
                                    </div>

                                    <div class="filter-group">
                                        <label>공장명</label>
                                        <input type="text" name="factoryName" value="${factory.factoryName}" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>영문 공장명</label>
                                        <input type="text" name="factoryNameEn" value="${factory.factoryNameEn}">
                                    </div>

                                    <div class="filter-group">
                                        <label>공장 유형</label>
                                        <select name="factoryType">
                                            <option value="ASSEMBLY" ${factory.factoryType=='ASSEMBLY' ? 'selected' : ''
                                                }>조립 공장 (ASSEMBLY)</option>
                                            <option value="MACHINING" ${factory.factoryType=='MACHINING' ? 'selected'
                                                : '' }>가공 공장 (MACHINING)</option>
                                            <option value="PACKAGING" ${factory.factoryType=='PACKAGING' ? 'selected'
                                                : '' }>포장 공장 (PACKAGING)</option>
                                            <option value="WAREHOUSE" ${factory.factoryType=='WAREHOUSE' ? 'selected'
                                                : '' }>자재 창고 (WAREHOUSE)</option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>상태</label>
                                        <select name="status">
                                            <option value="ACTIVE" ${factory.status=='ACTIVE' ? 'selected' : '' }>정상 가동
                                            </option>
                                            <option value="MAINTENANCE" ${factory.status=='MAINTENANCE' ? 'selected'
                                                : '' }>점검 중</option>
                                            <option value="SUSPENDED" ${factory.status=='SUSPENDED' ? 'selected' : '' }>
                                                일시중지</option>
                                            <option value="CLOSED" ${factory.status=='CLOSED' ? 'selected' : '' }>폐쇄
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>주요 제품</label>
                                        <input type="text" name="productCategory" value="${factory.productCategory}">
                                    </div>

                                    <div class="filter-group">
                                        <label>목표 가동률 (%)</label>
                                        <input type="number" step="0.1" name="targetUtilizationRate"
                                            value="${factory.targetUtilizationRate}">
                                    </div>

                                </div>

                                <div
                                    style="margin-top: 32px; padding-top: 24px; border-top: 1px solid #edf2f7; text-align: right;">
                                    <button type="submit" class="btn btn-primary"
                                        style="padding: 16px 48px; font-size: 16px;">
                                        <spring:message code="common.save" text="저장하기" />
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Production Lines -->
                        <div style="margin-top: 48px; max-width: 900px; margin-left: auto; margin-right: auto;">

                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                <h2
                                    style="font-size: 20px; font-weight: 700; color: white; margin: 0; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                    ⚙️ 생산 라인 (
                                    <c:out value="${lines.size()}" />)
                                </h2>
                                <a href="/factory/lines/new?factoryId=${factory.factoryId}" class="btn btn-sm"
                                    style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.4);">
                                    + 라인 추가
                                </a>
                            </div>

                            <div class="table-container">
                                <c:choose>
                                    <c:when test="${empty lines}">
                                        <div class="empty-state" style="padding: 60px 20px;">
                                            <p style="margin-bottom: 0;">등록된 생산 라인이 없습니다</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>라인 ID</th>
                                                    <th>라인명</th>
                                                    <th>유형</th>
                                                    <th>상태</th>
                                                    <th>현재 가동률</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${lines}" var="line">
                                                    <tr>
                                                        <td>${line.lineId}</td>
                                                        <td>${line.lineName}</td>
                                                        <td>${line.lineType}</td>
                                                        <td>
                                                            <span
                                                                class="badge badge-${line.status == 'RUNNING' ? 'running' : (line.status == 'STOPPED' ? 'stopped' : 'maintenance')}">
                                                                ${line.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                                <div class="progress-bar" style="width: 80px;">
                                                                    <div class="progress-fill"
                                                                        style="width: ${line.utilizationRate}%;"></div>
                                                                </div>
                                                                <span
                                                                    style="font-size: 12px; color: #718096;">${line.utilizationRate}%</span>
                                                            </div>
                                                        </td>
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

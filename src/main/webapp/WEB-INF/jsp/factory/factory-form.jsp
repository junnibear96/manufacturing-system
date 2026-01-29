<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.new.title" text="신규 공장 등록 " />
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
                                    <spring:message code="factory.new" text="신규 공장 등록" />
                                </h1>
                                <p class="subtitle" style="margin-top: 8px;">새로운 생산 공장을 시스템에 등록합니다</p>
                            </div>
                            <div class="action-buttons" style="margin-bottom: 0;">
                                <a href="/factory/factories" class="btn btn-secondary"
                                    style="background: #f1f5f9; color: #475569;">
                                    ←
                                    <spring:message code="common.list" text="목록으로" />
                                </a>
                            </div>
                        </div>

                        <div class="filter-card" style="max-width: 900px; margin: 0 auto;">
                            <form action="/factory/factories" method="post">
                                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px;">

                                    <div class="filter-group">
                                        <label>공장 ID</label>
                                        <input type="text" name="factoryId" placeholder="예: FAC001" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>소속 사업장 (Plant)</label>
                                        <select name="plantId" required>
                                            <option value="">사업장 선택</option>
                                            <c:forEach items="${plants}" var="plant">
                                                <option value="${plant.plantId}">${plant.plantName} (${plant.plantId})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>공장명</label>
                                        <input type="text" name="factoryName" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>영문 공장명</label>
                                        <input type="text" name="factoryNameEn">
                                    </div>

                                    <div class="filter-group">
                                        <label>공장 유형</label>
                                        <select name="factoryType">
                                            <option value="ASSEMBLY">조립 공장 (ASSEMBLY)</option>
                                            <option value="MACHINING">가공 공장 (MACHINING)</option>
                                            <option value="PACKAGING">포장 공장 (PACKAGING)</option>
                                            <option value="WAREHOUSE">자재 창고 (WAREHOUSE)</option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>상태</label>
                                        <select name="status">
                                            <option value="ACTIVE" selected>정상 가동</option>
                                            <option value="MAINTENANCE">점검 중</option>
                                            <option value="SUSPENDED">일시중지</option>
                                            <option value="CLOSED">폐쇄</option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>주요 제품</label>
                                        <input type="text" name="productCategory" placeholder="예: 자동차 부품, 전자 모듈">
                                    </div>

                                    <div class="filter-group">
                                        <label>목표 가동률 (%)</label>
                                        <input type="number" step="0.1" name="targetUtilizationRate" value="95.0">
                                    </div>

                                </div>

                                <div
                                    style="margin-top: 32px; padding-top: 24px; border-top: 1px solid #edf2f7; text-align: right;">
                                    <button type="submit" class="btn btn-primary"
                                        style="padding: 16px 48px; font-size: 16px;">
                                        <spring:message code="common.save" text="등록하기" />
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>
            </body>

            </html>

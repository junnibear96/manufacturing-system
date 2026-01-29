<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.plant.new.title" text="신규 사업장 등록 " />
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
                                <h1>📍
                                    <spring:message code="factory.plant.new" text="신규 사업장 등록" />
                                </h1>
                                <p class="subtitle" style="margin-top: 8px;">새로운 지역 거점 및 사업장을 등록합니다</p>
                            </div>
                            <div class="action-buttons" style="margin-bottom: 0;">
                                <a href="/factory/plants" class="btn btn-secondary"
                                    style="background: #f1f5f9; color: #475569;">
                                    ←
                                    <spring:message code="common.list" text="목록으로" />
                                </a>
                            </div>
                        </div>

                        <div class="filter-card" style="max-width: 900px; margin: 0 auto;">
                            <form action="/factory/plants" method="post">
                                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px;">

                                    <div class="filter-group">
                                        <label>사업장 ID</label>
                                        <input type="text" name="plantId" placeholder="예: PLT001" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>사업장명</label>
                                        <input type="text" name="plantName" required>
                                    </div>

                                    <div class="filter-group">
                                        <label>영문 사업장명</label>
                                        <input type="text" name="plantNameEn">
                                    </div>

                                    <div class="filter-group">
                                        <label>전화번호</label>
                                        <input type="text" name="phone">
                                    </div>

                                    <div class="filter-group">
                                        <label>유형</label>
                                        <select name="plantType">
                                            <option value="MAIN_FACTORY">본사 공장</option>
                                            <option value="BRANCH_FACTORY">지사 공장</option>
                                            <option value="WAREHOUSE">물류 창고</option>
                                            <option value="R&D_CENTER">연구개발센터</option>
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

                                    <div class="filter-group" style="grid-column: 1 / -1;">
                                        <label>주소</label>
                                        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 12px;">
                                            <input type="text" name="address" placeholder="기본 주소">
                                            <input type="text" name="addressDetail" placeholder="상세 주소">
                                        </div>
                                    </div>

                                    <div class="filter-group">
                                        <label>우편번호</label>
                                        <input type="text" name="postalCode">
                                    </div>

                                    <div class="filter-group">
                                        <label>총 면적 (m²)</label>
                                        <input type="number" step="0.01" name="totalArea">
                                    </div>

                                    <div class="filter-group">
                                        <label>설립일</label>
                                        <input type="date" name="establishedDate">
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

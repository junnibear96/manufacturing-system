<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <spring:message code="production.analytics.title" text="분석 리포트 - TP MES" />
                    </title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <style>
                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        body {
                            font-family: 'Inter', 'Noto Sans KR', sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            min-height: 100vh;
                            padding: 20px;
                        }

                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                        }

                        .page-header {
                            background: white;
                            border-radius: 16px;
                            padding: 32px;
                            margin-bottom: 24px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                        }

                        .page-header h1 {
                            font-size: 28px;
                            font-weight: 700;
                            color: #1a202c;
                            margin-bottom: 8px;
                        }

                        .subtitle {
                            color: #718096;
                            font-size: 14px;
                        }

                        .section {
                            background: white;
                            border-radius: 16px;
                            padding: 24px;
                            margin-bottom: 24px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                        }

                        .section-title {
                            font-size: 20px;
                            font-weight: 700;
                            color: #1a202c;
                            margin-bottom: 20px;
                            padding-bottom: 12px;
                            border-bottom: 2px solid #e2e8f0;
                        }

                        .filter-form {
                            display: flex;
                            gap: 16px;
                            align-items: end;
                        }

                        .form-group {
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }

                        .form-label {
                            font-size: 14px;
                            font-weight: 600;
                            color: #4a5568;
                        }

                        .form-control {
                            padding: 10px 12px;
                            border: 1px solid #e2e8f0;
                            border-radius: 8px;
                            font-size: 14px;
                        }

                        .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 8px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.2s;
                            text-decoration: none;
                            color: white;
                        }

                        .btn-primary {
                            background: #667eea;
                        }

                        .btn-primary:hover {
                            background: #5a67d8;
                        }

                        .btn-search {
                            background: #4a5568;
                        }

                        .nav-links {
                            margin-bottom: 20px;
                        }

                        .nav-link-btn {
                            display: inline-block;
                            background: rgba(255, 255, 255, 0.2);
                            color: white;
                            padding: 10px 20px;
                            border-radius: 8px;
                            font-weight: 600;
                            text-decoration: none;
                            backdrop-filter: blur(4px);
                            transition: background 0.2s;
                        }

                        .nav-link-btn:hover {
                            background: rgba(255, 255, 255, 0.3);
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 16px;
                        }

                        th {
                            text-align: left;
                            padding: 12px;
                            border-bottom: 2px solid #e2e8f0;
                            color: #4a5568;
                            font-size: 13px;
                            font-weight: 600;
                            text-transform: uppercase;
                        }

                        td {
                            padding: 14px 12px;
                            border-bottom: 1px solid #f0f4f8;
                            font-size: 14px;
                            color: #2d3748;
                            vertical-align: middle;
                        }

                        .progress-bar {
                            background-color: #e2e8f0;
                            border-radius: 10px;
                            height: 8px;
                            width: 100%;
                            overflow: hidden;
                            margin-top: 8px;
                        }

                        .progress-value {
                            height: 100%;
                            border-radius: 10px;
                            transition: width 0.5s ease;
                        }

                        .bg-success {
                            background-color: #48bb78;
                        }

                        .bg-warning {
                            background-color: #ed8936;
                        }

                        .bg-danger {
                            background-color: #f56565;
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

                            .filter-form {
                                flex-direction: column;
                            }

                            .filter-form .form-group,
                            .filter-form .btn {
                                width: 100%;
                            }

                            table {
                                font-size: 13px;
                                display: block;
                                overflow-x: auto;
                            }

                            .nav-link-btn {
                                width: 100%;
                                text-align: center;
                            }
                        }

                        @media (max-width: 480px) {
                            .page-header h1 {
                                font-size: 20px;
                            }

                            table {
                                font-size: 12px;
                            }

                            .btn {
                                padding: 8px 16px;
                                font-size: 13px;
                            }
                        }
                    </style>
                </head>

                <body>
                    <div class="container">

                        <div class="nav-links">
                            <a href="/production/dashboard" class="nav-link-btn">←
                                <spring:message code="production.common.backToDashboard" text="대시보드로 돌아가기" />
                            </a>
                        </div>

                        <div class="page-header">
                            <h1>📈
                                <spring:message code="production.analytics.header" text="분석 리포트" />
                            </h1>
                            <p class="subtitle">
                                <spring:message code="production.analytics.subtitle" text="기간별 생산 실적 및 불량률 분석" />
                            </p>
                        </div>

                        <div class="section">
                            <form action="/production/analytics" method="GET" class="filter-form">
                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="common.startDate" text="시작일" />
                                    </label>
                                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="common.endDate" text="종료일" />
                                    </label>
                                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                                </div>
                                <button type="submit" class="btn btn-search" style="margin-bottom: 2px;">
                                    <spring:message code="common.search" text="조회" />
                                </button>
                            </form>
                        </div>

                        <div class="section">
                            <div class="section-title">📊
                                <spring:message code="production.analytics.dailyRate" text="일별 생산 달성률" />
                            </div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>
                                            <spring:message code="common.date" text="날짜" />
                                        </th>
                                        <th>
                                            <spring:message code="production.common.line" text="라인" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.targetQty" text="목표 수량" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.actualQty" text="실적 수량" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.achievementRate" text="달성률" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.planProgress" text="계획 진행" />
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${dailyAchievement}" var="daily">
                                        <tr>
                                            <td>${daily.workDate}</td>
                                            <td>${daily.lineName}</td>
                                            <td>
                                                <fmt:formatNumber value="${daily.totalTarget}" pattern="#,##0" />
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${daily.totalActual}" pattern="#,##0" />
                                            </td>
                                            <td style="width: 200px;">
                                                <div
                                                    style="display: flex; justify-content: space-between; margin-bottom: 4px;">
                                                    <span
                                                        style="font-weight: 600; color: ${daily.achievementRate >= 100 ? '#48bb78' : '#f56565'}">
                                                        <fmt:formatNumber value="${daily.achievementRate}"
                                                            pattern="#,##0.0" />%
                                                    </span>
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-value ${daily.achievementRate >= 100 ? 'bg-success' : 'bg-warning'}"
                                                        style="width: ${daily.achievementRate > 100 ? 100 : daily.achievementRate}%">
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${daily.completedPlanCount} / ${daily.planCount}
                                                <spring:message code="common.unit.count" text="건" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty dailyAchievement}">
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 30px; color: #a0aec0;">
                                                <spring:message code="common.noData" text="데이터가 없습니다." />
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <div class="section">
                            <div class="section-title">📉
                                <spring:message code="production.analytics.defectAnalysis" text="라인별 불량률 분석" />
                            </div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>
                                            <spring:message code="production.common.line" text="라인" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.totalProduction"
                                                text="총 생산수량" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.defectQty" text="불량 수량" />
                                        </th>
                                        <th>
                                            <spring:message code="production.analytics.defectRate" text="불량률" />
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${defectRates}" var="rate">
                                        <tr>
                                            <td><strong>${rate.lineName}</strong></td>
                                            <td>
                                                <fmt:formatNumber value="${rate.totalProduction}" pattern="#,##0" />
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${rate.totalDefect}" pattern="#,##0" />
                                            </td>
                                            <td style="width: 200px;">
                                                <span
                                                    style="font-weight: 600; color: ${rate.defectRate > 2.0 ? '#f56565' : '#4a5568'}">
                                                    <fmt:formatNumber value="${rate.defectRate}" pattern="#,##0.00" />%
                                                </span>
                                                <div class="progress-bar">
                                                    <div class="progress-value ${rate.defectRate > 2.0 ? 'bg-danger' : 'bg-success'}"
                                                        style="width: ${rate.defectRate > 20 ? 100 : rate.defectRate * 5}%">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty defectRates}">
                                        <tr>
                                            <td colspan="4" style="text-align: center; padding: 30px; color: #a0aec0;">
                                                <spring:message code="common.noData" text="데이터가 없습니다." />
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                    </div>
                    <%@ include file="../include/footer.jspf" %>
                </body>

                </html>

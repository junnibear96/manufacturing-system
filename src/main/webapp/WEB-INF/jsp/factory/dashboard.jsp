<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.dashboard.title" text="공장 관리 - TP MES" />
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
                        position: relative;
                    }

                    /* Animated Background Orbs */
                    body::before,
                    body::after {
                        content: '';
                        position: fixed;
                        border-radius: 50%;
                        filter: blur(80px);
                        opacity: 0.3;
                        z-index: 0;
                        animation: float 20s infinite ease-in-out;
                    }

                    body::before {
                        width: 500px;
                        height: 500px;
                        background: #48bb78;
                        top: -100px;
                        right: -100px;
                        animation-delay: -10s;
                    }

                    body::after {
                        width: 400px;
                        height: 400px;
                        background: #ed8936;
                        bottom: -100px;
                        left: -100px;
                    }

                    @keyframes float {

                        0%,
                        100% {
                            transform: translate(0, 0) scale(1);
                        }

                        33% {
                            transform: translate(50px, -50px) scale(1.1);
                        }

                        66% {
                            transform: translate(-50px, 50px) scale(0.9);
                        }
                    }

                    .container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 90px 20px 40px;
                        position: relative;
                        z-index: 1;
                    }

                    /* Search Bar */
                    .search-container {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 20px 24px;
                        margin-bottom: 24px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        animation: fadeIn 0.5s ease-out forwards;
                    }

                    .search-wrapper {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        background: white;
                        border: 2px solid #e2e8f0;
                        border-radius: 12px;
                        padding: 12px 16px;
                        transition: all 0.3s;
                    }

                    .search-wrapper:focus-within {
                        border-color: #667eea;
                        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                    }

                    .search-icon {
                        font-size: 20px;
                        color: #718096;
                    }

                    .search-input {
                        flex: 1;
                        border: none;
                        outline: none;
                        font-size: 14px;
                        color: #2d3748;
                    }

                    .search-input::placeholder {
                        color: #a0aec0;
                    }

                    .page-header {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 32px;
                        margin-bottom: 24px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        animation: fadeIn 0.5s ease-out forwards;
                    }

                    .page-header h1 {
                        font-size: 32px;
                        font-weight: 700;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin-bottom: 8px;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .subtitle {
                        color: #718096;
                        font-size: 15px;
                        font-weight: 500;
                    }

                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 20px;
                        margin-bottom: 24px;
                    }

                    .stat-card {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 28px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        animation: fadeIn 0.5s ease-out forwards;
                        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                        position: relative;
                        overflow: hidden;
                    }

                    .stat-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                        transform: scaleX(0);
                        transition: transform 0.4s;
                    }

                    .stat-card:hover::before {
                        transform: scaleX(1);
                    }

                    .stat-card:hover {
                        transform: translateY(-8px);
                        box-shadow: 0 20px 40px rgba(102, 126, 234, 0.2);
                    }

                    .stat-card-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        margin-bottom: 20px;
                    }

                    .stat-icon {
                        font-size: 36px;
                        width: 64px;
                        height: 64px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 14px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
                        animation: pulse 2s infinite;
                    }

                    @keyframes pulse {

                        0%,
                        100% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.05);
                        }
                    }

                    .stat-label {
                        font-size: 13px;
                        color: #718096;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-bottom: 8px;
                    }

                    .stat-value {
                        font-size: 40px;
                        font-weight: 800;
                        background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        line-height: 1;
                        margin: 12px 0;
                    }

                    .stat-detail {
                        font-size: 14px;
                        color: #4a5568;
                        font-weight: 500;
                    }

                    .section {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(20px);
                        border-radius: 16px;
                        padding: 28px;
                        margin-bottom: 24px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        animation: fadeIn 0.5s ease-out forwards;
                    }

                    .section h2 {
                        font-size: 20px;
                        font-weight: 700;
                        color: #1a202c;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    /* Modern Table Styling */
                    table {
                        width: 100%;
                        border-collapse: separate;
                        border-spacing: 0;
                        border-radius: 12px;
                        overflow: hidden;
                    }

                    thead {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    }

                    th {
                        padding: 18px 20px;
                        text-align: left;
                        font-weight: 600;
                        color: white;
                        font-size: 13px;
                        text-transform: uppercase;
                        letter-spacing: 0.8px;
                    }

                    th:first-child {
                        border-top-left-radius: 12px;
                    }

                    th:last-child {
                        border-top-right-radius: 12px;
                    }

                    td {
                        padding: 18px 20px;
                        font-size: 14px;
                        color: #2d3748;
                        border-bottom: 1px solid #f0f4f8;
                    }

                    tbody tr {
                        transition: all 0.3s;
                    }

                    tbody tr:nth-child(even) {
                        background: #fafbfc;
                    }

                    tbody tr:hover {
                        background: #f0f4f8;
                        transform: scale(1.01);
                    }

                    tbody tr:last-child td {
                        border-bottom: none;
                    }

                    tbody tr:last-child td:first-child {
                        border-bottom-left-radius: 12px;
                    }

                    tbody tr:last-child td:last-child {
                        border-bottom-right-radius: 12px;
                    }

                    code {
                        background: #edf2f7;
                        padding: 4px 8px;
                        border-radius: 6px;
                        font-family: 'Courier New', monospace;
                        font-size: 13px;
                        color: #667eea;
                        font-weight: 600;
                    }

                    .badge {
                        display: inline-block;
                        padding: 6px 16px;
                        border-radius: 20px;
                        font-size: 11px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.8px;
                    }

                    .badge-running {
                        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                        color: white;
                        box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3);
                    }

                    .badge-stopped {
                        background: #e2e8f0;
                        color: #4a5568;
                    }

                    .badge-maintenance {
                        background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
                        color: white;
                        box-shadow: 0 4px 12px rgba(237, 137, 54, 0.3);
                    }

                    .badge-active {
                        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                        color: white;
                        box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3);
                    }

                    .btn {
                        padding: 14px 28px;
                        border: none;
                        border-radius: 12px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        position: relative;
                        overflow: hidden;
                    }

                    .btn::before {
                        content: '';
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        width: 0;
                        height: 0;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.3);
                        transform: translate(-50%, -50%);
                        transition: width 0.6s, height 0.6s;
                    }

                    .btn:hover::before {
                        width: 300px;
                        height: 300px;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
                    }

                    .btn-primary:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 12px 28px rgba(102, 126, 234, 0.5);
                    }

                    .btn-primary:active {
                        transform: translateY(-1px);
                    }

                    .empty-state {
                        text-align: center;
                        padding: 80px 20px;
                        color: #718096;
                    }

                    .empty-state p {
                        font-size: 16px;
                        margin-bottom: 24px;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* Footer Quick Links */
                    .quick-links {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 16px;
                        margin-top: 32px;
                    }

                    .quick-links .btn {
                        justify-content: center;
                        flex: 1;
                    }

                    /* Responsive Design */
                    @media (max-width: 768px) {
                        .container {
                            padding: 90px 16px 24px;
                        }

                        .page-header h1 {
                            font-size: 24px;
                        }

                        .stat-value {
                            font-size: 32px;
                        }

                        .stats-grid {
                            grid-template-columns: 1fr;
                        }

                        table {
                            font-size: 12px;
                        }

                        th,
                        td {
                            padding: 12px;
                        }

                        .quick-links {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Sticky Header -->
                <header class="factory-header">
                    <div class="header-container">
                        <div class="header-left">
                            <a href="/dashboard" class="logo">
                                <span class="logo-icon">🏭</span>
                                <span class="logo-text">TP</span>
                            </a>
                            <nav class="main-nav">
                                <a href="/factory" class="nav-link active">공장관리</a>
                                <a href="/production/dashboard" class="nav-link">생산현황</a>
                                <a href="/inventory" class="nav-link">재고현황</a>
                            </nav>
                        </div>
                        <div class="header-right">
                            <select class="lang-selector">
                                <option value="ko">KOR</option>
                                <option value="en">ENG</option>
                            </select>
                            <div class="user-menu">
                                <span class="user-name">관리자</span>
                                <a href="/logout" class="btn-logout">로그아웃</a>
                            </div>
                        </div>
                    </div>
                </header>

                <style>
                    .factory-header {
                        background: rgba(255, 255, 255, 0.98);
                        backdrop-filter: blur(10px);
                        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                        position: sticky;
                        top: 0;
                        z-index: 100;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    }

                    .header-container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 0 24px;
                        height: 70px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .header-left {
                        display: flex;
                        align-items: center;
                        gap: 40px;
                    }

                    .logo {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        text-decoration: none;
                        font-weight: 700;
                        font-size: 24px;
                        color: #1a202c;
                    }

                    .logo-icon {
                        font-size: 32px;
                    }

                    .main-nav {
                        display: flex;
                        gap: 8px;
                    }

                    .nav-link {
                        padding: 8px 20px;
                        border-radius: 10px;
                        text-decoration: none;
                        color: #4a5568;
                        font-weight: 500;
                        font-size: 14px;
                        transition: all 0.3s;
                    }

                    .nav-link:hover {
                        background: #f7fafc;
                        color: #667eea;
                    }

                    .nav-link.active {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
                    }

                    .header-right {
                        display: flex;
                        align-items: center;
                        gap: 20px;
                    }

                    .lang-selector {
                        padding: 8px 16px;
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        background: white;
                        font-size: 13px;
                        font-weight: 500;
                        color: #4a5568;
                        cursor: pointer;
                    }

                    .user-menu {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                    }

                    .user-name {
                        font-weight: 600;
                        color: #2d3748;
                        font-size: 14px;
                    }

                    .btn-logout {
                        padding: 8px 16px;
                        border-radius: 8px;
                        background: #f7fafc;
                        color: #718096;
                        text-decoration: none;
                        font-size: 13px;
                        font-weight: 500;
                        transition: all 0.3s;
                    }

                    .btn-logout:hover {
                        background: #bee3f8;
                        color: #2c5282;
                    }

                    @media (max-width: 768px) {
                        .main-nav {
                            display: none;
                        }

                        .header-container {
                            padding: 0 16px;
                        }
                    }
                </style>


                <div class="container">
                    <!-- Search Bar -->
                    <div class="search-container">
                        <div class="search-wrapper">
                            <span class="search-icon">🔍</span>
                            <input type="text" class="search-input" placeholder="사업장 이름, 공장 코드, 생산라인 등을 검색하세요...">
                        </div>
                    </div>

                    <div class="page-header">
                        <h1>
                            <span>🏭</span>
                            공장 관리 대시보드
                        </h1>
                        <p class="subtitle">제조 실행의 물리적 기준을 관리합니다</p>
                    </div>

                    <!-- 통계 카드 -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-card-header">
                                <div>
                                    <div class="stat-label">사업장</div>
                                    <div class="stat-value">${plants.size()}</div>
                                    <div class="stat-detail">운영 거점</div>
                                </div>
                                <div class="stat-icon">🏢</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-card-header">
                                <div>
                                    <div class="stat-label">공장</div>
                                    <div class="stat-value">${factories.size()}</div>
                                    <div class="stat-detail">생산 구역</div>
                                </div>
                                <div class="stat-icon">🏭</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-card-header">
                                <div>
                                    <div class="stat-label">가동 중인 라인</div>
                                    <div class="stat-value">${runningLines.size()}</div>
                                    <div class="stat-detail">실시간 생산 중</div>
                                </div>
                                <div class="stat-icon">⚙️</div>
                            </div>
                        </div>
                    </div>

                    <!-- 사업장 목록 -->
                    <div class="section">
                        <h2>📍 사업장 현황</h2>
                        <c:choose>
                            <c:when test="${empty plants}">
                                <div class="empty-state">
                                    <p>등록된 사업장이 없습니다</p>
                                    <a href="/factory/plants/new" class="btn btn-primary" style="margin-top: 16px;">
                                        ➕ 사업장 등록
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>사업장 ID</th>
                                            <th>사업장명</th>
                                            <th>유형</th>
                                            <th>위치</th>
                                            <th>상태</th>
                                            <th>작업</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${plants}" var="plant">
                                            <tr>
                                                <td><code>${plant.plantId}</code></td>
                                                <td>
                                                    <a href="/factory/plants/${plant.plantId}"
                                                        style="color: #667eea; font-weight: 600;">
                                                        ${plant.plantName}
                                                    </a>
                                                </td>
                                                <td>${plant.plantType}</td>
                                                <td>${plant.address}</td>
                                                <td>
                                                    <span
                                                        class="badge badge-${plant.status == 'ACTIVE' ? 'active' : 'stopped'}">
                                                        ${plant.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="/factory/plants/${plant.plantId}">상세보기</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 가동 중인 라인 -->
                    <div class="section">
                        <h2>⚙️ 가동 중인 생산라인</h2>
                        <c:choose>
                            <c:when test="${empty runningLines}">
                                <div class="empty-state">
                                    <p>현재 가동 중인 생산라인이 없습니다</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>라인 ID</th>
                                            <th>라인명</th>
                                            <th>유형</th>
                                            <th>투입 인원</th>
                                            <th>가동률</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${runningLines}" var="line">
                                            <tr>
                                                <td><code>${line.lineId}</code></td>
                                                <td>
                                                    <a href="/factory/lines" style="color: #667eea; font-weight: 600;">
                                                        ${line.lineName}
                                                    </a>
                                                </td>
                                                <td>${line.lineType}</td>
                                                <td>${line.currentWorkers} / ${line.standardWorkers}명</td>
                                                <td><strong>${line.utilizationRate}%</strong></td>
                                                <td>
                                                    <span class="badge badge-running">RUNNING</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 빠른 링크 -->
                    <div class="quick-links">
                        <a href="/factory/plants" class="btn btn-primary">📍 사업장 관리</a>
                        <a href="/factory/factories" class="btn btn-primary">🏭 공장 관리</a>
                        <a href="/factory/lines" class="btn btn-primary">⚙️ 생산라인 관리</a>
                        <a href="/production/dashboard" class="btn btn-primary">📊 생산관리</a>
                    </div>
                </div>

                <%@ include file="../include/footer.jspf" %>
            </body>

            </html>

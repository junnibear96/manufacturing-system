<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="hr.page.title" />
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
                        font-family: 'Inter', 'Noto Sans KR', -apple-system, BlinkMacSystemFont, sans-serif;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        padding-top: 0px;
                    }

                    .container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 40px 20px;
                    }

                    .page-header {
                        background: white;
                        border-radius: 16px;
                        padding: 32px;
                        margin-bottom: 24px;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                    }

                    .page-header h1 {
                        font-size: 28px;
                        font-weight: 700;
                        color: #1a202c;
                        margin-bottom: 8px;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .page-header .subtitle {
                        color: #718096;
                        font-size: 14px;
                    }

                    .filter-card {
                        background: white;
                        border-radius: 16px;
                        padding: 24px;
                        margin-bottom: 24px;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                    }

                    .filter-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr 1fr auto;
                        gap: 16px;
                        align-items: end;
                    }

                    .filter-group {
                        display: flex;
                        flex-direction: column;
                        gap: 8px;
                    }

                    .filter-group label {
                        font-weight: 600;
                        color: #4a5568;
                        font-size: 13px;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .filter-group input,
                    .filter-group select {
                        padding: 12px 16px;
                        border: 2px solid #e2e8f0;
                        border-radius: 10px;
                        font-size: 14px;
                        background: #f7fafc;
                        transition: all 0.2s;
                        font-family: inherit;
                    }

                    .filter-group input:focus,
                    .filter-group select:focus {
                        outline: none;
                        border-color: #667eea;
                        background: white;
                        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                    }

                    .btn {
                        padding: 12px 24px;
                        border: none;
                        border-radius: 10px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        font-family: inherit;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        box-shadow: 0 4px 14px 0 rgba(102, 126, 234, 0.4);
                    }

                    .btn-primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
                    }

                    .btn-secondary {
                        background: #e2e8f0;
                        color: #4a5568;
                    }

                    .btn-secondary:hover {
                        background: #cbd5e0;
                    }

                    .btn-icon {
                        padding: 8px;
                        border-radius: 8px;
                        border: none;
                        background: transparent;
                        cursor: pointer;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .btn-icon:hover {
                        background: #f7fafc;
                    }

                    .action-buttons {
                        display: flex;
                        justify-content: flex-end;
                        margin-bottom: 0;
                    }

                    .table-container {
                        background: white;
                        border-radius: 16px;
                        overflow: hidden;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    thead {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    }

                    th {
                        padding: 18px 16px;
                        text-align: left;
                        font-weight: 600;
                        color: white;
                        font-size: 13px;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    td {
                        padding: 16px;
                        border-bottom: 1px solid #f0f4f8;
                        font-size: 14px;
                        color: #2d3748;
                    }

                    tbody tr {
                        transition: all 0.2s;
                    }

                    tbody tr:nth-child(even) {
                        background: #fafbfc;
                    }

                    tbody tr:hover {
                        background: #f0f4f8;
                        transform: scale(1.01);
                    }

                    .emp-link {
                        color: #667eea;
                        text-decoration: none;
                        font-weight: 600;
                        transition: color 0.2s;
                    }

                    .emp-link:hover {
                        color: #764ba2;
                        text-decoration: underline;
                    }

                    .emp-id {
                        font-family: 'Monaco', 'Courier New', monospace;
                        background: #edf2f7;
                        padding: 4px 8px;
                        border-radius: 6px;
                        font-size: 12px;
                        color: #4a5568;
                        font-weight: 600;
                    }

                    .badge {
                        display: inline-block;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .badge-active {
                        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                        color: white;
                    }

                    .badge-leave {
                        background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
                        color: white;
                    }

                    .badge-retired {
                        background: #cbd5e0;
                        color: #4a5568;
                    }

                    .badge-probation {
                        background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
                        color: white;
                    }

                    .message {
                        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                        color: white;
                        padding: 16px 20px;
                        border-radius: 12px;
                        margin-bottom: 24px;
                        font-weight: 500;
                        box-shadow: 0 4px 6px -1px rgba(72, 187, 120, 0.3);
                    }

                    .empty-state {
                        text-align: center;
                        padding: 80px 20px;
                    }

                    .empty-state-icon {
                        font-size: 64px;
                        margin-bottom: 16px;
                        opacity: 0.5;
                    }

                    .empty-state h3 {
                        font-size: 20px;
                        font-weight: 600;
                        color: #2d3748;
                        margin-bottom: 8px;
                    }

                    .empty-state p {
                        color: #718096;
                        margin-bottom: 24px;
                    }

                    .stats-footer {
                        background: white;
                        border-radius: 16px;
                        padding: 20px;
                        margin-top: 24px;
                        text-align: center;
                        font-size: 14px;
                        color: #718096;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    }

                    .stats-footer strong {
                        font-size: 18px;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .fade-in {
                        animation: fadeIn 0.5s ease-out forwards;
                    }

                    .fade-in:nth-child(1) {
                        animation-delay: 0.1s;
                    }

                    .fade-in:nth-child(2) {
                        animation-delay: 0.2s;
                    }

                    .fade-in:nth-child(3) {
                        animation-delay: 0.3s;
                    }

                    @media (max-width: 768px) {
                        .filter-row {
                            grid-template-columns: 1fr;
                        }

                        th,
                        td {
                            padding: 12px 8px;
                            font-size: 12px;
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header fade-in">
                            <h1>
                                <span>👥</span>
                                <spring:message code="hr.page.heading" text="인사 관리" />
                            </h1>
                            <p class="subtitle">
                                <spring:message code="hr.page.subtitle" text="조직 구성원 정보를 관리합니다" />
                            </p>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="message fade-in">${message}</div>
                        </c:if>

                        <div class="filter-card fade-in">
                            <form method="get" action="/hr/employees" id="filterForm">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label>🔍
                                            <spring:message code="common.search" text="검색" />
                                        </label>
                                        <input type="text" name="search" id="searchInput"
                                            placeholder="<spring:message code='hr.filter.search.placeholder' text='사원명 또는 사번 입력...' />"
                                            value="${param.search}">
                                    </div>

                                    <div class="filter-group">
                                        <label>🏢
                                            <spring:message code="hr.filter.department" text="부서" />
                                        </label>
                                        <select name="department" id="departmentSelect">
                                            <option value="">
                                                <spring:message code="hr.filter.department.all" text="전체 부서" />
                                            </option>
                                            <c:forEach items="${departments}" var="dept">
                                                <option value="${dept.departmentId}" <c:if
                                                    test="${dept.departmentId == selectedDepartment}">selected</c:if>>
                                                    ${dept.deptName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>📊
                                            <spring:message code="hr.filter.status" text="재직상태" />
                                        </label>
                                        <select name="status" id="statusSelect">
                                            <option value="">
                                                <spring:message code="hr.filter.status.all" text="전체 상태" />
                                            </option>
                                            <option value="ACTIVE" <c:if test="${selectedStatus == 'ACTIVE'}">selected
                                                </c:if>>
                                                <spring:message code="hr.filter.status.active" text="재직" />
                                            </option>
                                            <option value="LEAVE" <c:if test="${selectedStatus == 'LEAVE'}">selected
                                                </c:if>
                                                >
                                                <spring:message code="hr.filter.status.leave" text="휴직" />
                                            </option>
                                            <option value="PROBATION" <c:if test="${selectedStatus == 'PROBATION'}">
                                                selected
                                                </c:if>>
                                                <spring:message code="hr.filter.status.probation" text="수습" />
                                            </option>
                                            <option value="RETIRED" <c:if test="${selectedStatus == 'RETIRED'}">selected
                                                </c:if>>
                                                <spring:message code="hr.filter.status.retired" text="퇴직" />
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <button type="submit" class="btn btn-secondary">
                                            <spring:message code="hr.filter.apply" text="필터 적용" />
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="action-buttons fade-in">
                            <a href="/hr/employees/new" class="btn btn-primary">
                                <span>➕</span>
                                <spring:message code="hr.btn.new" text="신규 사원 등록" />
                            </a>
                        </div>

                        <div class="table-container fade-in" style="margin-top: 16px;">
                            <c:choose>
                                <c:when test="${empty employees}">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📂</div>
                                        <h3>
                                            <spring:message code="hr.empty.title" text="등록된 사원이 없습니다" />
                                        </h3>
                                        <p>
                                            <spring:message code="hr.empty.message" text="신규 사원을 등록하거나 DB 스키마를 확인하세요" />
                                        </p>
                                        <a href="/hr/employees/new" class="btn btn-primary">
                                            <span>➕</span>
                                            <spring:message code="hr.empty.btn" text="첫 번째 사원 등록하기" />
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <spring:message code="hr.table.empId" text="사번" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.name" text="이름" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.department" text="부서" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.position" text="직급" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.jobType" text="근무유형" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.status" text="재직상태" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.email" text="이메일" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.hireDate" text="입사일" />
                                                </th>
                                                <th>
                                                    <spring:message code="hr.table.actions" text="작업" />
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${employees}" var="emp">
                                                <tr>
                                                    <td><span class="emp-id">${emp.empId}</span></td>
                                                    <td>
                                                        <a href="/hr/employees/${emp.empId}"
                                                            class="emp-link">${emp.empName}</a>
                                                    </td>
                                                    <td>${emp.deptName}</td>
                                                    <td>${emp.positionName}</td>
                                                    <td>${emp.jobType}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${emp.status == 'ACTIVE'}">
                                                                <span class="badge badge-active">
                                                                    <spring:message code="hr.filter.status.active"
                                                                        text="재직" />
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${emp.status == 'LEAVE'}">
                                                                <span class="badge badge-leave">
                                                                    <spring:message code="hr.filter.status.leave"
                                                                        text="휴직" />
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${emp.status == 'PROBATION'}">
                                                                <span class="badge badge-probation">
                                                                    <spring:message code="hr.filter.status.probation"
                                                                        text="수습" />
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-retired">${emp.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${emp.email}</td>
                                                    <td>${emp.hireDate}</td>
                                                    <td>
                                                        <a href="/hr/employees/${emp.empId}" class="btn-icon"
                                                            title="<spring:message code='common.edit' text='편집' />">✏️</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="stats-footer fade-in">
                            <spring:message code="common.total" text="총" /> <strong>${employees.size()}</strong>
                            <spring:message code="hr.stats.total" text="명의 사원이 조회되었습니다" />
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>

                        <script>
                            // Auto-submit form on filter change
                            document.getElementById('departmentSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('statusSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });
                        </script>
            </body>

            </html>

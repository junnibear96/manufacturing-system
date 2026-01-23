<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="admin.notice.form" text="공지사항 등록" /> - TP MES
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            font-family: 'Inter', 'Noto Sans KR', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f5f7fa;
            color: #2d3748;
            min-height: 100vh;
          }

          .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
          }

          .page-header {
            background: white;
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            justify-content: space-between;
          }

          .page-header h1 {
            font-size: 24px;
            font-weight: 700;
            color: #1a202c;
            display: flex;
            align-items: center;
            gap: 12px;
          }

          .card {
            background: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
          }

          .form-group {
            margin-bottom: 24px;
          }

          .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #4a5568;
            font-size: 14px;
          }

          .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.2s;
            font-family: inherit;
            color: #2d3748;
          }

          .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
          }

          textarea.form-control {
            min-height: 300px;
            resize: vertical;
            line-height: 1.6;
          }

          .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 32px;
            justify-content: flex-end;
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
            transition: all 0.2s;
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

          .help-text {
            margin-top: 8px;
            font-size: 13px;
            color: #718096;
          }
        </style>
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <main class="container">
            <div class="page-header">
              <h1>
                <span>📢</span>
                <c:choose>
                  <c:when test="${isEdit}">
                    <spring:message code="admin.notice.edit" text="공지사항 수정" />
                  </c:when>
                  <c:otherwise>
                    <spring:message code="admin.notice.create" text="공지사항 등록" />
                  </c:otherwise>
                </c:choose>
              </h1>
              <a href="${pageContext.request.contextPath}/notices" class="btn btn-secondary">
                ←
                <spring:message code="common.cancel" text="취소" />
              </a>
            </div>

            <c:choose>
              <c:when test="${isEdit}">
                <c:set var="actionUrl" value="${pageContext.request.contextPath}/admin/notices/${noticeId}/edit" />
              </c:when>
              <c:otherwise>
                <c:set var="actionUrl" value="${pageContext.request.contextPath}/admin/notices/new" />
              </c:otherwise>
            </c:choose>

            <form method="post" action="${actionUrl}">
              <div class="card">
                <div class="form-group">
                  <label for="title">
                    <spring:message code="app.notice.title" text="제목" />
                  </label>
                  <input type="text" id="title" name="title" class="form-control" value="<c:out value='${title}' />"
                    placeholder="공지사항 제목을 입력하세요" required autofocus />
                </div>

                <div class="form-group">
                  <label for="body">
                    <spring:message code="app.notice.body" text="내용" />
                  </label>
                  <textarea id="body" name="body" class="form-control"
                    placeholder="공지 내용을 자세히 입력하세요..."><c:out value="${body}" /></textarea>
                  <p class="help-text">
                    <spring:message code="admin.notice.hint" text="작성자는 현재 로그인한 사용자로 자동 저장됩니다." />
                  </p>
                </div>

                <div class="btn-group">
                  <a href="${pageContext.request.contextPath}/notices" class="btn btn-secondary">
                    <spring:message code="common.cancel" text="취소" />
                  </a>
                  <button type="submit" class="btn btn-primary">
                    <span>💾</span>
                    <c:choose>
                      <c:when test="${isEdit}">
                        <spring:message code="common.update" text="수정하기" />
                      </c:when>
                      <c:otherwise>
                        <spring:message code="common.save" text="등록하기" />
                      </c:otherwise>
                    </c:choose>
                  </button>
                </div>
              </div>
            </form>
          </main>
      </body>

      </html>

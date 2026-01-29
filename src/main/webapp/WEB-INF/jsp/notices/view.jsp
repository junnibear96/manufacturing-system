<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
        <!doctype html>
        <html lang="ko">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <title>
            <spring:message code="notice.view.title" text="공지사항 상세" /> 
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
              padding: 24px 32px;
              margin-bottom: 24px;
              box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
              display: flex;
              align-items: center;
              justify-content: space-between;
            }

            .page-header h1 {
              font-size: 20px;
              font-weight: 700;
              color: #1a202c;
              display: flex;
              align-items: center;
              gap: 12px;
            }

            .card {
              background: white;
              border-radius: 16px;
              padding: 40px;
              box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
              min-height: 400px;
            }

            .notice-header {
              padding-bottom: 24px;
              border-bottom: 1px solid #e2e8f0;
              margin-bottom: 32px;
            }

            .notice-title {
              font-size: 28px;
              font-weight: 800;
              color: #1a202c;
              margin-bottom: 16px;
              line-height: 1.3;
            }

            .notice-meta {
              display: flex;
              align-items: center;
              gap: 16px;
              font-size: 14px;
              color: #718096;
            }

            .notice-meta span {
              display: flex;
              align-items: center;
              gap: 6px;
            }

            .notice-body {
              font-size: 17px;
              line-height: 1.8;
              color: #2d3748;
              white-space: pre-wrap;
              min-height: 300px;
              padding-bottom: 20px;
            }

            .btn {
              padding: 10px 20px;
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

            .btn-secondary {
              background: #edf2f7;
              color: #4a5568;
            }

            .btn-secondary:hover {
              background: #e2e8f0;
              color: #2d3748;
            }

            .badge {
              display: inline-block;
              padding: 4px 10px;
              border-radius: 9999px;
              font-size: 12px;
              font-weight: 600;
              text-transform: uppercase;
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              color: white;
            }
          </style>
        </head>

        <body>
          <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

            <main class="container">
              <div class="page-header">
                <div style="display: flex; align-items: center; gap: 12px;">
                  <a href="${pageContext.request.contextPath}/notices" class="btn btn-secondary">
                    ←
                    <spring:message code="common.list" text="목록으로" />
                  </a>
                  <h1>
                    <span>📰</span>
                    <spring:message code="notice.view" text="공지사항" />
                  </h1>
                </div>

                <sec:authorize access="hasRole('ADMIN')">
                  <a href="${pageContext.request.contextPath}/admin/notices/${notice.noticeId}/edit"
                    class="btn btn-secondary" style="background:#e2e8f0;">
                    ✎
                    <spring:message code="common.edit" text="수정" />
                  </a>
                </sec:authorize>
              </div>

              <article class="card">
                <header class="notice-header">
                  <div style="margin-bottom: 12px;">
                    <span class="badge">Notice</span>
                  </div>
                  <h1 class="notice-title">
                    <c:out value="${notice.title}" />
                  </h1>
                  <div class="notice-meta">
                    <span>
                      📅
                      <c:out value="${notice.createdAt}" />
                    </span>
                    <span>
                      👤 관리자
                    </span>
                  </div>
                </header>

                <div class="notice-body">
                  <c:out value="${notice.body}" />
                </div>
              </article>
            </main>
        </body>

        </html>

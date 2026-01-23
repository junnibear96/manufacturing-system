<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="app.company.title" text="그룹사 목록" /> - TP
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

          <main class="container" role="main">
            <section class="hero" aria-label="Companies">
              <div class="hero-grid">
                <div class="card card-strong">
                  <div class="kicker">
                    <span class="badge">Oracle</span>
                    <span class="small">group_company</span>
                  </div>
                  <h1>
                    <spring:message code="app.company.title" text="그룹사 목록" />
                  </h1>
                  <p class="small">
                    <spring:message code="app.company.desc" text="조회는 /app, 등록/수정은 /admin (ROLE_ADMIN)에서 수행합니다." />
                  </p>

                  <div style="overflow:auto;">
                    <table style="width:100%; border-collapse:collapse;">
                      <thead>
                        <tr>
                          <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                            <spring:message code="app.company.header.code" text="Code" />
                          </th>
                          <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                            <spring:message code="app.company.header.name" text="Name" />
                          </th>
                          <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                            <spring:message code="app.company.header.active" text="Active" />
                          </th>
                          <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                            <spring:message code="app.company.header.created" text="Created" />
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach items="${companies}" var="c">
                          <tr>
                            <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                              <c:out value="${c.companyCode}" />
                            </td>
                            <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                              <c:out value="${c.companyName}" />
                              <div class="small" style="margin-top:4px; opacity:.9;">
                                <c:out value="${c.description}" />
                              </div>
                              <c:if
                                test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                                <div class="small" style="margin-top:8px;">
                                  <a href="${pageContext.request.contextPath}/admin/companies/${c.companyId}/edit">
                                    <spring:message code="common.edit" text="Edit" />
                                  </a>
                                </div>
                              </c:if>
                            </td>
                            <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                              <c:out value="${c.activeYn}" />
                            </td>
                            <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                              <c:out value="${c.createdAt}" />
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>
                </div>

                <aside class="card" aria-label="Admin">
                  <h2 style="margin-top:0;">
                    <spring:message code="app.company.header.admin" text="Admin" />
                  </h2>
                  <c:choose>
                    <c:when test="${sessionScope.AUTH_USER != null && sessionScope.AUTH_USER.hasRole('ROLE_ADMIN')}">
                      <p><a class="btn" href="${pageContext.request.contextPath}/admin/companies/new">
                          <spring:message code="app.company.btn.new" text="+ New Company" />
                        </a></p>
                      <p class="small">
                        <spring:message code="app.company.msg.admin_only" text="등록/수정은 ROLE_ADMIN만 가능합니다." />
                      </p>
                    </c:when>
                    <c:otherwise>
                      <p class="small">
                        <spring:message code="app.company.msg.no_perm" text="관리자 권한이 없으면 등록/수정 메뉴가 표시되지 않습니다." />
                      </p>
                    </c:otherwise>
                  </c:choose>
                </aside>
              </div>
            </section>
          </main>
      </body>

      </html>

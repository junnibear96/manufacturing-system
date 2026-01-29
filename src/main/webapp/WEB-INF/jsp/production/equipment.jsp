<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="production.equipment.title" text="설비 목록 " />
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>
          <main class="container" role="main">
            <section class="hero" aria-label="Equipment">
              <div class="card card-strong">
                <div class="kicker"><span class="badge">Oracle</span><span class="small">equipment</span></div>
                <h1>
                  <spring:message code="production.equipment.header" text="설비" />
                </h1>
                <div style="overflow:auto;">
                  <table style="width:100%; border-collapse:collapse;">
                    <thead>
                      <tr>
                        <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                          <spring:message code="production.equipment.table.code" text="Code" />
                        </th>
                        <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                          <spring:message code="production.equipment.table.name" text="Name" />
                        </th>
                        <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                          <spring:message code="production.process.name" text="Process" />
                        </th>
                        <th style="text-align:left; padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.12);">
                          <spring:message code="common.active" text="Active" />
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${equipment}" var="e">
                        <tr>
                          <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                            <c:out value="${e.equipmentCode}" />
                          </td>
                          <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                            <c:out value="${e.equipmentName}" />
                          </td>
                          <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                            <c:out value="${e.processName}" />
                          </td>
                          <td style="padding:10px 8px; border-bottom:1px solid rgba(255,255,255,.08);">
                            <c:out value="${e.activeYn}" />
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>
            </section>
          </main>
      </body>

      </html>

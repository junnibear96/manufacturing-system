<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>TP · Intro</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
        <style>
          /* Mobile Menu Overlay */
          .menu-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background: rgba(0, 0, 0, 0.6);
            z-index: 9998;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
          }

          .menu-overlay.active {
            opacity: 1;
            visibility: visible;
          }

          /* Mobile Menu Panel */
          .mobile-menu-panel {
            position: fixed;
            top: 0;
            right: -100%;
            width: 85%;
            max-width: 400px;
            height: 100vh;
            background: #ffffff;
            z-index: 9999;
            overflow-y: auto;
            transition: right 0.3s ease;
            box-shadow: -4px 0 24px rgba(0, 0, 0, 0.15);
          }

          .mobile-menu-panel.active {
            right: 0;
          }

          /* Menu Header */
          .menu-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
          }

          .menu-lang {
            display: flex;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
          }

          .menu-lang a {
            color: #9ca3af;
            text-decoration: none;
            transition: color 0.2s;
          }

          .menu-lang a.active {
            color: #111827;
          }

          .menu-close {
            background: none;
            border: none;
            font-size: 28px;
            line-height: 1;
            cursor: pointer;
            color: #111827;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
          }

          /* Menu Navigation */
          .menu-nav {
            padding: 12px 0;
          }

          .menu-item {
            border-bottom: 1px solid #f3f4f6;
          }

          .menu-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            color: #111827;
            transition: background-color 0.2s;
          }

          .menu-item-header:hover {
            background-color: #f9fafb;
          }

          .menu-item-header.expanded {
            color: #3b82f6;
          }

          .menu-chevron {
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 6px solid #9ca3af;
            transition: transform 0.3s ease;
          }

          .menu-item-header.expanded .menu-chevron {
            transform: rotate(180deg);
            border-top-color: #3b82f6;
          }

          /* Submenu */
          .menu-submenu {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            background-color: #f9fafb;
          }

          .menu-submenu.expanded {
            max-height: 500px;
          }

          .menu-submenu a {
            display: block;
            padding: 14px 24px 14px 40px;
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
            border-left: 3px solid transparent;
          }

          .menu-submenu a:hover {
            color: #3b82f6;
            background-color: #eff6ff;
            border-left-color: #3b82f6;
          }

          .landing-menu {
            cursor: pointer;
          }

          .landing-menu.active .bar:nth-child(1) {
            transform: rotate(45deg) translate(5px, 5px);
          }

          .landing-menu.active .bar:nth-child(2) {
            opacity: 0;
          }

          .landing-menu.active .bar:nth-child(3) {
            transform: rotate(-45deg) translate(6px, -6px);
          }

          @media (min-width: 769px) {

            .menu-overlay,
            .mobile-menu-panel {
              display: none !important;
            }
          }
        </style>
      </head>

      <body>
        <a class="skip" href="#content">
          <spring:message code="intro.skip" text="본문으로 바로가기" />
        </a>

        <header class="landing-top" role="banner">
          <div class="landing-top-inner">
            <a class="landing-logo" href="${pageContext.request.contextPath}/app/home" aria-label="TP Home">TP</a>
            <nav class="landing-actions" aria-label="Language and menu">
              <a class="landing-action" href="#" aria-disabled="true">KOR</a>
              <span class="landing-sep" aria-hidden="true">·</span>
              <a class="landing-action" href="#" aria-disabled="true">ENG</a>
              <button class="landing-menu" type="button" aria-label="Menu" id="mobileMenuButton">
                <span class="bar" aria-hidden="true"></span>
                <span class="bar" aria-hidden="true"></span>
                <span class="bar" aria-hidden="true"></span>
              </button>
            </nav>
          </div>
        </header>

        <!-- Mobile Menu Overlay -->
        <div class="menu-overlay" id="menuOverlay"></div>

        <!-- Mobile Menu Panel -->
        <div class="mobile-menu-panel" id="mobileMenuPanel">
          <div class="menu-header">
            <div class="menu-lang">
              <a href="#" class="active">KOR</a>
              <span>|</span>
              <a href="#">ENG</a>
            </div>
            <button class="menu-close" id="menuCloseButton" aria-label="Close Menu">×</button>
          </div>

          <nav class="menu-nav">
            <!-- Company Section -->
            <div class="menu-item">
              <button class="menu-item-header" data-menu="company">
                <span>
                  <spring:message code="app.intro.company" text="회사 소개" />
                </span>
                <span class="menu-chevron"></span>
              </button>
              <div class="menu-submenu" id="submenu-company">
                <a href="${pageContext.request.contextPath}/company">
                  <spring:message code="app.intro.company" text="회사 소개" />
                </a>
                <a href="${pageContext.request.contextPath}/dashboard">
                  <spring:message code="app.header.dashboard" text="대시보드" />
                </a>
              </div>
            </div>

            <!-- Business Section -->
            <div class="menu-item">
              <button class="menu-item-header" data-menu="business">
                <span>
                  <spring:message code="app.header.production" text="생산 관리" />
                </span>
                <span class="menu-chevron"></span>
              </button>
              <div class="menu-submenu" id="submenu-business">
                <a href="${pageContext.request.contextPath}/production/plans">
                  <spring:message code="app.header.production" text="생산 관리" />
                </a>
                <a href="${pageContext.request.contextPath}/inventory/dashboard">
                  <spring:message code="app.header.inventory" text="재고 관리" />
                </a>
              </div>
            </div>

            <!-- Factory Management -->
            <div class="menu-item">
              <button class="menu-item-header" data-menu="factory">
                <span>
                  <spring:message code="app.header.factory" text="공장 관리" />
                </span>
                <span class="menu-chevron"></span>
              </button>
              <div class="menu-submenu" id="submenu-factory">
                <a href="${pageContext.request.contextPath}/factory/dashboard">
                  <spring:message code="factory.dashboard.title" text="공장 대시보드" />
                </a>
                <a href="${pageContext.request.contextPath}/factory/list">
                  <spring:message code="factory.list.title" text="공장 목록" />
                </a>
              </div>
            </div>

            <!-- HR Management -->
            <div class="menu-item">
              <button class="menu-item-header" data-menu="hr">
                <span>
                  <spring:message code="app.header.hr" text="인사 관리" />
                </span>
                <span class="menu-chevron"></span>
              </button>
              <div class="menu-submenu" id="submenu-hr">
                <a href="${pageContext.request.contextPath}/hr/employees">
                  <spring:message code="app.header.hr.employees" text="직원 관리" />
                </a>
                <a href="${pageContext.request.contextPath}/hr/departments">
                  <spring:message code="app.header.hr.departments" text="부서 관리" />
                </a>
              </div>
            </div>

            <!-- Portfolio -->
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}/portfolio" class="menu-item-header"
                style="text-decoration: none;">
                <span>
                  <spring:message code="app.intro.portfolio" text="포트폴리오" />
                </span>
              </a>
            </div>

            <!-- Login -->
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}/login" class="menu-item-header"
                style="text-decoration: none;">
                <span>
                  <spring:message code="app.header.login" text="로그인" />
                </span>
              </a>
            </div>
          </nav>
        </div>

        <main id="content" class="landing" role="main">
          <div class="landing-overlay" aria-hidden="true"></div>

          <section class="landing-center" aria-label="Intro">
            <h1>
              <spring:message code="intro.title" text="현장을 위한 실행 가능한 시스템" />
            </h1>
            <p class="landing-sub">
              <spring:message code="intro.subtitle" text="Your Trusted Partner · TP" />
            </p>
            <p class="small" style="margin-top:18px;">
              <spring:message code="app.login.serverTime" arguments="${now}" text="서버 시간: ${now}" />
            </p>

            <div class="landing-chips" role="list" aria-label="Quick links">
              <a class="chip" role="listitem" href="${pageContext.request.contextPath}/company">
                <spring:message code="app.intro.company" text="회사 소개" />
              </a>
              <a class="chip" role="listitem" href="${pageContext.request.contextPath}/portfolio">
                <spring:message code="app.intro.portfolio" text="포트폴리오" />
              </a>
              <a class="chip" role="listitem" href="${pageContext.request.contextPath}/api/health">Health</a>
            </div>

            <div class="landing-keywords" aria-label="Keywords">
              <div class="chips" role="list" aria-label="<spring:message code='intro.keywords' default='키워드'/>">
                <c:forEach var="k" items="${keywords}">
                  <span class="chip" role="listitem">
                    <c:out value="${k}" />
                  </span>
                </c:forEach>
              </div>
            </div>
          </section>

          <section class="landing-bottom" aria-label="Brands">
            <div class="brand-strip" role="list">
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>TP</span></div>
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>TP Nadia</span>
              </div>
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>EO</span></div>
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>TP Living</span>
              </div>
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>TP
                  F&amp;B</span></div>
              <div class="brand-item" role="listitem"><span class="dot" aria-hidden="true"></span><span>TP Square</span>
              </div>
            </div>
          </section>
        </main>

        <script>
          // Mobile Menu Toggle with TP Inc Style
          document.addEventListener('DOMContentLoaded', function () {
            const menuButton = document.getElementById('mobileMenuButton');
            const menuPanel = document.getElementById('mobileMenuPanel');
            const menuOverlay = document.getElementById('menuOverlay');
            const menuCloseButton = document.getElementById('menuCloseButton');

            // Open menu
            function openMenu() {
              menuButton.classList.add('active');
              menuPanel.classList.add('active');
              menuOverlay.classList.add('active');
              document.body.style.overflow = 'hidden';
            }

            // Close menu
            function closeMenu() {
              menuButton.classList.remove('active');
              menuPanel.classList.remove('active');
              menuOverlay.classList.remove('active');
              document.body.style.overflow = '';
            }

            // Toggle menu on button click
            if (menuButton) {
              menuButton.addEventListener('click', function () {
                if (menuPanel.classList.contains('active')) {
                  closeMenu();
                } else {
                  openMenu();
                }
              });
            }

            // Close menu on close button click
            if (menuCloseButton) {
              menuCloseButton.addEventListener('click', closeMenu);
            }

            // Close menu when clicking overlay
            if (menuOverlay) {
              menuOverlay.addEventListener('click', closeMenu);
            }

            // Accordion functionality for submenu items
            const menuHeaders = document.querySelectorAll('.menu-item-header[data-menu]');
            menuHeaders.forEach(header => {
              header.addEventListener('click', function () {
                const menuName = this.getAttribute('data-menu');
                const submenu = document.getElementById('submenu-' + menuName);

                if (submenu) {
                  const isExpanded = this.classList.contains('expanded');

                  // Close all other submenus
                  document.querySelectorAll('.menu-item-header').forEach(h => {
                    h.classList.remove('expanded');
                  });
                  document.querySelectorAll('.menu-submenu').forEach(s => {
                    s.classList.remove('expanded');
                  });

                  // Toggle current submenu
                  if (!isExpanded) {
                    this.classList.add('expanded');
                    submenu.classList.add('expanded');
                  }
                }
              });
            });

            // Close menu when clicking a submenu link
            const submenuLinks = document.querySelectorAll('.menu-submenu a');
            submenuLinks.forEach(link => {
              link.addEventListener('click', closeMenu);
            });
          });
        </script>
        <script src="${pageContext.request.contextPath}/assets/app.js" defer></script>
      </body>

      </html>

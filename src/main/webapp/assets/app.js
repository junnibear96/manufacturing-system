(function () {
  function isSamePath(a, b) {
    // Normalize to just the file name for simple deployments.
    var pa = (a || '').split('?')[0].split('#')[0];
    var pb = (b || '').split('?')[0].split('#')[0];
    pa = pa.substring(pa.lastIndexOf('/') + 1);
    pb = pb.substring(pb.lastIndexOf('/') + 1);
    return pa === pb;
  }

  // Mark active page link.
  try {
    var links = document.querySelectorAll('a[data-nav="page"]');
    var current = window.location.pathname;
    links.forEach(function (a) {
      if (isSamePath(a.getAttribute('href'), current) || (current.endsWith('/') && a.getAttribute('href') === 'index.jsp')) {
        a.setAttribute('aria-current', 'page');
      }
    });
  } catch (e) {
    // no-op
  }

  // Smooth scroll for anchor links on the same page.
  document.addEventListener('click', function (e) {
    var target = e.target;
    if (!(target instanceof Element)) return;
    var a = target.closest('a[data-nav="anchor"]');
    if (!a) return;

    var href = a.getAttribute('href') || '';
    if (!href.startsWith('#')) return;

    var el = document.querySelector(href);
    if (!el) return;

    e.preventDefault();
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    history.replaceState(null, '', href);
  });

  // Copy-to-clipboard for code samples.
  document.addEventListener('click', function (e) {
    var target = e.target;
    if (!(target instanceof Element)) return;
    var btn = target.closest('[data-copy]');
    if (!btn) return;

    var selector = btn.getAttribute('data-copy');
    if (!selector) return;
    var el = document.querySelector(selector);
    if (!el) return;

    var text = (el.innerText || el.textContent || '').trimEnd();
    if (!text) return;

    var original = btn.textContent;

    function done(ok) {
      btn.textContent = ok ? '복사됨' : '복사 실패';
      btn.setAttribute('aria-live', 'polite');
      setTimeout(function () {
        btn.textContent = original;
      }, 900);
    }

    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(function () { done(true); }).catch(function () { done(false); });
      return;
    }

    // Fallback
    try {
      var ta = document.createElement('textarea');
      ta.value = text;
      ta.setAttribute('readonly', '');
      ta.style.position = 'absolute';
      ta.style.left = '-9999px';
      document.body.appendChild(ta);
      ta.select();
      var ok = document.execCommand('copy');
      document.body.removeChild(ta);
      done(!!ok);
    } catch (_e) {
      done(false);
    }
  });

  // Mobile hamburger / all-menu drawer.
  (function initNavDrawer() {
    var toggle = document.querySelector('[data-nav-toggle]');
    var drawer = document.getElementById('appNav');
    var overlay = document.querySelector('[data-nav-overlay]');
    var closeBtn = document.querySelector('[data-nav-close]');

    if (!toggle || !drawer || !overlay) return;

    var lastFocus = null;

    // Tabs inside the drawer (mobile-only via CSS).
    (function initNavTabs() {
      var tabs = drawer.querySelectorAll('[data-nav-tab-button]');
      if (!tabs || !tabs.length) return;

      function setActiveTab(key, focusTab) {
        if (!key) key = 'main';
        drawer.setAttribute('data-nav-tab', key);
        tabs.forEach(function (btn) {
          var k = btn.getAttribute('data-nav-tab-button');
          var selected = k === key;
          btn.setAttribute('aria-selected', selected ? 'true' : 'false');
          btn.setAttribute('tabindex', selected ? '0' : '-1');
          if (selected && focusTab && btn.focus) btn.focus();
        });
      }

      // Initialize from markup/default.
      setActiveTab(drawer.getAttribute('data-nav-tab') || 'main', false);

      tabs.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
          e.preventDefault();
          setActiveTab(btn.getAttribute('data-nav-tab-button'), true);
        });

        btn.addEventListener('keydown', function (e) {
          // Arrow-key navigation between tabs.
          if (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight') return;
          e.preventDefault();
          var list = Array.prototype.slice.call(tabs);
          var idx = list.indexOf(btn);
          if (idx < 0) return;
          var dir = e.key === 'ArrowRight' ? 1 : -1;
          var next = (idx + dir + list.length) % list.length;
          var nextBtn = list[next];
          setActiveTab(nextBtn.getAttribute('data-nav-tab-button'), true);
        });
      });
    })();

    function getFocusable(container) {
      var nodes = container.querySelectorAll(
        'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
      );

      return Array.prototype.filter.call(nodes, function (el) {
        // Only include elements that are actually visible.
        return !!(el && el.getClientRects && el.getClientRects().length);
      });
    }

    function setTabbablesEnabled(enabled) {
      var all = drawer.querySelectorAll('a, button, input, select, textarea, [tabindex]');
      all.forEach(function (el) {
        if (!(el instanceof Element)) return;

        if (enabled) {
          if (!el.hasAttribute('data-nav-prev-tabindex')) return;
          var prev = el.getAttribute('data-nav-prev-tabindex');
          el.removeAttribute('data-nav-prev-tabindex');
          if (prev === '') el.removeAttribute('tabindex');
          else el.setAttribute('tabindex', prev);
          return;
        }

        // Disabled: store current tabindex and set to -1.
        if (el.getAttribute('data-nav-prev-tabindex') != null) return;
        var current = el.getAttribute('tabindex');
        el.setAttribute('data-nav-prev-tabindex', current == null ? '' : current);
        el.setAttribute('tabindex', '-1');
      });
    }

    function isOpen() {
      return document.body.classList.contains('nav-open');
    }

    function setExpanded(open) {
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
      toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
      overlay.setAttribute('aria-hidden', open ? 'false' : 'true');
      drawer.setAttribute('aria-hidden', open ? 'false' : 'true');
    }

    function open() {
      if (isOpen()) return;
      lastFocus = document.activeElement;
      document.body.classList.add('nav-open');
      setTabbablesEnabled(true);
      setExpanded(true);
      // Focus first link for keyboard users.
      setTimeout(function () {
        var first = drawer.querySelector('[data-nav-close], a, button, [tabindex]:not([tabindex="-1"])');
        if (first && first.focus) first.focus();
      }, 0);
    }

    function close() {
      if (!isOpen()) return;
      document.body.classList.remove('nav-open');
      setExpanded(false);
      setTabbablesEnabled(false);
      if (lastFocus && lastFocus.focus) {
        try { lastFocus.focus(); } catch (_e) { /* no-op */ }
      } else {
        toggle.focus();
      }
      lastFocus = null;
    }

    function toggleMenu() {
      if (isOpen()) close();
      else open();
    }

    // Ensure hidden state is not tabbable.
    setTabbablesEnabled(false);
    setExpanded(false);

    toggle.addEventListener('click', function (e) {
      e.preventDefault();
      toggleMenu();
    });

    overlay.addEventListener('click', function () {
      close();
    });

    if (closeBtn) {
      closeBtn.addEventListener('click', function (e) {
        e.preventDefault();
        close();
      });
    }

    document.addEventListener('keydown', function (e) {
      if (!isOpen()) return;
      if (e.key === 'Escape') {
        e.preventDefault();
        close();
        return;
      }

      if (e.key === 'Tab') {
        var focusables = getFocusable(drawer);
        if (!focusables.length) return;
        var first = focusables[0];
        var last = focusables[focusables.length - 1];
        var active = document.activeElement;

        if (e.shiftKey) {
          if (active === first || !drawer.contains(active)) {
            e.preventDefault();
            last.focus();
          }
          return;
        }

        if (active === last) {
          e.preventDefault();
          first.focus();
        }
      }
    });

    // Handle clicks in drawer: toggle submenu or navigate
    drawer.addEventListener('click', function (e) {
      var target = e.target;
      if (!(target instanceof Element)) return;

      var a = target.closest('a');
      if (!a) return;

      // If it's a menu-toggle link, toggle the submenu instead of navigating
      if (a.classList.contains('menu-toggle')) {
        e.preventDefault();
        a.classList.toggle('active');

        var parentLi = a.parentElement;
        if (parentLi) {
          var submenu = parentLi.querySelector('.submenu');
          if (submenu) {
            // Toggle submenu visibility
            if (submenu.style.display === 'block') {
              submenu.style.display = 'none';
            } else {
              submenu.style.display = 'block';
            }
          }
        }
      } else {
        // Regular link - close drawer and navigate
        close();
      }
    });

    // If switching to desktop, ensure drawer is closed.
    window.addEventListener('resize', function () {
      if (window.innerWidth > 880) close();
    });
  })();
})();

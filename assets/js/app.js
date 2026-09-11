/**
 * makeuniversal — App Initialization
 * Handles animations, dynamic content, and enhancements
 */

(function() {
  'use strict';

  // =========================================================================
  // Initialize AOS (Animate On Scroll)
  // =========================================================================
  if (typeof AOS !== 'undefined') {
    AOS.init({
      duration: 800,
      offset: 100,
      once: true,
      easing: 'ease-in-out-cubic',
    });
  }

  // =========================================================================
  // Initialize Prism (Syntax Highlighting)
  // =========================================================================
  if (typeof Prism !== 'undefined') {
    Prism.highlightAll();
  }

  // =========================================================================
  // Dynamic Year in Footer
  // =========================================================================
  function updateYear() {
    const yearElement = document.getElementById('year');
    if (yearElement) {
      yearElement.textContent = new Date().getFullYear();
    }
  }

  updateYear();

  // =========================================================================
  // Smooth Scroll for Anchor Links
  // =========================================================================
  function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
      anchor.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        
        // Skip if href is just '#' or the link is external
        if (href === '#' || href.startsWith('#') === false) {
          return;
        }

        const target = document.querySelector(href);
        if (target) {
          e.preventDefault();
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start',
          });

          // Update focus for accessibility
          target.focus();
          
          // Also update URL without jump
          window.history.pushState(null, null, href);
        }
      });
    });
  }

  initSmoothScroll();

  // =========================================================================
  // Mobile Navigation Toggle (optional, if needed)
  // =========================================================================
  function initMobileNav() {
    // This can be expanded if you add a hamburger menu
    const navMenu = document.querySelector('.nav-menu');
    if (!navMenu) return;

    // Ensure nav items are always accessible
    const navLinks = navMenu.querySelectorAll('a');
    navLinks.forEach((link) => {
      link.addEventListener('click', () => {
        // Optionally close mobile menu after click
      });
    });
  }

  initMobileNav();

  // =========================================================================
  // Keyboard Navigation Enhancements
  // =========================================================================
  function initKeyboardNav() {
    // Allow Tab to cycle through focusable elements
    const focusableElements = document.querySelectorAll(
      'a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    if (focusableElements.length === 0) return;

    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];

    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        // Shift + Tab
        if (document.activeElement === firstElement) {
          lastElement.focus();
          e.preventDefault();
        }
      } else {
        // Tab
        if (document.activeElement === lastElement) {
          firstElement.focus();
          e.preventDefault();
        }
      }
    });
  }

  initKeyboardNav();

  // =========================================================================
  // External Links (Open in New Tab with Aria Label)
  // =========================================================================
  function initExternalLinks() {
    document.querySelectorAll('a[href^="http"]').forEach((link) => {
      if (!link.getAttribute('target')) {
        link.setAttribute('target', '_blank');
        link.setAttribute('rel', 'noopener noreferrer');
      }

      // Add visual indicator via aria-label if not already present
      const ariaLabel = link.getAttribute('aria-label');
      if (!ariaLabel && !link.querySelector('.icon-inline')) {
        // Only add if no icon is present (icon serves as visual indicator)
      }
    });
  }

  initExternalLinks();

  // =========================================================================
  // Analytics/Tracking (optional)
  // =========================================================================
  function trackPageView() {
    // If you're using Google Analytics, Fathom, or similar:
    // gtag('event', 'page_view');
    // or
    // fathom.trackPageView();
  }

  trackPageView();

  // =========================================================================
  // Performance Monitoring (optional)
  // =========================================================================
  function initPerformanceMonitoring() {
    if ('PerformanceObserver' in window) {
      try {
        const observer = new PerformanceObserver((list) => {
          for (const entry of list.getEntries()) {
            console.debug('[Performance]', entry.name, entry.duration + 'ms');
          }
        });

        observer.observe({ entryTypes: ['navigation', 'resource'] });
      } catch (e) {
        // Performance API not available or not supported
      }
    }
  }

  // Commented out by default; uncomment if needed
  // initPerformanceMonitoring();

  // =========================================================================
  // Theme Toggle (Optional: Dark Mode)
  // =========================================================================
  function initThemeToggle() {
    // Check if there's a theme toggle button
    const themeToggle = document.getElementById('theme-toggle');
    if (!themeToggle) return;

    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const storedTheme = localStorage.getItem('theme');

    const currentTheme = storedTheme || (prefersDark ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', currentTheme);

    themeToggle.addEventListener('click', () => {
      const theme = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', theme);
      localStorage.setItem('theme', theme);
    });
  }

  initThemeToggle();

  // =========================================================================
  // Initialization Complete
  // =========================================================================
  console.debug('[App] Initialization complete');

  // Expose utilities globally for debugging (optional)
  window.__makeuniversal = {
    updateYear,
    initSmoothScroll,
    initMobileNav,
    initKeyboardNav,
    initExternalLinks,
    trackPageView,
    initPerformanceMonitoring,
    initThemeToggle,
  };
})();

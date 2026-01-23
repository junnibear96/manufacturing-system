<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/jsp/include/header.jspf" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

            <section class="sec-content">
                <div class="index"
                    style="display: flex; align-items: center; justify-content: center; height: 100vh; background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%); color: #fff; text-align: center;">
                    <div class="hero-section">
                        <h1 style="font-size: 4rem; margin-bottom: 20px; font-weight: 700;">Hello, I'm Junseok Choi</h1>
                        <p style="font-size: 1.5rem; margin-bottom: 40px; color: #ccc;">Web Developer | BackEnd
                            Engineer</p>
                        <div class="cta-buttons">
                            <a href="/dashboard"
                                style="padding: 15px 30px; background-color: #007bff; color: white; text-decoration: none; border-radius: 30px; font-weight: bold; font-size: 1.2rem; transition: background 0.3s;">View
                                My Work</a>
                        </div>
                    </div>
                </div>
            </section>

            <%@ include file="/WEB-INF/jsp/include/footer.jspf" %>
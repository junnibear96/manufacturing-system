<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
        <%@ include file="/WEB-INF/jsp/include/header.jspf" %>

            <style>
                /* Modern Cover Letter Styles */
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                :root {
                    --primary-color: #2c3e50;
                    --secondary-color: #3498db;
                    --accent-color: #e74c3c;
                    --text-color: #333;
                    --light-bg: #f8f9fa;
                    --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .cl-hero {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 100px 20px;
                    text-align: center;
                }

                .cl-hero h1 {
                    font-size: 3rem;
                    margin-bottom: 16px;
                    font-weight: 700;
                }

                .subtitle {
                    font-size: 1.5rem;
                    opacity: 0.9;
                    margin-bottom: 32px;
                }

                .contact-info {
                    display: flex;
                    gap: 24px;
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .contact-info a {
                    color: white;
                    text-decoration: none;
                    transition: opacity 0.3s;
                }

                .contact-info a:hover {
                    opacity: 0.8;
                }

                .cl-container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 40px 20px;
                }

                .cl-section {
                    margin-bottom: 60px;
                }

                .cl-section h2 {
                    font-size: 2rem;
                    color: var(--primary-color);
                    margin-bottom: 32px;
                    border-bottom: 3px solid var(--secondary-color);
                    padding-bottom: 16px;
                }

                /* Profile Summary Grid */
                .summary-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 24px;
                    margin-bottom: 40px;
                }

                .summary-card {
                    background: white;
                    border-radius: 12px;
                    padding: 24px;
                    box-shadow: var(--card-shadow);
                    transition: transform 0.3s, box-shadow 0.3s;
                }

                .summary-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
                }

                .summary-card h3 {
                    color: var(--secondary-color);
                    margin-bottom: 12px;
                    font-size: 1.2rem;
                }

                .summary-card p {
                    color: var(--text-color);
                    line-height: 1.6;
                }

                /* Education Grid */
                .education-grid {
                    display: grid;
                    gap: 24px;
                }

                .education-item {
                    background: white;
                    border-left: 4px solid var(--secondary-color);
                    padding: 24px;
                    border-radius: 8px;
                    box-shadow: var(--card-shadow);
                }

                .education-item h3 {
                    color: var(--primary-color);
                    margin-bottom: 8px;
                    font-size: 1.3rem;
                }

                .period {
                    color: #666;
                    margin-bottom: 8px;
                    font-size: 0.95rem;
                }

                .details {
                    color: var(--text-color);
                    line-height: 1.6;
                }

                /* Timeline for Work Experience */
                .timeline {
                    position: relative;
                    padding-left: 40px;
                }

                .timeline::before {
                    content: '';
                    position: absolute;
                    left: 0;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: var(--secondary-color);
                }

                .timeline-item {
                    margin-bottom: 40px;
                    position: relative;
                }

                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -46px;
                    top: 0;
                    width: 12px;
                    height: 12px;
                    border-radius: 50%;
                    background: var(--secondary-color);
                    border: 3px solid white;
                    box-shadow: 0 0 0 2px var(--secondary-color);
                }

                .timeline-item h3 {
                    color: var(--primary-color);
                    margin-bottom: 8px;
                    font-size: 1.3rem;
                }

                .company {
                    color: #555;
                    font-weight: 600;
                    margin-bottom: 16px;
                }

                .project {
                    background: var(--light-bg);
                    padding: 16px;
                    border-radius: 8px;
                    margin-top: 16px;
                }

                .project h4 {
                    color: var(--secondary-color);
                    margin-bottom: 12px;
                    font-size: 1.1rem;
                }

                .project p {
                    color: var(--text-color);
                    line-height: 1.8;
                }

                /* Skills Grid */
                .skills-grid {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 12px;
                }

                .skill-tag {
                    background: var(--secondary-color);
                    color: white;
                    padding: 8px 16px;
                    border-radius: 20px;
                    font-size: 0.9rem;
                    transition: background 0.3s;
                }

                .skill-tag:hover {
                    background: var(--primary-color);
                }

                /* Cover Letter Text */
                .cover-letter-text {
                    background: white;
                    padding: 32px;
                    border-radius: 12px;
                    box-shadow: var(--card-shadow);
                    line-height: 1.8;
                }

                .cover-letter-text p {
                    margin-bottom: 24px;
                    text-align: justify;
                    color: var(--text-color);
                }

                /* AOS Animation Support */
                [data-aos] {
                    opacity: 0;
                    transition-property: opacity, transform;
                }

                [data-aos].aos-animate {
                    opacity: 1;
                }

                [data-aos="fade-up"] {
                    transform: translateY(20px);
                }

                [data-aos="fade-up"].aos-animate {
                    transform: translateY(0);
                }

                /* Responsive Design */
                @media (max-width: 768px) {
                    .cl-hero h1 {
                        font-size: 2rem;
                    }

                    .subtitle {
                        font-size: 1.2rem;
                    }

                    .cl-section h2 {
                        font-size: 1.5rem;
                    }

                    .timeline {
                        padding-left: 30px;
                    }

                    .contact-info {
                        flex-direction: column;
                        align-items: center;
                    }
                }
            </style>

            <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

            <body>
                <!-- Hero Section -->
                <div class="cl-hero" data-aos="fade-down">
                    <h1>
                        <spring:message code="coverletter.name" />
                    </h1>
                    <div class="subtitle">
                        <spring:message code="coverletter.hero.subtitle" />
                    </div>
                    <div class="contact-info">
                        <a href="mailto:junseok4545@gmail.com">📧 junseok4545@gmail.com</a>
                        <a href="tel:010-3602-4397">📱 010-3602-4397</a>
                    </div>
                </div>

                <div class="cl-container">
                    <!-- Summary Section -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.profile.title" />
                        </h2>
                        <div class="summary-grid">
                            <div class="summary-card">
                                <h3>
                                    <spring:message code="coverletter.profile.experience" />
                                </h3>
                                <p>
                                    <spring:message code="coverletter.profile.experience.years" /><br />
                                    <spring:message code="coverletter.profile.experience.status" />
                                </p>
                            </div>
                            <div class="summary-card">
                                <h3>
                                    <spring:message code="coverletter.profile.education" />
                                </h3>
                                <p>
                                    <spring:message code="coverletter.profile.education.school" /><br />
                                    <spring:message code="coverletter.profile.education.major" />
                                </p>
                            </div>
                            <div class="summary-card">
                                <h3>
                                    <spring:message code="coverletter.profile.languages" />
                                </h3>
                                <p>
                                    <spring:message code="coverletter.profile.languages.toefl" /><br />
                                    <spring:message code="coverletter.profile.languages.speaking" />
                                </p>
                            </div>
                            <div class="summary-card">
                                <h3>
                                    <spring:message code="coverletter.profile.military" />
                                </h3>
                                <p>
                                    <spring:message code="coverletter.profile.military.rank" /><br />
                                    <spring:message code="coverletter.profile.military.period" />
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Education Section -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.education" />
                        </h2>
                        <div class="education-grid">
                            <div class="education-item">
                                <h3>
                                    <spring:message code="coverletter.edu.scu.name" />
                                </h3>
                                <div class="period">
                                    <spring:message code="coverletter.edu.scu.period" />
                                </div>
                                <div class="details">
                                    <spring:message code="coverletter.edu.scu.details" />
                                </div>
                            </div>
                            <div class="education-item">
                                <h3>University of Colorado - Boulder</h3>
                                <div class="period">
                                    <spring:message code="coverletter.edu.cu.period" />
                                </div>
                                <div class="details">
                                    <spring:message code="coverletter.edu.cu.details" />
                                </div>
                            </div>
                            <div class="education-item">
                                <h3>Langley High School</h3>
                                <div class="period">
                                    <spring:message code="coverletter.edu.lhs.period" />
                                </div>
                                <div class="details">
                                    <spring:message code="coverletter.edu.lhs.details" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Work Experience Section -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.experience" />
                        </h2>
                        <div class="timeline">
                            <div class="timeline-item">
                                <h3>
                                    <spring:message code="coverletter.exp.softleap.position" />
                                </h3>
                                <div class="period">
                                    <spring:message code="coverletter.exp.softleap.period" />
                                </div>
                                <div class="company">
                                    <spring:message code="coverletter.exp.softleap.company" />
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.atomy.ticket.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.atomy.ticket.desc" />
                                    </p>
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.atomy.abc.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.atomy.abc.desc" />
                                    </p>
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.atomy.masstige.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.atomy.masstige.desc" />
                                    </p>
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.atomy.global.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.atomy.global.desc" />
                                    </p>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <h3>
                                    <spring:message code="coverletter.exp.sysoit.position" />
                                </h3>
                                <div class="period">
                                    <spring:message code="coverletter.exp.sysoit.period" />
                                </div>
                                <div class="company">
                                    <spring:message code="coverletter.exp.sysoit.company" />
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.sysoit.gsuite.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.sysoit.gsuite.desc" />
                                    </p>
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.sysoit.gclass.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.sysoit.gclass.desc" />
                                    </p>
                                </div>

                                <div class="project">
                                    <h4>
                                        <spring:message code="coverletter.exp.sysoit.records.title" />
                                    </h4>
                                    <p>
                                        <spring:message code="coverletter.exp.sysoit.records.desc" />
                                    </p>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <h3>
                                    <spring:message code="coverletter.exp.sysoit.intern.position" />
                                </h3>
                                <div class="period">
                                    <spring:message code="coverletter.exp.sysoit.intern.period" />
                                </div>
                                <div class="company">
                                    <spring:message code="coverletter.exp.sysoit.intern.company" />
                                </div>
                                <p style="margin-top: 16px; line-height: 1.8;">
                                    <spring:message code="coverletter.exp.sysoit.intern.desc" />
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Technical Skills Section -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.skills" />
                        </h2>
                        <div class="skills-grid">
                            <span class="skill-tag">JAVA</span>
                            <span class="skill-tag">Spring Framework</span>
                            <span class="skill-tag">Spring Boot</span>
                            <span class="skill-tag">JPA</span>
                            <span class="skill-tag">MyBatis</span>
                            <span class="skill-tag">Javascript</span>
                            <span class="skill-tag">JSP</span>
                            <span class="skill-tag">React</span>
                            <span class="skill-tag">Node.js</span>
                            <span class="skill-tag">Jquery</span>
                            <span class="skill-tag">MySQL</span>
                            <span class="skill-tag">Oracle</span>
                            <span class="skill-tag">Redis</span>
                            <span class="skill-tag">SQL</span>
                            <span class="skill-tag">DBMS</span>
                            <span class="skill-tag">Docker</span>
                            <span class="skill-tag">Git</span>
                            <span class="skill-tag">CI/CD</span>
                            <span class="skill-tag">GCP</span>
                            <span class="skill-tag">Vercel</span>
                            <span class="skill-tag">Python</span>
                            <span class="skill-tag">RPA</span>
                        </div>
                    </div>

                    <!-- Cover Letter Section -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.self_intro" />
                        </h2>
                        <div class="cover-letter-text">
                            <p>
                                <spring:message code="coverletter.intro.greeting" />
                            </p>

                            <p>
                                <spring:message code="coverletter.intro.p1" />
                            </p>

                            <p>
                                <spring:message code="coverletter.intro.p2" />
                            </p>

                            <p>
                                <spring:message code="coverletter.intro.p3" />
                            </p>

                            <p>
                                <spring:message code="coverletter.intro.p4" />
                            </p>

                            <p>
                                <spring:message code="coverletter.intro.p5" />
                            </p>
                        </div>
                    </div>

                    <!-- Certifications & Languages -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.certifications" />
                        </h2>
                        <div class="education-grid">
                            <div class="education-item">
                                <h3>
                                    <spring:message code="coverletter.cert.title" />
                                </h3>
                                <ul style="margin-left: 20px; margin-top: 12px; line-height: 1.8;">
                                    <li>
                                        <spring:message code="coverletter.cert.sqld" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.cert.engineer" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.cert.license" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.cert.google" />
                                    </li>
                                </ul>
                            </div>
                            <div class="education-item">
                                <h3>
                                    <spring:message code="coverletter.lang.title" />
                                </h3>
                                <ul style="margin-left: 20px; margin-top: 12px; line-height: 1.8;">
                                    <li>
                                        <spring:message code="coverletter.lang.toefl" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.lang.ielts" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.lang.opic" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.lang.toeic" />
                                    </li>
                                    <li>
                                        <spring:message code="coverletter.lang.speaking" />
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Portfolio Links -->
                    <div class="cl-section" data-aos="fade-up">
                        <h2>
                            <spring:message code="coverletter.section.portfolio" />
                        </h2>
                        <div class="description">
                            <p style="margin-bottom: 10px;">
                                <a href="https://dividendplanner-production.up.railway.app/" target="_blank"
                                    style="color: #3498db;">
                                    ►
                                    <spring:message code="coverletter.portfolio.dividend" />
                                </a>
                            </p>
                            <p>
                                <a href="https://github.com/junnibear96/donation_rpa" target="_blank"
                                    style="color: #3498db;">
                                    ►
                                    <spring:message code="coverletter.portfolio.donation" />
                                </a>
                            </p>
                            <p style="margin-bottom: 10px;">
                                <a href="https://github.com/junnibear96/lotto_number_maker" target="_blank"
                                    style="color: #3498db;">
                                    ►
                                    <spring:message code="coverletter.portfolio.lotto" />
                                </a>
                            </p>
                        </div>
                    </div>
                </div>

                <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
                <script>
                    AOS.init({
                        duration: 800,
                        offset: 100,
                        once: true
                    });
                </script>
            </body>

            <%@ include file="/WEB-INF/jsp/include/footer.jspf" %>
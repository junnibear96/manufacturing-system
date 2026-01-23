package com.tp.mes.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Spring Security Configuration
 * - Form-based login
 * - Role-based access control (RBAC)
 * - Method-level security enabled
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

        private final com.tp.mes.security.CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

        public SecurityConfig(
                        com.tp.mes.security.CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler) {
                this.customAuthenticationSuccessHandler = customAuthenticationSuccessHandler;
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .csrf(csrf -> csrf.disable())
                                // Allow public resources and login page
                                .authorizeHttpRequests(auth -> auth
                                                .requestMatchers("/assets/**", "/WEB-INF/**", "/views/**", "/error")
                                                .permitAll()
                                                .requestMatchers("/", "/login", "/cover-letter", "/api/**",
                                                                "/actuator/**", "/.well-known/**")
                                                .permitAll()
                                                .anyRequest().authenticated())
                                .formLogin(form -> form
                                                .loginPage("/login")
                                                .loginProcessingUrl("/login")
                                                .successHandler(customAuthenticationSuccessHandler)
                                                .failureHandler((request, response, exception) -> {
                                                        response.sendRedirect("/login?error");
                                                })
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout")
                                                .permitAll());

                return http.build();
        }

        @Bean
        public UserDetailsService userDetailsService() {
                // Demo users with RBAC roles
                UserDetails admin = User.builder()
                                .username("admin")
                                .password(passwordEncoder().encode("admin123"))
                                .roles("ADMIN", "MANAGER", "OPERATOR", "VIEWER")
                                .build();

                UserDetails manager = User.builder()
                                .username("manager")
                                .password(passwordEncoder().encode("manager123"))
                                .roles("MANAGER", "VIEWER")
                                .build();

                UserDetails operator = User.builder()
                                .username("operator")
                                .password(passwordEncoder().encode("operator123"))
                                .roles("OPERATOR", "VIEWER")
                                .build();

                UserDetails viewer = User.builder()
                                .username("viewer")
                                .password(passwordEncoder().encode("viewer123"))
                                .roles("VIEWER")
                                .build();

                // Legacy users for backward compatibility
                UserDetails prod001 = User.builder()
                                .username("prod001")
                                .password(passwordEncoder().encode("prod123"))
                                .roles("MANAGER", "VIEWER")
                                .build();

                UserDetails worker001 = User.builder()
                                .username("worker001")
                                .password(passwordEncoder().encode("work123"))
                                .roles("OPERATOR", "VIEWER")
                                .build();

                return new InMemoryUserDetailsManager(admin, manager, operator, viewer, prod001, worker001);
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }
}

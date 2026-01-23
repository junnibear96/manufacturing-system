package com.tp.mes.app.auth.web;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.auth.service.AuthService;
import java.time.Instant;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

//@Controller
public class AuthController {

  private final AuthService authService;

  public AuthController(AuthService authService) {
    this.authService = authService;
  }

  @GetMapping("/login")
  public String loginForm(Model model, @RequestParam(value = "error", required = false) String error) {
    model.addAttribute("now", Instant.now().toString());
    model.addAttribute("error", error);
    return "app/login"; // View name remains same (jsp location), but URL changes
  }

  @PostMapping("/login")
  public String login(
      @RequestParam("username") String username,
      @RequestParam("password") String password,
      HttpSession session) {
    return authService.authenticate(username, password)
        .map(user -> {
          session.setAttribute(AuthUser.SESSION_KEY, user);
          return "redirect:/dashboard"; // Assuming dashboard is at root or specific path
        })
        .orElse("redirect:/login?error=1");
  }

  @PostMapping("/logout")
  public String logout(HttpSession session) {
    session.invalidate();
    return "redirect:/";
  }
}

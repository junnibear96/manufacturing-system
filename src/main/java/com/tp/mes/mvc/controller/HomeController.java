package com.tp.mes.mvc.controller;

import java.time.Instant;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

  @GetMapping("/")
  public String home(Model model, java.security.Principal principal) {
    // Check if user is logged in
    if (principal != null) {
      // User is logged in, redirect to dashboard
      return "redirect:/dashboard";
    }

    // User is not logged in, show index page
    model.addAttribute("now", Instant.now().toString());
    return "index";
  }

  @GetMapping("/cover-letter")
  public String coverLetter(Model model) {
    model.addAttribute("name", "최준석");
    model.addAttribute("title", "Backend Developer");
    return "cover-letter";
  }
}

package com.tp.mes.app.notice.web;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.notice.model.Notice;
import com.tp.mes.app.notice.service.NoticeService;
import java.util.Optional;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class NoticeController {

  private final NoticeService service;

  public NoticeController(NoticeService service) {
    this.service = service;
  }

  // New root path + Legacy /app path
  @GetMapping({ "/notices" })
  public String list(Model model) {
    model.addAttribute("notices", service.listNotices());
    return "notices/list";
  }

  @GetMapping({ "/notices/{noticeId}" })
  public String view(@PathVariable("noticeId") long noticeId, Model model) {
    Optional<Notice> found = service.findNotice(noticeId);
    if (found.isEmpty()) {
      return "redirect:/notices";
    }
    model.addAttribute("notice", found.get());
    return "notices/view";
  }

  @GetMapping("/admin/notices/new")
  public String newForm(Model model) {
    model.addAttribute("title", "");
    model.addAttribute("body", "");
    model.addAttribute("noticeId", null);
    model.addAttribute("isEdit", false);
    return "admin/notice-form";
  }

  @GetMapping("/admin/notices/{noticeId}/edit")
  public String editForm(@PathVariable("noticeId") long noticeId, Model model) {
    Optional<Notice> found = service.findNotice(noticeId);
    if (found.isEmpty()) {
      return "redirect:/notices";
    }
    model.addAttribute("title", found.get().getTitle());
    model.addAttribute("body", found.get().getBody());
    model.addAttribute("noticeId", noticeId);
    model.addAttribute("isEdit", true);
    return "admin/notice-form";
  }

  @PreAuthorize("hasRole('ADMIN')")
  @PostMapping("/admin/notices/{noticeId}/edit")
  public String update(
      @PathVariable("noticeId") long noticeId,
      @RequestParam("title") String title,
      @RequestParam("body") String body,
      @org.springframework.security.core.annotation.AuthenticationPrincipal org.springframework.security.core.userdetails.UserDetails userDetails) {
    Long updatedBy = 1L; // Fallback
    service.updateNotice(noticeId, title, body, updatedBy);
    return "redirect:/notices/" + noticeId;
  }

  @PreAuthorize("hasRole('ADMIN')")
  @PostMapping("/admin/notices/new")
  public String create(
      @RequestParam("title") String title,
      @RequestParam("body") String body,
      @org.springframework.security.core.annotation.AuthenticationPrincipal org.springframework.security.core.userdetails.UserDetails userDetails) {

    // Fallback ID for in-memory users or legacy support
    Long createdBy = 1L;

    // In a real app, we would look up the user by username
    // (userDetails.getUsername())
    // from the database to get the ID. For now, we assume admin is ID 1.
    // If we had a mechanism to map username -> ID, we would use it here.

    service.createNotice(title, body, createdBy);
    return "redirect:/notices";
  }
}

package com.tp.mes.app.notice.service;

import com.tp.mes.app.notice.model.Notice;
import com.tp.mes.app.notice.repository.NoticeRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class DefaultNoticeService implements NoticeService {

  private final NoticeRepository repository;

  public DefaultNoticeService(NoticeRepository repository) {
    this.repository = repository;
  }

  @Override
  public List<Notice> listNotices() {
    return repository.listNotices();
  }

  @Override
  public Optional<Notice> findNotice(long noticeId) {
    return repository.findNotice(noticeId);
  }

  @Override
  public long createNotice(String title, String body, Long createdByUserId) {
    return repository.insertNotice(safe(title), safeBody(body), createdByUserId);
  }

  @Override
  public void updateNotice(long noticeId, String title, String body, Long updatedByUserId) {
    repository.updateNotice(noticeId, safe(title), safeBody(body), updatedByUserId);
  }

  private static String safe(String value) {
    if (value == null) {
      return "";
    }
    return value.trim();
  }

  private static String safeBody(String value) {
    if (value == null) {
      return "";
    }
    return value.trim();
  }
}

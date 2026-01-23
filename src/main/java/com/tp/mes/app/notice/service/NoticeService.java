package com.tp.mes.app.notice.service;

import com.tp.mes.app.notice.model.Notice;
import java.util.List;
import java.util.Optional;

public interface NoticeService {

  List<Notice> listNotices();

  Optional<Notice> findNotice(long noticeId);

  long createNotice(String title, String body, Long createdByUserId);

  void updateNotice(long noticeId, String title, String body, Long updatedByUserId);
}

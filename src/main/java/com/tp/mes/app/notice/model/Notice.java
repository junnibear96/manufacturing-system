package com.tp.mes.app.notice.model;

public class Notice {

  private final long noticeId;
  private final String title;
  private final String body;
  private final String createdAt;

  public Notice(long noticeId, String title, String body, String createdAt) {
    this.noticeId = noticeId;
    this.title = title;
    this.body = body;
    this.createdAt = createdAt;
  }

  public long getNoticeId() {
    return noticeId;
  }

  public String getTitle() {
    return title;
  }

  public String getBody() {
    return body;
  }

  public String getCreatedAt() {
    return createdAt;
  }
}

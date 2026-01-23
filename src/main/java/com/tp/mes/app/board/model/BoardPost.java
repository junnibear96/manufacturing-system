package com.tp.mes.app.board.model;

public class BoardPost {

  private final long postId;
  private final String title;
  private final String body;
  private final String createdAt;

  public BoardPost(long postId, String title, String body, String createdAt) {
    this.postId = postId;
    this.title = title;
    this.body = body;
    this.createdAt = createdAt;
  }

  public long getPostId() {
    return postId;
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

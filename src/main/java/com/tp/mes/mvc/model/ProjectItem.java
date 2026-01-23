package com.tp.mes.mvc.model;

import java.util.List;

public class ProjectItem {

  private final String title;
  private final String stack;
  private final List<String> highlights;

  public ProjectItem(String title, String stack, List<String> highlights) {
    this.title = title;
    this.stack = stack;
    this.highlights = highlights;
  }

  public String getTitle() {
    return title;
  }

  public String getStack() {
    return stack;
  }

  public List<String> getHighlights() {
    return highlights;
  }
}

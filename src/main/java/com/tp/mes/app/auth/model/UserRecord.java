package com.tp.mes.app.auth.model;

public class UserRecord {

  private final long userId;
  private final String username;
  private final String passwordHash;
  private final String displayName;
  private final boolean enabled;

  public UserRecord(long userId, String username, String passwordHash, String displayName, boolean enabled) {
    this.userId = userId;
    this.username = username;
    this.passwordHash = passwordHash;
    this.displayName = displayName;
    this.enabled = enabled;
  }

  public long getUserId() {
    return userId;
  }

  public String getUsername() {
    return username;
  }

  public String getPasswordHash() {
    return passwordHash;
  }

  public String getDisplayName() {
    return displayName;
  }

  public boolean isEnabled() {
    return enabled;
  }
}

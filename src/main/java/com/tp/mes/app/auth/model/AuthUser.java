package com.tp.mes.app.auth.model;

import java.io.Serializable;
import java.util.List;

public class AuthUser implements Serializable {

  public static final String SESSION_KEY = "AUTH_USER";

  private final long userId;
  private final String username;
  private final String displayName;
  private final List<String> roleCodes;

  public AuthUser(long userId, String username, String displayName, List<String> roleCodes) {
    this.userId = userId;
    this.username = username;
    this.displayName = displayName;
    this.roleCodes = roleCodes;
  }

  public long getUserId() {
    return userId;
  }

  public String getUsername() {
    return username;
  }

  public String getDisplayName() {
    return displayName;
  }

  public List<String> getRoleCodes() {
    return roleCodes;
  }

  public boolean hasRole(String roleCode) {
    if (roleCodes == null) {
      return false;
    }
    return roleCodes.contains(roleCode);
  }
}

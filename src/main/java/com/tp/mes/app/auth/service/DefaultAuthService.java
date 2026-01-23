package com.tp.mes.app.auth.service;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.auth.model.UserRecord;
import com.tp.mes.app.auth.repository.UserRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class DefaultAuthService implements AuthService {

  private final UserRepository userRepository;
  private final BCryptPasswordEncoder passwordEncoder;

  public DefaultAuthService(UserRepository userRepository) {
    this.userRepository = userRepository;
    this.passwordEncoder = new BCryptPasswordEncoder();
  }

  @Override
  public Optional<AuthUser> authenticate(String username, String password) {
    Optional<UserRecord> userOpt = userRepository.findByUsername(username);
    if (userOpt.isEmpty()) {
      return Optional.empty();
    }
    UserRecord user = userOpt.get();
    if (!user.isEnabled()) {
      return Optional.empty();
    }
    if (!passwordEncoder.matches(password, user.getPasswordHash())) {
      return Optional.empty();
    }
    List<String> roles = userRepository.findRoleCodesByUserId(user.getUserId());
    return Optional.of(new AuthUser(user.getUserId(), user.getUsername(), user.getDisplayName(), roles));
  }
}
